# Skill Maker Skill

You are a skill creation specialist for the Provider Directory project. This skill guides you through creating new Claude Code skills that become the single source of truth.

## Purpose

Create well-structured, reusable skills that:
- Provide specialized instructions for specific workflows
- Eliminate duplication in CLAUDE.md and agent configurations
- Can be referenced by other skills and agents
- Follow consistent documentation patterns

## Workflow Steps

### 1. UNDERSTAND - Gather Requirements

**Ask the user:**
- What workflow or task should this skill handle?
- When should this skill be invoked?
- What are the key steps in the workflow?
- Are there existing instructions in CLAUDE.md or agent files that duplicate this?
- Should other skills or agents reference this skill?

**Analyze existing documentation:**
- Search CLAUDE.md for related content
- Check `.claude/agents/` for agent-specific instructions
- Identify any duplication that should be removed

### 2. DESIGN - Plan the Skill Structure

**Every skill should have:**

**Header Section:**
- Title and clear description of purpose
- When to invoke the skill
- What outcomes to expect

**Workflow Section:**
- Step-by-step instructions (numbered or named phases)
- Clear success criteria for each step
- Tools and commands to use
- Integration points with other skills/agents

**Examples Section:**
- Concrete usage examples
- Common scenarios
- Expected outputs

**Reference Section:**
- Related skills and agents
- Related documentation
- Configuration files

**Skill Template:**
```markdown
# [Skill Name] Skill

You are a [role] specialist for the Provider Directory project. [Brief purpose statement]

## Purpose

[What this skill does and why it exists]

## Workflow Steps

### Step 1: [Name]
[Detailed instructions]

### Step 2: [Name]
[Detailed instructions]

## [Additional Sections as Needed]

## Examples

[Usage examples]

## Integration

[How other skills/agents reference this]

## Usage

Invoke this skill when:
- [Condition 1]
- [Condition 2]

\`\`\`
[skill-name]: [example invocation]
\`\`\`
```

### 3. CREATE - Write the Skill File

**File naming convention:**
- Use kebab-case: `skill-name.md`
- Be descriptive but concise
- Location: `.claude/skills/[skill-name].md`

**Writing guidelines:**
- Use clear, imperative language
- Include specific commands and file paths
- Reference project conventions (Makefile, TDD, quality standards)
- Add code examples for clarity
- Use emojis sparingly (only for critical points like ✅ ❌)

**Create the skill file:**
```bash
# File will be created at:
.claude/skills/[skill-name].md
```

### 4. REFACTOR - Make Skill the Source of Truth

This is the critical step that prevents duplication!

**Key Principle: Skills are Invoked On-Demand, Not Pre-Loaded**

Skills should be pulled into context only when needed, not referenced as documentation:
- ✅ **DO**: "If unclear about slicing, invoke `vertical-slice` skill"
- ✅ **DO**: "Use TDD approach (RED-GREEN-REFACTOR for each change)"
- ❌ **DON'T**: "See: .claude/skills/vertical-slice.md for details"
- ❌ **DON'T**: "Read the TDD skill documentation"

This keeps agent configs and CLAUDE.md lean while making skills available when actually needed.

**A. Update CLAUDE.md:**

Search CLAUDE.md for content that duplicates the skill's workflow.

**Before (Verbose):**
```markdown
## Feature Development Workflow

Follow these steps:
1. EXPLORE - Understand codebase
   - Ask questions
   - Read relevant files
   - Identify patterns
2. PLAN - Break into slices
   [... 50+ lines of detailed instructions ...]
```

**After (Concise Invocation Trigger):**
```markdown
## Feature Development

**Use the feature-dev skill for implementing features:**
\`\`\`
feature-dev: <feature description>
\`\`\`

The skill handles the complete 5-phase workflow: EXPLORE, PLAN, CODE, VERIFY, COMMIT.
```

**Update CLAUDE.md to:**
- Remove verbose instructions
- Add brief description of what skill does
- Explain when to invoke it
- **DO NOT** add "See: .claude/skills/..." (skills are pulled on-demand, not read as docs)
- Keep it minimal - just enough to know the skill exists and when to use it

**B. Update Agent Configurations:**

Check if agents in `.claude/agents/` have instructions that should reference this skill.

**Example - Before:**
```markdown
## Workflow

Follow these steps:
1. Create Jira ticket
2. Create branch
3. Implement with TDD
[... detailed TDD instructions ...]
```

**Example - After:**
```markdown
## Workflow

Follow these steps:
1. Create Jira ticket
2. Create branch
3. Implement with TDD
   - If unclear about TDD cycle: Invoke `tdd` skill
   - Follow RED-GREEN-REFACTOR for each change
```

**Update agents to:**
- State when to invoke skills (conditional: "if unclear", "if needed")
- Add brief constraint reminders (e.g., "<300 lines per slice")
- Keep agent-specific context only
- **DO NOT** add "See: .claude/skills/..." (skills are invoked on-demand, not pre-loaded)

**C. Update Other Skills:**

Check if existing skills should reference this new skill.

**Example:** If creating a `tdd` skill, update `bug-fix` skill to reference it instead of duplicating TDD instructions.

### 5. VERIFY - Check for Completeness

**Skill file checklist:**
- ✅ Clear purpose statement
- ✅ Step-by-step workflow
- ✅ Concrete examples
- ✅ Integration points documented
- ✅ Usage instructions included
- ✅ No unnecessary duplication with other skills

**Documentation checklist:**
- ✅ CLAUDE.md updated (duplication removed)
- ✅ Agents updated (if applicable)
- ✅ Other skills updated (if applicable)
- ✅ Only minimal references remain in other files
- ✅ Skill is the single source of truth

**Complexity checklist (Prevent dependency hell):**
- ✅ Dependency depth ≤3 (see rules below)
- ✅ No circular dependencies
- ✅ Invocations are conditional ("if unclear"), not automatic
- ✅ Context cost documented (lines loaded)
- ✅ Skill type assigned (Foundation/Definition/Workflow/Meta)

**Test the skill mentally:**
- Can I invoke it with clear syntax?
- Do I know when to use it vs other skills?
- Are the instructions complete and unambiguous?
- Does it integrate well with existing workflows?

### 6. COMMIT - Save the Skill

**Branch naming:**
- For single skill: `claude/add-[skill-name]-skill`
- For multiple skills: `claude/add-initial-skills` or `claude/add-[category]-skills`

**Commit workflow:**

Ask user: "Should I create a new branch for this skill, or use an existing branch?"

**If new branch needed:**
```bash
git checkout -b claude/add-[skill-name]-skill
```

**If adding to existing branch:**
```bash
# Verify we're on the right branch
git branch --show-current
```

**Stage and commit files:**

For each logical unit, create a separate commit:

**Commit 1: The skill itself**
```bash
git add .claude/skills/[skill-name].md
git commit -m "feat: add [skill-name] skill for [purpose]

[Detailed description of what the skill does]

Key features:
- [Feature 1]
- [Feature 2]
- [Feature 3]

Usage: \`[skill-name]: <description>\`

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

**Commit 2: Refactored documentation (if applicable)**
```bash
git add .claude/CLAUDE.md .claude/agents/ .claude/skills/
git commit -m "refactor: update docs to reference [skill-name] skill

Remove duplication from CLAUDE.md and agent configs by referencing
the [skill-name] skill as single source of truth.

Changes:
- CLAUDE.md: Replace verbose [workflow] with skill reference
- Agents: Update [agent-name] to reference skill
- Skills: Update [other-skill] to reference skill

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

**Prompt user:**
```
✅ Skill created: .claude/skills/[skill-name].md
✅ Documentation updated to use skill as source of truth

Commits ready on branch: [branch-name]
- Commit 1: Add [skill-name] skill
- Commit 2: Refactor docs to reference skill

Please review the commits and push when ready.
```

---

## Preventing Complexity (Dependency Guardrails)

As skills grow, dependency complexity can become a problem. Follow these rules to prevent dependency hell.

### Rule 1: Maximum Depth = 3

**What is depth?**
Depth measures how many skills get loaded from a single invocation.

```
User invokes Skill A (depth 0)
  → A invokes Skill B (depth 1)
    → B invokes Skill C (depth 2)
      → C invokes Skill D (depth 3)
        → D CANNOT invoke anything (would be depth 4 ❌)
```

**Examples:**

✅ **Acceptable (depth 2):**
```
User: bug-fix: services not saving
  → bug-fix invokes tdd (depth 1)
    → tdd invokes test-patterns (depth 2)
      → STOP (depth 3 would violate rule)

Context loaded: bug-fix + tdd + test-patterns
```

✅ **Acceptable (depth 3):**
```
User: feature-dev: implement provider search
  → feature-dev invokes vertical-slice (depth 1)
    → vertical-slice references acceptance-criteria (depth 2)
      → acceptance-criteria mentions story-splitting (depth 3)
        → STOP

Context loaded: feature-dev + vertical-slice + acceptance-criteria + story-splitting
```

❌ **Unacceptable (depth 4):**
```
User: orchestrator
  → orchestrator invokes feature-dev (depth 1)
    → feature-dev invokes vertical-slice (depth 2)
      → vertical-slice invokes acceptance-criteria (depth 3)
        → acceptance-criteria invokes story-splitting (depth 4) ❌
```

**Why depth 3?**
- Balances flexibility vs complexity
- Typical chain: Workflow → Definition → Foundation
- Prevents context explosion (>2000 lines loaded)

### Rule 2: Skill Type Hierarchy

Assign each skill a type to control invocation patterns:

**Foundation (Level 0) - Never invoke other skills**
```
Examples: tdd, code-review, testing-patterns
Purpose: Building blocks used by others
Can invoke: Nothing
Context cost: Low (300-500 lines)
```

**Definition (Level 1) - Can reference Foundation only**
```
Examples: vertical-slice, acceptance-criteria, definition-of-done
Purpose: Define standards and constraints
Can invoke: Foundation skills only
Context cost: Medium (500-700 lines)
```

**Workflow (Level 2) - Can invoke Foundation + Definition**
```
Examples: bug-fix, feature-dev, refactoring
Purpose: Complete end-to-end processes
Can invoke: Foundation + Definition skills
Context cost: High (700-1000 lines with dependencies)
```

**Meta (Special) - Can reference any, but carefully**
```
Examples: skill-maker, project-orchestrator
Purpose: Manage or create other skills
Can invoke: Any, but document depth
Context cost: Variable (depends on what's invoked)
```

**Invocation Rules:**
- ❌ Foundation → Foundation (should be self-contained)
- ✅ Definition → Foundation (OK, depth 1)
- ❌ Definition → Definition (creates coupling)
- ✅ Workflow → Foundation (OK, depth 1)
- ✅ Workflow → Definition (OK, depth 1)
- ❌ Workflow → Workflow (too complex, depth explosion)

### Rule 3: Conditional Invocation Only

**All invocations MUST be conditional, not automatic:**

✅ **Good (conditional):**
```markdown
If unclear about TDD cycle: invoke `tdd` skill
When story is too large: invoke `story-splitting` skill
For complex slicing: invoke `vertical-slice` skill
```

❌ **Bad (automatic):**
```markdown
Always invoke `tdd` for implementation
First, invoke `vertical-slice` to plan
Invoke `pr-size-check` before proceeding
```

**Why conditional?**
- Only loads context when actually needed
- User/agent decides if clarification required
- Prevents automatic cascade of invocations

### Rule 4: No Circular Dependencies

**Check for circular references before finalizing:**

❌ **Circular (Bad):**
```
bug-fix → references tdd
tdd → references code-review
code-review → references bug-fix
```

❌ **Circular (Bad):**
```
acceptance-criteria → references story-splitting
story-splitting → references vertical-slice
vertical-slice → references acceptance-criteria
```

✅ **Acyclic (Good):**
```
bug-fix → references tdd → (stops)
feature-dev → references vertical-slice → references tdd → (stops)
pr-size-check → references vertical-slice → (stops)
```

**How to detect:**
1. List all skills current skill invokes/references
2. For each referenced skill, list what it invokes
3. Check if any path leads back to current skill

### Rule 5: Document Dependencies

**Add this section to every skill:**

```markdown
## Dependencies

**This skill invokes/references:**
- tdd (conditional: if unclear about TDD)
- vertical-slice (conditional: if story too large)

**This skill is invoked by:**
- feature-dev (for implementation guidance)
- @full-stack-engineer (for TDD workflow)

**Skill type:** Workflow (Level 2)
**Dependency depth:** 1 (invokes Foundation skills only)
**Context cost:** ~850 lines (self + dependencies)
**Circular risk:** None (no skills reference this back)
```

### Rule 6: Monitor Context Cost

**Track how much context gets loaded:**

```
Skill: feature-dev (800 lines)
  → invokes vertical-slice (508 lines)
  → invokes acceptance-criteria (550 lines)

Total context: 1,858 lines

Warning: High context cost!
Consider: Reference instead of invoke?
```

**Context budgets:**
- 🟢 Low: <1,000 lines (good)
- 🟡 Medium: 1,000-2,000 lines (acceptable)
- 🔴 High: >2,000 lines (refactor needed)

**If context >2,000 lines:**
- Convert "invoke" to "reference" (just mention, don't load)
- Split skill into smaller pieces
- Re-evaluate necessity of each dependency

### Rule 7: Skills Never Invoke Agents

**Critical boundary: Skills and agents are different abstraction levels.**

**Skills = Instruction Layer**
- Pure instructions and guidance
- Workflow knowledge
- Loaded on-demand into ANY context

**Agents = Execution Layer**
- Separate conversations with tools
- Specialized execution contexts
- One agent per conversation

**Dependency Rules:**

✅ **ALLOWED:**
```
User → Agent (starts agent conversation)
User → Skill (loads skill into main context)
Agent → Skill (agent reads skill instructions)
Skill → Skill (with depth ≤3)
```

❌ **FORBIDDEN:**
```
Skill → Agent (skills can't execute, only instruct)
Agent → Agent (creates context switching nightmare)
```

**In practice:**

✅ **GOOD (Skill mentions agent):**
```markdown
## Integration

This skill is used by:
- @business-analyst (during PLAN phase)
- @full-stack-engineer (to understand constraints)

When using this skill, you might also need @qa-enforcer for verification.
```

❌ **BAD (Skill invokes agent):**
```markdown
## Workflow

Step 3: Invoke @business-analyst to create breakdown
Step 4: Wait for @business-analyst to complete
Step 5: Review output from @business-analyst
```

**Why this matters:**
- Skills are passive instructions loaded into a context
- Agents are active executors running separate conversations
- Mixing these layers creates circular dependencies and context chaos
- Clear separation maintains architectural sanity

---

## Quality Standards

Before committing any skill, ensure it meets these quality standards. These rules prevent technical debt and ensure skills remain maintainable as the system scales.

### 1. Mandatory Structure Template

**Every skill MUST have these sections in this order:**

```markdown
# [Skill Name] Skill

You are a [role] specialist for the Provider Directory project. [Brief purpose statement]

## Purpose
[2-3 sentences: what this skill does and when to use it]

## Workflow Steps
### Step 1: [Name]
[Detailed instructions]

### Step 2: [Name]
[Detailed instructions]

[Additional steps as needed]

## Usage
**Automatic invocation:**
[When this skill is automatically triggered]

**Manual invocation:**
```
[skill-name]: <description>
```

## Examples

### Example 1: [Scenario Name]
[Concrete example showing successful flow]

### Example 2: [Scenario Name]
[Concrete example showing failure + recovery]

## Success Criteria
Skill is complete when:
- ✅ [Measurable outcome 1]
- ✅ [Measurable outcome 2]
- ✅ [Measurable outcome 3]

## Tools and Skills (Optional)
**Tools:**
- [MCP tools, make commands, bash commands used in this skill]

**Related Skills:**
- [Skills this one may invoke conditionally]

**Related Agents:**
- [Agents that CAN use this skill, but skill doesn't invoke]
```

**Why mandatory structure?**
- Consistency makes skills easier to scan
- User knows where to find information
- AI can parse structure reliably
- Missing sections indicate incomplete skill

### 2. Skill Size Limits

**Enforce these size constraints:**

```
🟢 Ideal: 300-500 lines
   - Single focused workflow
   - Easy to load and parse
   - Low context cost

🟡 Acceptable: 500-800 lines
   - Complex workflow with extensive examples
   - Multiple phases or variations
   - Medium context cost

🔴 Too Large: >800 lines
   - MUST REFACTOR: Split into multiple skills
   - High context cost
   - Hard to maintain
```

**Current skills for reference:**
- tdd: 328 lines ✅
- bug-fix: 175 lines ✅
- vertical-slice: 508 lines ✅
- acceptance-criteria: 550 lines ✅
- pr-size-check: 613 lines ✅
- skill-maker: ~760 lines ⚠️ (acceptable for meta skill)

**If skill >800 lines:**
- Split by workflow phase (e.g., tdd-red, tdd-green, tdd-refactor)
- Split by context (e.g., backend-validation, frontend-validation)
- Extract examples into separate skill (e.g., tdd-examples)

**Why these limits?**
- We enforce <300 lines for code PRs
- Skills are instruction documents (easier to scan than code)
- Allow 2-3x code limit for comprehensive examples
- But still need upper bound to prevent bloat

### 3. Pre-Commit Validation Checklist

**Before committing ANY skill, verify ALL items:**

```markdown
## Validation Checklist

Structure:
✅ Has Purpose section (2-3 sentences)
✅ Has Workflow Steps (numbered, clear phases)
✅ Has Usage section (automatic + manual invocation)
✅ Has Success Criteria (measurable outcomes)
✅ Follows standard template structure

Content:
✅ Has at least 2 Examples (success + failure/recovery)
✅ Examples use real file paths, commands, tools
✅ All referenced skills exist
✅ All referenced agents exist
✅ No broken file path references

Quality:
✅ Size <800 lines (check with `wc -l`)
✅ Read skill aloud - does it make sense?
✅ Could a junior engineer follow this?
✅ No unnecessary duplication with other skills

Dependencies:
✅ Follows dependency rules (max depth 3)
✅ Doesn't invoke agents directly
✅ All invocations are conditional (if/when)
✅ No circular dependencies detected
✅ Context cost documented (<2,000 lines total)

Integration:
✅ CLAUDE.md updated (if needed)
✅ Agents updated (if needed)
✅ Other skills updated (if needed)
✅ Skill is single source of truth (no duplication)
```

**How to use:**
1. Copy checklist into commit message or review notes
2. Mark each item as you verify
3. If ANY item fails, fix before committing
4. Include validation summary in commit message

**Example commit message:**
```
feat: add acceptance-criteria skill

Validation complete:
✅ Structure: All mandatory sections present
✅ Content: 3 examples with real scenarios
✅ Quality: 550 lines (within 500-800 acceptable range)
✅ Dependencies: Depth 1 (invokes story-splitting only)
✅ Integration: CLAUDE.md updated, no duplication

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

### 4. Naming Conventions (Detailed)

**Beyond kebab-case, follow these semantic rules:**

**Concept Skills (nouns):**
```
✅ tdd (abbreviation of concept)
✅ vertical-slice (compound noun)
✅ acceptance-criteria (compound noun)

Use when: Defining a concept, pattern, or standard
```

**Process Skills (verb-noun):**
```
✅ bug-fix (action + target)
✅ code-review (action + target)
✅ pr-size-check (object + action)

Use when: Describing a workflow or process
```

**Meta Skills (compound-noun or role-noun):**
```
✅ skill-maker (role + target)
✅ project-orchestrator (context + role)

Use when: Managing/creating other skills
```

**Anti-patterns:**
```
❌ bug-fix-workflow (redundant suffix - all skills are workflows)
❌ fix-bugs (plural - skills represent singular concepts)
❌ pr_size_check (underscore instead of hyphen)
❌ PRSizeCheck (camelCase instead of kebab-case)
❌ pr-checker (too vague - what does it check?)
❌ skill1, skill2 (no semantic meaning)
```

**Filename MUST match invocation:**
```
Filename:   bug-fix.md
Invocation: bug-fix: services not saving

Filename:   vertical-slice.md
Invocation: vertical-slice: how to split large PR

Filename:   acceptance-criteria.md
Invocation: acceptance-criteria: validate story ACs
```

**Length guidelines:**
```
✅ 1 word: tdd, qa, deploy
✅ 2 words: bug-fix, code-review, api-design
✅ 3 words: pr-size-check, story-splitting
❌ 4+ words: too verbose, hard to remember
```

### 5. Required Examples

**Every skill MUST include at least 2 examples:**

**Example 1: Success Path**
```markdown
### Example 1: [Skill] Succeeds

**Scenario:** [Describe the starting condition]

**Invocation:**
```
[skill-name]: [concrete example]
```

**Process:**
1. [What happens in step 1]
2. [What happens in step 2]
3. [What happens in step 3]

**Result:**
✅ [Expected outcome]
✅ [Measurable success metric]

**Output:**
```
[Actual command output or result]
```
```

**Example 2: Failure + Recovery**
```markdown
### Example 2: [Skill] Fails (Scope Too Large)

**Scenario:** [Describe the problematic starting condition]

**Invocation:**
```
[skill-name]: [concrete example that will fail]
```

**Problem:**
❌ [What went wrong]
❌ [Why validation failed]

**Recovery:**
Invoke `[related-skill]` to resolve:
```
[related-skill]: [how to fix the problem]
```

**Result after recovery:**
✅ [How problem was resolved]
```

**Why require failure examples?**
- Skills often fail due to constraint violations
- Show user how to recover using other skills
- Demonstrate skill boundaries
- Teach when to invoke related skills

**Example from pr-size-check skill:**
```markdown
### Example 1: PR Passes All Checks
[Shows 245 lines, all quality gates pass]

### Example 2: PR Fails Size Check
[Shows 580 lines, suggests splitting using vertical-slice patterns]

### Example 3: Scope Creep Detected
[Shows unexpected files, suggests reverting scope creep]
```

### 6. Context Cost Alerts

**Track and document context cost for every skill:**

**In each skill's documentation section, add:**
```markdown
## Context Cost

**This skill:**
- Lines: [X] (e.g., 550 lines)
- Type: [Foundation/Definition/Workflow/Meta]

**Dependencies (if skill invokes others):**
- [dependency-1]: [Y] lines
- [dependency-2]: [Z] lines

**Total context when invoked:**
[X + Y + Z] lines

**Budget status:**
🟢 <1,000 lines: Low cost (good)
🟡 1,000-2,000 lines: Medium cost (acceptable)
🔴 >2,000 lines: High cost (refactor needed)
```

**Example from pr-size-check skill:**
```markdown
## Context Cost

**This skill:**
- Lines: 613
- Type: Workflow (Level 2)

**Dependencies:**
- vertical-slice: 508 lines (invoked if PR too large)

**Total context when invoked:**
613 + 508 = 1,121 lines ⚠️ Yellow zone

**Budget status:** 🟡 Medium cost (acceptable for comprehensive gate)
```

**When context >2,000 lines:**
```
Action required:
1. Convert "invoke" to "mention" (reference without loading)
2. Split skill into smaller focused skills
3. Remove examples, create separate examples skill
4. Re-evaluate necessity of each dependency
```

**How to calculate:**
```bash
# Lines in current skill
wc -l .claude/skills/[skill-name].md

# Lines in all dependencies
wc -l .claude/skills/dependency-1.md
wc -l .claude/skills/dependency-2.md

# Sum all values
echo "Total: $(expr 613 + 508)"
```

**Why monitor context cost?**
- LLM context has practical limits
- Loading >2,000 lines reduces comprehension
- High cost indicates over-coupling
- Budget helps prioritize refactoring

---

## Common Skill Categories

### Workflow Skills
- **bug-fix** - Bug fixing with Jira and TDD
- **feature-dev** - Complete feature development (5-phase)
- **refactor** - Code refactoring workflow
- **tdd** - RED-GREEN-REFACTOR cycle

### Technical Skills
- **backend-dev** - Phoenix/Elixir development patterns
- **frontend-dev** - Next.js/TypeScript patterns
- **database-migration** - Schema changes and migrations
- **api-design** - REST API design with OpenAPI

### Process Skills
- **code-review** - Reviewing code changes
- **quality-check** - Running verification
- **planning** - Breaking down features
- **exploration** - Discovering codebase patterns

### Meta Skills
- **skill-maker** - Creating new skills (this file!)

---

## Skill Naming Conventions

**Use kebab-case:**
- ✅ `bug-fix.md`
- ✅ `feature-dev.md`
- ✅ `skill-maker.md`
- ❌ `bugFix.md`
- ❌ `Bug_Fix.md`

**Be descriptive:**
- ✅ `tdd.md` - Clear abbreviation
- ✅ `bug-fix.md` - Describes purpose
- ❌ `workflow.md` - Too generic
- ❌ `skill1.md` - No meaning

**Match invocation syntax:**
- Filename: `feature-dev.md`
- Invocation: `feature-dev: implement provider search`

---

## Integration with Existing System

### Skills Reference Each Other

```
skill-maker (meta)
    └─> Creates all skills

tdd (foundation)
    └─> Referenced by: bug-fix, feature-dev, refactor

bug-fix (workflow)
    └─> References: tdd
    └─> Used for: bug fixes

feature-dev (workflow)
    └─> References: tdd, planning, exploration
    └─> Used for: new features
```

### Agents Use Skills

Agents should invoke skills when needed, not reference them as docs:

```markdown
## Implementation Phase

Use TDD approach for all code changes (RED-GREEN-REFACTOR).

**If unclear about TDD cycle:** Invoke `tdd` skill for detailed guidance.
```

### CLAUDE.md References Skills

CLAUDE.md should have minimal workflow details, just invocation triggers:

```markdown
## Bug Fixes

When a bug is identified, use the bug-fix skill:
\`\`\`
bug-fix: <brief bug description>
\`\`\`

The skill handles Jira ticket creation, branch setup, TDD implementation, and QA verification.
```

---

## Anti-Patterns to Avoid

**❌ Duplicating instructions across multiple files:**
```
CLAUDE.md has full TDD workflow (50 lines)
bug-fix.md has full TDD workflow (50 lines)
feature-dev.md has full TDD workflow (50 lines)
```

**✅ Single source of truth with references:**
```
tdd.md has full TDD workflow (50 lines)
bug-fix.md references tdd.md (3 lines)
feature-dev.md references tdd.md (3 lines)
CLAUDE.md references tdd.md (5 lines)
```

**❌ Vague skill invocation:**
```
workflow: do the thing
```

**✅ Clear skill invocation:**
```
bug-fix: services not saving during provider creation
```

**❌ Skills that are too broad:**
```
development.md - Contains everything about development
```

**✅ Skills that are focused:**
```
tdd.md - Just TDD cycle
bug-fix.md - Just bug fixing workflow
feature-dev.md - Just feature development
```

**❌ Referencing skills as documentation (bloats context):**
```
Agent file:
"See: .claude/skills/vertical-slice.md for complete details"

CLAUDE.md:
"See: .claude/skills/tdd.md for TDD workflow"
```

**✅ Conditional invocation triggers (pulls on-demand):**
```
Agent file:
"Each slice must be <300 lines. If unclear about slicing: invoke `vertical-slice` skill"

CLAUDE.md:
"Use TDD approach (RED-GREEN-REFACTOR). If unclear: invoke `tdd` skill"
```

---

## Success Criteria

A skill is well-created when:
- ✅ Skill file is complete and self-contained
- ✅ Purpose and usage are crystal clear
- ✅ Workflow steps are detailed and actionable
- ✅ Examples demonstrate real usage
- ✅ CLAUDE.md references skill (duplication removed)
- ✅ Agents reference skill (if applicable)
- ✅ Other skills reference it (if applicable)
- ✅ Skill is committed to git on appropriate branch
- ✅ User is prompted to review and push

---

## Dependencies

**This skill invokes/references:**
- None directly (Meta skill that documents how to create skills)
- Mentions: `tdd`, `bug-fix`, `vertical-slice`, `acceptance-criteria` (as examples)

**This skill is invoked by:**
- Users (when creating new skills)
- Engineers (when documenting workflows)
- Maintainers (when reducing duplication)

**Skill type:** Meta (Special)
**Dependency depth:** 0 (documents process, doesn't invoke skills during execution)
**Context cost:** ~1,168 lines (self only)
**Circular risk:** None (meta skill doesn't participate in normal skill chains)

**Special note:** Meta skills can reference any other skill as examples, but should not invoke them during skill creation process. The skills being created may have their own dependencies.

---

## Context Cost

**This skill:**
- Lines: 1,119
- Type: Meta (Special)

**Dependencies:**
- None (meta skill is self-contained)

**Total context when invoked:**
1,119 lines

**Budget status:** 🟡 Acceptable for meta skill

**Why this size is acceptable:**
- Meta skills have different constraints than workflow/definition skills
- Contains comprehensive quality standards and validation rules
- Includes extensive examples and anti-patterns
- Used infrequently (only when creating new skills)
- Not part of normal skill dependency chains
- Alternative would be splitting standards into separate document, but skill-maker needs them for validation

**Size notes:**
- Normal skills: <800 lines
- Meta skills: <1,200 lines acceptable if justified
- This skill: 1,119 lines (within acceptable range for meta)

---

## Usage

Invoke this skill when:
- User asks to create a new skill
- User wants to document a workflow
- User wants to reduce duplication in documentation
- You identify a repeated pattern that should be a skill

```
skill-maker: create a skill for [purpose]
```

The skill-maker will guide you through the complete process of creating a skill, making it the source of truth, and committing it properly.
