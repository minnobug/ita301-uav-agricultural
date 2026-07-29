
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS timescaledb;

-- ----------------------------------------------------------------------------
-- BAND 1 — IDENTITY & ORGANIZATION
-- ----------------------------------------------------------------------------

CREATE TYPE user_role AS ENUM ('ADMIN','HTX_MANAGER','OPERATOR','FARMER','AGRONOMIST');

CREATE TABLE users (
    id              UUID          PRIMARY KEY DEFAULT uuid_generate_v4(),
    email           VARCHAR(255)  NOT NULL UNIQUE,
    password_hash   VARCHAR(255)  NOT NULL,                 -- bcrypt hash, cost 12
    full_name       VARCHAR(100)  NOT NULL,
    role            user_role     NOT NULL,
    phone_number    VARCHAR(15),
    is_active       BOOLEAN       NOT NULL DEFAULT TRUE,    -- soft-delete flag; use this instead of hard DELETE (Decree 288 traceability)
    created_at      TIMESTAMP     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP     NOT NULL DEFAULT NOW()
);

CREATE TABLE cooperatives (
    id          UUID          PRIMARY KEY DEFAULT uuid_generate_v4(),
    name        VARCHAR(255)  NOT NULL,
    province    VARCHAR(100)  NOT NULL,
    address     TEXT,
    max_drones  INTEGER       NOT NULL DEFAULT 50,          -- configurable reference workload, not a hard limit (D1 §1.2)
    manager_id  UUID          NOT NULL,
    created_at  TIMESTAMP     NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_cooperative_manager FOREIGN KEY (manager_id) REFERENCES users(id) ON DELETE RESTRICT
);

-- ----------------------------------------------------------------------------
-- BAND 2 — FIELD & AGRONOMY
-- ----------------------------------------------------------------------------

CREATE TABLE fields (
    id               UUID                     PRIMARY KEY DEFAULT uuid_generate_v4(),
    farmer_id        UUID                     NOT NULL,
    cooperative_id   UUID                     NOT NULL,
    name             VARCHAR(255)             NOT NULL,
    crop_type        VARCHAR(100)             NOT NULL,     -- e.g. rice, corn
    area_size        DECIMAL(10,2)            NOT NULL,     -- auto-computed via PostGIS ST_Area
    location_polygon GEOMETRY(Polygon, 4326),               -- native PostGIS geometry
    created_at       TIMESTAMP                NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_field_farmer      FOREIGN KEY (farmer_id)      REFERENCES users(id)        ON DELETE CASCADE,
    CONSTRAINT fk_field_cooperative FOREIGN KEY (cooperative_id) REFERENCES cooperatives(id) ON DELETE RESTRICT
);
CREATE INDEX idx_fields_location ON fields USING GIST (location_polygon);

CREATE TABLE pesticides (
    id                UUID          PRIMARY KEY DEFAULT uuid_generate_v4(),
    name              VARCHAR(255)  NOT NULL,
    active_ingredient VARCHAR(255)  NOT NULL,
    is_approved_bvtv  BOOLEAN       NOT NULL DEFAULT FALSE,  -- checked at booking (UC01 Alt 4a, FR03)
    unit              VARCHAR(20)   NOT NULL DEFAULT 'L',
    created_at        TIMESTAMP     NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_pesticides_approved ON pesticides (is_approved_bvtv);

CREATE TABLE spray_formulas (
    id                    UUID          PRIMARY KEY DEFAULT uuid_generate_v4(),
    field_id              UUID          NOT NULL UNIQUE,     -- 1:1 with fields
    pesticide_id          UUID          NOT NULL,
    dosage_l_per_ha       DECIMAL(6,2)  NOT NULL,            -- FR02
    spray_count_per_season SMALLINT     NOT NULL,
    configured_by         UUID          NOT NULL,            -- Agronomist or HTX Manager (FR02)
    created_at            TIMESTAMP     NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_formula_field        FOREIGN KEY (field_id)      REFERENCES fields(id)     ON DELETE CASCADE,
    CONSTRAINT fk_formula_pesticide    FOREIGN KEY (pesticide_id)  REFERENCES pesticides(id) ON DELETE RESTRICT,
    CONSTRAINT fk_formula_configured   FOREIGN KEY (configured_by) REFERENCES users(id)      ON DELETE RESTRICT
);

CREATE TABLE pesticide_stock (
    id                    UUID          PRIMARY KEY DEFAULT uuid_generate_v4(),
    cooperative_id        UUID          NOT NULL,
    pesticide_id          UUID          NOT NULL,
    stock_l               DECIMAL(8,2)  NOT NULL DEFAULT 0,
    low_stock_threshold_l DECIMAL(8,2)  NOT NULL,            -- alert fires when stock_l < threshold (FR16)
    updated_at            TIMESTAMP     NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_stock_cooperative FOREIGN KEY (cooperative_id) REFERENCES cooperatives(id) ON DELETE CASCADE,
    CONSTRAINT fk_stock_pesticide   FOREIGN KEY (pesticide_id)   REFERENCES pesticides(id)   ON DELETE RESTRICT,
    CONSTRAINT uq_stock_coop_pest   UNIQUE (cooperative_id, pesticide_id)
);

-- ----------------------------------------------------------------------------
-- BAND 3 — FLEET & SAFETY
-- ----------------------------------------------------------------------------

CREATE TYPE drone_status AS ENUM ('IDLE','FLYING','MAINTENANCE','OFFLINE');

CREATE TABLE drones (
    id              UUID          PRIMARY KEY DEFAULT uuid_generate_v4(),
    cooperative_id  UUID          NOT NULL,
    serial_number   VARCHAR(100)  NOT NULL UNIQUE,           -- Decree 288/2025 drone identifier (FR21)
    model           VARCHAR(100)  NOT NULL,                  -- e.g. DJI Agras T40
    tank_capacity   DECIMAL(10,2) NOT NULL,
    status          drone_status  NOT NULL DEFAULT 'IDLE',
    battery_percent SMALLINT      NOT NULL DEFAULT 100,      -- mobile-GPS proxy / simulated telemetry (MVP)
    gps_lat         DECIMAL(9,6),
    gps_lng         DECIMAL(9,6),
    created_at      TIMESTAMP     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP     NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_drone_cooperative FOREIGN KEY (cooperative_id) REFERENCES cooperatives(id) ON DELETE RESTRICT
);
CREATE INDEX idx_drones_status ON drones (status);

CREATE TABLE operators (
    id                  UUID         PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id             UUID         NOT NULL UNIQUE,
    certificate_number  VARCHAR(100) NOT NULL UNIQUE,        -- Decree 288/2025 pilot certificate
    certificate_expiry  DATE         NOT NULL,               -- validated on every assignment (UC02)
    experience_years    INTEGER      NOT NULL DEFAULT 0,
    status              VARCHAR(50)  NOT NULL DEFAULT 'ACTIVE'  -- ACTIVE | ON_LEAVE | SUSPENDED
                            CHECK (status IN ('ACTIVE','ON_LEAVE','SUSPENDED')),
    CONSTRAINT fk_operator_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX idx_operators_cert_expiry ON operators (certificate_expiry);

CREATE TABLE geofences (
    id               UUID                     PRIMARY KEY DEFAULT uuid_generate_v4(),
    field_id         UUID                     NOT NULL UNIQUE,    -- 1:1 with fields
    boundary_polygon GEOMETRY(Polygon, 4326)  NOT NULL,
    buffer_meters    INTEGER                  NOT NULL DEFAULT 50, -- 50m buffer around 110kV lines (FR12)
    hazard_zones     JSONB,                                        -- [{type:'POWERLINE'|'RESIDENTIAL', coords}]
    is_active        BOOLEAN                  NOT NULL DEFAULT FALSE, -- set TRUE on UC03 check-in
    created_at       TIMESTAMP                NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_geofence_field FOREIGN KEY (field_id) REFERENCES fields(id) ON DELETE CASCADE
);
CREATE INDEX idx_geofences_boundary ON geofences USING GIST (boundary_polygon);

CREATE TABLE drone_maintenance (
    id               UUID          PRIMARY KEY DEFAULT uuid_generate_v4(),
    drone_id         UUID          NOT NULL,
    maintenance_date DATE          NOT NULL,
    description      TEXT          NOT NULL,
    cost             DECIMAL(12,2) NOT NULL DEFAULT 0,
    performed_by     VARCHAR(100),
    CONSTRAINT fk_maintenance_drone FOREIGN KEY (drone_id) REFERENCES drones(id) ON DELETE CASCADE
);

-- ----------------------------------------------------------------------------
-- BAND 4 — OPERATIONS
-- ----------------------------------------------------------------------------

CREATE TYPE order_status AS ENUM ('PENDING','ASSIGNED','IN_PROGRESS','COMPLETED','SUSPENDED','CANCELLED');

CREATE TABLE spray_orders (
    id                UUID          PRIMARY KEY DEFAULT uuid_generate_v4(),
    farmer_id         UUID          NOT NULL,
    field_id          UUID          NOT NULL,
    drone_id          UUID,                                   -- NULL until assigned (UC02)
    operator_id       UUID,                                   -- NULL until assigned
    scheduled_date    TIMESTAMP     NOT NULL,
    actual_start_time TIMESTAMP,
    status            order_status  NOT NULL DEFAULT 'PENDING',
    status_reason     TEXT,                                   -- 'Weather' | 'Needs Review' | 'Lacking safety confirmation' | 'Confirmation timeout'
    cancel_reason     TEXT,
    created_at        TIMESTAMP     NOT NULL DEFAULT NOW(),
    -- UC02 Alt 3a: no-assign path keeps status = PENDING, not CANCELLED
    CONSTRAINT fk_order_farmer   FOREIGN KEY (farmer_id)   REFERENCES users(id)       ON DELETE CASCADE,
    CONSTRAINT fk_order_field    FOREIGN KEY (field_id)    REFERENCES fields(id)      ON DELETE CASCADE,
    CONSTRAINT fk_order_drone    FOREIGN KEY (drone_id)    REFERENCES drones(id)      ON DELETE SET NULL,
    CONSTRAINT fk_order_operator FOREIGN KEY (operator_id) REFERENCES operators(id)   ON DELETE SET NULL
);
CREATE INDEX idx_spray_orders_field_date ON spray_orders (field_id, scheduled_date);  -- conflict checks (FR04)
CREATE INDEX idx_spray_orders_status     ON spray_orders (status);

CREATE TABLE flight_logs (
    id                  UUID         PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id            UUID         NOT NULL UNIQUE,         -- 1:1 with spray_orders
    drone_id            UUID         NOT NULL,
    operator_id         UUID         NOT NULL,
    start_time          TIMESTAMP,
    end_time            TIMESTAMP,
    check_in_lat        DECIMAL(9,6),
    check_in_lng        DECIMAL(9,6),
    total_area_sprayed  DECIMAL(10,2),
    pesticide_used_l    DECIMAL(6,2),                         -- actual volume entered at check-out (UC07); compared against formula for >20% deviation (UC07 Alt 2a)
    gps_trail           JSONB,                                -- [{lat,lng,ts}] approx. every 3s
    manual_override     BOOLEAN      NOT NULL DEFAULT FALSE,  -- TRUE after HTX Manager approval (UC03 Alt 3a)
    synced_at           TIMESTAMP,                            -- offline sync timestamp (NFR06, <=30s)
    status              VARCHAR(50)  NOT NULL DEFAULT 'IN_FLIGHT'
                            CHECK (status IN ('IN_FLIGHT','COMPLETED','FAILED')),
    CONSTRAINT uq_flight_order    UNIQUE (order_id),
    CONSTRAINT fk_flight_order    FOREIGN KEY (order_id)    REFERENCES spray_orders(id) ON DELETE CASCADE,
    CONSTRAINT fk_flight_drone    FOREIGN KEY (drone_id)    REFERENCES drones(id)       ON DELETE RESTRICT,
    CONSTRAINT fk_flight_operator FOREIGN KEY (operator_id) REFERENCES operators(id)    ON DELETE RESTRICT
);
SELECT create_hypertable('flight_logs', 'start_time', chunk_time_interval => interval '1 month');
CREATE INDEX idx_flight_logs_drone_time ON flight_logs (drone_id, start_time);

CREATE TABLE drone_positions (
    id            UUID          PRIMARY KEY DEFAULT uuid_generate_v4(),
    flight_log_id UUID          NOT NULL,
    latitude      DECIMAL(10,8) NOT NULL,
    longitude     DECIMAL(11,8) NOT NULL,
    altitude      DECIMAL(10,2) NOT NULL,
    speed         DECIMAL(10,2),
    recorded_at   TIMESTAMP     NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_position_flight FOREIGN KEY (flight_log_id) REFERENCES flight_logs(id) ON DELETE CASCADE
);
SELECT create_hypertable('drone_positions', 'recorded_at', chunk_time_interval => interval '1 week');
CREATE INDEX idx_drone_positions_flight_time ON drone_positions (flight_log_id, recorded_at DESC);
-- Retention >= 5 years: working assumption pending confirmation of Decree 288/2025 article (D2 §2.4)

CREATE TABLE weather_conditions (
    id          UUID          PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id    UUID          NOT NULL,
    temperature DECIMAL(5,2),
    wind_speed  DECIMAL(5,2),                                -- threshold >= 3 m/s (assumed, pending expert confirmation)
    humidity    DECIMAL(5,2),
    recorded_at TIMESTAMP     NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_weather_order FOREIGN KEY (order_id) REFERENCES spray_orders(id) ON DELETE CASCADE
);

-- ----------------------------------------------------------------------------
-- BAND 5 — COMPLIANCE & COMMUNICATION
-- ----------------------------------------------------------------------------

CREATE TABLE notifications (
    id         UUID          PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id    UUID          NOT NULL,
    title      VARCHAR(255)  NOT NULL,
    content    TEXT          NOT NULL,
    is_read    BOOLEAN       NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP     NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_notification_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX idx_notifications_user_unread ON notifications (user_id, is_read);

CREATE TABLE audit_logs (
    id                 UUID          PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_type         VARCHAR(50)   NOT NULL
                           CHECK (event_type IN (
                               'ORDER_CREATED','ORDER_CANCELLED','WEATHER_OVERRIDE',
                               'REPORT_EXPORTED','DATA_ACCESS','CHECKIN','CHECKOUT'
                           )),
    actor_id           UUID          NOT NULL,               -- ON DELETE RESTRICT: user with audit history cannot be hard-deleted (Decree 288 traceability)
    actor_role         user_role     NOT NULL,
    target_entity_id   UUID          NOT NULL,
    target_entity_type VARCHAR(50)   NOT NULL,
    description        TEXT          NOT NULL,
    ip_address         VARCHAR(45),
    occurred_at        TIMESTAMP     NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_audit_actor FOREIGN KEY (actor_id) REFERENCES users(id) ON DELETE RESTRICT
);
SELECT create_hypertable('audit_logs', 'occurred_at', chunk_time_interval => interval '1 month');
CREATE INDEX idx_audit_actor_occurred ON audit_logs (actor_id, occurred_at DESC);

-- Append-only enforcement via trigger (D4 §3.1, STRIDE Repudiation control §7.1)
CREATE OR REPLACE FUNCTION prevent_audit_log_modification()
RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'audit_logs is append-only: % is not permitted (Decree 288/2025/ND-CP compliance)', TG_OP;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_logs_append_only
BEFORE UPDATE OR DELETE ON audit_logs
FOR EACH ROW EXECUTE FUNCTION prevent_audit_log_modification();

CREATE TABLE reports (
    id              UUID          PRIMARY KEY DEFAULT uuid_generate_v4(),
    generated_by    UUID          NOT NULL,
    cooperative_id  UUID          NOT NULL,
    report_type     VARCHAR(50)   NOT NULL
                        CHECK (report_type IN ('DECREE_288','VIETGAP','GLOBALGAP')),
    period_start    DATE          NOT NULL,
    period_end      DATE          NOT NULL,
    file_format     VARCHAR(10)   NOT NULL
                        CHECK (file_format IN ('PDF','XLSX')),
    file_url        VARCHAR(255),
    exported_at     TIMESTAMP     NOT NULL DEFAULT NOW(),
    -- DECREE_288 format pending Plant Protection Dept confirmation (FR14)
    -- VietGAP/GlobalGAP field set pending export-company validation (FR15)
    CONSTRAINT fk_report_user        FOREIGN KEY (generated_by)   REFERENCES users(id)        ON DELETE CASCADE,
    CONSTRAINT fk_report_cooperative FOREIGN KEY (cooperative_id) REFERENCES cooperatives(id) ON DELETE RESTRICT
);

-- ============================================================================
-- INDEXING SUMMARY
-- fields.location_polygon          → GIST  (spatial queries, PostGIS ST_Contains)
-- spray_orders.farmer_id           → B-Tree (farmer history joins)
-- spray_orders.status              → B-Tree (active-order filtering, NFR04)
-- flight_logs.order_id             → B-Tree (compliance chain joins, Decree 288)
-- drone_positions.flight_log_id    → B-Tree (telemetry lookups, NFR01 <500ms)
-- drone_positions.recorded_at      → B-Tree (TimescaleDB time-series ORDER BY)
-- notifications.user_id + is_read  → B-Tree composite (unread polling)
-- ============================================================================