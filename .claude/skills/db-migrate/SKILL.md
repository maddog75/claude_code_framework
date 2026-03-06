---
name: db-migrate
description: "Create and run database migrations for the PHP backend. Supports create, run, and rollback."
---

# Database Migration

Create or run database migrations. Accepts `$ARGUMENTS` for the action.

## Usage
- `/db-migrate create_users_table` — create a new migration file
- `/db-migrate run` — execute all pending migrations
- `/db-migrate rollback` — revert the last migration
- `/db-migrate status` — show migration status

## Steps

### Creating a migration (`$ARGUMENTS` is a migration name):

1. Generate a migration file at `backend/migrations/{timestamp}_{name}.php`
   - Timestamp format: `YYYYMMDD_HHMMSS`
   - Example: `backend/migrations/20260306_120000_create_users_table.php`

2. Migration file template:
   ```php
   <?php
   declare(strict_types=1);

   return new class {
       public function up(PDO $db): void
       {
           $db->exec("
               CREATE TABLE table_name (
                   id INT AUTO_INCREMENT PRIMARY KEY,
                   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                   updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
               )
           ");
       }

       public function down(PDO $db): void
       {
           $db->exec("DROP TABLE IF EXISTS table_name");
       }
   };
   ```

3. Follow conventions:
   - snake_case table and column names
   - Plural table names (`users`, `orders`, `order_items`)
   - Always include `id`, `created_at`, `updated_at`
   - Add foreign key constraints with indexes
   - Use soft deletes (`deleted_at TIMESTAMP NULL`) where appropriate

### Running migrations (`$ARGUMENTS` is "run"):
```bash
cd backend && php migrate.php run
```

### Rolling back (`$ARGUMENTS` is "rollback"):
```bash
cd backend && php migrate.php rollback
```

### Checking status (`$ARGUMENTS` is "status"):
```bash
cd backend && php migrate.php status
```
