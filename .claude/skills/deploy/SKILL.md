---
name: deploy
description: "Deployment workflow for staging or production. Runs tests, builds, migrates, and deploys."
---

# Deploy

Deploy application services. Accepts `$ARGUMENTS` for target environment.

## Usage
- `/deploy` — deploy to staging (default)
- `/deploy staging` — deploy to staging
- `/deploy production` — deploy to production (requires confirmation)

## Steps

1. Parse target environment from `$ARGUMENTS` (default: `staging`)

2. If target is `production`, **ask for user confirmation** before proceeding

3. **Run all tests** — abort if any fail:
   ```bash
   cd frontend && npx vitest --run
   cd backend && ./vendor/bin/phpunit
   cd realtime && pytest
   ```

4. **Lint all services** — abort if any fail:
   ```bash
   cd frontend && npm run lint
   cd backend && ./vendor/bin/php-cs-fixer fix --dry-run
   ruff check realtime/
   ```

5. **Build frontend:**
   ```bash
   cd frontend && npm run build
   ```

6. **Run database migrations:**
   ```bash
   cd backend && php migrate.php run
   ```

7. **Deploy each service** to the target environment
   - The specific deployment commands depend on infrastructure setup
   - Report the status of each service deployment

8. **Run smoke tests** against the deployed environment to verify basic functionality

9. Report deployment status with service URLs and any warnings
