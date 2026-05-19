# 🛸 Drone/UAV Ecosystem — ITA301 RBL Project

> **Môn học:** ITA301 – Information System Analysis & Design  
> **Học kỳ:** Summer 2026 | **Nhóm:** 3  
>**Sub-domain:** Agricultural UAV   
> **Giảng viên hướng dẫn:** Nguyentt

---

## 📌 Mô tả đề tài
 
*"Các hợp tác xã và doanh nghiệp dịch vụ drone tại ĐBSCL hiện đang gặp vấn đề thiếu công cụ số để lập lịch, điều phối và giám sát đội drone phun thuốc, dẫn đến lãng phí nhiên liệu/thuốc BVTV, không truy xuất được nhật ký phun, và không đáp ứng yêu cầu báo cáo của Cục BVTV — gây tăng chi phí vận hành 15–20% và rủi ro pháp lý theo Nghị định 288/2025/NĐ-CP. Hệ thống Agri UAV Platform được thiết kế để tự động hóa lập lịch và điều phối drone phun thuốc chính xác thông qua field mapping, tính toán liều lượng theo vùng, và theo dõi tiến độ phun real-time, phục vụ các stakeholders: Nông dân/HTX, Operator/Phi công, Kỹ sư nông nghiệp, Cơ quan quản lý (Cục BVTV, Cục Tác chiến), trong phạm vi quản lý đội drone tối đa 50 máy/HTX tại vùng canh tác lúa ĐBSCL."*

---

## 👥 Thành viên nhóm

| Họ tên                | MSSV     | Vai trò | Phụ trách chính |
|-----------------------|----------|---------|-----------------|
| Đặng Thành Công       | SE193711 | Project Manager | Điều phối nhóm, tổng hợp toàn bộ project |
| Nguyễn Thị Thanh Thảo | SE191001 | Business Analyst | D1 – Proposal, D2 – SRS |
| Trần Anh Khoa         | SE194870 | System Analyst | D3 – System Modeling (DFD, UML, ERD) |
| Lê Văn Minh           | SE192904 | System Designer | D4 – Architecture, UI, Security |
| Đặng Võ Thanh Hiếu    | SE201011 | Presenter / QA | D5 – Slides, Q&A, kiểm soát chất lượng |

---

## 🗂️ Cấu trúc repo

```
ita301-[nhom]-[ten-de-tai]/
│
├── README.md                        ← file này
│
├── D1-project-proposal/             ← W3 (15%)
│   ├── proposal.pdf
│   ├── stakeholder-map.png
│   ├── business-case.xlsx
│   ├── wbs.png
│   └── risk-register.md
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
│   │   └── screens/
│   └── security/
│       ├── threat-model.md
│       └── qa-plan.md
│
├── D5-presentation-defense/         ← W10 (10%)
│   ├── slides.pptx
│   ├── slides.pdf
│   └── demo-video.mp4               ← (nếu có)
│
└── assets/
    ├── images/
    ├── references.bib
    └── domain-research/
```

---

## 🔗 Deliverables & Timeline

| Deliverable | Mô tả | Tuần nộp | Trọng số | Trạng thái |
|-------------|-------|----------|----------|------------|
| [D1 – Project Proposal](./D1-project-proposal/) | Business problem, stakeholder, scope, project plan | End of W3 | 15% | 🔄 Đang làm |
| [D2 – SRS Document](./D2-requirements-srs/) | Functional requirements, NFR, use cases | End of W4 | 25% | ⬜ Chưa nộp |
| [D3 – System Modeling](./D3-system-modeling/) | DFD, UML (Class/Sequence/Activity), ERD | End of W6 | 30% | ⬜ Chưa nộp |
| [D4 – System Design (SDD)](./D4-system-design-sdd/) | Architecture, UI, data design, security, QA | End of W9 | 20% | ⬜ Chưa nộp |
| [D5 – Final Presentation](./D5-presentation-defense/) | Slides 15–20 trang + demo + Q&A defense | Week 10 | 10% | ⬜ Chưa nộp |

> **Cập nhật trạng thái:** thay `⬜ Chưa nộp` → `🔄 Đang làm` → `✅ Đã nộp` sau mỗi milestone.

---

## 🏗️ Công cụ sử dụng

| Mục đích | Công cụ |
|----------|---------|
| UML diagrams | StarUML / Visual Paradigm / PlantUML |
| DFD & Flowchart | draw.io |
| UI Wireframes | Figma |
| SRS / SDD Document | Microsoft Word (IEEE 830 template) |
| ERD | draw.io / dbdiagram.io |
| Trình bày | Microsoft PowerPoint |
| Version control | Git + GitHub |

---

## 📐 Stakeholders chính

| Stakeholder | Loại | Vai trò trong hệ thống |
|-------------|------|------------------------|
| [Ví dụ: Fleet Dispatcher] | Primary | Quản lý và điều phối chuyến bay |
| [Ví dụ: Drone Pilot] | Primary | Thực hiện và giám sát chuyến bay |
| [Ví dụ: Cơ quan CAAV] | Regulatory | Cấp phép không phận |
| [Ví dụ: Khách hàng cuối] | Secondary | Theo dõi trạng thái giao hàng |

---

## 📋 Ghi chú về tính nhất quán tài liệu

Tất cả deliverables trong repo này phải **nhất quán logic** theo pipeline:

```
SRS (D2)  ──►  UML / DFD (D3)  ──►  SDD (D4)
```

- Mọi Functional Requirement trong D2 phải có Use Case tương ứng trong D3.
- Mọi Use Case trong D3 phải được trace về Architecture Decision trong D4.
- Inconsistency giữa các tài liệu → trừ điểm theo rubric môn.
- Xem **Traceability Matrix** tại [`D3-system-modeling/traceability-matrix.xlsx`](./D3-system-modeling/traceability-matrix.xlsx).

---

## 🏷️ Releases

| Version | Deliverable | Ngày |
|---------|-------------|------|
| `v1.0-D1` | Project Proposal | [DD/MM/YYYY] |
| `v2.0-D2` | SRS Document | [DD/MM/YYYY] |
| `v3.0-D3` | System Modeling Package | [DD/MM/YYYY] |
| `v4.0-D4` | System Design Document | [DD/MM/YYYY] |
| `v5.0-D5` | Final Presentation | [DD/MM/YYYY] |

---

*ITA301 – Summer 2026 | FPT University*