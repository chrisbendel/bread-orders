# Junie Guidelines for this Project

These are the working guidelines for contributors and automation (Junie) on this Rails application.

Project snapshot
- Framework: Ruby on Rails 8.1.1
- Language/Runtime: Ruby (see .ruby-version if present, else use system Ruby compatible with Gemfile)
- DB: PostgreSQL
- Assets: Propshaft
- Frontend: Turbo + Stimulus via importmap-rails
- Background/infra: solid_queue, solid_cache, solid_cable
- Testing: Minitest (+ system tests via Capybara + Selenium)
- Lint/Style: standardrb
- Security tools: bundler-audit, brakeman
- Deployment tooling: kamal (optional)

1) Getting started
- Prereqs: Ruby, Bundler, PostgreSQL, Node is not required (importmap), Chrome/Chromedriver for system tests.
- Install gems: bundle install
- Configure DB (ensure a local Postgres user with privileges). Environment can be set via DATABASE_URL or config/database.yml.
- Prepare DB (create + migrate + seed if needed): bin/rails db:prepare
- Start server: bin/rails server
- App URL: http://localhost:3000

2) Common tasks
- Console: bin/rails console
- Routes overview: bin/rails routes
- Task list: bin/rake -T
- Credentials: bin/rails credentials:edit
- Generate scaffolding: bin/rails generate <generator> <name>

3) Database
- Use migrations for schema changes: bin/rails generate migration <Name>
- Apply migrations: bin/rails db:migrate
- Rollback last migration: bin/rails db:rollback STEP=1
- Test DB lifecycle is managed by Rails; use db:test:prepare only if necessary.

4) Testing
- Run the whole test suite: bin/rails test
- Run model/controller tests only: bin/rails test test/models test/controllers
- Run a single file: bin/rails test test/models/user_test.rb
- Run a single test by name: bin/rails test TEST=test/models/user_test.rb TESTOPTS="--name test_does_something"
- System tests (Capybara + Selenium) require a browser; ensure Chrome/Chromedriver are available.

5) Linting and formatting
- Run StandardRB: bundle exec standardrb
- Auto-fix where possible: bundle exec standardrb --fix
- CI should fail on style violations.

6) Security checks
- Audit gems: bundle exec bundler-audit update && bundle exec bundler-audit check --ignore CVE-XXXX-XXXX
- Static analysis: bundle exec brakeman -q -w2

7) Assets and JavaScript
- Importmap is used (no bundler like Webpack). To pin a new package: bin/rails importmap:pin <pkg>
- Stimulus controllers live in app/javascript/controllers
- Turbo is enabled by default; prefer progressive enhancement.
- Propshaft serves assets; place images under app/assets/images and stylesheets under app/assets/stylesheets

8) Background jobs, caching, cable
- solid_queue: background jobs. Check configuration in config and ensure a worker is running in production.
- solid_cache: cache store backed by DB; verify cache tables exist after migrations.
- solid_cable: Action Cable over DB; ensure proper process in production to handle websockets.

9) Deployment
- Dockerfile is provided for containerization.
- Kamal is included; see kamal docs for setup. Typical flow: bundle exec kamal setup then bundle exec kamal deploy
- Ensure environment variables (DATABASE_URL, RAILS_MASTER_KEY, etc.) are configured in the target environment.

10) Coding conventions
- Follow StandardRB for Ruby style.
- Prefer Rails conventions (RESTful controllers, skinny controllers, fat models, service objects as needed).
- Strong Parameters in controllers; avoid mass-assignment vulnerabilities.
- Use i18n for user-facing strings (see config/locales).
- Avoid N+1 queries; use includes where needed.
- Keep business logic out of views and helpers unless presentational.

11) Git and PR workflow
- Use feature branches: feat/..., fix/..., chore/...
- Commit messages: Conventional style is encouraged (e.g., feat: add orders export)
- Open PRs small and focused; include tests and screenshots for UI changes.
- CI should run: lint (standardrb), tests, security scans (optional).

12) Environmental configuration
- Use Rails credentials for secrets.
- For local overrides, use .env and dotenv-rails if added; otherwise configure ENV in shell.
- Time zone and locale defaults should be set in application config if needed.

13) Observability and logs
- Rails logs are in log/*. For development, use bin/rails server logs. Configure log levels via environment.
- For background workers (solid_queue), ensure separate process logs in production.

14) How Junie should contribute
- Make minimal, well-scoped changes aligned with the issue description.
- Prefer small commits and clear messages.
- Update or add tests for any behavior changes.
- Keep tooling consistent: use bin/rails, bundle exec where applicable.
- Before changing public API or data model, discuss or open a proposal PR.

15) Quick command reference
- Setup: bundle install && bin/rails db:prepare
- Start: bin/rails s
- Tests: bin/rails test
- Lint: bundle exec standardrb --fix
- Security: bundler-audit, brakeman
- Migrate: bin/rails db:migrate
- Routes: bin/rails routes
- Console: bin/rails c

16) Product and roadmap
- Keep a lightweight product doc at .junie/product.md that tracks:
  - Product overview and target users
  - Current feature list (with brief descriptions and status)
  - Roadmap using Now / Next / Later buckets
  - Decisions log for key product choices
- Workflow
  - For any user-facing change, update .junie/product.md in the same PR (or include a follow-up task).
  - Link issues/PRs next to features or roadmap items.
  - Junie should consult this file for context before implementing features.
- Quick links
  - Product doc: .junie/product.md

17) UI and design direction
- Default approach: raw HTML templates with minimal CSS. Prefer semantic HTML and Flexbox utilities from application.css. Keep components simple and composable. 
- Mobile-first: design and test primarily on small screens. Enhance progressively for larger viewports.
- Utilities available: container, p-* spacing, fs-* type scale, flex, items-center, justify-*, gap-*. Add only when duplication emerges.
- No CSS frameworks by default. Avoid heavy dependencies; use Propshaft to serve plain CSS.

Notes
- This file is a living document. Update it when dependencies or workflows change.
