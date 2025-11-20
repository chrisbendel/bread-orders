# Bread Orders — Quickstart

## Setup

- bundle install
- bin/rails db:prepare

## Run

- bin/rails s # http://localhost:3000

## Auth (passwordless)

- Visit / and enter your email to sign in with OTP

## Tests

- bin/rails test # all tests
- bin/rails test test/models # models only

## Lint / Format

- bundle exec standardrb
- bundle exec standardrb --fix

## Security checks

- bundle exec bundler-audit update && bundle exec bundler-audit check
- bundle exec brakeman -q -w2

## Useful Rails commands

- bin/rails routes
- bin/rails console
- bin/rake -T

## Notes

- Emails use test delivery in test env; in dev/prod set host via config.action_mailer.default_url_options
- Public owner pages are at /:username
- Background jobs/cache/cable use solid_queue/solid_cache/solid_cable (DB-backed)

## Troubleshooting

- If tests complain about missing DB: run bin/rails db:prepare

## Deployments

- `fly deploy` to deploy
- `fly launch` to create a new instance
