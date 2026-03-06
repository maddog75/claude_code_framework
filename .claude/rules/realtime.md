---
paths:
  - "realtime/**/*.py"
---

# Realtime Rules

- Type hints on all function signatures — use `typing` module for complex types
- asyncio-based — never use blocking calls (`time.sleep`, synchronous HTTP, blocking I/O)
- Use `async def` for all handler functions, `await` for I/O operations
- All WebSocket messages follow the protocol: `{"type": str, "data": dict, "timestamp": str, "id": str}`
- Use Python `logging` module at appropriate levels (DEBUG for dev, INFO for operations, ERROR for failures)
- Handler functions go in `/handlers/` — one handler per event type or domain
- Use `websockets` library patterns — `async for message in websocket:` for receiving
- Handle `ConnectionClosed` exceptions gracefully — clean up subscriptions on disconnect
- Message routing: parse `type` field, dispatch to handler function via registry dict
- Test files: `tests/test_*.py` using pytest-asyncio for async test support
- debugpy compatible: use structured logging so debug output is clear when attached
- No global mutable state — use connection-scoped or class-scoped state management
