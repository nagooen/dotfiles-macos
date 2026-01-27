# Web Frontend Agents

Agents specific to the `web-frontend` repository (Angular 15 + TypeScript).

## Tech Stack
- **Angular 15** with TypeScript 4.9.5
- **Jest** for unit testing
- **Cypress** for E2E and component testing
- **NgRx** for state management
- **Angular Material 15** for UI components
- **GraphQL** with Apollo Client

## Available Agents

### `@web-frontend-engineer`
Execute full TDD RED-GREEN-REFACTOR cycles for Angular components.

**Use when:**
- Implementing Angular components, directives, or pipes
- Creating services or NgRx state management
- Need test-first discipline for Angular development

**Example:**
```
@web-frontend-engineer implement JobCard component with TDD
@web-frontend-engineer create user profile service with RxJS
```

## Development Commands

```bash
# Testing
npm run jest                    # Run all unit tests
npm run jest:watch              # Watch mode
npm run cy:run:component        # Component tests

# Quality
npm run lint                    # ESLint
npm run lint:fix                # Auto-fix
npm run format:check            # Prettier

# Development
npm run start:local             # Local dev server
```

## Related Documentation
- Main project docs: `/Users/duy.nguyen/projects/mableit/web-frontend/CLAUDE.md`
- Repository: https://github.com/bettercaring/web-frontend
