---
description: how to run tests in the application
---
# Testing Workflow

Use this workflow to run tests for the application.

1. Run the entire test suite:
// turbo
```bash
bin/rails test
```

2. Run model and controller tests:
// turbo
```bash
bin/rails test test/models test/controllers
```

3. Run a single test file:
```bash
bin/rails test <path/to/test_file.rb>
```

4. Run a single test by name:
```bash
bin/rails test <path/to/test_file.rb> --name <test_name>
```

> [!NOTE]
> System tests require a browser. Ensure Chrome and Chromedriver are installed if running locally.
