---
description: how to run database migrations
---
# Database Migration Workflow

Use this workflow to manage database migrations.

1. Create a new migration:
```bash
bin/rails generate migration <MigrationName>
```

2. Run pending migrations:
// turbo
```bash
bin/rails db:migrate
```

3. Rollback the last migration:
```bash
bin/rails db:rollback STEP=1
```

4. Prepare the database (setup, migrate, seed):
// turbo
```bash
bin/rails db:prepare
```
