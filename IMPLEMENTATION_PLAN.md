# IMPLEMENTATION PLAN - KAN-113

## Summary
Implement a light/dark theme toggle with a third option "System" that syncs to the user's OS color scheme. The selection persists across sessions via localStorage, does not require a page refresh, and an explicit user preference overrides future OS changes until the user reverts to "System".

## Scope (from Jira: KAN-113)
- Default to OS theme when no saved preference exists
- Manual toggle switches theme without full page refresh
- User selection persists across sessions
- Explicit preference overrides OS changes
- User can revert to "System" to follow device preference again

## Approach

### 1) Theme Model & Storage
- Add a theme "mode" with three possible values:
  - `system`: follow `prefers-color-scheme`
  - `light`
  - `dark`
- Persist the value in localStorage (eg. `sms_theme_mode_v1`).

### 2) CSS Theming
- Convert existing CSS custom properties to a themable structure:
  - Define default (Light) variables in `:root`
  - Define Dark variant variables under `[data-theme="dark"]` (e.g. on `<html>`)
- Update color-dependent rules to use variables instead of hard-coded colors where needed (e.g. table header background, hover states, button secondary background, input background).

### 3) Toggle UI
- Add a small theme selector in the header (or toolbar):
  - Label: "Theme"
  - Options: System / Light / Dark
- Accessibility: add aria-label and indicate current selection.

### 4) System Preference Sync
- Use `MatchMedia('(prefers-color-scheme: dark)')` to determine system mode.
- Attach an event listener for OS changes:
  - Only apply changes when the stored mode is `system`. If mode is `light` or `dark`, ignore OS changes.

### 5) Definition of Done / Testing
- Manual test cases:
  - Fresh load with no localStorage set: follows OS theme
  - Set to Dark / Light: theme changes immediately without refresh
  - Reload: it persists
  - While explicit mode set, changing OS theme does not change the app
   - Set to System: app follows OS again and updates on OS change
