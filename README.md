# AgriUAV Platform

**G3_ITA301 – Information System Analysis & Design · FPT University HCM · Summer 2026**

> Precision Agricultural Drone Spraying Coordination Platform for Rice Cooperatives in the Mekong Delta

![Status](https://img.shields.io/badge/status-completed-brightgreen)
![License](https://img.shields.io/badge/license-MIT-blue)
![Academic](https://img.shields.io/badge/academic-not%20production--ready-orange)
![Deliverables](https://img.shields.io/badge/deliverables-D1–D5-informational)

---

| Role | Member | Student ID |
|------|--------|------------|
| Project Manager | Đặng Thành Công | SE193711 |
| Business Analyst | Nguyễn Thị Thanh Thảo | SE191001 |
| System Analyst | Lê Văn Minh | SE192904 |
| System Designer | Trần Anh Khoa | SE194870 |
| Presenter / QA | Đặng Võ Thanh Hiếu | SE201011 |

**Instructor:** Mr. Trần Thanh Nguyên

---

## Problem Statement

Agricultural cooperatives (HTX) in the Mekong Delta currently coordinate drone spraying fleets via Zalo and Excel spreadsheets — no digital platform-level coordination exists. This causes:

- **Scheduling conflicts** between operators across shared fields
- **Compliance gaps** under [Decree 288/2025/NĐ-CP](https://thuvienphapluat.vn/) (effective 05/11/2025) governing unmanned aerial vehicles
- **Zero audit traceability** for VietGAP / GlobalGAP certification requirements

AgriUAV Platform fills this gap with a Web Dashboard + Mobile App system for scheduling, dispatch, near real-time monitoring, and compliance reporting.

**Why not adapt existing platforms?** General-purpose farm management tools (e.g., FarmERP, CropIn) lack drone fleet dispatch logic, Vietnamese regulatory hooks (Cục BVTV, Decree 288), and offline-first design for Mekong Delta 4G conditions. No available platform integrates cooperative RBAC governance with VietGAP audit trail generation.

**Empirical basis:** Nguyen, D.L. et al. (2025), *UAVs in Rice Production in Vietnam*, N=940 rice farmers across Mekong Delta provinces.

---

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        Clients                              │
│   Web Dashboard (React)          Mobile App (React Native)  │
│   HTX Manager / Agronomist       Operator / Farmer          │
└────────────────────┬───────────────────────────┬────────────┘
                     │ REST API                   │ WebSocket
                     ▼                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    Backend Services                          │
│   Auth (JWT + RBAC)   Scheduler   Geofence Engine           │
│   Compliance Reporter  Notification Engine  Offline Sync     │
└────────────────────────────────┬────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────┐
│                      Data Layer                              │
│   PostgreSQL 16 + PostGIS 3.4   TimescaleDB 2.x hypertable  │
│   (drone_positions — time-series telemetry)                  │
└─────────────────────────────────────────────────────────────┘
```

**Tech Stack:**
- **Database:** PostgreSQL 16 + PostGIS 3.4 + TimescaleDB 2.x
- **Backend:** REST API + WebSocket (near real-time telemetry proxy via operator mobile GPS)
- **Frontend:** Web Dashboard (React) + Mobile App (React Native)
- **Auth:** JWT + RBAC — 5 roles: Admin, HTX Manager, Operator, Farmer, Agronomist
- **Design constraint:** Offline-first sync for unstable 4G field conditions

**Data Model:** 14 logical entities in 3NF + 1 TimescaleDB hypertable (`drone_positions`) + 1 junction table (`report_flight_logs`), organized across 4 domain bands:

```
Identity & Organization → Field & Agronomy → Fleet & Safety → Compliance & Audit
                                   ↑
                            spray_orders (central transactional table)
```

Physical DDL: [`D4-system-design/AgriUAV_PhysicalDataModel_DDL_v1.0.sql`](D4-system-design/AgriUAV_PhysicalDataModel_DDL_v1.0.sql)

---

## Deliverables

| # | Deliverable | Final Version | Standard | Description |
|---|-------------|--------------|----------|-------------|
| D1 | Project Proposal | v1.7 | RBL/DSR | Problem statement, stakeholder analysis, project scope, feasibility |
| D2 | Software Requirements Specification | v2.5 | IEEE 830-1998 | FR01–FR21 functional requirements, UC01–UC10 use cases, non-functional constraints |
| D3 | System Modeling | v3.2 | UML 2.x / IDEF | DFD L0+L1, Class Diagram, Use Case Diagram, Sequence Diagrams (UC01/03/04), State Machine Diagrams, ERD, Data Dictionary |
| D4 | System Design Document | v4.7 | IEEE 1016 | Physical data model (DDL), deployment architecture, wireframes, API contract |
| D5 | AI Audit Log + Human Delta + Design Rationale | v1.1 | RBL Insight | 25 AI audit entries D1–D5, human correction documentation, design decision rationale |

---

## Repository Structure

```
ita301-uav-agricultural/
│
├── D1-project-proposal/       ← Project Proposal (final v1.7)
├── D2-requirements-srs/       ← SRS (final v2.5)
├── D3-system-modeling/        ← System Models + ERD/DFD sources (final v3.2)
│   ├── DFD_L0_L1_v1.5.drawio
│   ├── ERD_v1.8.drawio
│   └── AgriUAV_UML.mdj        ← StarUML master model (proof of manual authorship)
├── D4-system-design/          ← SDD + Deployment diagrams + Wireframes (final v4.7)
│   └── AgriUAV_PhysicalDataModel_DDL_v1.0.sql
├── D5-reflection/             ← AI Audit Log, Human Delta, Design Rationale
├── diagrams-source/           ← StarUML .mdj source file
├── archive/
│   ├── CHANGELOG.md           ← Full version history
│   ├── D1-history/            ← D1 v1.0 → v1.6
│   ├── D2-history/            ← D2 v2.1 → v2.4
│   ├── D3-history/            ← D3 v3.0 → v3.1 + ERD v1.7
│   └── D4-history/            ← D4 v4.1 → v4.6 + Wireframes v1/v2
├── README.md
├── LICENSE                    ← MIT (academic use only — not production-ready)
└── .gitignore
```

> **Versioning policy:** `main` branch contains only the final version of each deliverable. Full version history with changelogs is preserved in `archive/`.

---

## Key Design Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Database | PostgreSQL + TimescaleDB | Time-series hypertable for `drone_positions` telemetry; PostGIS for geofence polygon queries |
| Drone telemetry | Operator mobile GPS proxy (MVP) | Native MAVLink sensor integration deferred to post-MVP (see D2 §2.5); reduces hardware dependency |
| Auth model | RBAC with 5 roles (no separate Admin actor) | Admin modeled via `userRole` attribute to avoid diagram pollution; enforces least-privilege per FR13 |
| Offline sync | Offline-first mobile | Mekong Delta 4G coverage is unreliable; spray sessions must proceed without connectivity |
| UML tooling | StarUML `.mdj` as primary source | `.mdj` file pushed to repo as verifiable evidence of manual authorship; PlantUML `.puml` kept as draft only |

---

## Scope & Known Limitations

**In scope (MVP):**
- Cooperative and field registration (UC01–UC10)
- Spray order scheduling, GPS check-in, near real-time monitoring
- Geofence boundary enforcement (`GEOFENCE_BOUNDARY_CROSSING` events)
- Compliance report generation for VietGAP / Cục BVTV audit

**Explicitly out of scope (post-MVP):**
- Export Company integration (reframed as post-MVP per D1 | 1.4)
- Native MAVLink/drone telemetry sensors (post-MVP per D2 | 2.5)
- GlobalGAP full certification workflow
- Multi-cooperative federation management

---

## AI Usage — RBL Audit Log

This project follows FPT University's **RBL Insight** framework (AI Reflection = 30% of project grade).

- **25 audit log entries** spanning D1–D5
- Every entry documents: AI prompt → AI output → problem identified → human correction → artifact changed
- Format enforces critical engagement with AI output, not passive acceptance

Full log: [`D5-reflection/ITA301_G3_D5_20260719_AIAuditLog_v1.1.pdf`](D5-reflection/ITA301_G3_D5_20260719_AIAuditLog_v1.1.pdf)

---

## Key References

1. Nguyen, D.L. et al. (2025). *UAVs in Rice Production in Vietnam.* Research on World Agricultural Economy.
2. Nghị định 288/2025/NĐ-CP — Quản lý tàu bay không người lái (hiệu lực 05/11/2025).
3. IEEE Std 830-1998 — Software Requirements Specifications.
4. IEEE Std 1016-2009 — Software Design Descriptions.

---

## License

MIT — Academic project, FPT University HCM, Summer 2026.
**Not production-ready.** This system has not undergone security audit, load testing, or regulatory certification. Do not deploy in a live cooperative environment without independent review.