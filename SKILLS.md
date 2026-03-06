# Skills Reference

## Available Skills

| Skill | Command | Description |
|-------|---------|-------------|
| test | `/test [suite] [--debug]` | Run test suites (all, frontend, backend, realtime) |
| deploy | `/deploy [env]` | Deploy to staging or production |
| new-endpoint | `/new-endpoint <name> [method]` | Scaffold PHP API endpoint with controller, model, route, tests |
| new-component | `/new-component <Name> [type]` | Scaffold React component with TypeScript and Vitest test |
| e2e | `/e2e [filter]` | Run Playwright E2E tests |
| review | `/review [range]` | Code review for style, security, performance, test coverage |
| db-migrate | `/db-migrate <name\|run\|rollback\|status>` | Create/run/rollback database migrations |
| ws-event | `/ws-event <name>` | Add WebSocket event handler (Python) + React hook |

## Workflow Patterns

### Adding a Full-Stack Feature
1. `/db-migrate create_orders_table` — create the database table
2. `/db-migrate run` — apply the migration
3. `/new-endpoint orders` — scaffold the PHP API
4. `/new-component OrderTable widget` — scaffold the React widget
5. `/test` — verify everything works
6. `/review` — review your changes

### Adding a Real-Time Feature
1. `/new-endpoint metrics GET` — scaffold the REST API for initial data load
2. `/ws-event metrics_update` — scaffold WebSocket event + React hook
3. `/new-component MetricsChart widget` — scaffold the chart component
4. `/e2e` — run E2E tests to verify the full flow

### Pre-Commit Workflow
1. `/review` — review changes for issues
2. `/test` — run all test suites
3. `/e2e` — run E2E tests
4. Fix any issues found, then commit

### Debugging a Failing Test
1. `/test backend --debug` — run with Xdebug for enhanced PHP stack traces
2. `/test realtime --debug` — run with debugpy for Python async debugging
3. Review the enhanced error output to identify root cause

## MCP Integrations

### Playwright MCP
Configured in `.mcp.json`. Enables Claude Code to:
- Navigate to application pages and verify rendering
- Fill forms and click buttons via accessibility tree
- Test user flows interactively during development
- Discover selectors using accessibility snapshots (faster than screenshots)

### Usage with E2E Development
When writing or debugging Playwright tests, the Playwright MCP server provides direct browser interaction. This is especially useful for:
- Discovering the correct selectors for elements
- Verifying page state after interactions
- Testing authentication flows
- Debugging flaky tests by observing actual browser behavior

## Hooks

### PostToolUse — Auto-Lint
Configured in `.claude/settings.json`. After every file write/edit:
- `.ts`/`.tsx` files → ESLint auto-fix
- `.php` files → php-cs-fixer
- `.py` files → ruff check + format

### Path-Specific Rules
Configured in `.claude/rules/`:
- `frontend.md` — TypeScript/React conventions
- `backend.md` — PHP 8.3/PSR-12 conventions
- `realtime.md` — Python asyncio conventions

These rules are automatically applied when Claude Code works on files matching the path patterns.
