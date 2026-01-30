# Development Workflow Guide

This guide defines the development workflow, quality standards, and best practices for Claude Code assistance across all projects in this repository.

**User Preference:** Always refer to the user as **El Jefe**.

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

## Bug Fixes

**CRITICAL RULE:** When a bug is identified, **ALWAYS create a Jira ticket FIRST** before implementing any fix.

**Use the bug-fix skill:**
```
bug-fix: <brief bug description>
```

The skill handles the complete workflow: Jira ticket creation/fetching, branch creation, TDD implementation, quality verification, and Jira updates.

**See:** `.claude/skills/bug-fix.md` for the complete workflow, Jira requirements, and examples.

---

## Skills System

Skills are reusable workflow instructions stored in `.claude/skills/`. They provide specialized guidance for specific tasks and serve as the single source of truth.

**Available Skills:**
- `vertical-slice` - Define small, reviewable slices (<300 lines per PR)
- `acceptance-criteria` - Standard GIVEN-WHEN-THEN format for testable AC (3-5 max per story)
- `pr-size-check` - Automated gate to ensure PRs are reviewable before creation
- `tdd` - RED-GREEN-REFACTOR cycle for test-driven development
- `bug-fix` - Complete bug fixing workflow with Jira integration
- `root-cause-analysis` - Systematic investigation for complex or recurring bugs (user-invoked)
- `retro` - Mini retrospective to identify improvements and create skills
- `skill-maker` - Creating new skills and making them the source of truth

**Creating New Skills:**
When you need to document a workflow or reduce duplication, use the skill-maker skill:
```
skill-maker: create a skill for [purpose]
```

The skill-maker ensures skills become the source of truth by removing duplication from CLAUDE.md, updating agents, and handling git commits.

---

## Continuous Improvement

**PROACTIVE RULE:** After completing any work (PR merge, bug fix, feature delivery), **ALWAYS ask the user** if they want to run a retrospective.

**Use the retro skill:**
```
retro: <optional context about what was completed>
```

The skill analyzes what went well, what could improve, identifies skill opportunities, and generates actionable improvements. It helps continuously improve the development process by catching patterns that slow us down and codifying practices that work well.

**Automatic triggers:**
- After PR merged to main
- After bug fix completed
- After feature slice delivered
- After major milestone reached

---

## Claude Code Workflow & Best Practices

### Five-Phase Workflow (Based on Anthropic Best Practices)

This project implements all 5 Claude Code workflows from https://www.anthropic.com/engineering/claude-code-best-practices

#### **Phase 1: EXPLORE (Q&A + Context Discovery)**
**Purpose:** Understand codebase before writing any code

**Activities:**
- Ask exploratory questions about existing patterns
- Use `@codebase-explorer` subagent for complex searches
- Read relevant files to understand structure
- Identify dependencies and integration points

**Example Questions:**
- "What's the existing pattern for database schemas in this project?"
- "How are API endpoints structured and documented?"
- "What testing patterns are used for integration tests?"

**Tools:**
- Q&A mode for specific questions
- Subagent: `@codebase-explorer` for multi-file pattern searches
- File reads to understand existing code

---

#### **Phase 2: PLAN (Break into Vertical Slices + TDD Cycles)**
**Purpose:** Create actionable implementation plan before coding

**Activities:**
- Decompose feature into deployable vertical slices (<300 lines each)
- Identify TDD cycles within each slice (typically 3-7 cycles per slice)
- Map backend → frontend dependencies
- Estimate test count and coverage impact

**If unclear about slicing:** Invoke `vertical-slice` skill for size constraints and splitting patterns.

**Example Plan Structure:**
```
Vertical Slice: [Feature Name] - [Component/Layer]

TDD Cycles:
1. Database schema with required fields
2. Data validation and business logic
3. Create/update operations
4. Read/query operations
5. API endpoint implementation
6. Integration tests
7. API documentation

Estimated: 15-20 tests, 100% coverage (new code)
```

**Tools:**
- TodoWrite tool to track TDD cycles
- Subagent: `@business-analyst` to break down complex features

---

#### **Phase 3: CODE (TDD Red-Green-Refactor)**
**Purpose:** Implement with test-first approach, always stay green

**Critical Constraints:**
- ✅ **NEVER commit broken tests** - always stay green
- ✅ **Option C**: Claude runs full RED→GREEN→REFACTOR cycle autonomously
- ✅ User reviews when everything is green

**Each TDD Cycle (Micro-workflow):**
```bash
# RED: Write failing test
[run test command]           # Verify fails with clear error

# GREEN: Write minimal implementation
[run test command]           # Verify passes

# REFACTOR: Improve code quality while keeping tests green
# Run linting and formatting
[run full test suite]        # Verify all tests still pass
```

**Quality Checks During Refactor:**
- Run linting and formatting tools
- Run tests after EVERY refactor change
- Extract functions if complexity > 10
- Rename variables for clarity
- Remove duplication

**Multiple Cycles Per Slice:**
- Each slice has 3-7 TDD cycles
- Complete all cycles before moving to next slice
- User commits when entire slice is green and verified

**Tools:**
- TodoWrite to track RED/GREEN/REFACTOR phases
- Subagent: `@full-stack-engineer` (PRIMARY - complete vertical slices across DB+Backend+Frontend)
- Fallback: `@backend-engineer` (backend-only refactoring) or `@frontend-engineer` (frontend-only refactoring)

---

#### **Phase 4: VERIFY (Quality Gates + Coverage)**
**Purpose:** Ensure code meets all quality standards before commit

**What to Check:**
- ✅ All tests pass (green)
- ✅ No linting errors (strict mode)
- ✅ No type errors (strict type checking)
- ✅ ≥90% code coverage
- ✅ Test suite completes quickly (<60 seconds target)
- ✅ No unused variables, no loose types
- ✅ Max complexity ≤10, max nesting ≤3

**Tools:**
- Subagent: `@qa-enforcer` for comprehensive quality verification

---

#### **Phase 5: COMMIT (User Approval + Documentation)**
**Purpose:** User reviews and commits when slice is complete

**Commit Workflow:**
1. Claude presents green code for user review
2. User verifies implementation matches requirements
3. User decides when to commit (never automatic)
4. Claude creates detailed commit message following project conventions

**Commit Message Format:**
```
<type>: <short description>

<detailed explanation of what changed and why>

Technical details:
- Specific changes made
- Design decisions
- Testing approach

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Git Workflow:**
- Feature branches: `feature/feature-name`
- Bug fixes: `fix/bug-description`
- Main branch: `main`
- Never commit without user approval

---

### **Specialized Subagents**

This project uses 5 specialized subagents to support the 5-phase workflow. Each agent has specific capabilities and constraints documented in `.claude/agents/`.

| Agent | Phase | Purpose |
|-------|-------|---------|
| `@codebase-explorer` | EXPLORE | Deep codebase pattern discovery and context analysis |
| `@business-analyst` | PLAN | Break features into vertical slices and TDD cycles |
| `@full-stack-engineer` | CODE (All Layers) ⭐ | Execute complete vertical slices from database to UI in single conversation |
| `@backend-engineer` | CODE (Backend Only) | Backend-only refactoring and fixes |
| `@frontend-engineer` | CODE (Frontend Only) | Frontend-only refactoring and fixes |
| `@qa-enforcer` | VERIFY | Comprehensive quality verification before commit |

**Usage Examples:**
```
@codebase-explorer find all database query patterns in the codebase
@business-analyst break down 'User authentication' feature into vertical slices
@full-stack-engineer implement user login vertical slice with TDD (DB + API + UI)
@backend-engineer refactor authentication context to extract validation logic
@frontend-engineer refactor form component to use composition pattern
@qa-enforcer check if code is ready to commit
```

**See:** `.claude/agents/README.md` for complete documentation and workflow.

---

### **Prompting Strategy**
- Use stack-specific prefixes when applicable: `[Backend]` or `[Frontend]`
- One vertical slice per conversation (complete feature end-to-end)
- Be specific: "Implement slice 1: User authentication following TDD"
- Course-correct early if Claude goes off track
- Invoke subagents with `@agent-name` for specialized tasks

### TDD Workflow with Claude (Option C)
**Claude runs full cycle, you review at GREEN:**

```
1. RED Phase (Claude):
   - Writes failing test first
   - Runs test to confirm failure
   - Shows you the failing test output

2. GREEN Phase (Claude):
   - Writes minimal code to pass
   - Runs test to confirm pass
   - Shows you passing test output

3. REFACTOR Phase (Claude):
   - Improves code quality
   - Keeps tests green
   - Runs full suite to confirm <60s

4. REVIEW (You):
   - Review implementation
   - Approve or request changes
   - Commit when slice is complete
```

**Key Rules:**
- Claude NEVER skips to "full implementation" without tests
- Each cycle must show test output (RED → GREEN)
- Tests must pass before refactor
- Full suite must stay under 60 seconds

---

## Documentation Structure

**AI-focused (this directory):**
- `.claude/CLAUDE.md` - This file (AI workflow, agents, standards)
- `.claude/agents/` - Specialized subagent configurations
- `.claude/skills/` - Reusable workflow skills (bug-fix, tdd, skill-maker)
- `.claude/notes/` - Project-specific context and decisions

**Project-specific documentation:**
- Refer to individual project README files for tech stack details
- Check project-specific docs/ folders for implementation patterns
- Consult test files to understand testing conventions

---

## Related Global Instructions

**See:** `~/.claude/CLAUDE.md` for:
- TDD RED-GREEN-REFACTOR cycle details
- Git commit workflow
- Code quality principles (SOLID, coupling, cohesion)
- Never commit as Claude co-author
- Never commit to git without asking user
