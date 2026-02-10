# Global Claude Code Configuration

This directory contains universal Claude Code configurations that apply to **ALL your projects**.

## Quick Overview

```
~/.claude/                      # Global (YOU ARE HERE)
├── CLAUDE.md                   # Universal development workflow
├── CONFIGURATION-GUIDE.md      # Complete configuration documentation
├── README.md                   # This file
├── settings.json               # Plugin enablement
├── mcp.json                    # MCP server configurations
├── agents/                     # Universal agents
│   ├── shared/                 # Shared agents (codebase-explorer, qa-enforcer, etc.)
│   ├── README.md              # Agent documentation
│   └── STRUCTURE.md           # Agent structure guide
├── skills/                     # Personal skills (3)
│   ├── retro.md
│   ├── root-cause-analysis.md
│   └── terraform-research-patterns.md
└── [runtime files]             # History, cache, plans, etc.

/path/to/org/.claude/          # Organization-specific (optional)
├── CLAUDE.md                  # Org-specific guidance
├── agents/                    # Org-specific agents
├── notes/                     # Org context
└── skills/                    # Org-specific skills

/path/to/project/.claude/      # Project-specific (optional)
├── CLAUDE.md                  # Project tech stack details
├── settings.local.json        # Project permissions
└── notes/                     # Project context
```

## Universal Resources

These resources are available in **ALL your projects**, regardless of organization or tech stack:

### Core Workflow (5-Phase TDD)

See `CLAUDE.md` for the complete workflow:

1. **EXPLORE** - Understand codebase before writing any code
2. **PLAN** - Break into vertical slices + TDD cycles
3. **CODE** - TDD Red-Green-Refactor
4. **VERIFY** - Quality gates + coverage
5. **COMMIT** - User approval + documentation

### Personal Skills

Invoke with skill name:

- **retro** - Mini retrospective to identify improvements
- **root-cause-analysis** - Systematic investigation for complex bugs
- **terraform-research-patterns** - Terraform provider research patterns

Other skills (bug-fix, tdd, vertical-slice, etc.) are provided by the Attain Plugin Marketplace.

### Shared Agents

Invoke with `@agent-name`:

- **@codebase-explorer** - Deep codebase pattern discovery and context analysis
- **@business-analyst** - Break features into vertical slices and TDD cycles
- **@qa-enforcer** - Comprehensive quality verification before commit
- **@product-manager** - PRD creation through guided Q&A

See `agents/README.md` for complete documentation.

## Configuration Hierarchy

Claude Code reads configurations in this order (most specific wins):

1. **Project-level** (`.claude/` in project root) - HIGHEST PRIORITY
2. **Organization-level** (`.claude/` in org/company root) - MEDIUM PRIORITY
3. **Global-level** (`~/.claude/` - THIS DIRECTORY) - LOWEST PRIORITY

**Best Practices:**

| Content | Global | Organization | Project |
|---------|--------|--------------|---------|
| Universal workflow | ✅ | - | - |
| Universal skills | ✅ | - | - |
| Shared agents | ✅ | - | - |
| MCP configuration | ✅ | ❌ | ❌ |
| Plugin settings | ✅ | ❌ | ❌ |
| Org-specific agents | - | ✅ | - |
| Org context/notes | - | ✅ | - |
| Project tech stack | - | - | ✅ |
| Project permissions | - | - | ✅ |
| Project context | - | - | ✅ |

## Usage Examples

### Starting a New Project

```bash
cd /path/to/new-project

# Option 1: Use global workflow as-is (no project .claude needed)
# Universal skills and agents are automatically available

# Option 2: Add project-specific details
mkdir .claude
echo "# Project-Specific Configuration" > .claude/CLAUDE.md
# Add tech stack, testing patterns, etc.
```

### Using Skills

```bash
# Works in ANY project:
bug-fix: <description>
retro: <context>

# Or mention in conversation:
"Let's follow the TDD skill for this implementation"
"Run the pr-size-check skill before creating the PR"
```

### Using Agents

```bash
# Works in ANY project:
@codebase-explorer find all API endpoint patterns
@business-analyst break down user authentication feature
@qa-enforcer verify code quality before commit
```

## Documentation

- **Workflow Guide:** `CLAUDE.md` (complete 5-phase workflow)
- **Configuration Guide:** `CONFIGURATION-GUIDE.md` (detailed setup)
- **Agent Documentation:** `agents/README.md`
- **Agent Structure:** `agents/STRUCTURE.md`
- **Individual Skills:** `skills/*.md`

## File Management

| File | Purpose | Location | Notes |
|------|---------|----------|-------|
| `mcp.json` | MCP server configs | Global only | ONE COPY |
| `settings.json` | Plugin settings | Global only | ONE COPY |
| `CLAUDE.md` | Development workflow | All levels | Concatenated |
| `agents/` | Agent definitions | Global + Org | Inherited |
| `skills/` | Skill definitions | Global + Org | Inherited |
| `settings.local.json` | Permissions | Global + Project | Most specific wins |
| `notes/` | Context | All levels | Separate per level |

## Benefits of Global Configuration

✅ **Consistency** - Same workflow across all projects
✅ **No duplication** - Skills defined once, used everywhere
✅ **Easy updates** - Update workflow in one place
✅ **Portable** - Take your workflow to any project
✅ **Flexible** - Override with org/project-specific needs

## Adding Organization-Specific Content

For organization-specific agents or context:

```bash
cd /path/to/org-root
mkdir -p .claude/agents .claude/skills .claude/notes

# Create org-specific CLAUDE.md that references global
cat > .claude/CLAUDE.md << 'EOF'
# [Org Name] - Claude Configuration

Universal workflow at ~/.claude/CLAUDE.md applies to all projects.

This directory contains [Org Name]-specific resources:
- Agents for org tech stacks
- Organization context
- Org-specific skills
EOF
```

## Troubleshooting

**Skills not found:**
- Check `~/.claude/skills/` directory exists
- Verify skill files are `.md` format
- Skills are available globally (no project config needed)

**Agents not working:**
- Check `~/.claude/agents/shared/` directory exists
- Verify agent files are `.md` format
- Agents are available globally

**Workflow not applied:**
- Check `~/.claude/CLAUDE.md` exists
- This file is automatically loaded by Claude Code
- No project-specific config required

---

**Need Help?** See `CONFIGURATION-GUIDE.md` for complete documentation.
