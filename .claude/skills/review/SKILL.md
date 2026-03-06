---
name: review
description: "Perform a comprehensive code review of recent changes. Checks style, security, performance, and test coverage."
---

# Code Review

Review recent code changes for quality, security, and completeness. Accepts `$ARGUMENTS` for commit range.

## Usage
- `/review` — review changes in last commit
- `/review HEAD~3..HEAD` — review last 3 commits
- `/review main..feature/orders` — review branch changes

## Steps

1. Get the list of changed files:
   ```bash
   git diff --name-only HEAD~1    # or the range from $ARGUMENTS
   ```

2. Read each changed file and review for:

   **Code Quality:**
   - Follows project code style (PSR-12 for PHP, TypeScript strict for frontend, type hints for Python)
   - No code duplication or copy-paste patterns
   - Functions are focused and reasonably sized
   - Naming is clear and consistent with project conventions

   **Security (CRITICAL):**
   - No SQL injection (PHP must use prepared statements)
   - No XSS vulnerabilities (React escapes by default, but check `dangerouslySetInnerHTML`)
   - No exposed secrets, API keys, or credentials in code
   - No user input passed unsanitized to shell commands or file paths
   - Auth checks on protected endpoints

   **Performance:**
   - No N+1 query patterns
   - No unnecessary re-renders (missing React.memo, dependency arrays)
   - No blocking calls in async Python code
   - Appropriate use of pagination for data fetches

   **Testing:**
   - New functionality has corresponding tests
   - Bug fixes include regression tests
   - Test assertions are meaningful (not just "it doesn't throw")

3. Categorize each finding:
   - **CRITICAL** — must fix before merge (security, data loss, crashes)
   - **WARNING** — should fix (performance, maintainability)
   - **SUGGESTION** — nice to have (style, minor improvements)

4. Output a structured review with:
   - File path and line number for each finding
   - Category (CRITICAL/WARNING/SUGGESTION)
   - Description of the issue
   - Recommended fix with code snippet where appropriate
