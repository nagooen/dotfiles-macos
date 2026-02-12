# Global Claude Code Configuration

**User Preference:** Always refer to the user as **El Jefe**.

---

## AI Agent Workflow Rules

### Planning Before Implementation

**CRITICAL RULE:** NEVER start implementing code changes until the plan has been explicitly approved by the user. When asked to plan something, ONLY produce the plan document. Wait for explicit confirmation like "go ahead", "implement it", or "looks good" before writing any code. If unsure, ask: "Should I proceed with implementation?"

- NEVER start editing, creating, or deleting source files until the user explicitly approves a plan.
- When asked to review, summarise, or plan, provide ONLY the analysis/summary/plan first.
- Wait for explicit approval ("go ahead", "approved", "implement it") before making any code changes.
- Change only what is asked. Do not proactively fix, refactor, or improve surrounding code.

### PR Review Workflow

**PR Review Instructions:**
When asked to review a PR or pull PR comments:
- If asked to look at "my replies" or "my comments", focus on the USER's review comments, not the code diff
- Always summarize findings FIRST before proposing changes
- Ask before implementing fixes

**Standard Workflow:**
- When asked to review PR comments or summarise PR feedback:
  1. First provide ONLY a numbered summary grouped by: must-fix, suggestion, and nit.
  2. Wait for the user to confirm which items to address.
  3. Only then implement the agreed-upon fixes.
- Do NOT auto-commit or auto-push unless explicitly asked.

### Naming Conventions

**CRITICAL:** Always follow existing naming patterns in the codebase. Before renaming or creating components, check sibling files/folders for the full naming convention (e.g., `job-application-agreement-support-terms` not just `agreement-support-terms`). When the user provides a specific name, use it exactly — do not shorten or modify it.

- When creating or renaming components within a feature directory, use the FULL path-based prefix matching sibling components. Check existing sibling component selectors and file names for the naming pattern before proposing names.

### CSS/SCSS Conventions

**CRITICAL:** Use project CSS variables exactly as defined (e.g., `--grey-400` not `--color-grey-400`). Always verify variable names by checking the project's variables file before using them. When fixing styling issues, verify changes visually match the existing design system patterns.

- Always verify CSS variable names against the project's actual variable definitions before using them (e.g., check the source file for exact names — do NOT guess prefixes like `--color-grey-400` when the actual name is `--grey-400`).

### Codebase Navigation

- When a codebase has separate flows for different user roles (e.g., client-side vs worker-side), always confirm which side is relevant before proposing changes. Explore sibling directories to understand the boundary.

### Angular/TypeScript Patterns

**Data Access and Component Patterns:**
- Follow existing patterns in the codebase for data access (synchronous vs observable). Check how sibling components access the same service before choosing an approach.
- When working on wizard components, check the existing wizard form service pattern before implementing data flow.

### External Tools and MCP

**Atlassian/MCP Authentication:**
If an Atlassian MCP call returns a 401 error, immediately tell the user: "Your Atlassian auth token has expired. Please re-authenticate and let me know when ready." Do not retry repeatedly.

### Git Operations

**Best Practices:**
- Always GPG sign commits (never use `--no-gpg-sign` or `-c commit.gpgsign=false`)
- Before pushing, always pull/rebase first to avoid remote conflicts
- For interactive git commands, pipe 'yes' or use non-interactive flags to avoid EOF errors
- Never force push without explicit user permission

---

## Model Selection Strategy

**Goal:** Minimise token costs by using the appropriate model for task complexity.

### Model Tiers

| Model | Use For | Examples |
|-------|---------|----------|
| **Haiku** | Simple, mechanical tasks | File reads, grep searches, simple edits, running tests, git operations, formatting |
| **Sonnet** | Moderate complexity | Bug fixes, small features, code review, refactoring, writing tests |
| **Opus** | High complexity | Architecture decisions, complex features, multi-file refactors, planning, debugging subtle issues |

### When to Use Haiku (Fastest, Cheapest)

- Running bash commands (tests, builds, git)
- Reading files to gather context
- Simple search and replace edits
- Formatting or linting fixes
- Generating boilerplate code
- Straightforward Q&A about code

### When to Use Sonnet (Balanced)

- Implementing well-defined features
- Writing unit tests
- Code review with established patterns
- Refactoring within a single file
- Bug fixes with clear reproduction steps
- Documentation updates

### When to Use Opus (Most Capable)

- Architectural decisions and design
- Complex multi-file features
- Debugging non-obvious issues
- Planning and breaking down large tasks
- Security analysis
- Performance optimisation
- Anything requiring deep reasoning

### Task Agents Model Selection

When spawning Task agents, specify the model parameter:
- `model: "haiku"` for exploration and simple operations
- `model: "sonnet"` for implementation work
- `model: "opus"` only when complexity justifies it

---

This configuration uses the **Attain Plugin Marketplace** as the primary source for development workflows, skills, and agents.

---

## Configuration Architecture

### Primary: Attain Plugin Marketplace

The **attain-plugin-marketplace** provides a comprehensive plugin system with:

- **25+ Foundation Skills** - Code quality, architecture, testing, security
- **Specialized Agents** - Senior engineer, code quality guardian, review coordinator
- **Automated Commands** - `/start-ticket`, `/review-pr`, `/plan-feature`
- **Composition System** - Agents dynamically compose with skills based on context
- **Version Control** - Plugin update system with dependency management

**Installed Plugins:**
```
core@attain-plugin-marketplace                    # 25 foundation skills
developer-workflow@attain-plugin-marketplace      # Dev agents & commands
review-swarm@attain-plugin-marketplace            # Dynamic code review
planning-workflow@attain-plugin-marketplace       # Feature planning workflow
```

See `attain-plugin-marketplace/CLAUDE.md` for complete documentation.

### Supplemental: Global Skills (~/.claude/skills/)

Three supplemental skills are maintained at the global level for personal workflow optimization:

1. **retro** - Mini retrospective to identify improvements
2. **root-cause-analysis** - Systematic investigation for complex bugs
3. **terraform-research-patterns** - Terraform provider research patterns

**Note:** These skills have also been migrated to `attain-plugin-marketplace/core/skills/` for consistency.

---

## Available Resources

### Core Skills (via Plugin Marketplace)

**Development & Testing:**
- `tdd` - RED-GREEN-REFACTOR cycle (Foundation, Level 0)
- `bug-fix` - Complete bug fixing workflow with Jira (Workflow, Level 2)
- `clean-code` - Naming, functions, comments, DRY/KISS/YAGNI
- `vertical-slice` - Feature slicing patterns (<300 lines per PR)
- `acceptance-criteria` - GIVEN-WHEN-THEN format for testable AC
- `pr-size-check` - Ensure PRs are reviewable before creation

**Architecture & Design:**
- `solid-principles` - SRP, OCP, LSP, ISP, DIP analysis
- `hexagonal-architecture` - Ports & Adapters pattern
- `plan-simplifier` - Simplify over-engineered plans

**Code Quality & Review:**
- `bugs-edge-cases` - Common programming errors, edge cases
- `test-coverage` - Missing tests, weak assertions
- `security` - OWASP Top 10, authentication, injection attacks
- `performance` - N+1 queries, inefficient patterns
- `sre-concerns` - Fault tolerance, retries, circuit breakers

**Tech Stack Specifics:**
- `angular` - Angular conventions
- `elixir-phoenix` - Elixir/Phoenix patterns
- `react-native` - React Native conventions
- `ruby-rails` - Ruby on Rails with composition over metaprogramming
- `typescript` - TypeScript strict typing patterns
- `vite-react` - Vite + React with Atomic Design
- `oban-patterns` - Best practices for Oban background jobs
- `openapi-validation` - OpenAPI schema validation patterns

**Project Standards:**
- `sensible-defaults` - Org-wide engineering standards
- `quality-plan` - Front-load review concerns at ticket start
- `skill-maker` - Create new skills following quality standards

### Agents (via Plugin Marketplace)

**Development:**
- `@senior-clean-code-engineer` - Implement features with TDD + clean architecture
- `@code-quality-guardian` - Review code before commits (auto-detects tech stack)

**Planning:**
- `@product-manager` - PRD creation through guided Q&A
- `@architect` - Technical feasibility, ADRs, infrastructure planning
- `@test-strategist` - Test strategy and coverage targets
- `@epic-lead` - Synthesize PRD + architecture into vertical slices

**Review:**
- `@review-coordinator` - Orchestrate dynamic code review (1-10 agents based on complexity)
- `@qa-enforcer` - Execute focused code reviews with specific skill assignments

**Discovery:**
- `@codebase-explorer` - Deep pattern discovery and context analysis
- `@business-analyst` - Break features into slices and TDD cycles

### Commands (via Plugin Marketplace)

**Development Workflow:**
- `/start-ticket` - Complete workflow from Jira ticket to PR
- `/bug-fix` - Guided bug fix workflow with TDD

**Planning:**
- `/plan-feature` - PRD → Architecture + Test Strategy → Vertical Slices → Jira

**Review:**
- `/review-pr` - Dynamic parallel code review with 1-10 specialized agents

---

## Supplemental Global Skills

These skills are available globally for personal workflow needs:

### retro
**Purpose:** Mini retrospective to identify improvements and create skills

**When to use:**
- After PR merged to main
- After bug fix completed
- After feature slice delivered
- After major milestone reached

**Invocation:**
```
retro: [optional context about what was completed]
```

**What it does:**
- Reviews work completed in conversation
- Identifies pain points and successes
- Recommends skill opportunities
- Suggests user workflow improvements
- Creates skills via `skill-maker`

### root-cause-analysis
**Purpose:** Systematic investigation for complex or recurring bugs

**When to use:**
- Bug is complex with unclear cause
- Same type of bug has occurred before
- User explicitly requests RCA
- Bug has significant impact

**Invocation:**
```
root-cause-analysis: <bug description>
```

**What it does:**
- Gathers initial information
- Reproduces the bug
- Uses Five Whys methodology
- Documents root cause and prevention

### terraform-research-patterns
**Purpose:** Research Terraform provider attributes when docs are inaccessible

**When to use:**
- Terraform validation errors
- WebFetch fails on Terraform Registry
- Need to understand resource schema
- Converting API docs to Terraform config

**Invocation:**
```
terraform-research-patterns: help find [provider] [resource] [attribute]
```

**What it does:**
- Searches provider GitHub for schema
- Finds examples in provider repository
- Checks local codebase patterns
- Maps API documentation to Terraform HCL

---

## How This Works

### Configuration Hierarchy

1. **Plugin Marketplace** (Primary) - Comprehensive development system
2. **Global ~/.claude/** (Supplemental) - Personal workflow skills
3. **Organization .claude/** (Optional) - Org-specific agents and context
4. **Project .claude/** (Optional) - Project tech stack and permissions

### Skill Resolution

When a skill is invoked:
1. Check if skill exists in plugin marketplace (e.g., `core@attain-plugin-marketplace/skills/tdd`)
2. If not found, check global `~/.claude/skills/`
3. If not found, check organization `.claude/skills/`
4. If not found, report skill not found

### Agent Resolution

When an agent is invoked (e.g., `@senior-clean-code-engineer`):
1. Check if agent exists in plugin marketplace
2. If not found, check organization `.claude/agents/`
3. If not found, check global `~/.claude/agents/`
4. If not found, report agent not found

---

## Plugin Management

### Install Plugin

```bash
# Add marketplace (one-time)
/plugin marketplace add /path/to/attain-plugin-marketplace

# Install plugins
/plugin install core@attain-plugin-marketplace
/plugin install developer-workflow@attain-plugin-marketplace
/plugin install review-swarm@attain-plugin-marketplace
/plugin install planning-workflow@attain-plugin-marketplace
```

### List Installed Plugins

```bash
/plugin list
```

### Update Plugin

```bash
/plugin update core@attain-plugin-marketplace
```

---

## Benefits of This Architecture

✅ **Comprehensive** - 25+ skills + specialized agents vs 9 basic skills
✅ **Composition** - Agents dynamically compose with skills
✅ **Automation** - Commands like `/start-ticket` automate workflows
✅ **Tech Stack Support** - 6 framework-specific skills
✅ **Versioned** - Plugin update system with dependencies
✅ **Extensible** - Create new plugins for teams/orgs
✅ **Professional** - Industry-standard patterns (SOLID, clean code, TDD)

---

## Documentation

**Plugin Marketplace:**
- Main: `attain-plugin-marketplace/CLAUDE.md`
- Core Skills: `attain-plugin-marketplace/core/skills/README.md`
- Developer Workflow: `attain-plugin-marketplace/developer-workflow/README.md`
- Review Swarm: `attain-plugin-marketplace/review-swarm/CLAUDE.md`
- Planning Workflow: `attain-plugin-marketplace/planning-workflow/README.md`

**Global Config:**
- This file: `~/.claude/CLAUDE.md`
- Global README: `~/.claude/README.md`
- Global agents: `~/.claude/agents/README.md`

---

## Documentation Storage Convention

**IMPORTANT:** Plans are stored at the **user level** (`~/.claude/memory/plans/`) organised by project. This keeps plans accessible across sessions and separates them from repository code.

### Folder Structure (User-Level)

```
~/.claude/
├── memory/
│   └── plans/
│       ├── web-frontend/                    # Project-specific plans
│       │   ├── ES-50845-agreement-terms-implementation-plan-v2.md
│       │   ├── ES-51283-mobile-time-selector-fix.md
│       │   └── ES-51285-name-hours-fixes.md
│       ├── better-caring/                   # Another project
│       │   └── ES-xxxxx-*.md
│       ├── attain-plugin-marketplace/       # Plugin/tooling plans
│       │   └── plan-simplifier-analysis.md
│       └── global/                          # Non-project plans
│           ├── mcp-server-setup.md
│           └── skill-creation.md
├── settings.json                            # Global settings
└── CLAUDE.md                                # This file
```

### Storage Guidelines

**Plans (~/.claude/memory/plans/<project>/):**
- Format: `[TICKET-KEY]-[description].md` or `[descriptive-name].md`
- Created by: `/start-ticket` command or manual planning
- Purpose: Reference during implementation and PR review
- Lifecycle: Kept until no longer needed (manual cleanup)
- Access: `Read` tool with path `~/.claude/memory/plans/<project>/[filename].md`

**Project Context (repository .claude/notes/):**
- Format: `[topic].md` or `YYYY-MM-DD-[decision].md`
- Created by: Manual or agent-driven context capture
- Purpose: Project-specific context, decisions, patterns
- Lifecycle: Permanent - committed to git
- Access: `Read` tool with path `<repo>/.claude/notes/[filename].md`

**Retrospectives (repository .claude/retros/):**
- Format: `YYYY-MM-DD-[topic].md`
- Created by: `retro` skill after work completion
- Purpose: Document learnings and improvements
- Lifecycle: Permanent - committed to git for team reference

### Why User-Level Plans?

✅ **Persistence:** Plans survive branch switches and repo changes
✅ **Cross-Session:** Accessible across Claude Code sessions
✅ **Organisation:** Grouped by project for easy discovery
✅ **No Git Noise:** Plans don't clutter repository history
✅ **Privacy:** Personal working documents stay local

### Referencing Plans

When implementing a ticket, reference the saved plan:

```markdown
# Read the plan
Read: ~/.claude/memory/plans/web-frontend/ES-12345-implementation-plan.md

# Verify alignment
- Check: Am I following the approved approach?
- Check: Have I completed the quality checkpoints?
- Check: Have I implemented the planned test scenarios?
```

### Repository .claude/ Directory

Repository-level `.claude/` is still used for:
- `CLAUDE.md` - Project-specific coding guidelines
- `settings.local.json` - Project permissions
- `notes/` - Team-shared context (committed to git)
- `retros/` - Team retrospectives (committed to git)

**DO commit:**
- `.claude/notes/` - Project context
- `.claude/retros/` - Team learnings
- `.claude/CLAUDE.md` - Project guidance

---

## Beads Issue Tracking

**Beads** is a local-first issue tracking system used for personal task management during development.

### Critical Rule

**NEVER commit `.beads/` to remote branches.** Beads is for local tracking only.

### Setup (Per Repository)

```bash
# 1. Add to local git exclude (not .gitignore - keeps it personal)
echo ".beads/" >> .git/info/exclude

# 2. Configure sync branch (optional - for local backup)
bd config set sync-branch beads-sync

# 3. Set issue prefix
bd config set issue-prefix <project-name>
```

### Common Commands

```bash
bd create "Issue title" --type task     # Create issue
bd list                                  # List open issues
bd show <id>                             # View issue details
bd update <id> --status in_progress     # Update status
bd close <id>                            # Close issue
bd sync --full --no-push                 # Sync locally (never push)
```

### What NOT To Do

- ❌ `bd sync --full` (without `--no-push`) - pushes to remote
- ❌ `git add .beads/` - stages beads files
- ❌ Remove `.beads/` from `.git/info/exclude`

### Integration with Jira

Beads is for **personal task breakdown** during implementation. The source of truth for tickets remains Jira. Use beads to:
- Break down Jira tickets into smaller tasks
- Track personal progress
- Manage local TODO items

---

## Development Workflow

This is El Jefe's integrated workflow combining Attain plugins, Beads context management, and persistent plan storage.

### Overview

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  /start-ticket  │ ──► │  Beads Context  │ ──► │  Memory Plans   │
│  (Attain)       │     │  Management     │     │  (Persistent)   │
└─────────────────┘     └─────────────────┘     └─────────────────┘
      Jira               Local Tracking          ~/.claude/memory/
```

### Phase 1: Start Ticket (Attain Plugin)

Use `/start-ticket` to begin work on a Jira ticket:

```bash
/start-ticket ES-12345
```

This will:
1. Fetch ticket details from Jira
2. Generate an implementation plan
3. **APPROVAL GATE** - Wait for El Jefe's approval
4. Save plan to `~/.claude/memory/plans/<project>/ES-12345-*.md`

### Phase 2: Context Management (Beads)

Once the plan is approved, break down work into trackable beads:

```bash
# Create beads for each implementation task
bd create --title="Implement API endpoint" --type=task --priority=2
bd create --title="Add unit tests" --type=task --priority=2
bd create --title="Update documentation" --type=task --priority=3

# Set dependencies
bd dep add <tests-id> <api-id>  # Tests depend on API

# Start working
bd ready                         # See what's available
bd update <id> --status=in_progress
```

**Why Beads for Context:**
- Survives conversation compaction (`bd prime` recovers context)
- Tracks progress across multiple sessions
- Dependencies prevent working on blocked items
- Local-only - doesn't pollute git history

### Phase 3: Plan Updates (Memory Layer)

As implementation progresses, update the plan in the memory layer:

```bash
# Plans are stored here:
~/.claude/memory/plans/<project>/ES-12345-implementation-plan.md
```

**When to Update Plans:**
- Requirements clarified during implementation
- Technical approach changed
- New edge cases discovered
- Scope adjusted

**Plan Update Workflow:**
1. Read current plan: `Read ~/.claude/memory/plans/<project>/ES-12345-*.md`
2. Make updates to reflect reality
3. Continue implementation aligned with updated plan

### Phase 4: PR Created (Awaiting Review)

After PR is created, update beads with PR link but **DO NOT close**:

```bash
# Update beads with PR link (keep in_progress)
bd update <id> --notes="PR created: <PR_URL>"

# Export beads state
bd sync --flush-only
```

**IMPORTANT:** Do NOT close beads issues until the PR has been merged. The issue stays `in_progress` during code review.

### Phase 5: PR Merged (Completion)

Only close beads after PR is merged:

```bash
# Verify PR is merged first
gh pr view <PR_NUMBER> --json state

# If merged, close beads
bd close <id1> <id2> <id3> --reason="PR merged: <PR_URL>"

# Export final state
bd sync --flush-only

# Optional: Run retrospective
retro: completed ES-12345 implementation
```

### Workflow Commands Summary

| Phase | Tool | Command |
|-------|------|---------|
| Start | Attain | `/start-ticket ES-12345` |
| Plan | Memory | `Read ~/.claude/memory/plans/<project>/...` |
| Track | Beads | `bd create`, `bd ready`, `bd update` |
| Progress | Beads | `bd list --status=in_progress` |
| Update Plan | Memory | Edit plan file in memory layer |
| PR Created | Beads | `bd update <id> --notes="PR: <URL>"` |
| PR Merged | Beads | `bd close <ids>`, `bd sync --flush-only` |
| Review | Attain | `/review-pr` |

### Context Recovery

After conversation compaction or new session:

```bash
bd prime                    # Recover beads context (auto-runs via hooks)
bd ready                    # See available work
bd show <id>                # Get full context on a task
```

Then read the plan:
```
Read ~/.claude/memory/plans/<project>/ES-12345-implementation-plan.md
```

### Key Principles

1. **Jira is source of truth** for tickets - Attain fetches from there
2. **Beads is local context** - Never commit, survives compaction
3. **Memory layer is persistent plans** - User-level, cross-session
4. **Plans evolve** - Update as understanding improves

---

## Quickstart

**For development work:**
```bash
/start-ticket ES-12345
# Workflow: Jira fetch → plan generation → APPROVAL GATE → branch → implementation → PR
# Plan saved to: .claude/plans/ES-12345-implementation-plan.md (and optionally Jira)
```

**For code review:**
```bash
/review-pr
# Dynamically allocates 1-10 specialized QA agents based on PR complexity
```

**For feature planning:**
```bash
/plan-feature https://attainhealthtech.atlassian.net/browse/ES-12345
# Creates: PRD → ADRs + Test Plan → Vertical Slices → Jira Epic + Stories
```

**For retrospectives:**
```bash
retro: completed user authentication feature
# Analyzes work, identifies improvements, creates skills
```

---

## Changelog

**2026-01-30:**
- Added integrated Development Workflow section (Attain → Beads → Memory Plans)
- Documented full workflow phases: start ticket, context management, plan updates, completion

**2026-01-29:**
- Added Beads issue tracking guidelines (local-only, never commit to remote)
- Reorganised plans to `~/.claude/memory/plans/<project>/` structure
- Added "El Jefe" user preference

**2026-01-27:**
- Consolidated to plugin marketplace as primary system
- Added documentation storage convention (`.claude/` layer)
- Updated `/start-ticket` workflow with plan approval gate
- Plans stored in `.claude/plans/` for reference during implementation

**Plugin Marketplace:** `/Users/duy.nguyen/projects/mableit/attain-plugin-marketplace`
