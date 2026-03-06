---
name: e2e
description: "Run Playwright end-to-end tests against the running application. Optionally filter by test name or file."
---

# Run E2E Tests

Run Playwright end-to-end tests. Accepts `$ARGUMENTS` for filtering.

## Usage
- `/e2e` — run all E2E tests
- `/e2e login` — run tests matching "login"
- `/e2e e2e/dashboard.spec.ts` — run a specific test file
- `/e2e --headed` — run with visible browser

## Prerequisites

Verify all three services are running before executing tests:

```bash
# Check frontend (port 3000)
curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 || echo "Frontend not running on :3000"

# Check backend API (port 8080)
curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/api/health || echo "API not running on :8080"

# Check WebSocket (port 8765)
echo '{}' | timeout 2 wscat -c ws://localhost:8765 2>/dev/null || echo "WebSocket not running on :8765"
```

If any service is not running, report which ones are down and provide the start commands.

## Steps

1. Verify all three services are running (see prerequisites above)

2. Run Playwright tests:
   ```bash
   cd frontend && npx playwright test $ARGUMENTS
   ```

3. If tests pass, report the summary (tests passed, duration)

4. If tests fail:
   - Report failing test names with file paths and line numbers
   - Include the error messages and assertion failures
   - Check for screenshots in `frontend/test-results/`
   - Suggest fixes based on the error output
   - If appropriate, suggest running `npx playwright show-report` for the full HTML report

5. The Playwright MCP server is available for interactive browser testing during development. Use it to navigate pages, fill forms, and verify UI state via accessibility tree.
