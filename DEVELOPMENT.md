# Development Setup

## Prerequisites

- Node.js 20+ and npm
- PHP 8.3+ with extensions: pdo, pdo_mysql/pdo_pgsql, mbstring, json, curl, openssl
- Composer 2.x
- Python 3.11+ with pip
- Docker and Docker Compose (recommended)
- Git

## Quick Start (Docker Compose)

```bash
# Clone and start all services
cp .env.example .env        # Configure environment variables
docker compose up -d         # Start all services
docker compose logs -f       # Watch logs
```

Services will be available at:
- Frontend: http://localhost:3000
- PHP API: http://localhost:8080
- WebSocket: ws://localhost:8765
- Database: localhost:3306 (MySQL) or localhost:5432 (PostgreSQL)

## Manual Setup

### Frontend (Next.js + React)

```bash
cd frontend
npm install
cp .env.example .env.local   # Set NEXT_PUBLIC_API_URL and NEXT_PUBLIC_WS_URL
npm run dev                   # Starts on port 3000 with hot reload
```

### Backend (PHP 8.3 REST API)

```bash
cd backend
composer install
cp .env.example .env          # Configure database credentials and JWT secret
php migrate.php run           # Run database migrations
php -S localhost:8080 -t public/   # Start dev server
```

Note: In production, use PHP-FPM with Nginx instead of the built-in server.

### Realtime (Python WebSocket Server)

```bash
cd realtime
python -m venv venv
source venv/bin/activate      # On Windows: venv\Scripts\activate
pip install -r requirements.txt
python websocket_server.py    # Starts on port 8765
```

## Environment Variables

| Variable | Service | Default | Description |
|----------|---------|---------|-------------|
| `NEXT_PUBLIC_API_URL` | Frontend | `http://localhost:8080` | PHP API base URL |
| `NEXT_PUBLIC_WS_URL` | Frontend | `ws://localhost:8765` | WebSocket server URL |
| `DB_HOST` | Backend | `localhost` | Database host |
| `DB_PORT` | Backend | `3306` | Database port |
| `DB_NAME` | Backend | `app` | Database name |
| `DB_USER` | Backend | `root` | Database user |
| `DB_PASS` | Backend | `""` | Database password |
| `JWT_SECRET` | Backend | *(required)* | JWT signing secret |
| `WS_PORT` | Realtime | `8765` | WebSocket listen port |
| `API_CALLBACK_URL` | Realtime | `http://localhost:8080` | PHP API URL for callbacks |

## Debugging

### PHP Debugging with Xdebug

Xdebug provides step debugging, stack traces, and profiling for PHP. It is especially valuable for debugging failing PHPUnit tests and tracing API request flows.

**Installation:**
```bash
# Ubuntu/Debian
sudo apt install php8.3-xdebug

# Or via PECL
pecl install xdebug
```

**Configuration** (`php.ini` or `/etc/php/8.3/cli/conf.d/20-xdebug.ini`):
```ini
[xdebug]
zend_extension=xdebug
xdebug.mode=debug,develop
xdebug.start_with_request=yes
xdebug.client_host=127.0.0.1
xdebug.client_port=9003
xdebug.log=/tmp/xdebug.log
```

**Usage with PHPUnit:**
```bash
# Run tests with Xdebug enabled for detailed stack traces
XDEBUG_MODE=debug php vendor/bin/phpunit --filter=TestName

# Run with trace output for call flow analysis
XDEBUG_MODE=trace php vendor/bin/phpunit
```

**VSCode launch.json:**
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Listen for Xdebug",
      "type": "php",
      "request": "launch",
      "port": 9003,
      "pathMappings": {
        "/var/www/html": "${workspaceFolder}/backend"
      }
    }
  ]
}
```

**Claude Code Integration:**
When tests fail, Claude Code can run PHPUnit with Xdebug trace mode to get detailed call stacks, variable values, and pinpoint exact failure locations. The enhanced error output from `xdebug.mode=develop` provides richer context for debugging.

### Python Debugging with debugpy

debugpy is Microsoft's Python debugger that supports remote debugging, breakpoints, and variable inspection. Valuable for debugging async WebSocket handlers and pytest failures.

**Installation:**
```bash
pip install debugpy
```

**Attach to WebSocket Server:**
```python
# Add at the top of websocket_server.py for debug sessions
import debugpy
debugpy.listen(("0.0.0.0", 5678))
print("Waiting for debugger attach on port 5678...")
debugpy.wait_for_client()  # Remove this line for non-blocking
```

**Usage with pytest:**
```bash
# Run tests with debugpy for enhanced debugging
python -m debugpy --listen 5678 -m pytest tests/ -v

# Or run a specific test with wait-for-client
python -m debugpy --listen 5678 --wait-for-client -m pytest tests/test_handlers.py -v
```

**VSCode launch.json:**
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Python: Remote Attach",
      "type": "debugpy",
      "request": "attach",
      "connect": { "host": "localhost", "port": 5678 },
      "pathMappings": [
        { "localRoot": "${workspaceFolder}/realtime", "remoteRoot": "." }
      ]
    }
  ]
}
```

**Claude Code Integration:**
Claude Code can launch pytest with debugpy to get enhanced traceback information for async code. When WebSocket handlers fail, debugpy provides clearer async stack traces than standard Python output.

### Frontend Debugging

- **React DevTools** browser extension for component inspection
- **Network tab** to inspect API calls (Headers, Response, Timing)
- **WebSocket frames** visible in Network tab → WS filter
- **Next.js error overlay** shows component stack traces in development
- `console.log` in useEffect hooks for data flow tracing

### WebSocket Testing

```bash
# Install wscat for command-line WebSocket testing
npm install -g wscat

# Connect and send messages
wscat -c ws://localhost:8765
> {"type":"auth","data":{"token":"your-jwt-token"}}
> {"type":"subscribe","data":{"channel":"orders"}}
```

## Common Issues

**CORS errors from frontend:**
Ensure PHP API sets headers: `Access-Control-Allow-Origin`, `Access-Control-Allow-Methods`, `Access-Control-Allow-Headers`. Use a CORS middleware.

**WebSocket connection refused:**
Verify the Python server is running (`python websocket_server.py`) and the port matches `NEXT_PUBLIC_WS_URL`.

**Hot reload not working on Linux:**
Increase file watcher limit: `echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p`

**PHP class not found:**
Run `composer dump-autoload` to regenerate the autoloader.

**Database connection refused:**
Verify the database container is running (`docker compose ps`) and credentials in `.env` match.
