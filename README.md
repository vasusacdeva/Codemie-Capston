# Student Management System

Single-page app (`index.html`) for managing student records. Data is stored in browser localStorage.

## Features
- **XLS Download (KAN-41):** "Export XLS" downloads the currently displayed (filtered) records as `students_YYYY-MM-DD_HHMM.xls` with Roll No, Name, Email, Course, Grade, Status. Fully client-side; shows "No data to export." when empty.
- **Dark/Light Mode (KAN-42):** header toggle switches themes. **Light Mode is the default**; the choice is persisted in localStorage.

## Run
Open `index.html` in a browser, or with Docker:
```
docker compose up --build -d   # http://localhost:8080
docker compose down
```

## Tests
Gherkin scenarios: `tests/student-enhancements.feature`. Playwright: `npx playwright test tests`.
