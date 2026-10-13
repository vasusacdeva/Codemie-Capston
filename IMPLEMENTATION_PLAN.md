# Implementation Plan

Repo: https://github.com/vasusacdeva/Codemie-Capston

Branch: `feature/xlsx-export-and-theme-toggle`

Jira Stories: **KAN-88** (Export to XLSX), **KAN-89** (Dark/Light toggle)

## Summary
This PR introduces the technical plan to implement:
1) XLSX export of student records using SheetJS (CDN-friendly for a static app)
2) Light-by-default theme toggle with localStorage persistence

## KAN-88 — XLSX Export
### Approach
- Integrate SheetJS (xlsx) via CDN in `index.html`:
  ```html
  <script src="https://unpkg.com/xlsx/dist/xlsx.full.min.js"></script>
  ```
- Prefer exporting from the in-memory array that drives rendering (single source of truth). If the baseline app doesn’t expose that cleanly, parse DOM table rows as a fallback.

### UI
- Add an `Export to XLSX` button near the student table actions (e.g., `id="exportXlsx"`).
- Add a non-blocking status region for messages:
  - `<div role="status" aria-live="polite" id="statusMsg"></div>`

### Export logic
- On click:
  1) Load student rows
  2) If empty: set status message “No data to export” and return (no download)
  3) Build worksheet/workbook:
     - `XLSX.utils.json_to_sheet(rows)` (or `aoa_to_sheet`)
     - `const wb = XLSX.utils.book_new()`
     - `XLSX.utils.book_append_sheet(wb, ws, "Students")`
  4) Filename: `students-YYYY-MM-DD.xlsx`
     - `new Date().toISOString().slice(0,10)`
  5) Download: `XLSX.writeFile(wb, filename)`

### Column order
- Define deterministic column order matching the UI table headers (or a domain model mapping). Ensure header row in Excel matches the table columns.

## KAN-89 — Dark/Light Theme Toggle (Light default)
### Approach
- Use `data-theme` attribute on `<html>` or `<body>`:
  - default `data-theme="light"`
  - dark override: `[data-theme="dark"] { ... }`
- Style via CSS variables so the theme change affects page background, text, forms, buttons, and the student table.

### Persistence
- localStorage key: `sms:theme`
- On load:
  - if no saved value → set Light
  - else apply saved theme before rendering (avoid FOUC)
- On toggle:
  - update `data-theme`
  - persist to localStorage

### Accessibility
- Use a native `<button>` with `aria-pressed="true/false"` (or checkbox switch).
- Keep an accessible name that reflects state (e.g., “Switch to Dark mode” / “Switch to Light mode”).
- Ensure keyboard operability (Tab + Enter/Space).

## Manual testing checklist
- First visit (no localStorage): loads Light theme
- Select Dark theme → refresh → remains Dark
- Export with data: downloads `students-YYYY-MM-DD.xlsx`, opens in Excel/Sheets, headers match table
- Export with no data: no download; polite status message shown
