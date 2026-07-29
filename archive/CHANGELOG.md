# Version History — AgriUAV Platform (ITA301 Group 3)

Full version history for all deliverables. Final versions live in the main folders.

---

## D1 — Project Proposal

| Version | Date | Key Changes |
|---------|------|-------------|
| v1.0 | 2026-05-30 | Initial draft — topic selection, problem statement |
| v1.1 | 2026-05-31 | Stakeholder map, AS-IS process added |
| v1.2 | 2026-06-02 | 3-layer ecosystem model (Hardware / Service / Platform) |
| v1.3 | 2026-06-10 | Citation audit, Decree 288/2025 references verified |
| v1.4 | 2026-06-16 | Fix citation overclaim (Vietnam Naval News, TAA) |
| v1.5 | 2026-06-25 | RQ alignment pass with D2 scope |
| v1.6 | 2026-06-25 | Scope fix — maxDrones configurable, not hard limit |
| **v1.7** | **2026-07-17** | **FINAL — defense-ready, all RQs confirmed** |

---

## D2 — Software Requirements Specification (SRS)

| Version | Date | Key Changes |
|---------|------|-------------|
| v2.1 | 2026-06-13 | Initial SRS draft, FR1–FR10 defined |
| v2.2 | 2026-06-13 | UC diagram, NFR section added |
| v2.3 | 2026-06-17 | UC expansion to 8 use cases, user stories added |
| v2.4 | 2026-06-24 | Self-audit: 10 consistency issues fixed (Audit Log Entry #13) |
| **v2.5** | **2026-07-17** | **FINAL — FR12 geofence 50m buffer, NFR offline-first confirmed** |

---

## D3 — System Modeling

| Version | Date | Key Changes |
|---------|------|-------------|
| v3.0 | 2026-06-28 | DFD L0/L1, Class Diagram, Sequence Diagrams, ERD v1 |
| v3.1 | 2026-06-28 | Physical data model (15 tables), DDL, TimescaleDB hypertable |
| **v3.2** | **2026-07-19** | **FINAL — ERD v1.8 (PostGIS, RBAC, audit_logs append-only)** |

Diagram history:
- `ERD_AgriUAV_v1.7.drawio` → superseded by v1.8 (geofence_zones table added)

---

## D4 — System Design Document (SDD)

| Version | Date | Key Changes |
|---------|------|-------------|
| v4.1 | 2026-07-07 | Initial SDD draft (misnamed as D3 file — early iteration) |
| v4.2 | 2026-07-07 | Architecture diagrams, RBAC matrix added |
| v4.3 | 2026-07-12 | Deployment diagrams (3 views), wireframes v1 |
| v4.4 | 2026-07-12 | UI/UX personas, user journey map |
| v4.5 | 2026-07-18 | Telemetry contradiction flagged (3s vs 250ms) |
| v4.6 | 2026-07-19 | AI Audit Log appendix, Design Rationale added |
| **v4.7** | **2026-07-19** | **FINAL — Wireframes v3.0, Khoa final review pass** |

Wireframe history:
- `Wireframes_v1.0.fig` → 3 screens (HTX Manager, Farmer, Pilot)
- `Wireframes_v2.0.fig` → expanded to 8 screens
- `Wireframes_v3.0.fig` → FINAL, 12 screens covering all personas
