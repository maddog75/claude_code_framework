---
name: ws-event
description: "Add a new WebSocket event handler to the Python realtime server and corresponding React hook."
---

# New WebSocket Event

Scaffold a WebSocket event handler (Python) and React consumer hook. Accepts `$ARGUMENTS` as the event name.

## Usage
- `/ws-event price_update` — create handler for price_update events
- `/ws-event order_notification` — create handler for order notifications

## Steps

1. Parse `$ARGUMENTS` as the event name (snake_case)

2. **Create Python handler** at `realtime/handlers/{event_name}.py`:
   ```python
   import json
   import logging
   from datetime import datetime, timezone
   from uuid import uuid4

   logger = logging.getLogger(__name__)

   async def handle_{event_name}(websocket, data: dict) -> None:
       """Handle {event_name} events.

       Message format:
         Incoming: {"type": "{event_name}", "data": {...}}
         Outgoing: {"type": "{event_name}", "data": {...}, "timestamp": "ISO8601", "id": "uuid"}
       """
       response = {
           "type": "{event_name}",
           "data": data,
           "timestamp": datetime.now(timezone.utc).isoformat(),
           "id": str(uuid4()),
       }
       await websocket.send(json.dumps(response))
   ```

3. **Register the handler** in `realtime/websocket_server.py`:
   - Import the handler function
   - Add to the message type router/registry dict:
     ```python
     handlers = {
         # ... existing handlers
         "{event_name}": handle_{event_name},
     }
     ```

4. **Create or update React hook** in `frontend/utils/useWebSocket.ts`:
   - Add typed handler for the new event
   - Export a typed callback interface:
     ```typescript
     // Type for {event_name} data
     interface {EventName}Data {
       // Define fields based on the event data shape
     }

     // In the useWebSocket hook, add handler:
     case "{event_name}":
       on{EventName}?.(message.data as {EventName}Data);
       break;
     ```

5. **Create Python test** at `realtime/tests/test_{event_name}.py`:
   - Test handler processes valid messages correctly
   - Test handler response matches protocol format
   - Test error handling for invalid data
   - Use pytest-asyncio for async tests

6. **Create React hook test** at `frontend/__tests__/useWebSocket.test.ts` (or update existing):
   - Test that the hook calls the event handler when receiving the message type
   - Test with mock WebSocket

7. Report created/modified files and the message format for documentation
