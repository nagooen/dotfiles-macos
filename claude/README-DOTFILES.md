# Claude Code Configuration

This directory contains AI-powered development workflow configurations for Claude Code CLI.

## What is Claude Code?

Claude Code is an AI-powered CLI assistant that helps with software development tasks. This configuration provides specialized agents, reusable workflow patterns (skills), and custom commands to enhance your development experience.

## Installation

The Claude configuration is installed to `~/.claude/` on your system. This makes it available globally for all your projects.

```bash
# Install using the dotfiles install script
./install.sh
# Then select option 5 (Claude Code configurations only)
# Or option 1 (All) to install everything
```

## What's Included

### 📁 Agents (`~/.claude/agents/`)

Specialized AI agents for different development workflows:

- **@codebase-explorer** - Deep code exploration and pattern discovery
- **@business-analyst** - Feature decomposition into vertical slices
- **@full-stack-engineer** - Complete vertical slice implementation (DB + API + UI)
- **@backend-engineer** - Backend-only refactoring and implementation
- **@frontend-engineer** - Frontend-only development
- **@qa-enforcer** - Quality verification before commits
- **@product-manager** - PRD creation with guided Q&A

Plus project-specific agents for different services.

### 🎯 Skills (`~/.claude/skills/`)

Reusable workflow patterns:

- **bug-fix** - Complete bug fixing workflow with Jira integration
- **tdd** - RED-GREEN-REFACTOR test-driven development cycle
- **vertical-slice** - Feature slicing patterns (<300 lines per PR)
- **acceptance-criteria** - GIVEN-WHEN-THEN format for testable AC
- **pr-size-check** - Automated gate to ensure reviewable PRs
- **retro** - Mini retrospective for continuous improvement
- **skill-maker** - Creating new skills and making them source of truth
- **root-cause-analysis** - Systematic investigation for complex bugs

### ⚙️ Commands (`~/.claude/commands/`)

Custom CLI commands for workflows (if available).

### 📝 Notes & Plans (`~/.claude/notes/`, `~/.claude/plans/`)

Project-specific context and planning documents.

## Usage

### Using Agents

Invoke agents with the `@agent-name` prefix:

```bash
# Explore codebase patterns
@codebase-explorer find all database query patterns

# Break down a feature
@business-analyst break down 'User authentication' feature into vertical slices

# Implement with TDD
@full-stack-engineer implement user login vertical slice with TDD

# Verify quality before commit
@qa-enforcer check if code is ready to commit
```

### Using Skills

Skills are invoked directly or referenced in workflows:

```bash
# Use bug-fix skill for systematic bug fixing
bug-fix: authentication token not refreshing

# Run retrospective after completing work
retro: post-feature-implementation

# Create a new skill
skill-maker: create a skill for API documentation workflow
```

## Five-Phase Development Workflow

This configuration implements a structured 5-phase workflow:

1. **EXPLORE** - Understand codebase before coding (Q&A + Context Discovery)
2. **PLAN** - Break into vertical slices with TDD cycles
3. **CODE** - TDD RED-GREEN-REFACTOR implementation
4. **VERIFY** - Quality gates (tests, linting, coverage)
5. **COMMIT** - User approval + documentation

## Key Principles

- **Test-Driven Development (TDD)**: RED → GREEN → REFACTOR cycle
- **Vertical Slices**: Small, deployable features (<300 lines per PR)
- **Always Green**: Never commit broken tests
- **Quality First**: Linting, type checking, ≥90% coverage
- **User Approval**: User reviews and commits (never automatic)

## Customization

You can customize this configuration by:

1. **Adding New Agents**: Create agent definition files in `agents/`
2. **Creating Skills**: Use the `skill-maker` skill to document workflows
3. **Project Context**: Add notes in `notes/` for project-specific information
4. **Commands**: Add custom commands in `commands/` directory

## Documentation

For complete documentation, see:

- `CLAUDE.md` - Main workflow guide and best practices
- `CONFIGURATION-GUIDE.md` - Detailed configuration instructions
- `agents/README.md` - Agent documentation and usage
- `agents/STRUCTURE.md` - Agent structure guidelines

## Continuous Improvement

After completing work, run a retrospective:

```bash
retro: <context about what was completed>
```

This helps identify:
- What went well
- What could improve
- Patterns to codify as skills
- Process improvements

## Support

For more information about Claude Code:
- Visit: https://claude.com/claude-code
- GitHub: https://github.com/anthropics/claude-code

---

This configuration is designed to make you a more productive developer by combining AI assistance with proven engineering practices.
