# ita301-rbl-g3

> **ITA301 — Information System Analysis & Design**
> Research-Based Learning Project | Summer 2026 | Group 3

---

## 📌 Project Overview

| Item | Detail |
|------|--------|
| **Course** | ITA301 — Information System Analysis & Design |
| **Semester** | Summer 2026 |
| **Group** | G3 |
| **Sub-domain** | Delivery UAV |
| **Topic** | Nền tảng điều phối giao hàng bằng drone trong đô thị |
| **Status** | 🟡 In Progress — Phase 1 |

---

## 👥 Team Members

| # | Full Name | Student ID | Role |
|---|-----------|------------|------|
| 1 | *(Tên)* | *(MSSV)* | Project Manager |
| 2 | *(Tên)* | *(MSSV)* | Business Analyst |
| 3 | *(Tên)* | *(MSSV)* | System Analyst |
| 4 | *(Tên)* | *(MSSV)* | System Designer |
| 5 | *(Tên)* | *(MSSV)* | Presenter / QA |

---

## 📦 Deliverables

| Deliverable | Description | Due | Status |
|-------------|-------------|-----|--------|
| [D1 — Project Proposal](./D1_Proposal/) | Business problem, stakeholder map, scope, project plan | End of W3 | 🔲 Not started |
| [D2 — SRS Document](./D2_SRS/) | Functional & non-functional requirements, use cases | End of W4 | 🔲 Not started |
| [D3 — System Modeling Package](./D3_Modeling/) | DFD, UML (Class/Sequence/Activity), ERD | End of W6 | 🔲 Not started |
| [D4 — System Design Document](./D4_SDD/) | Architecture, UI design, data design, security, QA plan | End of W9 | 🔲 Not started |
| [D5 — Final Presentation](./D5_Presentation/) | Slides + live defense | Week 10 | 🔲 Not started |

---

## 🗂️ Repository Structure

```
ita301-rbl-g3/
│
├── README.md
│
├── D1_Proposal/
│   ├── proposal.pdf
│   ├── stakeholder-map.png
│   ├── business-case.md
│   └── wbs-timeline.xlsx
│
├── D2_SRS/
│   ├── SRS.pdf
│   ├── use-cases/
│   │   ├── UC01_<name>.md
│   │   └── UC02_<name>.md
│   └── user-stories.md
│
├── D3_Modeling/
│   ├── diagrams/
│   │   ├── dfd-level0.png
│   │   ├── dfd-level1.png
│   │   ├── class-diagram.png
│   │   ├── sequence/
│   │   └── activity/
│   ├── erd.png
│   ├── data-dictionary.md
│   └── traceability-matrix.xlsx
│
├── D4_SDD/
│   ├── SDD.pdf
│   ├── architecture/
│   │   ├── architecture-decision.md
│   │   └── deployment-diagram.png
│   ├── ui-wireframes/
│   ├── security-threat-model.md
│   └── qa-test-plan.md
│
└── D5_Presentation/
    ├── final-slides.pdf
    └── demo-screenshots/
```

---

## 📅 Timeline

| Week | Phase | Key Activity | Deliverable |
|------|-------|--------------|-------------|
| W1 | P1 | RBL Kickoff, chọn sub-domain, lập nhóm | Topic proposal sơ bộ |
| W2 | P1 | Stakeholder mapping, AS-IS analysis | Stakeholder map + Business case draft |
| W3 | P1 | Hoàn thiện business case, WBS, risk register | ✅ **D1** |
| W4 | P2 | Elicitation, viết Use Cases & User Stories, SRS | ✅ **D2** |
| W5 | P3 | Progress Test 1, DFD Level 0 & 1, UML draft | PT1 + diagrams draft |
| W6 | P3 | Hoàn thiện UML, ERD, traceability matrix | ✅ **D3** |
| W7 | P4 | Persona, wireframes, physical data model | UI + data model |
| W8 | P4 | Progress Test 2, kiến trúc hệ thống, tech stack | PT2 + Architecture |
| W9 | P4 | Trade-off analysis, QA plan, security, ops | ✅ **D4** |
| W10 | P5 | Progress Test 3, mock defense, final defense | ✅ **D5** |

---

## 🔗 External Resources

- 📐 Diagrams (StarUML / draw.io): *(link)*
- 🎨 UI Wireframes (Figma): *(link)*
- 📋 Task Board: *(GitHub Projects hoặc Notion link)*

---

## 📝 Commit Convention

Repo này dùng commit message theo format sau:

```
[Dx] <action> <artifact> - <short note>
```

**Ví dụ:**
```
[D1] add stakeholder-map v1
[D2] update UC03 - add alternative flow
[D3] fix class-diagram multiplicity
[D4] add architecture trade-off analysis
[MISC] update README - add Figma link
```

**Action keywords:** `add`, `update`, `fix`, `remove`, `refactor`, `review`

---

*Last updated: 2026-05-15*
