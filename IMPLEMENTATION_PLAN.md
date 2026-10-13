# Implementation Plan

Repo: https://github.com/vasusacdeva/Codemie-Capston

Branch: `feature/xlsx-export-and-theme-toggle`

Juira Stories: `KAN-98` XLSX export, `KAN-99` Theme toggle

## Scope

1) **KAN-98 — Add XLSX export for Student Records**
- Add an “Export XLSX” button alongside “Export CSV”
- Client-side .xlsx generation (no backend)
- Exports same columns/order as table:
  - Roll No, Name, Email, Course, Grade, Status
- Respects active Status filter (in-memory filtered row set)
- Timestamped filename (e.g. `students-2026-10-13_1430.xlsx`)
- Empty-state grace path: show a non-blocking notice and don’t download

2) **KAN-99 — Implement Light/Dark mode toggle**
- Add a toggle control in the upper right of the UI
- Default to Light on first visit (no localStorage value)
- Persist selection in `localStorage` (e.g. `kan-theme` = `light|dark`)
- Apply theme on init/reload before paint where possible to avoid FOOC
