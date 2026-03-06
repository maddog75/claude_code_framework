---
name: new-component
description: "Scaffold a new React component with TypeScript, Tailwind styling, and Vitest test."
---

# New React Component

Scaffold a React component with test. Accepts `$ARGUMENTS` as component name and optional type.

## Usage
- `/new-component OrderTable` — scaffold a standard component
- `/new-component OrderTable widget` — scaffold a dashboard widget component
- `/new-component OrderForm form` — scaffold a form component with React Hook Form
- `/new-component OrdersPage page` — scaffold a Next.js page

## Steps

1. Parse `$ARGUMENTS`: extract component name (required, PascalCase) and type (optional: `widget`, `form`, `page`; default: standard component)

2. **Create component file:**
   - Standard/Widget: `frontend/components/{ComponentName}.tsx`
   - Form: `frontend/components/{ComponentName}.tsx` with React Hook Form integration
   - Page: `frontend/pages/{path}.tsx` as a Next.js page

3. **Component template requirements:**
   - TypeScript with strict props interface (`{ComponentName}Props`)
   - Functional component with `export default`
   - Tailwind CSS classes for styling
   - `data-testid` attribute on the root element
   - If `widget`: include a card-like container layout for dashboard grid placement
   - If `form`: use `useForm` from React Hook Form, include `onSubmit` handler prop, add Zod schema validation
   - If `page`: include Next.js page metadata, data fetching pattern (getServerSideProps or client-side fetch)

4. **Create test file** at `frontend/__tests__/{ComponentName}.test.tsx` (or co-located):
   - Import from `@testing-library/react` and `@testing-library/user-event`
   - Test that the component renders without errors
   - Test key interactions (click, input, submit as appropriate)
   - Test prop variations
   - If `form`: test validation messages, submit handler call
   - If `widget`: test data display, loading state

5. Report created files and suggest next steps (add to page, connect to API)
