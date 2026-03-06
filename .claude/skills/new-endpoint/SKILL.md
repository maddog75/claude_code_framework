---
name: new-endpoint
description: "Scaffold a new PHP REST API endpoint with controller, model, route, and PHPUnit test."
---

# New API Endpoint

Scaffold a complete PHP API endpoint. Accepts `$ARGUMENTS` as the resource name and optional HTTP method.

## Usage
- `/new-endpoint orders` — scaffold full CRUD for orders
- `/new-endpoint orders GET` — scaffold GET endpoint only
- `/new-endpoint orders POST` — scaffold POST endpoint only

## Steps

1. Parse `$ARGUMENTS`: extract resource name (required) and HTTP method (optional, default: full CRUD)

2. **Create controller** at `backend/controllers/{ResourceName}Controller.php`:
   - PascalCase class name from resource name
   - PSR-12 compliant with strict types declaration
   - PHP 8.3 typed properties, return types, match expressions
   - Methods for requested HTTP verbs (index, show, store, update, destroy)
   - JSON envelope response format: `{"data": ..., "error": ..., "meta": ...}`
   - Input validation with typed parameters
   - Error handling with try/catch returning appropriate HTTP status codes

3. **Create model** at `backend/models/{ResourceName}.php`:
   - Typed properties matching expected database columns
   - Static finder methods (findAll, findById)
   - Save/update/delete methods using prepared statements
   - Validation rules as a static method

4. **Add route** in `backend/api/routes.php`:
   - RESTful route pattern: `GET /api/{resource}`, `POST /api/{resource}`, etc.
   - Map to the controller methods

5. **Create PHPUnit test** at `backend/tests/Feature/Controllers/{ResourceName}ControllerTest.php`:
   - Test each endpoint method
   - Test success responses (correct status code, JSON structure)
   - Test validation errors (missing/invalid fields)
   - Test not-found cases
   - Use database transactions for cleanup

6. Report created files and suggest next steps (run tests, add business logic)
