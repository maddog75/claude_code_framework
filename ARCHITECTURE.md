# Architecture

## Overview

This is a multi-service web application using Clean Architecture with strict separation of concerns:

- **Frontend** (Next.js + React) — UI rendering, client-side state, API consumption, WebSocket subscriptions
- **Backend** (PHP 8.3 REST API) — Business logic, CRUD operations, authentication, data validation
- **Realtime** (Python 3 WebSocket Server) — Real-time data broadcasting, event pub/sub, live feeds

Each service is independent and communicates via HTTP JSON (frontend ↔ backend) and WebSocket (frontend ↔ realtime).

```
┌──────────────┐
│   Browser    │
│   Client     │
└──┬───────┬───┘
   │       │
   │ HTTP  │ WebSocket
   │       │
   v       v
┌──────┐ ┌──────────┐
│Next.js│ │Python WS │
│:3000  │ │:8765     │
└──┬────┘ └──────────┘
   │
   │ fetch/axios
   v
┌──────────┐
│PHP 8.3   │
│REST API  │
│:8080     │
└──┬───────┘
   │
   v
┌──────────┐
│Database  │
│MySQL/PG  │
└──────────┘
```

## Directory Structure

```
/frontend                 Next.js + React application
  /components             Reusable React components
  /pages                  Next.js pages and routes
  /utils                  Helper functions, API client, hooks
  /e2e                    Playwright E2E test specs
  __tests__/              Vitest unit tests

/backend                  PHP 8.3 REST API
  /public                 Web root (index.php entry point)
  /api                    Route definitions
  /controllers            Request handlers
  /models                 Data models / ORM entities
  /services               Business logic layer
  /migrations             Database migration files
  /tests                  PHPUnit tests

/realtime                 Python WebSocket server
  websocket_server.py     Main server entry point
  /handlers               Event handlers
  /tests                  pytest tests
  config.py               Server configuration
```

## Service Boundaries

### Frontend (Next.js + React)
- Handles all UI rendering and user interaction
- No business logic — purely presentational with data fetching
- Consumes PHP REST API via fetch/axios for CRUD operations
- Subscribes to Python WebSocket server for real-time updates
- Manages client-side state (React state, context, or Zustand)
- Routes via Next.js file-based routing

### Backend (PHP 8.3 REST API)
- Stateless REST API returning JSON
- Owns all business logic, validation, and authorization
- Single source of truth for persistent data
- Issues and validates JWT tokens for authentication
- Can notify the Python WebSocket server of events via HTTP callback

### Realtime (Python 3 WebSocket Server)
- Thin relay layer — not a source of truth
- Manages WebSocket connections and subscriptions
- Broadcasts data events to subscribed clients
- Receives events from external data sources or PHP API callbacks
- Uses asyncio for non-blocking concurrent connections

## Data Flow Patterns

### Standard CRUD Flow
```
Browser → Next.js page → fetch("/api/resource") → PHP API → Database
                                                           ↓
Browser ← React render ← setState(data) ← JSON response ←─┘
```

### Real-Time Data Flow
```
Data Source → Python WS Server → broadcasts to subscribers
                                        ↓
Browser ← React render ← setState ← WebSocket onmessage
```

### Mixed Flow (User Action Triggers Real-Time Update)
```
Browser → fetch POST → PHP API → writes to Database
                          ↓
                    HTTP callback to Python WS
                          ↓
                    Python broadcasts to all connected clients
                          ↓
Browser ← React render ← WebSocket onmessage (all subscribers)
```

## REST API Conventions

### Endpoints
- `GET    /api/{resource}`      — List resources (supports pagination)
- `GET    /api/{resource}/{id}` — Get single resource
- `POST   /api/{resource}`      — Create resource
- `PUT    /api/{resource}/{id}` — Update resource
- `DELETE /api/{resource}/{id}` — Delete resource

### JSON Response Envelope
All responses use a consistent envelope:

```json
{
  "data": { "id": 1, "name": "Example" },
  "error": null,
  "meta": { "page": 1, "total": 100, "per_page": 20 }
}
```

### Error Response
```json
{
  "data": null,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Name is required",
    "details": [{ "field": "name", "rule": "required" }]
  },
  "meta": {}
}
```

### HTTP Status Codes
- `200` Success
- `201` Created
- `400` Validation error
- `401` Unauthorized
- `403` Forbidden
- `404` Not found
- `500` Server error

## WebSocket Message Protocol

### Connection
- Endpoint: `ws://host:8765`
- Auth: send JWT token as first message after connection

### Message Format
All messages follow this structure:
```json
{
  "type": "event_name",
  "data": { },
  "timestamp": "2026-03-06T12:00:00Z",
  "id": "uuid-v4"
}
```

### Client → Server Messages
| Type | Description |
|------|-------------|
| `auth` | Send JWT token for authentication |
| `subscribe` | Subscribe to a channel/topic |
| `unsubscribe` | Unsubscribe from a channel/topic |
| `ping` | Keep-alive ping |

### Server → Client Messages
| Type | Description |
|------|-------------|
| `auth_ok` | Authentication successful |
| `data_update` | New or updated data for subscribed channel |
| `notification` | System notification |
| `error` | Error message |
| `pong` | Keep-alive response |

### Reconnection Strategy
- Exponential backoff: 1s, 2s, 4s, 8s, 16s, 30s (max)
- Resubscribe to all previous channels on reconnect

## Authentication

- JWT-based authentication issued by the PHP backend
- Frontend stores token in httpOnly cookie
- API requests include `Authorization: Bearer <token>` header
- WebSocket auth: token sent as first message after connection open
- Token refresh: silent refresh before expiry via `/api/auth/refresh`

## Database Design

- Relational database (MySQL 8+ or PostgreSQL 15+)
- Migration-based schema management (files in `/backend/migrations/`)
- Naming: snake_case for tables and columns, plural table names
- Every table has: `id` (auto-increment PK), `created_at`, `updated_at`
- Foreign keys with proper indexes
- Soft deletes where appropriate (`deleted_at` nullable timestamp)

## Dashboard Architecture

- Dashboard pages compose multiple chart and table widgets in a responsive Tailwind grid
- **TanStack Table** for sortable, filterable, paginated data grids with server-side pagination
- **Recharts** for standard charts (line, bar, pie)
- **Chart.js** for canvas-based performance charts
- **Visx** for custom SVG visualizations
- Data loading: initial fetch from PHP REST API, then real-time updates via WebSocket
- Example data flow:
```javascript
// Initial load from REST API
fetch("/api/orders")
  .then(res => res.json())
  .then(({ data }) => {
    setTableData(data);
    setChartData(processForCharts(data));
  });

// Real-time updates via WebSocket
const socket = new WebSocket("ws://localhost:8765");
socket.onmessage = (event) => {
  const { type, data } = JSON.parse(event.data);
  if (type === "data_update") {
    setRealtimeChartData(prev => [...prev, data]);
  }
};
```
