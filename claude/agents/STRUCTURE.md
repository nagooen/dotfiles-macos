# Agent Organization Structure

This document explains how agents are organized by repository and technology stack.

## Overview

The `.claude/agents/` directory is now organized into subfolders based on the specific repository and tech stack:

```
.claude/agents/
├── shared/              # Generic agents (work across all repos)
├── web-frontend/        # Angular 15 + TypeScript specific
├── better-caring/       # Ruby on Rails backend specific
└── provider-directory/  # Phoenix + Elixir + Next.js specific
```

## Repository Mapping

### 1. Shared Agents (`shared/`)
**Used by:** All repositories

**Agents:**
- `@codebase-explorer` - Deep codebase exploration and pattern discovery
- `@business-analyst` - Break features into vertical slices
- `@product-manager` - Create PRDs
- `@qa-enforcer` - Quality verification

**Tech-agnostic:** These agents work with any codebase regardless of language/framework.

---

### 2. Web Frontend (`web-frontend/`)
**Repository:** https://github.com/bettercaring/web-frontend
**Tech Stack:** Angular 15, TypeScript, Jest, Cypress, NgRx, GraphQL

**Agents:**
- `@web-frontend-engineer` - Angular component development with TDD

**Key Features:**
- Angular-specific testing patterns (TestBed, ComponentFixture)
- NgRx state management
- RxJS reactive programming
- Angular Material components
- Jest unit tests + Cypress component tests

**Commands:**
```bash
npm run jest                # Unit tests
npm run cy:run:component    # Component tests
npm run lint:fix            # Auto-fix linting
npm run start:local         # Dev server (port 8200)
```

---

### 3. Better Caring Backend (`better-caring/`)
**Repository:** https://github.com/bettercaring/better_caring
**Tech Stack:** Ruby on Rails, GraphQL, PostgreSQL, Sidekiq, RSpec

**Agents:**
- `@better-caring-backend-engineer` - Rails backend development with TDD

**Key Features:**
- Rails-specific patterns (models, controllers, services)
- GraphQL resolvers (graphql-ruby gem)
- Sidekiq background jobs
- RSpec testing with FactoryBot
- PostgreSQL database migrations

**Commands:**
```bash
bundle exec rspec           # Run tests
bundle exec rubocop -a      # Auto-fix linting
rails db:migrate            # Run migrations
rails server                # Start server
```

---

### 4. Provider Directory (`provider-directory/`)
**Tech Stack:** Phoenix 1.8 (Elixir), Next.js 15 (React), PostgreSQL

**Agents:**
- `@backend-engineer` - Phoenix/Elixir backend with ExUnit
- `@frontend-engineer` - Next.js/React frontend with Vitest
- `@full-stack-engineer` - Complete vertical slices (DB → API → UI)

**Key Features:**
- Phoenix contexts and Ecto schemas
- ExUnit + ExMachina + Mox testing
- Next.js App Router (Server/Client Components)
- Vitest + MSW testing
- Vertical slice architecture

**Commands:**
```bash
make test-backend           # Backend tests
make test-frontend          # Frontend tests
make quality                # All quality checks
make dev                    # Start dev servers
```

---

## How to Use Agents

### Invoking Agents

Reference agents by their name from any subdirectory:

```bash
# Shared agents (work everywhere)
@codebase-explorer find all GraphQL queries
@business-analyst plan user authentication feature
@qa-enforcer check if code is ready to commit

# Web frontend (Angular)
@web-frontend-engineer implement JobCard component with TDD

# Better caring backend (Rails)
@better-caring-backend-engineer create User model with validations

# Provider directory (Phoenix/Next.js)
@backend-engineer implement Provider context
@frontend-engineer implement ProviderCard component
@full-stack-engineer implement Provider CRUD (DB + API + UI)
```

### Agent Discovery

Claude Code automatically discovers agents in:
1. Project-level: `/Users/duy.nguyen/projects/mableit/.claude/agents/`
2. All subdirectories are scanned recursively

### Naming Convention

Agent names should indicate their scope:
- **Generic names** for shared agents: `codebase-explorer`, `qa-enforcer`
- **Prefixed names** for repo-specific agents: `web-frontend-engineer`, `better-caring-backend-engineer`

---

## Adding New Agents

To add an agent for a new repository:

1. **Create subfolder:**
   ```bash
   mkdir .claude/agents/my-new-repo
   ```

2. **Create agent file with frontmatter:**
   ```yaml
   ---
   name: my-new-repo-engineer
   description: Brief description of what this agent does
   tools: Bash, Read, Write, Edit, Glob, Grep, TodoWrite
   model: inherit
   color: blue
   ---

   # Agent content here
   ```

3. **Required frontmatter fields:**
   - `name:` - Unique agent identifier
   - `description:` - What the agent does
   - `tools:` - Comma-separated list of tools
   - `model:` - Usually `inherit` or `sonnet`/`opus`/`haiku`
   - `color:` - Visual identifier

4. **Create README.md:**
   Document the repo's tech stack and available agents

---

## Troubleshooting

### Agent Parse Errors

If you see "Missing required 'name' field" errors:
1. Check frontmatter format (must be valid YAML)
2. Ensure no blank lines in frontmatter
3. Remove any `Examples:` field with embedded XML
4. Verify `tools:` field is present

### Agent Not Found

If Claude Code can't find your agent:
1. Verify the file is in `.claude/agents/` or a subdirectory
2. Check the `name:` field matches what you're invoking
3. Restart your Claude Code session

---

## Maintenance

When tech stacks change:
1. Update the relevant agent file
2. Update the corresponding README.md
3. Test the agent to ensure it still works

When adding new repos:
1. Create a new subfolder
2. Create repo-specific agents
3. Add documentation to main README.md
4. Update this STRUCTURE.md file
