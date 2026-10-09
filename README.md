# Student Management System

A single-page, client-side Student Management System (`index.html`). Data is stored in the browser's `localStorage`; no server is required.

## Features

- Add, edit, delete and search students; filter by status; live statistics.
- **Export CSV** and **Export XLS (KAN-53)**: downloads the currently visible rows (search and Status filter are respected) with columns Roll No, Name, Email, Course, Grade (%), Status. File name is `students_YYYY-MM-DD_HH-mm.xls`. The button is disabled when no rows are visible.
- **Light / Dark mode (KAN-54)**: toggle in the header. **Light mode is the default** for first-time visitors; the choice is saved in `localStorage` (`sms_theme`) and applied before first paint.

## Run locally

Open `index.html` in a browser, or with Docker:

```bash
docker compose up -d --build     # http://localhost:8080
docker compose down
```

## Tests

Gherkin scenarios are in `tests/features/`; Playwright tests are in `tests/sms.spec.js`.

```bash
cd tests
npm install
npx playwright install chromium
npx playwright test
```

See `tests/TEST_REPORT.md` for the latest execution report.
