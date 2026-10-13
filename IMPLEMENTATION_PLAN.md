# Implementation Plan

Branch: `feature/xlsx-export-and-theme-toggle`

Stories:
- **KAN-100** — Export student records to XLSX from student list
- **KAN-101** — Add Light/Dark mode theme toggle (Light default) with persistence

---

## 1) Scope & Goals

### KAN-100 — XLSX export
- Add an "Export to XLSX" button on the student records/list screen.
- Disable the button when there are 0 rows.
- Export columns in the same order as displayed in the UI.
- File name format: `students_YYYY-MM-DD.xlsx`.

### KAN-101 — Theme toggle
- Default theme is Light when no preference exists in localStorage.
- Toggle switches between Light/Dark immediately.
- Persist selection in localStorage (e.g. key `app:theme`).

---

## 2) Technical Approach

### 2.1 XLSX Export (SheetJS)
**Dependency**
- Prefer SheetJS (`xlsx`) for client-side XLSX generation.
- If this repo is plain HTML/JS without a build step, use the UMD build via CDN and call `XLSX` from `window`.

**Data source & mapping**
- Export from the same in-memory array used to render the table (avoid DOM scraping).
- Define a shared column definition list:
  - `key` (field accessor)
  - `label` (header)
  - optional `format(row)` for display/export alignment

**Worksheet generation**
- Use AoA to guarantee ordering:
  - `headers = columnDefs.map(c => c.label)`
  - `rows = students.map(s => columnDefs.map(c => (c.format?c.format(s):s[c.key])))`
  - `ws = XLSX.utils.aoa_to_sheet([headers, ...rows])`
- `wb = XLSX.utils.book_new()`
- `XLSX.utils.book_append_sheet(wb, ws, 'Students')`
- Write file: `XLSX.writeFile(wb, filename)`

**File naming**
- `today = new Date().toISOString().slice(0,10)`
- `filename = `students_${today}.xlsx``

**UX**
- Place export button near table actions.
- Disabled state when `students.length === 0`.

### 2.2 Theme Toggle
**Storage**
- Read: `localStorage.getItem('app:theme')` => `light | dark`.
- Write on toggle: `localStorage.setItem('app:theme', nextTheme)`.

**Applying theme**
- Apply a root attribute/class:
  - set `document.documentElement.dataset.theme = theme` (or on `body`).
- Define CSS variables for tokens:
  - `--bg`, `--text`, `--surface`, `--border` etc.
- Provide `[data-theme='light']` and `[data-theme='dark']` variable values.

**UI control**
- Add a switch/button in header/nav.
- Ensure accessible label (`aria-label`) and good contrast.

---

## 3) Task Checklist
- [KAN-100] Add SheetJS dependency (npm or CDN)
- [KAN-100] Implement export helper (build worksheet + write file)
- [KAN-100] Add "Export to XLSX" button + disabled state
- [KAN-101] Add CSS theme tokens for light/dark
- [KAN-101] Add theme toggle control + initial theme load
- [KAN-101] Persist selection to localStorage
- [KAN-101] Verify contrast on key screens

## 4) Testing Plan
- Export downloads XLSX and row/column counts match UI
- Export button disabled when no data
- Filename matches `students_YYYY-MM-DD.xlsx`
- Theme toggles light<->dark and persists across reload

## 5) Risks / Mitigations
- Bundle size: consider CDN UMD if no build tooling
- Data types: normalize dates/numbers to match UI formatting
- CSS conflicts: prefer variables over heavy overrides
