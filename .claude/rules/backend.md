---
paths:
  - "backend/**/*.php"
---

# Backend Rules

- PSR-12 coding standard — enforced by php-cs-fixer
- PHP 8.3 features: typed properties, enums, readonly classes, match expressions, named arguments, intersection types
- All API responses use JSON envelope: `{"data": ..., "error": ..., "meta": ...}`
- Prepared statements for ALL database queries — never string interpolation with user input
- Type declarations on all function parameters and return types — no missing types
- Controllers handle HTTP concerns only (request parsing, response formatting)
- Business logic goes in `/services` — controllers call services, services call models
- Models handle data access and validation only
- Always validate input at the controller level before passing to services
- Use `match` expressions instead of switch statements
- Error handling: throw typed exceptions, catch in controller, return error envelope with appropriate HTTP status
- Xdebug-compatible: use meaningful exception messages and maintain clean call stacks for trace analysis
- Test files mirror source structure: `controllers/OrderController.php` → `tests/Feature/Controllers/OrderControllerTest.php`
