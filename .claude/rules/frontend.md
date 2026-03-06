---
paths:
  - "frontend/**/*.ts"
  - "frontend/**/*.tsx"
  - "frontend/**/*.js"
  - "frontend/**/*.jsx"
---

# Frontend Rules

- TypeScript strict mode — no `any` types unless absolutely necessary, prefer `unknown` + type guards
- Functional components only — never use class components
- Tailwind CSS for all styling — no inline `style` objects, no CSS modules, no styled-components
- React Hook Form for all forms — use `useForm`, `Controller`, and Zod for schema validation
- PascalCase for component files (`OrderTable.tsx`), camelCase for utility files (`formatDate.ts`)
- Import order: React/Next.js → third-party libraries → local imports (use `@/` alias)
- Add `data-testid` attributes on interactive elements and key display elements for Playwright
- Co-locate test files: `ComponentName.test.tsx` next to `ComponentName.tsx`
- Use TanStack Table for all tabular data — configure columns with `createColumnHelper`
- Use Recharts/Chart.js/Visx for visualizations — pick based on complexity (Recharts for standard, Visx for custom)
- Prefer server components where possible; use `"use client"` only when needed (hooks, event handlers)
- API calls go through a centralized fetch wrapper in `/utils/api.ts`
