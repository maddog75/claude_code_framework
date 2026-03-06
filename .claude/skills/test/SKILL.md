---
name: test
description: "Run all test suites across frontend, backend, and realtime services. Use when the user wants to run tests or verify code changes."
---

# Run Tests

Run test suites for this project. Accepts `$ARGUMENTS` to control scope.

## Usage
- `/test` — run all test suites
- `/test frontend` — run frontend tests only
- `/test backend` — run backend tests only
- `/test realtime` — run realtime tests only
- `/test --debug` — run all tests with Xdebug/debugpy for enhanced error output

## Steps

1. Determine which suites to run from `$ARGUMENTS` (default: all)

2. **Frontend tests** (if running):
   ```bash
   cd frontend && npx vitest --run
   ```

3. **Backend tests** (if running):
   ```bash
   cd backend && ./vendor/bin/phpunit
   ```
   If `--debug` flag is present:
   ```bash
   cd backend && XDEBUG_MODE=develop ./vendor/bin/phpunit
   ```

4. **Realtime tests** (if running):
   ```bash
   cd realtime && pytest -v
   ```
   If `--debug` flag is present:
   ```bash
   cd realtime && python -m debugpy --listen 5678 -m pytest -v
   ```

5. Report results: list passing/failing suites with counts. For failures, include file paths, line numbers, and error messages.

6. If any tests fail, suggest fixes based on the error output.
