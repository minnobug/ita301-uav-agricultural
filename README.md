# AgriUAV Platform

**ITA301 – Information System Analysis & Design**

> Precision Agricultural Drone Spraying Coordination Platform for Rice Cooperatives in the Mekong Delta

**Status: Completed — July 2026**

---

## Group 3 (IS1901)

| Role | Member | Student ID |
|------|--------|------------|
| Project Manager | Đặng Thành Công | SE193711 |
| Business Analyst | Nguyễn Thị Thanh Thảo | SE191001 |
| System Analyst | Lê Văn Minh | SE192904 |
| System Designer | Trần Anh Khoa | SE194870 |
| Presenter / QA | Đặng Võ Thanh Hiếu | SE201011 |

**Instructor:** Mr. Trần Thanh Nguyên

---

## 📋 Problem Statement

Agricultural cooperatives (HTX) in the Mekong Delta manage drone spraying fleets using Zalo and Excel — no digital coordination layer exists at the platform level. This causes scheduling conflicts, compliance gaps under Decree 288/2025/NĐ-CP, and zero traceability for VietGAP/GlobalGAP audits.

AgriUAV Platform fills this gap: a Web Dashboard + Mobile App system for scheduling, dispatch, near real-time monitoring, and compliance reporting.

**Empirical basis:** Nguyen et al. (2025), N=940 rice farmers across Mekong Delta provinces.

---

## 📦 Deliverables

| # | Deliverable | Final Version | Standard |
|---|-------------|--------------|----------|
| D1 | Project Proposal | v1.7 | RBL/DSR |
| D2 | Software Requirements Specification | v2.5 | IEEE 830-1998 |
| D3 | System Modeling (DFD, UML, ERD, DD) | v3.2 | UML 2.x / IDEF |
| D4 | System Design Document | v4.7 | IEEE 1016 |
| D5 | AI Audit Log + Human Delta + Design Rationale | v1.1 | RBL Insight |

---

## 📁 Repository Structure

```
ita301-uav-agricultural/
│
├── D1-project-proposal/       ← Project Proposal (final v1.7)
├── D2-requirements-srs/       ← SRS (final v2.5)
├── D3-system-modeling/        ← System Models + ERD/DFD sources (final v3.2)
├── D4-system-design/          ← SDD + Deployment diagrams + Wireframes (final v4.7)
├── D5-reflection/             ← AI Audit Log, Human Delta, Design Rationale
├── diagrams-source/           ← StarUML .mdj source file
├── archive/
│   ├── CHANGELOG.md           ← Full version history
│   ├── D1-history/            ← D1 v1.0 → v1.6
│   ├── D2-history/            ← D2 v2.1 → v2.4
│   ├── D3-history/            ← D3 v3.0 → v3.1 + ERD v1.7
│   └── D4-history/            ← D4 v4.1 → v4.6 + Wireframes v1/v2
├── README.md
├── LICENSE
└── .gitignore
```

> **Note on versions:** Main branch contains only the final version of each deliverable. Full version history with changelogs is preserved in `archive/`.

---

## 🏗️ System Architecture

**Tech Stack:**
- **DB:** PostgreSQL 16 + PostGIS 3.4 + TimescaleDB 2.x
- **Backend:** REST API + WebSocket (near real-time telemetry)
- **Frontend:** Web Dashboard (React) + Mobile App (React Native)
- **Auth:** JWT + RBAC — 5 roles: Admin, HTX Manager, Operator, Farmer, Agronomist
- **Design constraint:** Offline-first sync for unstable 4G in field conditions

**Data Model:** 15 tables across 5 bands:
`Identity & Org` → `Field & Agronomy` → `Fleet & Safety` → `Operations` → `Compliance & Audit`

**Key file:** [`D4-system-design/AgriUAV_PhysicalDataModel_DDL_v1.0.sql`](D4-system-design/AgriUAV_PhysicalDataModel_DDL_v1.0.sql)

---

## 🤖 AI Usage — RBL Audit Log

This project follows FPT University's **RBL Insight** framework (AI Reflection = 30% of project grade).

- **25 Audit Log entries** spanning D1–D5
- Every entry documents: AI prompt → AI output → problem identified → human correction → artifact changed
- Full log: [`D5-reflection/ITA301_G3_D5_20260719_AIAuditLog_v1.1.pdf`](D5-reflection/ITA301_G3_D5_20260719_AIAuditLog_v1.1.pdf)

---

## 📚 Key References

1. Nguyen, D.L. et al. (2025). *UAVs in Rice Production in Vietnam.* Research on World Agricultural Economy.
2. Nghị định 288/2025/NĐ-CP — Quản lý tàu bay không người lái (hiệu lực 05/11/2025).
3. IEEE Std 830-1998 — Software Requirements Specifications.

---

## 📄 License

MIT — Academic project, FPT University HCM, Summer 2026.
