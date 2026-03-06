# Testing Strategy

## Philosophy

- **Testing pyramid**: many unit tests (fast), moderate integration tests, few E2E tests (slow, high confidence)
- Every new feature requires tests; every bug fix requires a regression test
- Tests must be fast, isolated, and deterministic
- Test behavior, not implementation details

```
        /    E2E    \        Playwright (critical paths, slow)
       / Integration \       Cross-service API tests (moderate)
      /     Unit      \      Vitest / PHPUnit / pytest (fast, many)
```

## Frontend Testing — Vitest

**Framework:** Vitest + React Testing Library
**Config:** `frontend/vitest.config.ts`
**Run:**
```bash
cd frontend
npx vitest              # Watch mode
npx vitest --run        # Single run (CI)
npx vitest --coverage   # With coverage report
```

**File convention:** `ComponentName.test.tsx` co-located with the component.

**What to test:**
- Component rendering with various props
- User interactions (click, type, submit) via `@testing-library/user-event`
- Custom hook behavior via `renderHook`
- API response handling (mock fetch with `vi.mock` or MSW)
- Form validation with React Hook Form
- WebSocket message handling (mock WebSocket)

**Mocking patterns:**
```typescript
// Mock API calls
vi.mock('@/utils/api', () => ({
  fetchOrders: vi.fn().mockResolvedValue({ data: mockOrders })
}));

// Mock WebSocket
const mockSocket = { onmessage: null, send: vi.fn(), close: vi.fn() };
vi.stubGlobal('WebSocket', vi.fn(() => mockSocket));
```

## Backend Testing — PHPUnit

**Framework:** PHPUnit 10+
**Config:** `backend/phpunit.xml`
**Run:**
```bash
cd backend
./vendor/bin/phpunit                          # All tests
./vendor/bin/phpunit --filter=OrderTest       # Specific test
./vendor/bin/phpunit --coverage-text          # With coverage
```

**Directory structure:**
```
backend/tests/
  Unit/
    Models/
    Services/
  Feature/
    Controllers/
```

**What to test:**
- Controller endpoints return correct status codes and JSON envelope
- Model validation rules
- Service layer business logic
- Database operations (use transactions for automatic rollback)
- Authentication and authorization middleware
- Input validation and error responses

**Test database:**
Use `.env.testing` with a separate test database. Wrap each test in a transaction that rolls back after completion.

### Debugging Tests with Xdebug

When PHPUnit tests fail, use Xdebug to get detailed stack traces and step through code:

```bash
# Enhanced error output with Xdebug develop mode
XDEBUG_MODE=develop ./vendor/bin/phpunit --filter=FailingTest

# Step debugging with breakpoints (attach VSCode debugger first)
XDEBUG_MODE=debug ./vendor/bin/phpunit --filter=FailingTest

# Full function call trace for analyzing execution flow
XDEBUG_MODE=trace ./vendor/bin/phpunit --filter=FailingTest
```

Claude Code can interpret Xdebug's enhanced stack traces to identify root causes faster. The `develop` mode adds improved `var_dump` output and better error messages.

## Realtime Testing — pytest

**Framework:** pytest + pytest-asyncio
**Config:** `realtime/pyproject.toml` or `realtime/pytest.ini`
**Run:**
```bash
cd realtime
pytest                              # All tests
pytest tests/test_handlers.py -v    # Specific test file
pytest --cov=. --cov-report=term    # With coverage
```

**File convention:** `tests/test_*.py`

**What to test:**
- WebSocket message parsing and routing
- Subscription management (subscribe/unsubscribe)
- Broadcast logic (message reaches all subscribers)
- Connection/disconnection handling
- Message protocol compliance (correct format, required fields)
- Authentication flow
- Error handling and edge cases

**Async test pattern:**
```python
import pytest
from websockets.testing import LocalConnection

@pytest.mark.asyncio
async def test_subscribe():
    async with LocalConnection(handler) as conn:
        await conn.send('{"type": "subscribe", "data": {"channel": "orders"}}')
        response = await conn.recv()
        assert json.loads(response)["type"] == "subscribed"
```

### Debugging Tests with debugpy

When pytest tests fail on async WebSocket handlers, use debugpy for enhanced debugging:

```bash
# Run pytest with debugpy listening for a debugger
python -m debugpy --listen 5678 -m pytest tests/ -v

# Wait for VSCode debugger to attach before running
python -m debugpy --listen 5678 --wait-for-client -m pytest tests/test_handlers.py -v
```

debugpy provides clearer async stack traces than standard Python output, making it easier for Claude Code to diagnose issues in async/await code paths.

## E2E Testing — Playwright

**Framework:** Playwright with TypeScript
**Config:** `frontend/playwright.config.ts`
**Run:**
```bash
cd frontend
npx playwright test                     # Headless (CI)
npx playwright test --headed            # With browser UI
npx playwright test --ui                # Interactive UI mode
npx playwright test --grep="login"      # Filter by test name
npx playwright show-report              # View HTML report
```

**Prerequisites:** All three services must be running (frontend :3000, API :8080, WebSocket :8765).

**Directory:** `frontend/e2e/`

**What to test:**
- Page navigation and loading
- Authentication flows (login, logout, protected routes)
- CRUD workflows (create, read, update, delete via UI)
- Form submissions with validation
- Dashboard rendering (charts load with data)
- Real-time updates (verify WebSocket-driven chart/table updates)
- Responsive layout at different viewports

**Best practices:**
- Use `data-testid` attributes for reliable selectors
- Use Playwright's auto-waiting — avoid hardcoded `sleep`/`waitForTimeout`
- Use Page Object Model for reusable page interactions
- Take screenshots on failure (configured in `playwright.config.ts`)
- Run across browsers: Chromium, Firefox, WebKit

**Page Object pattern:**
```typescript
// e2e/pages/DashboardPage.ts
export class DashboardPage {
  constructor(private page: Page) {}

  async goto() {
    await this.page.goto('/dashboard');
  }

  async getOrderCount() {
    return this.page.getByTestId('order-count').textContent();
  }

  async waitForRealtimeUpdate() {
    await this.page.getByTestId('live-indicator').waitFor({ state: 'visible' });
  }
}
```

### Playwright MCP Integration

The Playwright MCP server enables Claude Code to interact with the browser during development:
- Navigate to pages and verify rendering
- Fill forms and test interactions
- Inspect accessibility tree for selector discovery
- Verify visual state without screenshots (uses accessibility tree)

Configure in `.mcp.json` at project root. The MCP server uses accessibility snapshots for faster, more reliable interaction than pixel-based approaches.

## Integration Testing

**Frontend → Backend:**
Test API client functions against the running PHP server or a mock server (MSW).

**Backend → Database:**
Test queries against a test database with seeded data. Use PHPUnit's `setUp`/`tearDown` with transactions.

**Frontend → Realtime:**
Test WebSocket hook behavior with a mock WebSocket server or `ws` library.

**Full Stack:**
Playwright E2E tests inherently cover the complete integration across all three services.

## CI/CD Pipeline

```
lint (parallel)        → unit tests (parallel)    → integration    → E2E
├─ ESLint (frontend)   ├─ Vitest (frontend)       │                ├─ Playwright
├─ php-cs-fixer (API)  ├─ PHPUnit (backend)       │                └─ (all services
└─ ruff (realtime)     └─ pytest (realtime)       │                    in Docker)
```

- **Fail fast:** stop pipeline on first failure
- **Parallel:** frontend, backend, and realtime unit tests run simultaneously
- **E2E:** run against built services in Docker Compose
- **Coverage:** enforce minimum thresholds per service
