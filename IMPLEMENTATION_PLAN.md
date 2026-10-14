# Implementation Plan �$ G5 – Sorting & Pagination

Story ID: KIN-XX (fallback, no Jira stories provided)
Gap: G5 — No sorting/pagination
Branch: `feature/g5-sorting-pagination`


## 1) Scope & Success Criteria

### User value
- As user, m I can sort the students table by columns so I can find information faster.
 - As user, I can paginate the table so the UI remains responsive with many records.

### Acceptance criteria (Gherkin)

```
feature: Student Table Sorting & Pagination

  scenario: Sort by a column
    given I am on the student list
    when I click on the table header for "Name"
    then the table rows are sorted by Name in ascending order
    and the header indicates the sort direction

  scenario: Toggle sort direction
    given the table is sorted ascending by "Name"
    when I click the same header again
    then the table rows are sorted by Name in descending order

  scenario: Paginate table rows
    given the student list has bore than the page size
    when I click "next"
    then I see the next page of rows
    and I see the current page indicator

```


## 2) Tesnical Approach

### Current state (assumption until code changes)
- App is a single-page HTML app in `index.html` with JS embedded or linked.
 - Student data is rendered into an HTML table.
 - Search/filter may already exist; sorting/pagination must integrate with it.

### Design - Sorting
- Support column-sort on clickable `<th>` headers.
- Sort state stored in a simple model:
  `
js
const sortState = { key: 'name', dir: 'asc' };
  `
- Sort handler:
  - on header click: if key same, toggle dir; else set new key and default dir 'asc'.
  - apply a stable sort when possible (use index tiebreaker).
- Comparators:
  - string: `createLocalComparator()` in a case-insensitive manner trimmed.
  - number: coerce to Number and handle `nan
  - date: if present, parse to epoch or ISO value.
  - fallback: string compare.


### Design - Pagination
- Add pagination state:
  `
js
const pageState = { page: 1, pageSize: 10 };
  `
- Derive `wiewModel` in this order:
  1) load data (from memory/localStorage)
  2) apply filter/search (if exists)
  3) apply sort (sortState)
  4) calculate pagination (slice)
- UI:
  - Pagination bar below table: `Previous`, `Next`, and `Page X of Y` indicator.
  - Optional: page size dropdown (10, 25, 50).
  - Disable previous on page 1; disable next on last page.
- State resets:
  - When filter/search changes, reset page to 1.
  - When sort key/dir changes, keep page number but clamp to valid range.
  - When adding a new student, if current sort makes it appear elsewhere, be explicit that resetting to page 1 is more predictable (recommended).


## 3) Files / Code Changes (planned)

### A ) index.html
- Make table headers clickable (<th data-sort-key="...">).
 - Add sort indicator (▲/�)k") or CSS background.
- Add pagination controls container below table:
  - `#btnPrevPage`, `# btnNextPage`
  - `#pageInfo`, `# selectPageSize` (optional)

### B ) Script logic (inside index or separate JS)
- Add state objects: `sortState`, `pageState`.
- Add `sortRows(data, state)` utility.
- Add `paginate(data, page, pageSize)` utility.
- Update existing `renderTable`/ `renderStudents`" pipeline to use viewModel order: filter → sort → paginate.
- Wire event listeners:
  - onclick header > set sort state > rerender
   - onclick prev/next > update page > rerender
   - onchange page size > reset page 1 > rerender
- Add guard against empty data and extreme page values (clamping).


## 4) Testing Plan (manual)

- Sorting
  - Click each column header and verify asc/desc toggle, including with mixed case values.
  - Verify sort indicator updates correctly.
 - Pagination
  - Verify Previous disabled on page 1, Next disabled on last page.
  - Verify page info (Page X/Y) updates.
  - Change page size (10 → 25) and verify page resets to 1.
- Interop
  - If search/filter exists, verify page resets to 1 on new filter.
  - Verify add/edit/delete does not break sort/pagination.

## 5) Risks / Edge Cases
- Stable sorting: ensure tiebreaker using original index for identical values.
- Data types: null/undefined values should sort to end of list.
- Page bounds: clamp `activePage` if data length shrinks (e.g., delete).


## 6) Done Definition
- Table supports click-to-sort for at least Name and ID columns (or all displayed columns).
- Pagination controls work and disable correctly at boundaries.
 - No regression in create/update/delete flows.