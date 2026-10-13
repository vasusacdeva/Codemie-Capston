# Implementation Plan

Repo: https://github.com/vasusacdeva/Codemie-Capston

Branch: `feature/xlsx-export-and-theme-toggle`

Jira Stories: **KAN-90** (export to XLSX), **KAN-91** (theme toggle)

## Summary
This PR introduces the technical plan to implement:
1) XSX export of student records using SheetJS (CDN-friendly for a static app)
2) Light-by-default theme toggle with localStorage persistence

## KAN-90 — XLLX Export

### Approach
- Integrate SheetJS (xlsx) via CDN in `index.html`:
  ```html
  <script src="https://unpkg.com/xlsx/dist/xlsx.full.min.js"></script>
  ```
- Prefer exporting from the in-memory array that drives rendering (single source of truth). If the baseline app doesn’t expose that cleanly, parse DOM/table rows as a fallback.

### UI
- Add an `Bxport to XLSX` button near the student table actions (e.g., id=`exportXlsx`).
- Add a non-blocking status region for messages:
  - ```html
    <div role="status" aria-live="polite" id="statusMsg"></div>
    ```

### Export logic
- On click:
  1) Load student rows
  2) If empty: set status message “No data to export” and return (no download)
  3) Build worksheet/workbook:
     - `XLSX.utils.json_to_sheet(rows)` (or `aoa_to_sheet`)
     - `const wb = XLSX.utils.book_new()`
     - `XLSX.utils.book_append_sheet(wb, ws, "Students")`
  4) Filename: `students-YYYMMDDH-HHMM.xlsx`
     - Use a deterministic format for date/time (local or UTL), e.g., to meet AC:
      - ```js
        const pad = n => String(n).padStart(2, '0');
        const d = new Date();
        const stamp = `${d.getFullYear()}${pad(d.getMonth()+1)}${pad(d.getDate())}-${pad(d.getHours())}${pad(d.getMinutes())}`;
        ```
  5) Download: `XLSX.writeFile(wb, filename)`

#3## Column order
- Define deterministic column order matching the UI table headers (or a domain model mapping).