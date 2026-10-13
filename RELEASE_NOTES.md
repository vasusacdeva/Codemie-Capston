# Release Notes

---

## v1.1.0 — 2026-10-13

### Overview

This sprint delivered two user-facing features — Excel export and a Dark/Light theme toggle — alongside a focused security and quality hardening pass.

---

### New Features

#### KAN-100: XLSX Export

- Added a green **Export XLSX** button to the Student Records toolbar, positioned alongside the existing Export CSV button.
- Uses SheetJS 0.18.5 loaded from the Cloudflare CDN with a verified SRI integrity hash (`sha384-vtjasyidUo0kW94K5MXDXntzOJpQgBKXmE7e2Ga4LG0skTTLeBi97eFAXsqewJjw`).
- Exports the currently filtered row set — search and status filters are respected.
- Downloaded filename pattern: `students_YYYY-MM-DD.xlsx`
- Exported columns: Roll No, Name, Email, Course, Grade, Status
- Button is disabled when the filtered row count is zero.
- The existing CSV export button is retained and continues to function independently.

#### KAN-101: Dark / Light Theme Toggle

- Added a toggle button in the page header (top-right corner).
- Switches between a light palette (default) and a dark palette via a `data-theme` attribute on the `<html>` element.
- Preference is persisted to `localStorage` under the key `app:theme`.
- Flash-of-unstyled-content (FOUC) prevented by an inline theme-init script placed first in `<head>`, which runs before any render paint.
- Accessible: the button exposes `aria-pressed` (true/false) and a dynamic `aria-label` ("Switch to Dark Mode" / "Switch to Light Mode").
- Smooth 0.2 s CSS transition applied to all colour-bearing properties on theme switch.

---

### Security Improvements

| Item | Detail |
|---|---|
| SRI integrity hash | SheetJS CDN `<script>` carries `integrity` + `crossorigin="anonymous"` — browser rejects the script if the file is tampered with |
| XSS escaping | All user-controlled values (status, id/roll-no, grade) rendered via `innerHTML` are now HTML-escaped through a shared `escHtml()` helper |
| localStorage quota safety | `saveStudents()` is wrapped in try/catch; a storage quota error no longer causes an unhandled exception |
| CDN failure guard | XLSX export checks `typeof XLSX !== 'undefined'` before calling the library, and shows a user-visible alert if the CDN script failed to load |

---

### Test Coverage

| Suite | Result |
|---|---|
| Unit tests (Node.js `node:test`) | 30 / 30 passing |
| HTTP health checks | 15 / 15 passing |
| Static analysis checks | 9 / 9 passing |
| Code review passes | 3 passes — all findings resolved |

---

### Known Limitations and Future Backlog

The following items were surfaced as INFO-level findings during the final code review pass. They do not affect current correctness or security but are recorded here for prioritisation in a future sprint.

1. **Multi-tab edit race condition**
   When the same application is open in two browser tabs simultaneously and a student is edited in both tabs at the same time, the second `localStorage.setItem` silently overwrites the first. A `storage` event listener or a lightweight optimistic-lock timestamp would prevent data loss in this scenario.

2. **`crypto.randomUUID` polyfill missing**
   `crypto.randomUUID()` is used to generate student IDs. This API is available in all modern browsers over HTTPS, but it is absent in non-secure contexts (plain HTTP) in some browsers and is not present in Internet Explorer. A short UUID-v4 fallback function should be added for environments where `crypto.randomUUID` is unavailable.

3. **Accessibility improvements for row action buttons**
   The Edit and Delete buttons in each table row do not carry unique accessible labels (e.g., "Edit student Jane Smith"). Screen readers will announce them as "Edit" and "Delete" without row context. Adding `aria-label="Edit Jane Smith"` dynamically when the table is rendered would improve the experience for assistive technology users.

4. **Empty-state and table-header accessibility**
   The empty-state message shown when no students match the current filter is not announced to screen readers when the filter changes. Adding `role="status"` or `aria-live="polite"` to the container would ensure assistive technologies announce the result count change. Column headers in the student table could additionally benefit from `scope="col"` attributes.

---

## v1.0.0 — Initial Release

- Student CRUD: add, edit, delete
- Real-time search and status filter
- Statistics dashboard (total, active, inactive, average grade)
- CSV export
