# IMPLEMENTATION PLAN - KAN-XX - Theme Toggle / Accessibility Baseline

## Context / Story

Fallback story identifier: **KAN-XX**

Gap Analysis Item #4: **No Theme Toggle / Accessibility Baseline**

*As a **user** I want to toggle between light and dark themes and have basic accessibility support, so that the app can be used more comfortably and complies with basic a11y expectations.*

## Scope (Design + Implementation)

### 1) Theming Architecture

- Implement theme via CSS Custom Properties (token based) to avoid duplicate stylesheets.
- Use a attribute on the root element to switch theme: `documentElement.setAttribute('data-theme', 'light')`
  - data-theme="light" default
  - data-theme="dark" dark mode
- Theme tokens live in a single place (e.g. src/assets/styles/theme.css or styles.theme.css).

Proposed tokens (minimum):
