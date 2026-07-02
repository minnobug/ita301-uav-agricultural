# AgriUAV Platform — ITA301 RBL Project

> **Course:** ITA301 – Information System Analysis & Design
> **Semester:** Summer 2026 | **Team:** 3 | **Sub-domain:** Agricultural UAV
> **Lecture:** Trần Thanh Nguyên | FPT University HCM
> **Last updated:** 2026-07-02 — for the authoritative file per deliverable, see the "latest" version noted in the table below, not just the newest date in the folder listing.

---

## Problem Statement

*"Các hợp tác xã và doanh nghiệp dịch vụ drone tại ĐBSCL hiện đang gặp vấn đề **thiếu công cụ số** để lập lịch, điều phối và giám sát đội drone phun thuốc, dẫn đến lãng phí nhiên liệu/thuốc BVTV, không truy xuất được nhật ký phun, và không đáp ứng yêu cầu báo cáo của Cục BVTV — gây **tăng chi phí vận hành 15–20%** và rủi ro pháp lý theo Nghị định 288/2025/NĐ-CP.*
>
> *Hệ thống **AgriUAV Platform** được thiết kế để tự động hóa lập lịch, điều phối drone phun thuốc chính xác qua field mapping, tính toán liều lượng theo vùng, và theo dõi tiến độ phun real-time — phục vụ đội drone tối đa 50 máy/HTX tại vùng canh tác lúa ĐBSCL."*

---

## Team Members

| Full Name              | Student ID | Role            | Main Responsibilities                        |
|------------------------|------------|-----------------|------------------------------------------------|
| Đặng Thành Công        | SE193711   | Project Manager | Team coordination, overall project synthesis |
| Nguyễn Thị Thanh Thảo | SE191001   | Business Analyst| D1 – Proposal, D2 – SRS                     |
| Lê Văn Minh            | SE192904   | System Analyst  | D3 – System Modeling (DFD, UML, ERD)        |
| Trần Anh Khoa          | SE194870   | System Designer | D4 – Architecture, UI, Security              |
| Đặng Võ Thanh Hiếu     | SE201011   | Presenter / QA  | D5 – Slides, Q&A, Quality Control           |

---

## Repository Structure

The repository stores the team's ITA301 design deliverables.

```
ita301-uav-agricultural/
├── README.md
├── D1-project-proposal/
├── D2-requirements-srs/
├── D3-system-modeling/
├── D4-system-design-sdd/
├── D5-presentation-defense/
├── AI-audit-log/
└── assets/
```

---

## Deliverables & Timeline

| Deliverable                                                    | Description | Deadline | Weight | Status |
|------------------------------------------------------------------|---|---|---|---|
| [D1 – Project Proposal](./D1-project-proposal/) - latest: v1.6 | Business problem, stakeholder map, scope, WBS, risk register | W3 | 15% | ✅ Submitted |
| [D2 – SRS Document](./D2-requirements-srs/) - latest: v2.4      | 21 FR, 7 NFR, 10 Use Cases in IEEE 830 format | W4 | 25% | ✅ Submitted |
| [D3 – System Modeling](./D3-system-modeling/) - latest: v3.1 | DFD L0+L1, UML (Class/Use Case/Sequence/Activity — StarUML), ERD 3NF, Data Dictionary, Traceability | W6 | 30% | ✅ Submitted |
| [D4 – System Design](./D4-system-design-sdd/)                  | Architecture, UI wireframes, security model, QA plan | W9 | 20% | 🔄 In progress |
| [D5 – Final Defense](./D5-presentation-defense/)               | 20 slides + prototype demo + Q&A | W10–W11 | 10% | ⬜ Not submitted |

> Update status after each milestone: `⬜ Not submitted` → `🔄 In progress` → `✅ Submitted`. When bumping status, also update the "latest: vX.Y" tag above so it always points to the current authoritative file.

---

## AI Audit Log

Audit log is maintained in `AI-audit-log/`.

- Target: 25 entries, current progress 20 (through D3, entries #01-20).
- AI support: Claude, ChatGPT, NotebookLM, Gemini.
- Purpose: document AI usage, validate outputs, and record domain-specific corrections.

---

## Stakeholders

The project supports core users and regulatory stakeholders for agricultural drone operations.

| Stakeholder | Role |
|---|---|
| Cooperative Management (HTX) | Schedule missions, dispatch fleet, monitor operations and costs |
| Operators / Drone Pilots | Execute flight plans and report mission status via mobile app |
| Rice Farmers | Request spraying service, receive notifications, and track application history |
| Agricultural Exporters | Access spraying history for compliance with VietGAP / GlobalGAP (post-MVP, via HTX Manager) |
| Cục BVTV / Cục Tác chiến | Oversee regulatory compliance and flight approvals |

---

## Traceability

All deliverables must remain logically aligned across project phases:

```
D1 Proposal  ──►  D2 SRS  ──►  D3 Models  ──►  D4 SDD
(Business)       (Requirements)  (Modeling)     (Design)
```

- Every FR in D2 must map to a Use Case in D3.
- Every Use Case in D3 must trace to an architecture decision in D4.
- D3 v3.1 traceability matrix: 21/21 FRs documented, ≈90% traced to Class Diagram / DB table, ≈90% traced to ≥1 UC.

---

## Tools Used

| Purpose | Tool |
|---|---|
| UML diagrams (primary, submission evidence) | StarUML (`.mdj`) |
| UML diagrams (reference only) | PlantUML (`.puml`) |
| DFD & ERD | draw.io |
| UI wireframes | Figma |
| SRS / SDD documentation | Microsoft Word (IEEE 830) |
| AI assistance | Claude, ChatGPT, Gemini, NotebookLM |
| Version control | Git + GitHub |

---

## References

[1] Nguyen, D. L., Cao, H. V., Nguyen, N. A. T., Duong, V. T. T., & Nguyen, T. H. (2025). "The Effect of Farm Size on the Decision to Adopt Digital Technology: The Case of Unmanned Aerial Vehicles in Rice Production in Vietnam." Research on World Agricultural Economy, 7(1), 117–132. https://doi.org/10.36956/rwae.v7i1.2358

[2] Government of Vietnam. Decree No. 288/2025/ND-CP. https://thuvienphapluat.vn/van-ban/Giao-thong-Van-tai/Nghi-dinh-288-2025-ND-CP-quan-ly-tau-bay-khong-nguoi-lai-va-phuong-tien-bay-khac-679996.aspx

[3] Thanh Nien Newspaper. (June 2025). https://thanhnien.vn/bung-no-uav-nong-nghiep-o-mien-tay-185250617232615926.htm

[4] Tuoi Tre Newspaper. (2024). https://tuoitre.vn/drone-phun-thuoc-tru-sau-va-vao-day-110kv-gay-mat-dien-o-5-huyen-tai-long-an-20241014173928997.htm

[5] Vietnam Naval News. (2025). https://baohaiquanvietnam.vn/tin-tuc/quan-ly-thiet-bi-bay-khong-nguoi-lai-trong-nong-nghiep-khong-de-cong-nghe-tro-thanh-hiem-hoa

[6] Vietnam News. (2024). https://vietnamnews.vn/society/1688198/use-of-agricultural-drones-on-the-rise-in-the-mekong-delta.html

[7] Lao Dong Newspaper. (2025). https://laodong.vn/xa-hoi/drone-nong-nghiep-va-bai-toan-so-hoa-o-dbscl-1498970.ldo

[8] CropLife Vietnam. (2025). https://croplifevietnam.org/toa-dam-dua-drone-tro-thanh-tro-thu-dac-luc-cua-nha-nong.html

[9] VnExpress. (2025). "UAV Việt có tiềm năng cạnh tranh thế giới", citing Markets & Data. https://vnexpress.net/uav-viet-co-tiem-nang-canh-tranh-the-gioi-4991987.html

---

## Scope Boundaries

**In scope:** Fleet scheduling, near real-time drone monitoring, GIS field mapping, pilot management, compliance-support report export (PDF/Excel), Zalo/SMS notifications.

**Out of scope:** Hardware flight control, AI pest detection (computer vision), payment gateway, direct API integration with Cục Tác chiến (UTM), multi-cooperative federation, native MAVLink telemetry (post-MVP).

> This repository is for ITA301 analysis and design documentation only: SRS, UML, SDD, wireframes — not backend/frontend source code.

---

*ITA301 – Summer 2026 | FPT University HCM*