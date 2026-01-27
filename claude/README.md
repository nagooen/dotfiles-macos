# Mable Organization Claude Configuration

This directory contains Claude Code configurations shared across all Mable projects.

## Quick Overview

```
~/.claude/                      # Global (user-level)
├── settings.json              # Plugin enablement
├── mcp.json                   # MCP server configurations
└── [runtime files]            # History, cache, etc.

/projects/mableit/.claude/     # Organization (shared across all projects)
├── CLAUDE.md                  # Development workflow guide
├── CONFIGURATION-GUIDE.md     # Complete configuration documentation
├── agents/                    # Reusable agents (5-phase workflow)
├── skills/                    # Reusable skills (bug-fix, tdd, etc.)
└── notes/                     # Organization context

/<project>/.claude/            # Project-specific
├── CLAUDE.md                  # Project-specific guidance
├── settings.local.json        # Project permissions
└── notes/                     # Project context
```

## Available Resources

### Agents (5-Phase Workflow)

Invoke with `@agent-name`:

- `@codebase-explorer` - Deep codebase pattern discovery and context analysis
- `@business-analyst` - Break features into vertical slices and TDD cycles
- `@full-stack-engineer` - Execute complete vertical slices (PRIMARY)
- `@backend-engineer` - Backend-only refactoring and fixes
- `@frontend-engineer` - Frontend-only refactoring and fixes
- `@qa-enforcer` - Comprehensive quality verification

See `agents/README.md` for complete documentation.

### Skills (Reusable Workflows)

- `bug-fix` - Complete bug fixing workflow with Jira integration
- `tdd` - RED-GREEN-REFACTOR cycle for test-driven development
- `vertical-slice` - Define small, reviewable slices (<300 lines per PR)
- `acceptance-criteria` - Standard GIVEN-WHEN-THEN format for testable AC
- `pr-size-check` - Automated gate to ensure PRs are reviewable
- `retro` - Mini retrospective to identify improvements
- `root-cause-analysis` - Systematic investigation for complex bugs
- `skill-maker` - Creating new skills and making them source of truth

## Configuration Hierarchy

Claude Code reads configurations in this order (most specific wins):

1. **Project-level** (`.claude/` in project root) - HIGHEST PRIORITY
2. **Organization-level** (this directory) - MEDIUM PRIORITY
3. **Global-level** (`~/.claude/`) - LOWEST PRIORITY

## File Management

| File | Global | Organization | Project | Notes |
|------|--------|--------------|---------|-------|
| `mcp.json` | ✓ | ❌ | ❌ | ONE COPY ONLY at global level |
| `settings.json` | ✓ | ❌ | ❌ | Plugin settings only at global |
| `CLAUDE.md` | - | ✓ | ✓ | Both levels, concatenated |
| `agents/` | - | ✓ | Optional | Shared at org, override if needed |
| `skills/` | - | ✓ | Optional | Shared at org, override if needed |
| `settings.local.json` | ✓ | - | ✓ | Project permissions |
| `notes/` | - | ✓ | ✓ | Context at both levels |

## Documentation

- **Complete Guide:** [`CONFIGURATION-GUIDE.md`](./CONFIGURATION-GUIDE.md)
- **Workflow Guide:** [`CLAUDE.md`](./CLAUDE.md)
- **Agent Documentation:** [`agents/README.md`](./agents/README.md)
- **Agent Structure:** [`agents/STRUCTURE.md`](./agents/STRUCTURE.md)

## Quick Start

### For New Projects

1. Create `.claude/` directory in project root
2. Create project-specific `CLAUDE.md` with tech stack details
3. Optionally add `settings.local.json` for permissions
4. Reference organization workflows from project CLAUDE.md

```bash
mkdir -p /path/to/project/.claude
# Add project-specific CLAUDE.md
# Organization agents and skills are automatically available
```

### Adding a New Skill

1. Create skill file in `skills/` directory
2. Update `CLAUDE.md` to list the new skill
3. Commit to version control

### Consolidation Checklist

- [x] Remove duplicate `mcp.json` from organization level
- [x] Ensure CLAUDE.md files are in `.claude/` directories
- [x] Separate workflow (org) from project details (project)
- [x] Document the hierarchy in README.md
- [x] Create comprehensive CONFIGURATION-GUIDE.md

## Best Practices

✅ **Do:**
- Keep MCP configuration at global level only
- Share agents and skills at organization level
- Document project-specific details in project CLAUDE.md
- Reference organization workflows from project level

❌ **Don't:**
- Duplicate `mcp.json` at multiple levels
- Copy agents or skills to project level
- Mix workflow guides with project details
- Put CLAUDE.md at project root (use `.claude/` directory)

---

**Need Help?** See [`CONFIGURATION-GUIDE.md`](./CONFIGURATION-GUIDE.md) for complete documentation.
