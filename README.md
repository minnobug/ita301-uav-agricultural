# AgriUAV Platform — ITA301 RBL Project

> **Course:** ITA301 – Information System Analysis & Design
> **Semester:** Summer 2026 | **Team:** 3 | **Sub-domain:** Agricultural UAV
> **Lecture:** Trần Thanh Nguyên | FPT University HCM

---

## 📌 Problem Statement

*"Các hợp tác xã và doanh nghiệp dịch vụ drone tại ĐBSCL hiện đang gặp vấn đề **thiếu công cụ số** để lập lịch, điều phối và giám sát đội drone phun thuốc, dẫn đến lãng phí nhiên liệu/thuốc BVTV, không truy xuất được nhật ký phun, và không đáp ứng yêu cầu báo cáo của Cục BVTV — gây **tăng chi phí vận hành 15–20%** và rủi ro pháp lý theo Nghị định 288/2025/NĐ-CP.*
>
> *Hệ thống **AgriUAV Platform** được thiết kế để tự động hóa lập lịch, điều phối drone phun thuốc chính xác qua field mapping, tính toán liều lượng theo vùng, và theo dõi tiến độ phun real-time — phục vụ đội drone tối đa 50 máy/HTX tại vùng canh tác lúa ĐBSCL."*

---

## 👥 Team Members

| Full Name              | Student ID | Role            | Main Responsibilities                        |
|------------------------|------------|-----------------|----------------------------------------------|
| Đặng Thành Công        | SE193711   | Project Manager | Team coordination, overall project synthesis |
| Nguyễn Thị Thanh Thảo | SE191001   | Business Analyst| D1 – Proposal, D2 – SRS                     |
| Lê Văn Minh            | SE192904   | System Analyst  | D3 – System Modeling (DFD, UML, ERD)        |
| Trần Anh Khoa          | SE194870   | System Designer | D4 – Architecture, UI, Security              |
| Đặng Võ Thanh Hiếu     | SE201011   | Presenter / QA  | D5 – Slides, Q&A, Quality Control           |

---

## Repository Structure

The repository stores the team’s ITA301 design deliverables.

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

| Deliverable | Description | Deadline | Weight | Status |
|---|---|---|---|---|
| [D1 – Project Proposal](./D1-project-proposal/) | Business problem, stakeholder map, scope, WBS, risk register | W3 | 15% | ✅ Submitted |
| [D2 – SRS Document](./D2-requirements-srs/) | ≥15 FR, ≥5 NFR, ≥8 Use Cases in IEEE 830 format | W4 | 25% | ✅ Submitted |
| [D3 – System Modeling](./D3-system-modeling/) | DFD L0+L1, UML (Class/Sequence/Activity), ERD 3NF | W6 | 30% | 🔄 In progress |
| [D4 – System Design](./D4-system-design-sdd/) | Architecture, UI wireframes, security model, QA plan | W9 | 20% | ⬜ Not submitted |
| [D5 – Final Defense](./D5-presentation-defense/) | 20 slides + prototype demo + Q&A | W10–W11 | 10% | ⬜ Not submitted |

> Update status after each milestone: `⬜ Not submitted` → `🔄 In progress` → `✅ Submitted`

---

## AI Audit Log

Audit log is maintained in `AI-audit-log/ITA301_AuditLog_AgriUAV_v1.0.docx`.

- Target: 25 entries, current progress 12.
- AI support: Claude, ChatGPT, NoteboolLM, Gemini.
- Purpose: document AI usage, validate outputs, and record domain-specific corrections.

---

## Stakeholders

The project supports core users and regulatory stakeholders for agricultural drone operations.

| Stakeholder | Role |
|---|---|
| Cooperative Management (HTX) | Schedule missions, dispatch fleet, monitor operations and costs |
| Operators / Drone Pilots | Execute flight plans and report mission status via mobile app |
| Rice Farmers | Request spraying service, receive notifications, and track application history |
| Agricultural Exporters | Access spraying history for compliance with VietGAP / GlobalGAP |
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

---

## Tools Used

| Purpose | Tool |
|---|---|
| UML diagrams | PlantUML |
| DFD & flowchart | draw.io |
| UI wireframes | Figma |
| SRS / SDD documentation | Microsoft Word (IEEE 830) |
| ERD | draw.io / dbdiagram.io |
| AI assistance | Claude, ChatGPT, Gemini, NotebookLM |
| Version control | Git + GitHub |

---

## References

[1] Nguyen, D.L. et al. (2026). "The Effect of Farm Size on the Decision to Adopt Digital Technology: The Case of Unmanned Aerial Vehicles in Rice Production in Vietnam." Research on World Agricultural Economy. https://journals.nasspublishing.com/index.php/rwae/article/view/2358

[2] Government of Vietnam. Decree No. 288/2025/ND-CP. https://thuvienphapluat.vn/van-ban/Giao-thong-Van-tai/Nghidinh-288-2025-ND-CP-quan-ly-tau-bay-khong-nguoi-lai-va-phuong-tien-bay-khac-679996.aspx

[3] Thanh Nien Newspaper. (June 2025). https://thanhnien.vn/bung-no-uav-nong-nghiep-o-mien-tay-185250617232615926.htm

[4] Dan Viet Digital News. (2024). https://tuoitre.vn/drone-phun-thuoc-tru-sau-va-vaoday-110kv-gay-mat-dien-o-5-huyen-tai-long-an-20241014173928997.htm

[5] Vietnam Naval News. (2024). https://baohaiquanvietnam.vn/tin-tuc/quan-ly-thiet-bi-bay-khong-nguoi-lai-trong-nongnghiep-khong-de-cong-nghe-tro-thanh-hiem-hoa

[6] Vietnam News. (2026). https://vietnamnews.vn/society/1688198/use-of-agricultural-drones-on-the-rise-in-the-mekong-delta.html

[7] Lao Dong Newspaper. (2025). https://laodong.vn/xa-hoi/drone-nong-nghiep-va-bai-toan-so-hoa-o-dbscl-1498970.ldo

[8] CropLife Vietnam. (2025). https://croplifevietnam.org/toadam-dua-drone-tro-thanh-tro-thu-dac-luc-cua-nha-nong.html

---

## Scope Boundaries

**In scope:** Fleet scheduling, real-time drone monitoring, GIS field mapping, pilot management, compliance report export (PDF/Excel), Zalo/SMS notifications.

**Out of scope:** Hardware flight control, AI pest detection (computer vision), payment gateway, direct API integration with Cục Tác chiến, multi-cooperative federation.

> This repository is for ITA301 analysis and design documentation only: SRS, UML, SDD, wireframes — not backend/frontend source code.

---

*ITA301 – Summer 2026 | FPT University HCM*