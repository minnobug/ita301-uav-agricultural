# 🌾 AgriUAV Platform — ITA301 RBL Project

> **Môn học:** ITA301 – Information System Analysis & Design
> **Học kỳ:** Summer 2026 | **Nhóm:** 3 | **Sub-domain:** Agricultural UAV
> **Giảng viên hướng dẫn:** Trần Thanh Nguyên | FPT University HCM

---

## 📌 Problem Statement

*"Các hợp tác xã và doanh nghiệp dịch vụ drone tại ĐBSCL hiện đang gặp vấn đề **thiếu công cụ số** để lập lịch, điều phối và giám sát đội drone phun thuốc, dẫn đến lãng phí nhiên liệu/thuốc BVTV, không truy xuất được nhật ký phun, và không đáp ứng yêu cầu báo cáo của Cục BVTV — gây **tăng chi phí vận hành 15–20%** và rủi ro pháp lý theo Nghị định 288/2025/NĐ-CP.*
>
> *Hệ thống **AgriUAV Platform** được thiết kế để tự động hóa lập lịch, điều phối drone phun thuốc chính xác qua field mapping, tính toán liều lượng theo vùng, và theo dõi tiến độ phun real-time — phục vụ đội drone tối đa 50 máy/HTX tại vùng canh tác lúa ĐBSCL."*

---

## 👥 Thành viên nhóm

| Full Name              | Student ID | Role            | Main Responsibilities                        |
|------------------------|------------|-----------------|----------------------------------------------|
| Đặng Thành Công        | SE193711   | Project Manager | Team coordination, overall project synthesis |
| Nguyễn Thị Thanh Thảo | SE191001   | Business Analyst| D1 – Proposal, D2 – SRS                     |
| Lê Văn Minh            | SE192904   | System Analyst  | D3 – System Modeling (DFD, UML, ERD)        |
| Trần Anh Khoa          | SE194870   | System Designer | D4 – Architecture, UI, Security              |
| Đặng Võ Thanh Hiếu     | SE201011   | Presenter / QA  | D5 – Slides, Q&A, Quality Control           |
---

## 🗂️ Cấu trúc repo

```
ita301-uav-agricultural/
│
├── README.md
│
├── D1-project-proposal/             ← W3 (15%) 
│   ├── D1_AgriUAV_Proposal_EN.docx
│
├── D2-requirements-srs/             ← W4 (25%)
│   ├── SRS-document.pdf
│   ├── use-cases/
│   ├── user-stories.md
│   └── FR-NFR-table.xlsx
│
├── D3-system-modeling/              ← W6 (30%)
│   ├── dfd/
│   │   ├── dfd-level0.png
│   │   └── dfd-level1.png
│   ├── uml/
│   │   ├── class-diagram.puml
│   │   ├── sequence/
│   │   └── activity/
│   ├── erd/
│   │   ├── erd-logical.png
│   │   ├── erd-physical.png
│   │   └── data-dictionary.md
│   └── traceability-matrix.xlsx
│
├── D4-system-design-sdd/            ← W9 (20%)
│   ├── SDD-document.pdf
│   ├── architecture/
│   │   ├── diagram.png
│   │   ├── tech-stack.md
│   │   └── tradeoff-analysis.md
│   ├── ui-wireframes/
│   └── security/
│       ├── threat-model.md
│       └── qa-plan.md
│
├── D5-presentation-defense/         ← W10–W11 (10%)
│   ├── slides.pptx
│   ├── slides.pdf
│   └── demo-video.mp4
│
├── AI-audit-log/                  
│   └── ITA301_AuditLog_AgriUAV_v1.0.docx
│
└── assets/
    ├── images/
    ├── references.bib
    └── domain-research/
```

---

## 🚀 Deliverables & Timeline

| Deliverable | Mô tả | Deadline | Trọng số | Trạng thái |
|---|---|---|---|---|
| [D1 – Project Proposal](./D1-project-proposal/) | Business problem, stakeholder map, scope, WBS, risk register | W3 — 29/05/2026 | 15% | ✅ Đã nộp |
| [D2 – SRS Document](./D2-requirements-srs/) | ≥15 FR, ≥5 NFR, ≥8 Use Cases theo IEEE 830 | W4 | 25% | ✅ Đã nộp |
| [D3 – System Modeling](./D3-system-modeling/) | DFD L0+L1, UML (Class/Sequence/Activity), ERD 3NF | W6 | 30% | 🔄 Đang làm |
| [D4 – System Design](./D4-system-design-sdd/) | Architecture, UI wireframes, security model, QA plan | W9 | 20% | ⬜ Chưa nộp |
| [D5 – Final Defense](./D5-presentation-defense/) | ~20 slides + Figma prototype demo + Q&A | W10–W11 | 10% | ⬜ Chưa nộp |

> Cập nhật trạng thái sau mỗi milestone: `⬜ Chưa nộp` → `🔄 Đang làm` → `✅ Đã nộp`

---

## 🧠 AI Audit Log — RBL Insight (30% điểm Project)

Tracked tại: [`AI-audit-log/ITA301_AuditLog_AgriUAV_v1.0.docx`](./AI-audit-log/)

| Chỉ số | Giá trị |
|---|---|
| Tổng entries | 12 / 25 target |
| Hallucination phát hiện | 3 (FAA Part 107 bias, ecosystem ranking sai, AI bỏ sót Cục Tác chiến) |
| AI tools sử dụng | Claude, ChatGPT |
| DTC coverage | Decomposition ✅ \| Pattern Recognition ✅ \| Abstraction 🔄 \| Process/Algorithm ✅ |

**Top Human Delta Moments:**
- **Entry 02** — AI xếp Agricultural UAV dưới Delivery UAV về regulatory burden: sai vì NĐ 288/2025 đã có hành lang pháp lý rõ cho Agri UAV
- **Entry 04** — AI không biết sự cố 110kV Long An và rủi ro khai khống giờ bay — domain knowledge thuần túy từ nhóm
- **Entry 07** — AI đề xuất risk "budget" và "deployment failure" không applicable cho IS project sinh viên

---

## 📐 Stakeholders

| Stakeholder | Loại | Power | Interest | Vai trò trong hệ thống |
|---|---|---|---|---|
| Cooperative Management (HTX) | Primary | 5 | 5 | Lập lịch, điều phối fleet, theo dõi tài chính |
| Operators / Drone Pilots | Primary | 2 | 5 | Nhận lệnh bay, check-in/out trên mobile app |
| Rice Farmers | Primary | 3 | 4 | Đặt lịch phun, nhận thông báo Zalo/SMS |
| Agricultural Exporters | Secondary | 3 | 4 | Truy xuất lịch sử phun thuốc (VietGAP/GlobalGAP) |
| Cục BVTV / Cục Tác chiến | Regulatory | 5 | 3 | Giám sát tuân thủ NĐ 288/2025, cấp phép bay |

---

## 📋 Tính nhất quán tài liệu (Traceability)

Tất cả deliverables phải **nhất quán logic** theo pipeline:

```
D1 Proposal  ──►  D2 SRS  ──►  D3 Models  ──►  D4 SDD
(Business)       (Requirements)  (Modeling)     (Design)
```

- Mọi FR trong D2 → phải có Use Case trong D3
- Mọi Use Case trong D3 → phải trace về Architecture Decision trong D4
- Xem **Traceability Matrix**: [`D3-system-modeling/traceability-matrix.xlsx`](./D3-system-modeling/traceability-matrix.xlsx)

---

## 🔧 Công cụ sử dụng

| Mục đích | Công cụ |
|---|---|
| UML diagrams | StarUML / PlantUML |
| DFD & Flowchart | draw.io |
| UI Wireframes | Figma |
| SRS / SDD Document | Microsoft Word (IEEE 830) |
| ERD | draw.io / dbdiagram.io |
| AI Assistance | Claude, ChatGPT |
| Version control | Git + GitHub |

---

## 📚 Key References

- Nguyen, D.L. et al. (2026). *The Effect of Farm Size on the Decision to Adopt Digital Technology: UAVs in Rice Production in Vietnam.* RWAE Journal.
- Nghị định 288/2025/NĐ-CP — Quản lý hoạt động bay thiết bị không người lái (hiệu lực 05/11/2025).
- Thanh Niên (T6/2025) — 1,215 drones đang hoạt động tại 3 tỉnh ĐBSCL.
- Dân Việt — Drone phun thuốc va vào đường dây 110kV, mất điện 76.000 khách hàng tại Long An.

---

## 🏷️ Releases

| Tag | Deliverable | Ngày |
|---|---|---|
| `v1.0-D1` | Project Proposal | 29/05/2026 |
| `v2.0-D2` | SRS Document | [End W4] |
| `v3.0-D3` | System Modeling Package | [End W6] |
| `v4.0-D4` | System Design Document | [End W9] |
| `v5.0-D5` | Final Presentation & Defense | [W10–W11] |

---

## ⚠️ Scope Boundaries

**In-scope:** Fleet scheduling, real-time drone monitoring, GIS field mapping, pilot management, compliance report export (PDF/Excel), Zalo/SMS notifications.

**Out-of-scope:** Hardware flight control, AI pest detection (computer vision), payment gateway, direct API integration với Cục Tác chiến, multi-cooperative federation.

> ITA301 là môn **Phân tích & Thiết kế** — repo này chứa tài liệu thiết kế (SRS, UML, SDD, wireframes), **không phải source code backend/frontend**.

---

*ITA301 – Summer 2026 | FPT University HCM | Khoa Công nghệ Thông tin*
