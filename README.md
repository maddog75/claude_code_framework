# Claude Model Project

A modern multi-service web application built with AI-assisted development using Claude Code. The project follows Clean Architecture with strict separation of concerns across three independent services.

## Architecture

```
┌──────────────┐
│   Browser    │
└──┬───────┬───┘
   │       │
   │ HTTP  │ WebSocket
   v       v
┌──────┐ ┌──────────┐
│Next.js│ │Python WS │
│:3000  │ │:8765     │
└──┬────┘ └──────────┘
   │
   │ REST/JSON
   v
┌──────────┐
│PHP 8.3   │
│API :8080 │
└──┬───────┘
   v
┌──────────┐
│Database  │
└──────────┘
```

- **Frontend** (Next.js + React) — UI rendering, routing, client-side state
- **Backend** (PHP 8.3 REST API) — Business logic, CRUD operations, authentication
- **Realtime** (Python 3 WebSocket) — Live data feeds, event broadcasting

## Tech Stack

### Frontend
| Category | Libraries |
|----------|-----------|
| Framework | Next.js, React, TypeScript |
| Styling | Tailwind CSS |
| Data Grids | TanStack Table, MUI DataGrid |
| Charts | Recharts, Chart.js, Visx |
| Forms | React Hook Form |
| Date Pickers | MUI DatePicker, React Day Picker |
| Autocomplete | MUI Autocomplete, Downshift |
| Dialogs | Radix UI |
| Rich Text | Slate, Tiptap |
| Drag & Drop | dnd-kit |
| Animations | Framer Motion |

### Backend & Realtime
| Service | Technology |
|---------|-----------|
| REST API | PHP 8.3 (PSR-12, Composer) |
| WebSocket Server | Python 3.11+ (asyncio, websockets) |
| Database | MySQL / PostgreSQL |

### Testing & Debugging
| Tool | Purpose |
|------|---------|
| Vitest | Frontend unit tests |
| PHPUnit | Backend unit/feature tests |
| pytest | WebSocket server tests |
| Playwright | End-to-end browser tests |
| Xdebug | PHP step debugging & profiling |
| debugpy | Python remote debugging |

## Project Structure

```
/frontend              Next.js + React application
  /components          Reusable React components
  /pages               Next.js pages and routes
  /utils               Helpers, API client, WebSocket hooks
  /e2e                 Playwright E2E test specs

/backend               PHP 8.3 REST API
  /public              Web root (index.php)
  /api                 Route definitions
  /controllers         Request handlers
  /models              Data models
  /services            Business logic
  /migrations          Database migrations
  /tests               PHPUnit tests

/realtime              Python WebSocket server
  websocket_server.py  Main entry point
  /handlers            Event handlers
  /tests               pytest tests
```

## Quick Start

### With Docker Compose
```bash
cp .env.example .env
docker compose up -d
```

### Manual Setup
```bash
# Frontend
cd frontend && npm install && npm run dev

# Backend
cd backend && composer install && php -S localhost:8080 -t public/

# Realtime
cd realtime && pip install -r requirements.txt && python websocket_server.py
```

Services run on: Frontend `:3000` | API `:8080` | WebSocket `:8765`

## AI-Assisted Development

This project is configured for AI-assisted development with [Claude Code](https://claude.ai/code). The setup includes:

- **CLAUDE.md** — Project instructions loaded every session
- **8 Skills** — Automated workflows invoked via slash commands:
  - `/test` — Run all test suites
  - `/new-endpoint` — Scaffold a PHP API endpoint
  - `/new-component` — Scaffold a React component
  - `/e2e` — Run Playwright E2E tests
  - `/review` — Code review for security, style, performance
  - `/deploy` — Deployment workflow
  - `/db-migrate` — Database migrations
  - `/ws-event` — Add WebSocket event handler
- **Path-specific rules** — Automatic code conventions per language
- **Playwright MCP** — Browser automation for E2E testing
- **Auto-lint hook** — Lints files on save (ESLint, php-cs-fixer, ruff)

## Documentation

| Document | Description |
|----------|-------------|
| [ARCHITECTURE.md](ARCHITECTURE.md) | Service boundaries, API contracts, WebSocket protocol, database design |
| [DEVELOPMENT.md](DEVELOPMENT.md) | Environment setup, Docker Compose, debugging with Xdebug/debugpy |
| [TESTING.md](TESTING.md) | Testing strategy, per-service guides, CI/CD pipeline |
| [SKILLS.md](SKILLS.md) | Available skills, workflow patterns, MCP integrations |

## API Design

All REST endpoints return a consistent JSON envelope:

```json
{
  "data": { },
  "error": null,
  "meta": { "page": 1, "total": 100, "per_page": 20 }
}
```

WebSocket messages follow a typed protocol:

```json
{
  "type": "event_name",
  "data": { },
  "timestamp": "2026-03-06T12:00:00Z",
  "id": "uuid"
}
```

## Contributing

- Branch naming: `feature/`, `fix/`, `refactor/`
- Commit messages: [Conventional Commits](https://www.conventionalcommits.org/) (`feat:`, `fix:`, `refactor:`, `test:`, `docs:`)
- All commits must pass linting and tests
- PR required for merge to main

## License

All frontend UI libraries used are free and open-source.
