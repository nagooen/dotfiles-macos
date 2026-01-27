# Claude Code Subagents

This directory contains specialized subagent definitions organized by repository and tech stack.

## Directory Structure

```
.claude/agents/
├── shared/              # Generic agents (work across all repos)
│   ├── codebase-explorer.md
│   ├── business-analyst.md
│   ├── product-manager.md
│   └── qa-enforcer.md
├── web-frontend/        # Angular 15 + TypeScript specific
│   └── frontend-engineer.md
├── better-caring/       # Ruby on Rails backend specific
│   └── backend-engineer.md
└── provider-directory/  # Phoenix + Elixir + Next.js specific
    ├── backend-engineer.md
    ├── frontend-engineer.md
    └── full-stack-engineer.md
```

## Available Agents

## Shared Agents (All Repos)

### 0. `@product-manager` (PRE-PLANNING Phase)
**Purpose:** Create comprehensive Product Requirements Documents (PRDs) for new features

**Use when:**
- Starting a brand new feature from scratch
- Need to gather and structure requirements
- Want to create implementation-ready specifications
- Working with stakeholders to define scope

**Example:**
```
@product-manager create PRD for user profile feature
@product-manager document requirements for notification system
```

**Output:** Detailed PRD suitable for junior developers to implement, including:
- Functional requirements with acceptance criteria
- API contracts (request/response schemas)
- UI/UX specifications with validation rules
- Test scenarios (backend + frontend)
- TDD breakdown (RED-GREEN-REFACTOR cycles)
- Edge cases and error scenarios

**Output Location:** `docs/prds/prd-[feature-name].md`

**Suggested next agent:** `@codebase-explorer` or `@business-analyst`

---

### 1. `@codebase-explorer` (EXPLORE Phase)
**Purpose:** Deep codebase exploration and pattern discovery

**Use when:**
- Need to understand existing patterns
- Finding where to add new functionality
- Discovering integration points
- Learning how existing features work

**Example:**
```
@codebase-explorer find all Phoenix contexts that use Ecto.Repo
@codebase-explorer how are API endpoints structured?
```

**Input:** None (exploration is discovery-focused)

**Output:** Analysis report with findings, patterns, and recommendations

**Suggested next agent:** `@business-analyst`

---

### 2. `@business-analyst` (PLAN Phase)
**Purpose:** Break down features into vertical slices and TDD cycles

**Use when:**
- Starting a new feature
- Need to decompose complex requirements
- Planning multi-stack work (backend + frontend)
- Estimating test coverage and duration

**Example:**
```
@business-analyst break down 'Provider creates entry to be searched' feature
@business-analyst plan TDD cycles for provider CRUD API with OpenAPI
```

**Input:** `docs/prds/prd-[feature-name].md` (from @product-manager) OR verbal feature description

**Output Location:** `docs/slices/slice-N-plan.md`

**Output:** Implementation plan with:
- Vertical slices (independently deployable)
- TDD cycles (3-7 per slice)
- Backend → Frontend dependency mapping
- Test count and coverage estimates
- Duration estimates

**Suggested next agent:** `@backend-engineer` or `@frontend-engineer`

---

### 3a. `@backend-engineer` (CODE Phase - Backend)
**Purpose:** Execute full RED-GREEN-REFACTOR TDD cycles for Phoenix/Elixir backend

**Use when:**
- Implementing Phoenix contexts (business logic)
- Creating Ecto schemas and changesets
- Building API controllers with OpenAPI specs
- Database migrations with zero-downtime strategy
- Need test-first discipline for Elixir

**Example:**
```
@backend-engineer implement Provider context with validations
@backend-engineer create booking creation with overlap validation
```

**Input:** `docs/slices/slice-N-plan.md` (from @business-analyst)

**Output:**
- Elixir code (contexts, schemas, controllers, migrations)
- ExUnit tests
- Updated plan with completed checkboxes

**Suggested next agent:** `@qa-enforcer`

---

### 3b. `@frontend-engineer` (CODE Phase - Frontend)
**Purpose:** Execute full RED-GREEN-REFACTOR TDD cycles for Next.js/TypeScript frontend

**Use when:**
- Implementing frontend components (atoms, molecules, organisms)
- Creating Next.js pages or Server Actions
- Need test-first discipline for React
- Want automated quality checks for TypeScript

**Example:**
```
@frontend-engineer implement ProviderCard organism
@frontend-engineer create provider search form with validation
```

**Input:** `docs/slices/slice-N-plan.md` (from @business-analyst)

**Output:**
- React components (atoms, molecules, organisms, templates, pages)
- Vitest tests with MSW mocks
- Updated plan with completed checkboxes

**Suggested next agent:** `@qa-enforcer`

---

### 4. `@qa-enforcer` (VERIFY Phase)
**Purpose:** Comprehensive quality verification before commit

**Use when:**
- Before requesting user to commit
- After completing a vertical slice
- When unsure if code meets all standards
- Before creating a pull request

**Example:**
```
@qa-enforcer check if code is ready to commit
@qa-enforcer verify slice 1 meets all standards
```

**Input:** Completed code from @backend-engineer or @frontend-engineer

**Output:** Quality verification report with:
- Code quality status (format, lint, dialyzer, type-check)
- Test suite status (<60s requirement)
- Coverage gates (≥90%)
- Pre-commit hook compatibility
- Ready to Commit: YES/NO

**Suggested next agent:** None (user reviews and commits)

---

## Agent Workflow

```
┌─────────────────────────────────────────────────────────┐
│               Feature Request (Optional)                 │
│                                                          │
│               ┌────────────────────────┐                │
│               │   @product-manager     │                │
│               │   Create PRD           │                │
│               └────────────────────────┘                │
└─────────────────────────────────────────────────────────┘
                           │
                           ▼
              ┌────────────────────────┐
              │  @codebase-explorer    │
              │  Understand context    │
              └────────────────────────┘
                           │
                           ▼
              ┌────────────────────────┐
              │   @business-analyst    │
              │   Break into slices    │
              └────────────────────────┘
                           │
                           ▼
         ┌─────────────────┴─────────────────┐
         │                                    │
         ▼                                    ▼
┌────────────────────┐            ┌────────────────────┐
│ @backend-engineer  │            │ @frontend-engineer │
│  Backend cycles    │            │  Frontend cycles   │
│ (Phoenix/Elixir)   │            │  (Next.js/React)   │
└────────────────────┘            └────────────────────┘
         │                                    │
         └─────────────────┬─────────────────┘
                           ▼
              ┌────────────────────────┐
              │    @qa-enforcer        │
              │   Verify standards     │
              └────────────────────────┘
                           │
                           ▼
              ┌────────────────────────┐
              │    User Reviews        │
              │    Commits Code        │
              └────────────────────────┘
```

---

## Ultrathink Policy

### Mandatory Ultrathink
**`@business-analyst`** - MUST use ultrathink (sequential-thinking MCP) for all planning tasks.

Planning is the highest-leverage phase. Deep reasoning ensures:
- ✅ Optimal feature decomposition
- ✅ Correct dependency sequencing
- ✅ Realistic time/coverage estimates
- ✅ Risk identification before coding starts

Poor planning → wasted CODE phase effort.

### Recommended Ultrathink
**`@codebase-explorer`** - Use ultrathink for complex/architectural searches:
- "How should multi-tenancy be implemented?"
- Pattern analysis across multiple contexts
- Synthesizing findings from many files

Skip ultrathink for simple searches:
- "Where is the User model?"
- "Find all API routes"

**`@backend-engineer` & `@frontend-engineer`** - Optional but recommended for:
- Complex algorithm implementations
- Tricky refactoring decisions
- Performance optimization strategies
- When stuck on test design

### No Ultrathink Needed
- **`@qa-enforcer`**: Mechanical check execution and reporting
- **`@product-manager`**: Interactive requirements gathering process

---

## Best Practices

### 1. Use Agents Sequentially
Follow the workflow: EXPLORE → PLAN → CODE → VERIFY → COMMIT

### 2. One Agent at a Time
Don't invoke multiple agents in a single prompt. Complete one phase before moving to next.

### 3. Agent Output as Input
Use output from one agent as input to the next:
- `@codebase-explorer` findings inform `@business-analyst`
- `@business-analyst` TDD cycles guide `@backend-engineer` or `@frontend-engineer`
- Engineer completion triggers `@qa-enforcer`

### 4. Iterate Within Phases
You can invoke the same agent multiple times:
- `@codebase-explorer` for different patterns
- `@backend-engineer` or `@frontend-engineer` for each TDD cycle (3-7 per slice)
- `@qa-enforcer` after each fix

### 5. Skip When Appropriate
Not every task needs all agents:
- Simple bug fix: Skip EXPLORE, go straight to TDD
- Documentation: Skip CODE, use Q&A mode
- Refactoring: Skip EXPLORE if context is known

---

## Color Legend

- **product-manager**: cyan (neutral, requirements)
- **codebase-explorer**: white (neutral, exploration)
- **business-analyst**: blue (planning, analysis)
- **backend-engineer**: magenta (Elixir/Phoenix purple)
- **frontend-engineer**: yellow (Next.js/JavaScript bright)
- **qa-enforcer**: green (testing, quality)

---

## Implementation Notes

These are **documentation-driven agents** - they define behavior patterns rather than executable code. When you invoke `@agent-name`, Claude Code will:

1. Read the agent definition from this directory
2. Adopt the agent's capabilities and constraints
3. Follow the agent's workflow and output format
4. Stay within the agent's scope

This approach provides:
- ✅ Consistent behavior across sessions
- ✅ Clear separation of concerns
- ✅ Easy to modify and extend
- ✅ Version controlled alongside code

---

## Future Enhancements

Potential additional agents:
- `@api-designer` - Design OpenAPI specs before implementation
- `@db-migrator` - Generate and verify Ecto migrations
- `@component-builder` - Build atomic design components with Storybook
- `@test-optimizer` - Identify slow tests and optimize for <60s
- `@security-auditor` - Check for security issues (SQL injection, XSS, etc.)

---

## Related Documentation

- Main workflow: `../.claude/CLAUDE.md` (Section: "Five-Phase Workflow")
- Frontend patterns: `../../docs/frontend-guide.md`
- Backend patterns: `../../docs/backend-guide.md`
- Testing conventions: `../../docs/testing-guide.md`
- Code quality standards: `../../docs/code-quality.md`
- API design standards: `../../docs/api-standards.md`
