#!/usr/bin/env bash
# Auto-lint hook: runs the appropriate linter after file writes/edits.
# Called by Claude Code PostToolUse hook with tool result JSON on stdin.

set -euo pipefail

# Read the tool result JSON from stdin
INPUT=$(cat)

# Extract the file path from the JSON
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.file // empty' 2>/dev/null || true)

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Determine file type and run appropriate linter
case "$FILE_PATH" in
  *.ts|*.tsx|*.js|*.jsx)
    if command -v npx &>/dev/null && [ -f "$CLAUDE_PROJECT_DIR/frontend/node_modules/.bin/eslint" ]; then
      cd "$CLAUDE_PROJECT_DIR/frontend" && npx eslint --fix "$FILE_PATH" 2>/dev/null || true
    fi
    ;;
  *.php)
    if command -v php &>/dev/null && [ -f "$CLAUDE_PROJECT_DIR/backend/vendor/bin/php-cs-fixer" ]; then
      cd "$CLAUDE_PROJECT_DIR/backend" && ./vendor/bin/php-cs-fixer fix "$FILE_PATH" --quiet 2>/dev/null || true
    fi
    ;;
  *.py)
    if command -v ruff &>/dev/null; then
      ruff check --fix "$FILE_PATH" 2>/dev/null || true
      ruff format "$FILE_PATH" 2>/dev/null || true
    fi
    ;;
esac

exit 0
