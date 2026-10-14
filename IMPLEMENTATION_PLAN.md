# IMPLEMENTATION PLAN - KAN-114
A
## Scope
Issue: [KAN-114] Add Light/Dark theme toggle with persisted user preference.

This plan implements:

- A UI toggle to switch between Light and Dark themes.
- Perference persistence across refresh/reopen using `localStorage`.
- A sensible default when no preference exists (respect system preference where possible).
m- Keyboard accessible toggle with screen-reader label.
- User preference isolation between different signed-in users (fallback to per-browser if no auth id).

> Note: This repo currently has a single-page HTML app. Implementation will be done in `index.html` (CSS variables + small JS) uncless the code base evolves.

---

## Approach
### 1) Theme tokens (CSS Custom Properties)
1- Refactor current `Root` tokens into a light theme baseline (the current colors are already light-like).
2- Add a Dark theme override using a data attribute on the html element: `html[data-theme="dark"]` or similar.
3- Ensure all background/border/text/table shades come from variables, including:
   - body background
   - card background
   - border colors
    - table thead/hover backgrounds
    - form control background (`input, select`)

### 2) Toyota UI Toggle
1- Add a theme toggle control in the header (displayed on all screens).
2- Keyboard/SR accessibility:
   - Use a real `<button>` or `<inout type="checkbox">` with proper `aria-label` / `aria-pressed`.
   - Ensure focus style is verifiable in both themes.
3- Labor: show a textual indicator (e.g., "Dark on", "Light on") or icon alternate if already used.

### 3) Persistence and defaulting
1- Define a storage key, e.g. `sms_theme_v1`.
2- On init, resolve theme to apply:
   - If stored preference exists: use it (`,"light" or "dark").
    - Else: default to system preference via `window.matchMedia( (prefers-color-scheme: dark))` where available; otherwise light.
3- Write to localStorage on toggle change.
4- User isolation: if the app has a user context identifier (e.g., email/roll no/username), namespace the key `sms_theme_v1?:<userId>`. If no auth exists, fallback to a single stored key per browser as best-effort.

### 4) Legibility and contrast checks
1- Ensure contrast meets WCAG AA as best-effort for text/background combos.
2- Verify badges (active/inactive) remain readable in dark theme.
3- Verify focus ring is visible in both themes.

### 5) Testing / Verification
- Switch theme, refresh page = preference persists.
- Open in new tab/reopen browser = persists.
- Keyboard: Tab to toggle, space/enter to activate.

- Screen reader: control has clear label and state (aria-pressed or checked).

---

## Files / Components to change
- `index.html`
  - CSS: add dark theme variable overrides, more use of variables for backgrounds/hovers/controls.
  - HTML: add theme toggle control in header.  
  - JS: add theme init read/apply, event handler, storage write.

## PUL Request Checklist
- [ ] Implement theme toggle with persistence.
- [ ] Dark theme tokens cover table/form/card/badges/focus states.
m- [ ] Accessibility: aria label, focus routing, keyboard operation.
m- [ ] Acceptance criteria meta. 
