# IMPLEMENTATION PLAN - KAN-112

## Summary
Implement theme/preference support for Light, Dark, and System. The selection must apply immediately, default to System when no preference exists, persist for logged-in users across sessions, and follow OS theme changes in System mode without a page refresh.

## Scope (strictly from Jira Ticket KAN-112)
- Theme modes: Light / Dark / System
- Instant UI update on selection
- Default theme: System when no saved preference
- Persistence across sessions for logged-in users
- System mode listens to OS theme changes without refresh

## Out of Scope
- Any new theme token system or redesign of UI components
- Anonymous persistence across devices (not specified in KAN-112)

## Assumptions / Open Questions (HITL_review)
- Where to surface the theme toggle: settings page vs header menu. This plan implements a minimal settings control (location TBD).
  - Recommendation: add to an existing Settings or Profile dropdown if present.
- How to persist preference: backend user preference store vs localStorage fallback. KAN-112 says persist for logged-in users; this plan implements backend persistence when an API exists, else localStorage as a temporary fallback.

## Technical Design

### 1) Storage Model
- Preference values: `light` | `dark` | `system`
- Storage key: `themePreference` (either in user preferences or localStorage)
- Default: `system` when no value is found

### 2) Theme Apply Mechanism (Frontend)
- On app boot, initialize theme with priority:
  1) saved preference (logged-in user pref or localStorage)
  2) default `system`
- For system mode: use `window.matchMedia('(prefers-color-scheme: dark)')` to derive effective theme
- Apply theme to the root element via data attribute or class:
  - Recommended: set `document.documentElement.dataset.theme = 'light' | 'dark'`
  - CSS sample: `[data-theme='dark'] { ... }`
- Instant update: changing the selection updates root attr/class and re-renders no reload

### 3) Listen for OS Theme Changes (System mode)
- When preference = system, add an event listener: mediaQueryList.addEventListener('change', ...)
- On change, recalculate effective theme and apply without refresh
- Cleanup listener on unmount/dispose

### 4) Save preference (logged-in users)
- Best-effort approach (depends on existing app):
  - If there is a user preferences API: PATCH /user/preferences {theme: 'light'|'dark'|'system'}
  - Otherwise: store in localStorage and leave a TODO to backfill server-side persistence

### 5) UI Control
- Add a theme selector control (radio group or select): Light, Dark, System
- On change: call `applyTheme(pref)` and `savePref(pref)`
- Show current selection on load

## Testing Plan
- Unit:
  - Default to system when no pref set
  - Applies dark/light effective state for system mode
- Integration/E-2E:
  - Select light / dark / system updates UI without reload
  - System mode responds to OS color scheme change via event listener
  - Persistence: reload app preserves preference (localStorage or API)

## Done Criteria (maps to KAN-112 AC)
- [ ] Light selection updates UI immediately
- [ ] Dark selection updates UI immediately
- [ ] System selection updates to OS theme
- [ ] System mode updates on OS theme change without refresh
- [ ] Default is System when no preference saved
- [ ] Preference persists across sessions for logged-in users
