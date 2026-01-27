# Claude Code Configuration Guide

Complete guide to managing Claude Code configurations across the Mable organization.

**Last Updated:** January 21, 2026

---

## Table of Contents

1. [Overview](#overview)
2. [Directory Structure](#directory-structure)
3. [Configuration Hierarchy](#configuration-hierarchy)
4. [File Types and Purpose](#file-types-and-purpose)
5. [Best Practices](#best-practices)
6. [Consolidation Strategy](#consolidation-strategy)
7. [Common Scenarios](#common-scenarios)
8. [Troubleshooting](#troubleshooting)

---

## Overview

Claude Code uses a hierarchical configuration system that allows you to define settings at three levels:

1. **Global** (`~/.claude/`) - User-level settings that apply to all projects
2. **Organization** (`/projects/mableit/.claude/`) - Shared across all Mable projects
3. **Project** (`/projects/mableit/<project>/.claude/`) - Specific to individual projects

The more specific configuration takes precedence when there are overlaps.

### Key Principles

- **Single Source of Truth**: Each configuration item should exist at only one level
- **Share Reusable Resources**: Agents, skills, and workflows at organization level
- **Customize Where Needed**: Project-specific guidance at project level
- **Avoid Duplication**: Don't copy configurations between levels

---

## Directory Structure

### Global Level (`~/.claude/`)

```
~/.claude/
├── settings.json                 # Plugin enablement
├── settings.local.json          # Local overrides (optional)
├── mcp.json                     # MCP server configurations
├── history.jsonl                # Session history (managed by Claude)
├── cache/                       # Runtime cache
├── debug/                       # Debug logs
├── session-env/                 # Session environment
├── shell-snapshots/             # Shell state snapshots
├── todos/                       # Todo list persistence
├── projects/                    # Project metadata
├── plugins/                     # Plugin installations
└── [other runtime files]
```

**Purpose:** System-wide settings and runtime data

**What goes here:**
- MCP server configurations (Atlassian, Playwright, Figma, etc.)
- Plugin enablement settings
- Personal preferences
- Runtime data managed by Claude Code

**Don't put here:**
- Project-specific workflows
- Organization-specific agents or skills
- Project documentation

### Organization Level (`/projects/mableit/.claude/`)

```
/projects/mableit/.claude/
├── CLAUDE.md                    # Development workflow guide
├── CONFIGURATION-GUIDE.md       # This file
├── agents/                      # Reusable agents
│   ├── README.md               # Agent system documentation
│   ├── STRUCTURE.md            # Agent structure guide
│   ├── backend-engineer/       # Backend-specific agent
│   ├── business-analyst/       # Requirements & planning agent
│   ├── codebase-explorer/      # Code exploration agent
│   ├── frontend-engineer/      # Frontend-specific agent
│   ├── full-stack-engineer/    # Full-stack agent (primary)
│   ├── qa-enforcer/            # Quality verification agent
│   ├── shared/                 # Shared agent components
│   ├── better-caring/          # Backend project agents
│   ├── connections-service/    # Connections service agents
│   ├── provider-directory/     # Provider directory agents
│   └── web-frontend/           # Frontend project agents
├── skills/                      # Reusable workflow skills
│   ├── acceptance-criteria.md  # AC writing standards
│   ├── bug-fix.md             # Bug fix workflow
│   ├── pr-size-check.md       # PR size validation
│   ├── retro.md               # Retrospective workflow
│   ├── root-cause-analysis.md # RCA workflow
│   ├── skill-maker.md         # Skill creation workflow
│   ├── tdd.md                 # TDD cycle workflow
│   ├── terraform-research-patterns.md
│   ├── vertical-slice.md      # Vertical slicing guide
│   └── project-specific/      # Project-specific skills
├── notes/                       # Organization-wide context
├── plans/                       # Organization-wide plans
└── commands/                    # Custom commands
```

**Purpose:** Shared resources across all Mable projects

**What goes here:**
- Development workflow guides (5-phase, TDD, etc.)
- Reusable agents that work across projects
- Reusable skills (bug-fix, tdd, vertical-slice, etc.)
- Organization-wide standards and practices
- Cross-project documentation

**Don't put here:**
- Technology-specific implementation details (use project level)
- MCP server configurations (use global)
- Project-specific permissions

### Project Level (`/projects/mableit/<project>/.claude/`)

```
/projects/mableit/web-frontend/.claude/
├── CLAUDE.md                    # Angular 15 project guide
├── settings.local.json          # Project-specific permissions
└── notes/                       # Project-specific context

/projects/mableit/better_caring/.claude/
├── CLAUDE.md                    # Ruby on Rails project guide
├── settings.local.json          # Project-specific permissions
└── notes/                       # Project-specific context

/projects/mableit/provider_directory/.claude/
├── CLAUDE.md                    # Elixir/Phoenix project guide
├── settings.local.json          # Project-specific permissions
└── notes/                       # Project-specific context
```

**Purpose:** Project-specific customization and documentation

**What goes here:**
- Technology stack details (Angular, Rails, Elixir, etc.)
- Project architecture and structure
- Setup and development commands
- Project-specific coding standards
- Project-specific permissions
- Project context and decisions

**Don't put here:**
- Generic workflow guides (use organization)
- Reusable agents or skills (use organization)
- MCP server configurations (use global)

---

## Configuration Hierarchy

### Precedence Order

When Claude Code looks for configurations, it checks in this order:

1. **Project-level** (`.claude/` in current project) - HIGHEST PRIORITY
2. **Organization-level** (parent `.claude/` directory) - MEDIUM PRIORITY
3. **Global-level** (`~/.claude/`) - LOWEST PRIORITY

The most specific (project-level) configuration wins when there are conflicts.

### How Files are Merged

| File Type | Merge Behavior |
|-----------|----------------|
| `CLAUDE.md` | **Concatenated** - All levels are read and combined |
| `settings.local.json` | **Merged** - Project settings override organization/global |
| `mcp.json` | **Replaced** - Only most specific level is used |
| `agents/` | **Available** - All agents from all levels are accessible |
| `skills/` | **Available** - All skills from all levels are accessible |

### Example: CLAUDE.md Precedence

When Claude Code opens `/projects/mableit/web-frontend/`, it reads:

1. **Global:** `~/.claude/CLAUDE.md` (if exists)
2. **Organization:** `/projects/mableit/.claude/CLAUDE.md` (workflow guide)
3. **Project:** `/projects/mableit/web-frontend/.claude/CLAUDE.md` (Angular specifics)

All three are combined to give Claude the complete context.

---

## File Types and Purpose

### CLAUDE.md

**Purpose:** Instructions for Claude Code about the project, workflow, or organization

**Location Strategy:**
- **Organization:** General workflow, TDD practices, 5-phase workflow, skills system
- **Project:** Technology-specific details, commands, architecture, coding standards

**Example Organization CLAUDE.md:**
```markdown
# Development Workflow Guide

## Bug Fixes
- Use bug-fix skill
- Always create Jira ticket first

## Skills System
- Available skills: vertical-slice, tdd, bug-fix, etc.

## Five-Phase Workflow
- Phase 1: EXPLORE
- Phase 2: PLAN
- Phase 3: CODE
- Phase 4: VERIFY
- Phase 5: COMMIT
```

**Example Project CLAUDE.md:**
```markdown
# Web Frontend (Angular 15)

## Setup
- npm run start:local
- npm test

## Architecture
- NgRx state management
- GraphQL integration
- Component structure

## Testing
- Jest for unit tests
- Cypress for E2E
```

### settings.local.json

**Purpose:** Project-specific permissions and settings

**Location:** Project level only (not shared)

**Example:**
```json
{
  "permissions": {
    "allow": [
      "Bash(gh api:*)",
      "Bash(npm run jest:*)",
      "Bash(find:*)",
      "WebSearch"
    ]
  }
}
```

**Use Cases:**
- Pre-approve specific bash commands
- Enable WebSearch for documentation lookups
- Allow MCP tool usage

### mcp.json

**Purpose:** MCP (Model Context Protocol) server configurations

**Location:** Global level only (`~/.claude/mcp.json`)

**Why Global Only:**
- MCP servers are user-level tools (Atlassian, GitHub, Playwright, etc.)
- Same configuration works across all projects
- Avoids duplication and sync issues

**Example:**
```json
{
  "mcpServers": {
    "atlassian": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "https://mcp.atlassian.com/v1/mcp"],
      "disabled": false
    },
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp"],
      "disabled": false
    }
  }
}
```

### settings.json

**Purpose:** Plugin enablement and global settings

**Location:** Global level only (`~/.claude/settings.json`)

**Example:**
```json
{
  "enabledPlugins": {
    "core@attain-plugin-marketplace": true,
    "planning-workflow@attain-plugin-marketplace": true,
    "developer-workflow@attain-plugin-marketplace": true,
    "review-swarm@attain-plugin-marketplace": true,
    "coding-tutor@every-marketplace": true
  }
}
```

### agents/

**Purpose:** Specialized subagents for different tasks

**Location:** Organization level (shared across projects)

**Available Agents:**
- `@codebase-explorer` - Deep codebase exploration
- `@business-analyst` - Requirements and planning
- `@full-stack-engineer` - Complete vertical slices (PRIMARY)
- `@backend-engineer` - Backend-only work
- `@frontend-engineer` - Frontend-only work
- `@qa-enforcer` - Quality verification

**Usage:**
```
@codebase-explorer find all GraphQL query patterns
@full-stack-engineer implement user authentication with TDD
@qa-enforcer verify code is ready to commit
```

### skills/

**Purpose:** Reusable workflow instructions

**Location:** Organization level (shared across projects)

**Available Skills:**
- `bug-fix` - Complete bug fixing workflow
- `tdd` - Test-driven development cycle
- `vertical-slice` - Feature slicing guidelines
- `acceptance-criteria` - AC writing standards
- `pr-size-check` - PR size validation
- `retro` - Retrospective workflow
- `root-cause-analysis` - RCA workflow
- `skill-maker` - Create new skills

**Usage:**
Skills are invoked by Claude Code automatically when relevant or explicitly:
```
Use the bug-fix skill to fix this issue
```

### notes/

**Purpose:** Context and decisions documentation

**Location:** Both organization and project levels

**Organization notes:** Cross-project context, architecture decisions
**Project notes:** Project-specific context, technical decisions

---

## Best Practices

### 1. Avoid Duplication

❌ **Don't:**
- Copy `mcp.json` to organization or project levels
- Duplicate workflow guides across projects
- Copy agents or skills to project levels

✅ **Do:**
- Keep MCP configuration in global `~/.claude/mcp.json`
- Reference shared agents and skills from organization level
- Add project-specific details to project CLAUDE.md

### 2. Keep Project CLAUDE.md Focused

❌ **Don't:**
- Repeat workflow guides from organization level
- Include generic best practices
- Copy coding standards from elsewhere

✅ **Do:**
- Focus on project-specific setup commands
- Document project architecture and structure
- Link to organization CLAUDE.md for workflows
- Include technology-specific conventions

**Example Reference:**
```markdown
## Development Workflow

See `/projects/mableit/.claude/CLAUDE.md` for:
- Bug fix workflow
- TDD practices
- 5-phase development workflow
- Available skills and agents
```

### 3. Use settings.local.json for Permissions

✅ **Good Use Cases:**
- Pre-approve safe, frequently-used commands
- Enable project-specific tools
- Allow WebSearch for documentation

❌ **Avoid:**
- Over-permissive wildcards
- Dangerous commands without restrictions
- Permissions that should require user approval

### 4. Version Control

**Should be committed:**
- `.claude/CLAUDE.md`
- `.claude/settings.local.json`
- `.claude/agents/`
- `.claude/skills/`
- `.claude/notes/`

**Should NOT be committed:**
- `~/.claude/` (global user directory)
- `.claude/plans/` (temporary planning files)
- `.claude/cache/` (runtime cache)

**Add to .gitignore (if needed):**
```
.claude/plans/
.claude/cache/
.claude/*.local.json  # If it contains secrets
```

### 5. Documentation Maintenance

- Keep CONFIGURATION-GUIDE.md up to date
- Document new agents in `agents/README.md`
- Document new skills in organization CLAUDE.md
- Add project setup changes to project CLAUDE.md

---

## Consolidation Strategy

### Current State Analysis

Before consolidation, you may have:
- Duplicate `mcp.json` files at multiple levels
- CLAUDE.md files in wrong locations (project root instead of `.claude/`)
- Mixed content (workflow + project specifics) in single files
- Unclear hierarchy

### Step-by-Step Consolidation

#### Step 1: Audit Current Configuration

```bash
# Find all .claude directories
find /Users/duy.nguyen/projects -name ".claude" -type d -maxdepth 4

# Check for duplicate mcp.json
find /Users/duy.nguyen/projects/mableit -name "mcp.json"

# Check for CLAUDE.md in wrong locations
find /Users/duy.nguyen/projects/mableit -name "CLAUDE.md" -not -path "*/.claude/*"
```

#### Step 2: Remove Duplicates

```bash
# Remove duplicate mcp.json from organization level
rm /Users/duy.nguyen/projects/mableit/.claude/mcp.json

# Keep only global mcp.json at ~/.claude/mcp.json
```

#### Step 3: Move Misplaced Files

```bash
# If CLAUDE.md is at project root, move to .claude/
mv /Users/duy.nguyen/projects/mableit/web-frontend/CLAUDE.md \
   /Users/duy.nguyen/projects/mableit/web-frontend/.claude/CLAUDE.md
```

#### Step 4: Separate Concerns

**Organization CLAUDE.md should contain:**
- Bug fix workflow
- Skills system overview
- 5-phase workflow
- TDD practices
- Agent descriptions

**Project CLAUDE.md should contain:**
- Setup commands
- Architecture overview
- Technology-specific conventions
- Project structure
- Testing commands

#### Step 5: Verify Hierarchy

```bash
# Check final structure
tree -L 2 ~/.claude/
tree -L 3 /Users/duy.nguyen/projects/mableit/.claude/
tree -L 2 /Users/duy.nguyen/projects/mableit/web-frontend/.claude/
```

### Checklist

- [ ] Only one `mcp.json` exists (at `~/.claude/`)
- [ ] Only one `settings.json` exists (at `~/.claude/`)
- [ ] Organization CLAUDE.md contains workflow guides
- [ ] Project CLAUDE.md contains project-specific details
- [ ] No duplicate agents or skills across levels
- [ ] settings.local.json only at project level (if needed)
- [ ] All files are in `.claude/` directory (not project root)

---

## Common Scenarios

### Scenario 1: Adding a New Mable Project

```bash
# 1. Create .claude directory
mkdir -p /Users/duy.nguyen/projects/mableit/new-project/.claude

# 2. Create project-specific CLAUDE.md
cat > /Users/duy.nguyen/projects/mableit/new-project/.claude/CLAUDE.md << 'EOF'
# New Project

## Development Workflow

See `/projects/mableit/.claude/CLAUDE.md` for organization workflow and practices.

## Setup
[Project setup commands]

## Architecture
[Project architecture]

## Testing
[Testing commands]
EOF

# 3. Add project-specific permissions (optional)
cat > /Users/duy.nguyen/projects/mableit/new-project/.claude/settings.local.json << 'EOF'
{
  "permissions": {
    "allow": [
      "Bash(npm run test:*)",
      "WebSearch"
    ]
  }
}
EOF

# Done! Organization agents and skills are automatically available
```

### Scenario 2: Adding a New Organization Skill

```bash
# 1. Create skill file
cat > /Users/duy.nguyen/projects/mableit/.claude/skills/new-skill.md << 'EOF'
# New Skill

[Skill description and workflow]
EOF

# 2. Update organization CLAUDE.md
# Add new skill to the "Available Skills" section

# 3. Commit to version control
cd /Users/duy.nguyen/projects/mableit
git add .claude/skills/new-skill.md
git add .claude/CLAUDE.md
git commit -m "Add new-skill to organization skills"
```

### Scenario 3: Enabling a New MCP Server

```bash
# Edit global mcp.json
code ~/.claude/mcp.json

# Add new server:
{
  "mcpServers": {
    "existing-server": { ... },
    "new-server": {
      "command": "npx",
      "args": ["-y", "@some/mcp-server"],
      "disabled": false
    }
  }
}

# Restart Claude Code to load new MCP server
```

### Scenario 4: Project-Specific Agent

If you need a project-specific agent (rare):

```bash
# Create project agent directory
mkdir -p /Users/duy.nguyen/projects/mableit/web-frontend/.claude/agents/angular-specialist

# Add agent configuration
# [Agent files]

# Reference in project CLAUDE.md
# "@angular-specialist is available for Angular-specific tasks"
```

### Scenario 5: Migrating from Old Structure

```bash
# Before: Everything at project level
project/.claude/
├── CLAUDE.md (workflow + project details mixed)
├── mcp.json (duplicate)
├── agents/ (duplicated)
└── skills/ (duplicated)

# After: Clean separation
~/.claude/
└── mcp.json (only here)

/mableit/.claude/
├── CLAUDE.md (workflow only)
├── agents/ (shared)
└── skills/ (shared)

project/.claude/
├── CLAUDE.md (project details only)
└── settings.local.json (project permissions)
```

---

## Troubleshooting

### Issue: Claude doesn't see my CLAUDE.md

**Cause:** File is in wrong location (project root instead of `.claude/`)

**Solution:**
```bash
# Move to correct location
mv /path/to/project/CLAUDE.md /path/to/project/.claude/CLAUDE.md
```

### Issue: Agents or skills not working

**Cause:** Missing organization-level .claude directory

**Solution:**
```bash
# Ensure organization .claude exists
ls -la /Users/duy.nguyen/projects/mableit/.claude/

# Check agents are present
ls -la /Users/duy.nguyen/projects/mableit/.claude/agents/
ls -la /Users/duy.nguyen/projects/mableit/.claude/skills/
```

### Issue: MCP servers not loading

**Cause:** `mcp.json` in wrong location or syntax error

**Solution:**
```bash
# Check global mcp.json exists
cat ~/.claude/mcp.json

# Validate JSON syntax
python3 -m json.tool ~/.claude/mcp.json

# Restart Claude Code
```

### Issue: Permissions not working

**Cause:** `settings.local.json` syntax error or wrong location

**Solution:**
```bash
# Check project settings
cat /path/to/project/.claude/settings.local.json

# Validate JSON syntax
python3 -m json.tool /path/to/project/.claude/settings.local.json

# Check permissions format
# Should be: "Bash(command:pattern)"
```

### Issue: Changes not taking effect

**Solution:**
1. Restart Claude Code completely
2. Check file was saved correctly
3. Verify JSON syntax if applicable
4. Check file is in correct directory

### Issue: Duplicate or conflicting configurations

**Solution:**
```bash
# Find all CLAUDE.md files
find /Users/duy.nguyen/projects/mableit -name "CLAUDE.md"

# Find all mcp.json files (should only be in ~/.claude/)
find /Users/duy.nguyen/projects/mableit -name "mcp.json"

# Remove duplicates, keep only correct locations
```

---

## Quick Reference

### File Locations Cheat Sheet

| File | Location | Purpose |
|------|----------|---------|
| `mcp.json` | `~/.claude/` | MCP servers (ONE COPY ONLY) |
| `settings.json` | `~/.claude/` | Plugin settings (ONE COPY ONLY) |
| `CLAUDE.md` | `/mableit/.claude/` | Workflow guide (SHARED) |
| `CLAUDE.md` | `/<project>/.claude/` | Project guide (SPECIFIC) |
| `agents/` | `/mableit/.claude/` | Reusable agents (SHARED) |
| `skills/` | `/mableit/.claude/` | Reusable skills (SHARED) |
| `settings.local.json` | `/<project>/.claude/` | Project permissions (SPECIFIC) |
| `notes/` | Both | Context (BOTH LEVELS) |

### Commands Cheat Sheet

```bash
# View structure
tree -L 2 ~/.claude/
tree -L 3 /Users/duy.nguyen/projects/mableit/.claude/

# Validate JSON files
python3 -m json.tool ~/.claude/mcp.json
python3 -m json.tool project/.claude/settings.local.json

# Find all .claude directories
find ~/projects -name ".claude" -type d

# Check for duplicates
find ~/projects/mableit -name "mcp.json"

# Edit key files
code ~/.claude/mcp.json
code ~/.claude/settings.json
code /Users/duy.nguyen/projects/mableit/.claude/CLAUDE.md
code /Users/duy.nguyen/projects/mableit/web-frontend/.claude/CLAUDE.md
```

---

## Additional Resources

- **Organization Workflow:** `/projects/mableit/.claude/CLAUDE.md`
- **Agent Documentation:** `/projects/mableit/.claude/agents/README.md`
- **Agent Structure:** `/projects/mableit/.claude/agents/STRUCTURE.md`
- **Claude Code Docs:** https://docs.anthropic.com/claude/docs/claude-code

---

**Questions or Issues?**

If you encounter issues with Claude Code configuration:
1. Check this guide for troubleshooting steps
2. Verify file locations match the structure above
3. Validate JSON syntax for all `.json` files
4. Restart Claude Code after making changes
