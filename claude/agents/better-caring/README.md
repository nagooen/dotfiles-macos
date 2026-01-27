# Better Caring Backend Agents

Agents specific to the `better_caring` repository (Ruby on Rails monolith).

## Tech Stack
- **Ruby on Rails** - Core monolithic backend
- **GraphQL** - Primary API (graphql-ruby gem)
- **PostgreSQL** - Database
- **Sidekiq** - Background jobs
- **RSpec** - Testing framework
- **FactoryBot** - Test data

## Available Agents

### `@better-caring-backend-engineer`
Execute full TDD RED-GREEN-REFACTOR cycles for Rails backend.

**Use when:**
- Implementing Rails models, controllers, or services
- Creating GraphQL resolvers and types
- Building Sidekiq background jobs
- Database migrations
- Need test-first discipline for Ruby/Rails

**Example:**
```
@better-caring-backend-engineer implement User model with validations
@better-caring-backend-engineer create JobResolver for GraphQL
@better-caring-backend-engineer add Sidekiq job for email notifications
```

## Development Commands

```bash
# Testing
bundle exec rspec               # Run all tests
bundle exec rspec spec/path     # Specific test

# Database
rails db:migrate                # Run migrations
rails db:rollback               # Rollback

# Quality
bundle exec rubocop             # Linting
bundle exec rubocop -a          # Auto-fix

# Development
rails server                    # Start server
rails console                   # Console
```

## Related Documentation
- Main project docs: `/Users/duy.nguyen/projects/mableit/better_caring/README.md`
- Repository: https://github.com/bettercaring/better_caring
