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
- Real-time name / email / roll-no search
- Filter by status (Active / Inactive / All)
- Both filters compose — only matching rows are shown in the table

### Statistics Dashboard
- Live counters: Total Students, Active Students, Inactive Students, Average Grade (where applicable)
- Stats update automatically on every add, edit, or delete

### CSV Export
- "Export CSV" button exports the currently filtered row set
- Filename format: `students_YYYY-MM-DD.csv`
- Button is disabled when there are no rows to export

> **Note:** An XLSX export feature (KAN-100, shipped in v1.1.0) was removed during the KAN-104 sprint when the SheetJS CDN dependency was dropped. The current version exports CSV only.

### Light / Dark Theme Toggle (KAN-114)
- Toggle button in the page header switches between Light (default) and Dark palettes
- In Dark mode the button shows **☀️ Light**; in Light mode it shows **🌙 Dark**
- Preference is saved to `localStorage` under the key `themePreference` and survives page refresh
- Flash-of-unstyled-content (FOUC) prevented: an inline script in `<head>` reads the saved preference and applies `data-theme` on `<html>` before any first paint
- Accessible: button carries `aria-pressed` (`true` / `false`) and a dynamic `aria-label` that update on every toggle
- Badge colours (Active / Inactive status pills) are defined as CSS variables with proper dark-mode overrides
- **Private browsing:** all `localStorage` calls are wrapped in `try/catch`; if storage is unavailable the app falls back to the default Light theme gracefully

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

### Exporting to CSV
1. Optionally filter the table using the search box or status dropdown.
2. Click **Export CSV**.
3. Your browser downloads `students_YYYY-MM-DD.csv`.

### Switching Themes
1. Click the **🌙 Dark** / **☀️ Light** toggle button in the top-right corner of the header.
2. Your preference is saved automatically and restored on the next visit.

#### localStorage Persistence Notes
- Preference key: `themePreference` (values: `"light"` or `"dark"`)
- The saved value is read by an inline script in `<head>` before the first browser paint, preventing any flash of the wrong theme
- In private / incognito browsing windows, `localStorage` may be unavailable or quota-zero (browser-dependent). The app handles this gracefully:
  - The inline head script catches any `SecurityError` and falls back to Light theme
  - The toggle click handler catches any `QuotaExceededError` and continues to switch the theme visually without persisting it
  - `initTheme()` also catches any read error to prevent button label desync

---

## Tech Stack

| Layer | Technology |
|---|---|
| Markup | HTML5 |
| Styling | Vanilla CSS with CSS custom properties (theme variables) |
| Logic | Vanilla JavaScript (ES2020) |
| Data persistence | `localStorage` |

No frameworks, no bundlers, no runtime dependencies.

---

## Browser Compatibility

Tested and supported in current versions of:
- Google Chrome / Chromium
- Mozilla Firefox
- Microsoft Edge

Requires a browser with support for:
- `localStorage`
- CSS custom properties (`var()`)
- ES2020 (`?.`, `??`, `crypto.randomUUID`)

Internet Explorer is not supported.

---

## Changelog

### v1.2.0 — 2026-10-14
- **[KAN-114]** Replaced 3-option System/Light/Dark segmented control with a simpler 2-option Light/Dark toggle button
- **[KAN-114]** Theme preference persisted to `localStorage` key `themePreference`; survives page refresh
- **[KAN-114]** FOUC prevention: inline `<head>` script applies saved theme before first paint
- **[KAN-114]** All `localStorage` calls wrapped in `try/catch`; safe in private/incognito browsing
- **[KAN-114]** Badge colours (Active / Inactive) converted to CSS variables with dark-mode overrides
- **[KAN-114]** `aria-pressed` and `aria-label` on toggle button update correctly on every switch

### v1.1.0 — 2026-10-13
- **[KAN-100]** Added XLSX export using SheetJS 0.18.5 with SRI integrity check *(removed in subsequent sprint)*
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
