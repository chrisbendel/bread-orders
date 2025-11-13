# Product doc

This file captures lightweight product context for the bread-orders app. Keep it short, current, and useful for day-to-day work.

## Overview
- One-liner: TODO
- Target users: TODO
- Value proposition: TODO
- Success metrics: TODO

## Principles
- Keep flows simple; optimize for recurring tasks.
- Prefer explicitness over magic in UI copy and flows.
- Ship small, iterate quickly.

## Current features
Maintain a concise list of shipped or in-progress features. Add links to code, PRs, and issues. Use the template below.

Template
- Feature: NAME
  - Status: planned | in-progress | shipped | deprecated
  - Summary: 1-2 lines
  - Owner: OWNER
  - Links: [Issue #], [PR], [Docs]

Initial list
- Feature: Orders CRUD
  - Status: planned
  - Summary: Basic models, forms, and list pages for bread orders.
  - Owner: YOU
  - Links:

## Roadmap
Use Now / Next / Later buckets; keep items small. Include an indicative date if helpful.

- Now
  - Orders CRUD MVP
  - Basic authentication (if needed)

- Next
  - Customer profiles
  - Order fulfillment workflow (statuses, assignments)

- Later
  - Payments integration
  - Reporting/export

## Decisions log
Record key decisions with rationale. One line each, link to PR/issue.

- 2025-11-13 Decision: Adopt mobile-first UI with raw HTML + minimal CSS utilities (Flexbox) — Rationale: Optimize for phone usage (~99% users), reduce complexity and dependencies, focus on speed and clarity — Links: #

## Maintenance workflow
- For any user-facing change, update this file in the same PR.
- When adding a feature, add it to "Current features" and adjust the Roadmap.
- If a decision is made, add an entry to the Decisions log.
