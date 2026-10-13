# Student Management System

A lightweight, single-page web application for managing student records. Built with vanilla HTML, CSS, and JavaScript — no build tools or backend required. Just open `index.html` in a browser.

---

## Features

### Student Records (CRUD)
- Add new students with Roll No, Name, Email, Course, Grade, and Status
- Edit existing student records inline via a modal form
- Delete individual students
- Unique Roll No enforcement

### Search and Filter
- Real-time name/email/roll-no search
- Filter by status (Active / Inactive / All)
- Both filters compose — only matching rows are shown in the table

### Statistics Dashboard
- Live counters: Total Students, Active Students, Inactive Students, Average Grade (where applicable)
- Stats update automatically on every add, edit, or delete

### CSV Export (KAN-99)
- "Export CSV" button exports the currently filtered row set
- Filename format: `students_YYYY-MM-DD.csv`
- Button is disabled when there are no rows to export

### XLSX Export (KAN-100)
- "Export XLSX" button (green) exports the currently filtered row set as a real Excel file
- Powered by SheetJS 0.18.5 (loaded from CDN with SRI integrity verification)
- Filename format: `students_YYYY-MM-DD.xlsx`
- Columns: Roll No, Name, Email, Course, Grade, Status
- Button is disabled when there are no rows to export

### Dark / Light Theme Toggle (KAN-101)
- Toggle button in the page header (top-right corner) switches between light and dark palettes
- Default is **Light Mode**
- Preference is persisted in `localStorage` under the key `app:theme`
- Flash-of-unstyled-content (FOUC) prevented: an inline script in `<head>` reads the saved preference and sets `data-theme` on `<html>` before any paint
- Accessible: the button carries `aria-pressed` and a descriptive `aria-label` that update on every toggle
- Smooth 0.2 s CSS transition on all colour changes

---

## Getting Started

### Option 1 — Open directly (no server needed)
```
Double-click index.html in your file manager, or:
open index.html          # macOS
start index.html         # Windows
xdg-open index.html      # Linux
```

### Option 2 — Serve locally (recommended for development)
```bash
# Python 3
python -m http.server 8080
# Then open http://localhost:8080 in your browser
```

No npm install, no bundler, no environment variables needed.

---

## Usage Guide

### Exporting to Excel (XLSX)
1. Optionally filter the table using the search box or status dropdown.
2. Click the green **Export XLSX** button in the Student Records toolbar.
3. Your browser downloads `students_YYYY-MM-DD.xlsx` automatically.
4. The button is greyed out when there are no rows matching the current filter.

### Exporting to CSV
1. Optionally filter the table.
2. Click **Export CSV**.
3. Your browser downloads `students_YYYY-MM-DD.csv`.

### Switching Themes
- Click the **Light / Dark** toggle button in the top-right corner of the header.
- Your preference is saved automatically and restored on the next visit.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Markup | HTML5 |
| Styling | Vanilla CSS with CSS custom properties (theme variables) |
| Logic | Vanilla JavaScript (ES2020) |
| Excel export | [SheetJS (xlsx) 0.18.5](https://sheetjs.com/) via CDN (SRI-verified) |
| Data persistence | `localStorage` |
| Tests | Node.js built-in `node:test` runner |

No frameworks, no bundlers, no runtime dependencies beyond SheetJS.

---

## Browser Compatibility

Tested and supported in current versions of:
- Google Chrome / Chromium
- Mozilla Firefox
- Microsoft Edge

Requires a browser with support for:
- `localStorage`
- CSS custom properties (`var()`)
- ES2020 (`?.`, `??`, `crypto.randomUUID` — see Known Limitations)

Internet Explorer is not supported.

---

## Changelog

### v1.1.0 — 2026-10-13
- **[KAN-100]** Added XLSX export using SheetJS 0.18.5 with SRI integrity check
- **[KAN-101]** Added Dark/Light theme toggle with FOUC prevention and localStorage persistence
- Security: SRI hash on SheetJS CDN script
- Security: XSS escaping applied to all user-controlled values rendered via `innerHTML`
- Security: `saveStudents()` wrapped in try/catch for localStorage quota safety
- Security: `typeof XLSX` guard added before export to handle CDN load failures
- Quality: Export buttons disabled when filtered row count is zero

### v1.0.0 — Initial release
- Student CRUD (add, edit, delete)
- Search and status filter
- Statistics dashboard
- CSV export
