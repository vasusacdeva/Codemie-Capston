# Implementation Plan — KAN-104 / Gap #4: Theme Toggle (Light/Dark/System)

Repo: `ttps://github.com/vasusacdeva/Codemie-Capston`

Story: KIN-104 — Add theme toggle (Light/Dark/System) and persist user preference

EPIC: KIN-103 — Theme Toggle (Light/Dark) - UI/UX Enhancement

---

## 1) Goals / Outcomes

1. Add a theme selector with 3 options: `System` (default), `Light`, `Dark`.
2. Persist user preference in `localStorage`.
3. Onload, hydrate theme without FOUC (flash of unthemed content).
4. Accessible control: Keyboard navigation, aria attributes, and reasonable contrast.

## Non-Goals

- Design rebranding or full token system refresh (beyond of minimal CSS variables required to support theme).
- Heavy UI refactoring outside color/surface tokens.

---

## 2) Technical Approach

### 2.1) Theme model

We'll store a single preference key in localStorage:

```ts
type ThemePref = 'system' | 'light' | 'dark';

const THEME_KEY = 'codemie:theme';
```

When `Pref === 'system'`, the effective theme is derived from `prefers-color-scheme:` media query.

Apply the effective theme via a non-invasive HTML attribute on root:

- `<html data-theme="light|dark">`

### 2.2) CSS tokens (variables)

Add minimal color tokens on `:root` and override in `[data-theme="dark"]` to avoid scattered hard-coded colors.

Example tokens:

```css
:root {
  --bg-color: #ffffff;
  --surface-color: #f7f8fc;
  --text-color: #111827;
  --muted-text: #4f4655;
  --border-color: #e5e7eb;
  --accent-color: #2563eb;
}

[data-theme="dark"] {
  --bg-color: #0c1222;
  --surface-color: #111827;
  --text-color: #f8fafc;
  --muted-text: #94a3c8;
  --border-color: #1f2937;
  --accent-color: #60a6fa;
}
```

Map existing colors in `container/card/buttons/text` styles to use variables automatically.

### 2.3) JavaScript implementation

Add a small initializer that:

- Reads stored pref from localStorage (fallback to `system`).
- Computes effective theme (based on matchMedia if system).
- Sets `documentDocumentElement.dataset.theme` to `light` or `dark`.
- Listens for os theme changes when pref is `system`.

Prefer placing a small inline script in <head> before styles are applied to minimize FOUC.

### 2.4) UI control

Add a control (e.g. a segmented control or select) with:

- Label: `Theme`
- Options: System, Light, Dark
- ARAA: `aria-label`/`aria-labelledby`, focus styles, keyboard usag

Placement: header nav or settings area depending on existing layout.

---

## 3) File/Code Changes (planned)

Note: repo is currently a static HTML app (index.html). Implemation will be done by editing existing CSS and add inline JS scripts or a new js file if preferred.

1. `index.html`
    - Inline init script in `head` to hydrate theme pref early
    - Add theme toggle control in header/nav/settings
    - Add listeners to update localStorage and re-apply theme

---

## 4) Acceptance Criteria Checklist (KAN-104)

- [ ] First load defaults to System theme
- [ ] User can select Light/Dark/System
- [ ] Preference persists across reloads
- [ ] When System is selected, OS theme changes are reflected without reload
- [ ] Accessible: keyboard navigation, focus states, screen reader semantics

---

## 5) Testing Plan

- Manual: verify toggle, refresh, OS theme change (System), and contrast on key views.
