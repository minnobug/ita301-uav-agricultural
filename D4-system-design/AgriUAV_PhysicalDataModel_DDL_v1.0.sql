-- ============================================================================
-- AgriUAV Platform — Physical Data Model (DDL)
-- Source: ITA301_G3_D3_20260628_v3.1 (Section 3, Physical Data Model, pages 17-21)
-- Stack: PostgreSQL 16 + PostGIS 3.4 + TimescaleDB 2.x
-- Draft prepared for W7 submission — REVIEW before submitting (see checklist at bottom)
-- ============================================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS timescaledb;

-- ----------------------------------------------------------------------------
-- BAND 1 — IDENTITY & ORGANIZATION
-- ----------------------------------------------------------------------------

CREATE TYPE user_role AS ENUM ('ADMIN','HTX_MANAGER','OPERATOR','FARMER','AGRONOMIST');

CREATE TABLE users (
    "userId"        VARCHAR(36)   NOT NULL PRIMARY KEY,      -- UUID v4
    "fullName"      VARCHAR(255)  NOT NULL,
    email           VARCHAR(255)  NOT NULL UNIQUE,
    "passwordHash"  VARCHAR(255)  NOT NULL,                  -- bcrypt hash, cost 12
    role            user_role     NOT NULL,
    "isActive"      BOOLEAN       NOT NULL DEFAULT TRUE,      -- soft delete flag
    "createdAt"     TIMESTAMP     NOT NULL DEFAULT NOW()
);

CREATE TABLE cooperatives (
    "cooperativeId" VARCHAR(36)   NOT NULL PRIMARY KEY,
    "managerId"     VARCHAR(36)   NOT NULL REFERENCES users("userId"),
    name            VARCHAR(255)  NOT NULL,
    province        VARCHAR(100)  NOT NULL,
    address         TEXT,
    "maxDrones"     INTEGER       NOT NULL DEFAULT 50          -- configurable reference workload, not a hard limit (D1 v1.6 |1.2)
);

-- ----------------------------------------------------------------------------
-- BAND 2 — FIELD & AGRONOMY
-- ----------------------------------------------------------------------------

CREATE TABLE fields (
    "fieldId"       VARCHAR(36)   NOT NULL PRIMARY KEY,
    "farmerId"      VARCHAR(36)   NOT NULL REFERENCES users("userId"),
    "cooperativeId" VARCHAR(36)   NOT NULL REFERENCES cooperatives("cooperativeId"),
    "fieldName"     VARCHAR(255)  NOT NULL,
    "cropType"      VARCHAR(100)  NOT NULL,                    -- e.g. rice, corn
    "areaHa"        DECIMAL(8,4)  NOT NULL,                    -- auto-computed from gpsPolygon via PostGIS ST_Area
    "gpsPolygon"    TEXT          NOT NULL,                    -- GeoJSON polygon
    "createdAt"     TIMESTAMP     NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_fields_gpspolygon ON fields USING GIST ((ST_GeomFromGeoJSON("gpsPolygon")));

CREATE TABLE pesticides (
    "pesticideId"      VARCHAR(36)  NOT NULL PRIMARY KEY,
    name               VARCHAR(255) NOT NULL,
    "activeIngredient" VARCHAR(255) NOT NULL,
    "isApprovedBVTV"   BOOLEAN      NOT NULL DEFAULT FALSE,
    unit               VARCHAR(20)  NOT NULL DEFAULT 'L'
);
CREATE INDEX idx_pesticides_approved ON pesticides ("isApprovedBVTV");

CREATE TABLE spray_formulas (
    "formulaId"           VARCHAR(36)  NOT NULL PRIMARY KEY,
    "fieldId"              VARCHAR(36)  NOT NULL UNIQUE REFERENCES fields("fieldId"),   -- 1:1 with fields
    "pesticideId"          VARCHAR(36)  NOT NULL REFERENCES pesticides("pesticideId"),
    "dosageLPerHa"         DECIMAL(6,2) NOT NULL,               -- FR02
    "sprayCountPerSeason"  SMALLINT     NOT NULL,
    "configuredBy"         VARCHAR(36)  NOT NULL REFERENCES users("userId")             -- Agronomist
);

CREATE TABLE pesticide_stock (
    "stockId"             VARCHAR(36)  NOT NULL PRIMARY KEY,
    "cooperativeId"       VARCHAR(36)  NOT NULL REFERENCES cooperatives("cooperativeId"),
    "pesticideId"         VARCHAR(36)  NOT NULL REFERENCES pesticides("pesticideId"),
    "stockL"              DECIMAL(8,2) NOT NULL DEFAULT 0,
    "lowStockThresholdL"  DECIMAL(8,2) NOT NULL,
    "updatedAt"           TIMESTAMP    NOT NULL DEFAULT NOW(),
    UNIQUE ("cooperativeId", "pesticideId")
);

-- ----------------------------------------------------------------------------
-- BAND 3 — FLEET & SAFETY
-- ----------------------------------------------------------------------------

CREATE TYPE drone_status AS ENUM ('IDLE','FLYING','MAINTENANCE','OFFLINE');

CREATE TABLE drones (
    "droneId"        VARCHAR(36)   NOT NULL PRIMARY KEY,
    "cooperativeId"  VARCHAR(36)   NOT NULL REFERENCES cooperatives("cooperativeId"),
    "serialNumber"   VARCHAR(100)  NOT NULL UNIQUE,             -- Decree 288/2025 drone identifier (FR21)
    model            VARCHAR(100)  NOT NULL,                    -- e.g. DJI Agras T40
    "tankCapacityL"  DECIMAL(5,2)  NOT NULL,
    "batteryPercent" SMALLINT      NOT NULL DEFAULT 100,        -- mobile-GPS proxy / simulated telemetry (MVP)
    status           drone_status  NOT NULL DEFAULT 'IDLE',
    "gpsLat"         DECIMAL(9,6),
    "gpsLng"         DECIMAL(9,6),
    "updatedAt"      TIMESTAMP     NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_drones_status ON drones (status);

CREATE TABLE operators (
    "operatorId"          VARCHAR(36)  NOT NULL PRIMARY KEY,
    "userId"               VARCHAR(36)  NOT NULL UNIQUE REFERENCES users("userId"),
    "certificateNumber"    VARCHAR(50)  NOT NULL UNIQUE,        -- Decree 288/2025 pilot certificate
    "certificateExpiry"    DATE         NOT NULL,               -- validated on every assignment (UC02)
    "operationalStatus"    VARCHAR(50)  NOT NULL DEFAULT 'ACTIVE' -- ACTIVE | ON_LEAVE | SUSPENDED
);
CREATE INDEX idx_operators_cert_expiry ON operators ("certificateExpiry");

CREATE TABLE geofences (
    "geofenceId"       VARCHAR(36)  NOT NULL PRIMARY KEY,
    "fieldId"          VARCHAR(36)  NOT NULL UNIQUE REFERENCES fields("fieldId"),        -- 1:1 with fields
    "boundaryPolygon"  TEXT         NOT NULL,                   -- GeoJSON
    "bufferMeters"     INTEGER      NOT NULL DEFAULT 50,        -- default buffer around registered 110kV lines (FR12)
    "hazardZones"      JSONB,                                   -- {type:'POWERLINE'|'RESIDENTIAL', coords}
    "isActive"         BOOLEAN      NOT NULL DEFAULT FALSE      -- set TRUE on UC03 check-in
);
CREATE INDEX idx_geofences_boundary ON geofences USING GIST ((ST_GeomFromGeoJSON("boundaryPolygon")));

-- ----------------------------------------------------------------------------
-- BAND 4 — OPERATIONS (CORE TRANSACTION)
-- ----------------------------------------------------------------------------

CREATE TYPE order_status AS ENUM ('PENDING','ASSIGNED','IN_PROGRESS','COMPLETED','SUSPENDED','CANCELLED');

CREATE TABLE spray_orders (
    "orderId"          VARCHAR(36)   NOT NULL PRIMARY KEY,
    "farmerId"         VARCHAR(36)   NOT NULL REFERENCES users("userId"),
    "fieldId"          VARCHAR(36)   NOT NULL REFERENCES fields("fieldId"),
    "droneId"          VARCHAR(36)   REFERENCES drones("droneId"),        -- NULL until assigned (UC02)
    "operatorId"       VARCHAR(36)   REFERENCES operators("operatorId"),  -- NULL until assigned
    "scheduledDate"    TIMESTAMP     NOT NULL,
    "actualStartTime"  TIMESTAMP,                                          -- set on check-in
    status             order_status  NOT NULL DEFAULT 'PENDING',
    "statusReason"     TEXT,                                               -- 'Weather' | 'Needs Review' | 'Lacking safety confirmation' | 'Confirmation timeout'
    "pestAmountL"      DECIMAL(6,2),                                       -- calculated on assignment
    "cancelReason"     TEXT,
    "createdAt"        TIMESTAMP     NOT NULL DEFAULT NOW()
    -- Note: "no-assign" path keeps status = PENDING (UC02 Alt 3a), not CANCELLED.
);
CREATE INDEX idx_spray_orders_field_date ON spray_orders ("fieldId", "scheduledDate");  -- conflict checks (FR04)
CREATE INDEX idx_spray_orders_status ON spray_orders (status);                          -- active-order filtering

CREATE TABLE flight_logs (
    "logId"           VARCHAR(36)   NOT NULL PRIMARY KEY,
    "orderId"         VARCHAR(36)   NOT NULL UNIQUE REFERENCES spray_orders("orderId"),  -- 1:1 with spray_orders
    "droneId"         VARCHAR(36)   NOT NULL REFERENCES drones("droneId"),
    "operatorId"      VARCHAR(36)   NOT NULL REFERENCES operators("operatorId"),
    "checkInTime"     TIMESTAMP     NOT NULL,
    "checkOutTime"    TIMESTAMP,
    "checkInLat"      DECIMAL(9,6)  NOT NULL,
    "checkInLng"      DECIMAL(9,6)  NOT NULL,
    "pesticideUsedL"  DECIMAL(6,2),
    "areaSprayed"     DECIMAL(8,4),
    "gpsTrail"        JSONB,                                    -- {lat,lng,ts} approx. every 3s
    "manualOverride"  BOOLEAN       NOT NULL DEFAULT FALSE,      -- TRUE only after HTX Manager approval of GPS-out-of-100m check-in (UC03 Alt 3a)
    "syncedAt"        TIMESTAMP                                 -- offline sync timestamp (NFR06, <=30s)
);
SELECT create_hypertable('flight_logs', 'checkInTime', chunk_time_interval => interval '1 month');
CREATE INDEX idx_flight_logs_drone_time ON flight_logs ("droneId", "checkInTime");
-- Checkout confirmation (UC07) relies on the pilot's authenticated session (FR18), not a biometric/PIN field.

-- derived table — supports FR10/NFR01, not one of the 14 logical entities
CREATE TABLE drone_positions (
    "posId"       BIGSERIAL     PRIMARY KEY,
    "droneId"     VARCHAR(36)   NOT NULL REFERENCES drones("droneId"),
    "orderId"     VARCHAR(36)   REFERENCES spray_orders("orderId"),        -- NULL if idle telemetry
    lat           DECIMAL(9,6)  NOT NULL,
    lng           DECIMAL(9,6)  NOT NULL,
    "recordedAt"  TIMESTAMP     NOT NULL DEFAULT NOW()
);
SELECT create_hypertable('drone_positions', 'recordedAt', chunk_time_interval => interval '1 week');
CREATE INDEX idx_drone_positions_latest ON drone_positions ("droneId", "recordedAt" DESC);
-- Retention: flight_logs, drone_positions, audit_logs kept >= 5 years as a WORKING ASSUMPTION pending
-- confirmation of the specific Decree 288/2025/ND-CP article reference (per D2 | 2.4) — not a confirmed legal minimum.

-- ----------------------------------------------------------------------------
-- BAND 5 — COMPLIANCE & COMMUNICATION
-- ----------------------------------------------------------------------------

CREATE TABLE notifications (
    "notificationId"  VARCHAR(36)  NOT NULL PRIMARY KEY,
    "recipientId"     VARCHAR(36)  NOT NULL REFERENCES users("userId"),
    "relatedOrderId"  VARCHAR(36)  REFERENCES spray_orders("orderId"),
    channel           VARCHAR(20)  NOT NULL,       -- SMS | ZALO | PUSH
    "eventType"       VARCHAR(50)  NOT NULL,
    content           TEXT         NOT NULL,
    status             VARCHAR(20)  NOT NULL DEFAULT 'PENDING',  -- PENDING | SENT | FAILED
    "sentAt"          TIMESTAMP
);
CREATE INDEX idx_notifications_recipient_sent ON notifications ("recipientId", "sentAt" DESC);

CREATE TYPE audit_event_type AS ENUM (
    'ORDER_CREATED','ORDER_CANCELLED','WEATHER_OVERRIDE','REPORT_EXPORTED','DATA_ACCESS','CHECKIN','CHECKOUT'
);

CREATE TABLE audit_logs (
    "auditId"          VARCHAR(36)        NOT NULL PRIMARY KEY,
    "eventType"        audit_event_type   NOT NULL,
    "actorId"          VARCHAR(36)        NOT NULL REFERENCES users("userId"),
    "actorRole"        user_role          NOT NULL,
    "targetEntityId"   VARCHAR(36)        NOT NULL,
    "targetEntityType" VARCHAR(50)        NOT NULL,
    description        TEXT               NOT NULL,
    "ipAddress"        VARCHAR(45),
    "occurredAt"       TIMESTAMP          NOT NULL DEFAULT NOW()
);
SELECT create_hypertable('audit_logs', 'occurredAt', chunk_time_interval => interval '1 month');
CREATE INDEX idx_audit_logs_actor_time ON audit_logs ("actorId", "occurredAt" DESC);
-- Append-only: block UPDATE/DELETE at DB level.
CREATE RULE audit_logs_no_update AS ON UPDATE TO audit_logs DO INSTEAD NOTHING;
CREATE RULE audit_logs_no_delete AS ON DELETE TO audit_logs DO INSTEAD NOTHING;
-- GPS check-in overrides (UC03 Alt 3a) are logged here with eventType = CHECKIN.

CREATE TABLE reports (
    "reportId"       VARCHAR(36)  NOT NULL PRIMARY KEY,
    "generatedBy"    VARCHAR(36)  NOT NULL REFERENCES users("userId"),
    "cooperativeId"  VARCHAR(36)  NOT NULL REFERENCES cooperatives("cooperativeId"),
    "reportType"     VARCHAR(20)  NOT NULL,       -- DECREE_288 | VIETGAP | GLOBALGAP
    "periodStart"    DATE         NOT NULL,
    "periodEnd"      DATE         NOT NULL,
    "fileFormat"     VARCHAR(10)  NOT NULL,       -- PDF | XLSX
    "fileUrl"        TEXT         NOT NULL,
    "exportedAt"     TIMESTAMP    NOT NULL DEFAULT NOW()
);
-- DECREE_288 layout aligned to Plant Protection Dept fields, exact official format pending authority
-- confirmation (FR14). VietGAP/GlobalGAP field set is project-defined, pending export-company validation (FR15).

-- ============================================================================
-- REVIEW CHECKLIST BEFORE SUBMITTING (do this part yourself — not mechanical):
--   [ ] Confirm every FK direction/cardinality still matches ERD_v3.1.drawio band diagram
--   [ ] Confirm ENUM value lists match the latest Class Diagram (UML v3.1) status/role enums
--   [ ] "reportType" and "channel" left as VARCHAR + comment (not native ENUM) since D3 prose
--       didn't specify exact ENUM(n) sizing for them — decide if that should change
--   [ ] Test-run against a scratch PostgreSQL 16 + PostGIS + TimescaleDB instance if time allows
-- ============================================================================
