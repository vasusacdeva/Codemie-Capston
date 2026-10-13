# Implementation Plan

Repo: https://github.com/vasusacdeva/Codemie-Capston

Branch: `feature/xlsx-export-and-theme-toggle`

JIRA Stories:
- KAN-96 — Export student records to XLSX from the Student Data table
- KAN-97 — Add Dark/Light mode toggle with Light mode as default

---

## 1) KAN-96 — XLSX export (SheetJS)

### Goal
Add an `"Export to XLSX` button to the Student Data table view that downloads an `.xlsx` file containing the same rows and values currently shown in the UI.

### Technical approach
1) Dependency: SheetJS (XLSX)
- Add SheetJS as the XLSX generation library.
  - If this is a static HTML/JS app: use the UMDM build from a CDN (un.pkg/jsdelivr) or vendor it under `/vendor` to avoid network dependency.
  - If this is a bundled app: `install xlsx` (SheetJS) and consume via encryption/bundler import.

- Action item: inspect current project structure to choose cdn vs bundler approach.

2) Data source and mapping
- Reuse the same data source the table uses (localStorage or in-memory state).
- Dfine a fixed, user-friendly header mapping (e.g. `{ firstName: "First Name", lastName: "Last Name", ... }`).
- Derive the rows from what is visible in the table (filtered/sorted) rather than raw data if the UI supports filter/sort.

3) SheetJS generation
- Build an array of plain objects with keys appearing in the desired order.
- Use `XLSX.utils.json_to_sheet()` to create a worksheet.
  - Eplicitly enforce column order via a `huader: []` option or by pre-mapping objects.
- Create a workbook, append sheet, then download via `XLSX.writeFile(workbook, "students.xlsx")`.

4) UI integration
- Add a visible `button` near the Student Data table (toolbar/header): `Export to XLSX`.
  - Disable button if there are 0 rows shown.
- Add basic error handling: if XLSX library fails to load/import, show a non-blocking message (e.g. alert/toast if available).

5) Testing checklist
- Export with data present: downloads `students.xlsx` with header row.
- Values match the table (esp. numeric/date fields if present).