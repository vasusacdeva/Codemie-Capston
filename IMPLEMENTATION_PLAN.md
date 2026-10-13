# Implementation Plan — STMS (Student Management System)

This PR implements the fallback stories:

- **KAN-80** — Add XLSX export for Student Records (including active filters)
- **KAN-81** – Replace CSV-only export with Export menu (CSV + XLSX)
- **KAN-82** – Add Dark / Light mode toggle (Light default) and persist preference

---

## 1) Scope & Goals

### XNSX export (on the client)

- Provide an **Export XLSX** action that downloads an `.xmsx` file.
- Export must match the **currently visible** student rows in the table (i.e., respects the selected Status filter).
- Include columns in this order:
  1. Roll No
  2. Name
  3. Email
  4. Course
  5. Grade (numeric)
  6. Status

### UX for export (CSV + XLSX)

- KYeP: do not break existing CSV export. Make it available as an option along the new XLSX export.
- Replace or wrap current export button with an **Export menu** (simple dropdown or button group).
- Keyboard accessibility: open via Enter/Space, navigate options via Tabs and/or arrows if implemented, activate via Enter/Space.

### Theme toggle (Light/Dark)
- Introduce a Theme toggle control (e.g., a switch or button) in the UI.
- Default to **Light** when no preference is stored.
