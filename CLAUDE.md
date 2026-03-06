# CLAUDE.md

## Project Overview

Multi-service web application with Clean Architecture: Next.js frontend for UI, PHP 8.3 REST API for business logic and CRUD, Python 3 WebSocket server for real-time data feeds. Each service is independent. See @ARCHITECTURE.md for detailed design.

## Tech Stack

**Frontend (Next.js + React)**
- Next.js 14+ / React 18+ / TypeScript / Tailwind CSS
- Tables: TanStack Table, MUI DataGrid
- Date Pickers: MUI DatePicker, React Day Picker
- Autocomplete: MUI Autocomplete, Downshift
- Charts: Recharts, Chart.js, Visx
- Forms: React Hook Form
- Dialogs: Radix UI
- Rich Text Editors: Slate, Tiptap
- Drag & Drop: dnd-kit
- Animations: Framer Motion

**Backend:** PHP 8.3 / Composer / PSR-4 autoloading
**Realtime:** Python 3.11+ / asyncio / websockets
**Testing:** Vitest (frontend), PHPUnit (backend), pytest (realtime), Playwright (E2E)
**Debugging:** Xdebug (PHP), debugpy (Python)

## Directory Structure

```
/frontend           Next.js + React app
  /components       Reusable React components
  /pages            Next.js pages/routes
  /utils            Helpers, API client, hooks
  /e2e              Playwright E2E tests
/backend            PHP 8.3 REST API
  /public           Web root (index.php)
  /api              Route definitions
  /controllers      Request handlers
  /models           Data models
  /services         Business logic
  /migrations       DB migrations
  /tests            PHPUnit tests
/realtime           Python WebSocket server
  websocket_server.py
  /handlers         Event handlers
  /tests            pytest tests
```

## Code Style

### Frontend (TypeScript/React)
- TypeScript strict mode, 2-space indentation
- Functional components only, no class components
- React Hook Form for all forms — never uncontrolled forms with manual state
- Tailwind CSS for all styling — no inline style objects, no CSS modules
- File naming: PascalCase for components (`OrderTable.tsx`), camelCase for utils (`formatDate.ts`)
- Import order: React → third-party → local (use `@/` path alias)
- Use `data-testid` attributes on interactive elements for Playwright selectors

### Backend (PHP 8.3)
- PSR-12 coding standard
- Use PHP 8.3 features: typed properties, enums, readonly classes, match expressions, named arguments
- All responses use JSON envelope: `{"data": ..., "error": ..., "meta": ...}`
- Prepared statements for ALL database queries — never interpolate user input
- Type declarations on all function parameters and return types

### Realtime (Python 3)
- Type hints on all function signatures
- asyncio-based — no blocking calls, use `await` for I/O
- JSON message protocol: all messages have `type`, `data`, `timestamp`, `id` fields
- Use Python `logging` module, not `print()` for diagnostics

## Commands

### Build & Run
```bash
# Frontend
cd frontend && npm install && npm run dev          # Dev server :3000
cd frontend && npm run build                       # Production build

# Backend
cd backend && composer install                     # Install deps
cd backend && php -S localhost:8080 -t public/     # Dev server :8080

# Realtime
cd realtime && pip install -r requirements.txt
cd realtime && python websocket_server.py          # WS server :8765
```

### Testing
```bash
# Unit tests
cd frontend && npx vitest --run
cd backend && ./vendor/bin/phpunit
cd realtime && pytest

# E2E (requires all services running)
cd frontend && npx playwright test

# With debugging
cd backend && XDEBUG_MODE=debug ./vendor/bin/phpunit --filter=TestName
cd realtime && python -m debugpy --listen 5678 -m pytest tests/ -v
```

### Linting
```bash
cd frontend && npm run lint
cd backend && ./vendor/bin/php-cs-fixer fix --dry-run
ruff check realtime/
```

## Git Workflow

- Branch naming: `feature/description`, `fix/description`, `refactor/description`
- Commit messages: conventional commits (`feat:`, `fix:`, `refactor:`, `test:`, `docs:`)
- All commits must pass linting and tests
- PR required for merge to main
- Never commit `.env` files, secrets, or credentials

## Key References

- @ARCHITECTURE.md — service boundaries, API contracts, WebSocket protocol, database design
- @DEVELOPMENT.md — environment setup, Docker Compose, debugging with Xdebug/debugpy
- @TESTING.md — testing pyramid, per-service test strategies, CI/CD pipeline
- @SKILLS.md — available skills, workflow patterns, MCP integrations
