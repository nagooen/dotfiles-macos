# Retrospective Skill

You are a continuous improvement specialist for the Provider Directory project. This skill guides you through a structured retrospective after completing work (PR merge, feature completion, bug fix, or major milestone).

## Purpose

Conduct mini-retrospectives through introspection of the current conversation context to:
- Review MY OWN work and identify patterns that slowed me down
- Recognize effective practices I used that are worth codifying
- Create skills to prevent recurring issues in my workflow
- Generate actionable improvements for BOTH my workflow AND the user's workflow
- Suggest how the user could work differently to be more effective

**This is introspection:** I analyze my own work in the current context, not ask the user what to retrospect.

## When to Invoke

**Automatic prompts:**
After any of these events, proactively ask: "Would you like to run a retrospective?"
- PR merged to main
- Bug fix completed
- Feature slice delivered
- Major milestone reached
- User explicitly requests retrospective

**Manual invocation:**
```
retro: [optional context about what was just completed]
```

## Workflow Steps

### Step 1: SCOPE - Review Context (Introspection)

**Automatically analyze the current conversation context:**
- What work was completed in this conversation?
- What files were changed and how many lines?
- What was the primary type of work? (bug fix, feature development, refactoring, documentation)
- What tools/skills/agents were used?
- What commits were made? (git log)
- What blockers or delays occurred?
- How long did the work take?

**This is introspection - review YOUR OWN work in this context, not the user's.**

Example:
```
Context Analysis:
- Work: Created retro skill for continuous improvement
- Files: .claude/skills/retro.md (650 lines), .claude/CLAUDE.md (20 lines)
- Type: Skill creation (documentation)
- Tools: skill-maker guidance, Write, Edit, Bash (git)
- Duration: ~45 minutes
- Commits: 2 (skill + docs update)
- Blockers: None significant
```

### Step 2: ANALYZE - Examine What Happened

**Review the conversation history and code changes to answer:**

**What went well? (Successes)**
- Which practices helped move quickly?
- Which tools or workflows were effective?
- Which skills or agents were particularly useful?
- What quality checks caught issues early?
- What patterns made code easier to write/test?

**What went poorly? (Pain Points)**
- Where did we get blocked or slowed down?
- Which tasks required multiple attempts?
- What information was missing that we had to search for?
- Were there any repeated mistakes or patterns?
- Did we violate any constraints (PR size, test speed, etc.)?

**What surprised us? (Unexpected)**
- What took longer/shorter than expected?
- What complexity was hidden initially?
- What dependencies were discovered late?
- What assumptions proved incorrect?

### Step 3: IDENTIFY - Find Skill Opportunities

**For each pain point, ask:**

**Could a skill prevent this?**
- Is this a repeated pattern? (If yes → skill candidate)
- Would documented guidance help? (If yes → skill candidate)
- Is this specific to this project? (If yes → skill candidate)
- Is this already covered by existing skills? (If yes → update existing skill)

**Skill candidate template:**
```markdown
Pain Point: [Description of what went wrong]
Frequency: [One-time / Occasional / Repeated]
Impact: [Low / Medium / High]
Skill Opportunity: [What skill could prevent this]
Skill Name: [Proposed kebab-case name]
Skill Type: [Foundation / Definition / Workflow / Meta]
```

**For each success, ask:**

**Should we codify this?**
- Was this a new pattern we discovered?
- Would documenting this help maintain consistency?
- Could this replace less effective approaches?

**Success pattern template:**
```markdown
Success: [Description of what went well]
Why it worked: [Explanation]
Make it repeatable: [What skill/doc update would codify this]
```

### Step 4: PRIORITIZE - Rank Improvement Actions

**Score each opportunity (1-5):**
- **Frequency**: How often will this help? (1=rare, 5=daily)
- **Impact**: How much time/frustration saved? (1=minimal, 5=major)
- **Effort**: How easy to implement? (1=complex, 5=simple)
- **Clarity**: How clear is the solution? (1=vague, 5=obvious)

**Priority formula:**
```
Priority Score = (Frequency × Impact × Effort) / 25
```

**Sort by priority score (highest first)**

**Output ranked list:**
```markdown
## Improvement Opportunities (Ranked)

1. [Skill Name] - Score: 4.8/5
   - Prevents: [Pain point]
   - Frequency: 5, Impact: 5, Effort: 4, Clarity: 5

2. [Documentation Update] - Score: 3.6/5
   - Improves: [Success pattern]
   - Frequency: 4, Impact: 3, Effort: 5, Clarity: 4

3. [Process Change] - Score: 2.4/5
   - Addresses: [Unexpected issue]
   - Frequency: 2, Impact: 4, Effort: 3, Clarity: 5
```

### Step 5: RECOMMEND - Suggest Next Actions

**For top 3 priorities, provide concrete recommendations:**

Recommendations can target improvements in THREE areas:
1. **Claude's workflow** - Skills, tools, or patterns I should use
2. **User's workflow** - How the user could work differently (encouraged!)
3. **System/process** - Documentation, tooling, or project setup

**Skill Creation (Claude improvement):**
```markdown
Action: Create `[skill-name]` skill
Purpose: [What it solves]
Target: Claude's workflow (prevents recurring pattern)
Invocation: `[skill-name]: <description>`
Estimated effort: [time estimate]
Next step: Run `skill-maker: create [skill-name] skill`
```

**Documentation Update (Claude improvement):**
```markdown
Action: Update [file-name]
Change: [What to add/modify]
Target: Claude's workflow (reduces context searching)
Why: [Benefit]
Next step: Edit [file-name] to add [specific section]
```

**Process Change (User/System improvement):**
```markdown
Action: [Change description]
Target: User's workflow / System improvement
Current: [How we/user do it now]
Proposed: [How we/user should do it]
Benefit: [Impact of change]
Rationale: [Why this would help the user work more effectively]
Next step: [How to implement]
```

**Example user workflow suggestions:**
- "User could provide more context upfront about constraints"
- "User could run retro more frequently (after each commit vs after PR)"
- "User could specify priority when giving multiple tasks"
- "User could clarify expected timeline to help with planning"

### Step 6: COMMIT - Ask User to Act

**Present findings to user:**
```markdown
## Retrospective Summary

### What Went Well ✅
- [Success 1]
- [Success 2]
- [Success 3]

### What Could Improve 🔄
- [Pain point 1]
- [Pain point 2]
- [Pain point 3]

### Top 3 Actions (Prioritized)
1. [Action 1] - Score: X/5
2. [Action 2] - Score: Y/5
3. [Action 3] - Score: Z/5

Would you like me to:
A. Create skill for [highest priority item]
B. Update documentation for [second priority]
C. Implement all 3 recommendations
D. Skip for now (capture as backlog)
```

**Always save retrospective output:**
- Create file in `docs/retros/YYYY-MM-DD-[topic].md`
- Include full analysis: successes, pain points, recommendations
- Helps track improvements over time
- Creates searchable history of lessons learned

**If user chooses A/B/C:**
- Save retro output to `docs/retros/` FIRST
- Then immediately invoke `skill-maker` or make the change
- Track progress with TodoWrite tool
- Commit both retro file and changes together

**If user chooses D (defer):**
- Save retro output to `docs/retros/`
- User can review backlog items later
- No immediate action taken

## Examples

### Example 1: Post-PR Retrospective (Feature Development)

**Scenario:** Just completed work on PR #44 (Feature flag backend implementation)

**Invocation:**
```
retro
```

**Step 1: SCOPE (Introspection)**
```
Context Analysis (reviewing my own work):
- Work: Implemented feature flag backend (PR #44)
- Files: 4 files changed, 285 lines
- Type: Feature development (backend API + migrations)
- Tools used: TDD skill, Makefile commands, git
- Duration: ~2 days (multiple TDD cycles)
- Commits: 4 commits
- Blockers: Spent 30 min on OpenAPI schema structure
```

**Step 2: ANALYZE**

**What went well:**
- TDD cycle kept tests green throughout
- Makefile commands (make test-backend) worked perfectly
- Test suite stayed under 60s (actual: 3.2s)
- Quality checks caught unused variable before commit

**What went poorly:**
- Spent 30 minutes figuring out OpenAPI schema structure
- Had to search multiple files to understand health check exemption pattern
- Migration naming convention wasn't immediately clear
- Forgot to add API_ENABLED flag to test examples initially

**What surprised us:**
- Health check exemption logic was simpler than expected
- Feature flag migration was smaller than anticipated (10 lines)

**Step 3: IDENTIFY**

**Skill Opportunities:**

**Pain Point 1: OpenAPI Schema Discovery**
```
Pain Point: Finding correct OpenAPI schema structure for new endpoints
Frequency: Repeated (happens on every new API endpoint)
Impact: Medium (30 min per endpoint)
Skill Opportunity: Document OpenAPI patterns for common response types
Skill Name: api-schema-patterns
Skill Type: Definition (Level 1)
Priority Score: (4 × 3 × 4) / 25 = 1.92
```

**Pain Point 2: Health Check Exemption Pattern**
```
Pain Point: Finding where/how to add health check exemptions
Frequency: Occasional (feature flags, maintenance mode)
Impact: Medium (searching multiple files)
Skill Opportunity: Document exemption patterns with examples
Skill Name: middleware-exemptions
Skill Type: Definition (Level 1)
Priority Score: (2 × 3 × 5) / 25 = 1.20
```

**Success Pattern:**
```
Success: TDD kept tests green, caught bugs early
Why it worked: Following tdd skill religiously
Make it repeatable: Already documented in tdd.md ✅
Action: None needed (pattern already working)
```

**Step 4: PRIORITIZE**

```
1. api-schema-patterns - Score: 1.92/5
2. middleware-exemptions - Score: 1.20/5
```

**Step 5: RECOMMEND**

**Priority 1: Claude Improvement**
```
Action: Create `api-schema-patterns` skill
Target: Claude's workflow
Purpose: Document common OpenAPI schema patterns (responses, errors, pagination)
Invocation: `api-schema-patterns: help with [response-type]`
Estimated effort: 30-45 minutes
Next step: Run `skill-maker: create api-schema-patterns skill`

Impact:
- Save 30 min per new endpoint (happens ~2x per week)
- Reduce context switching to find examples
- Ensure consistent API design
```

**Priority 2: User Workflow Suggestion**
```
Action: Provide OpenAPI examples upfront for complex endpoints
Target: User's workflow
Current: User provides feature requirements, I discover OpenAPI patterns during implementation
Proposed: When creating API endpoints, user could link to similar existing endpoint as reference
Benefit: Reduces discovery time from 30 min to <5 min
Rationale: User knows codebase patterns better than I do initially
Example: "Create POST /api/features endpoint (similar to POST /api/providers)"
```

**Step 6: COMMIT**

**Present to user:**
```
## Retrospective Summary - PR #44

### What Went Well ✅
- TDD cycle kept everything green
- Makefile commands streamlined testing
- Quality checks caught issues early

### What Could Improve 🔄
- I spent 30 min discovering OpenAPI schema patterns (repeated pattern)
- I had to search multiple files for health check exemption pattern

### Top 2 Actions (Prioritized)

1. **Claude Improvement:** Create `api-schema-patterns` skill - Score: 1.92/5
   - Saves 30 min per endpoint (~1 hour/week)
   - Prevents inconsistent API design

2. **Your Workflow:** Provide reference endpoints upfront
   - When creating API endpoints, link to similar existing endpoint
   - Example: "Create POST /api/features (similar to POST /api/providers)"
   - Reduces my discovery time from 30 min to <5 min

Would you like me to:
A. Create api-schema-patterns skill now
B. Note both suggestions for future
C. Skip (not worth the effort)
```

**Result:**
1. Save retro output to `docs/retros/2025-01-15-pr-44-feature-flag.md`
2. User chooses A → Invoke `skill-maker: create api-schema-patterns skill`
3. Commit both retro file and new skill together

---

## Retrospective File Format

**Location:** `docs/retros/YYYY-MM-DD-[topic].md`

**Naming convention:**
- Date: YYYY-MM-DD format (sortable)
- Topic: Brief descriptor (kebab-case)
- Examples:
  - `2025-01-15-pr-44-feature-flag.md`
  - `2025-01-16-bug-fix-es-48641.md`
  - `2025-01-20-provider-search-slice.md`

**Template:**
```markdown
# Retrospective: [Topic]

**Date:** YYYY-MM-DD
**Context:** [Brief description of work completed]
**Duration:** [How long the work took]
**Files Changed:** [Number of files, lines of code]

## What Went Well ✅

- [Success 1]
- [Success 2]
- [Success 3]

## What Could Improve 🔄

- [Pain point 1 - be specific about what I struggled with]
- [Pain point 2]
- [Pain point 3]

## Unexpected Findings 🤔

- [Surprise 1]
- [Surprise 2]

## Action Items (Prioritized)

### 1. [Action Name] - Score: X.XX/5

**Type:** Claude Improvement / User Workflow / System Change
**Target:** [What this improves]
**Current State:** [How it works now]
**Proposed:** [How it should work]
**Impact:** [Expected benefit]
**Next Step:** [Concrete action to take]

**Scoring:**
- Frequency: X/5
- Impact: X/5
- Effort: X/5
- Clarity: X/5

### 2. [Action Name] - Score: Y.YY/5

[Same structure as above]

### 3. [Action Name] - Score: Z.ZZ/5

[Same structure as above]

## Decision

- [ ] Create skills/make changes now
- [ ] Defer to backlog
- [ ] No action needed

## Follow-up

[Space for user to add notes after reviewing]
```

---

### Example 2: Post-Bug-Fix Retrospective

**Scenario:** Just merged fix for ES-48641 (health check accessibility during maintenance)

**Invocation:**
```
retro: bug fix ES-48641
```

**Step 2: ANALYZE**

**What went well:**
- Bug was caught quickly (failed in staging)
- TDD cycle reproduced issue immediately
- Fix was simple (6 lines)
- All quality gates passed first time

**What went poorly:**
- Didn't anticipate this edge case during feature development
- No test coverage for middleware exemption logic initially
- Had to manually verify exemption pattern in multiple places

**Step 3: IDENTIFY**

**Skill Opportunity:**
```
Pain Point: Edge cases not considered during feature development
Frequency: Occasional (happened 2x in last month)
Impact: High (breaks production if not caught)
Skill Opportunity: Checklist for common edge cases during PLAN phase
Skill Name: edge-case-checklist
Skill Type: Definition (Level 1)
Priority Score: (2 × 5 × 5) / 25 = 2.00
```

**Step 5: RECOMMEND**

```
Action: Create `edge-case-checklist` skill
Purpose: Prompt engineers to consider common edge cases during planning
Examples:
- Health checks during maintenance mode
- Error handling for external API failures
- Race conditions in concurrent operations
- Null/empty state handling

Next step: Run `skill-maker: create edge-case-checklist skill`
```

**Step 6: COMMIT**

User agrees → Create skill immediately

**Result:**
✅ New skill prevents similar bugs in future

---

### Example 3: Retro Reveals No Actionable Items

**Scenario:** Small documentation update, no issues

**Invocation:**
```
retro: updated API standards doc
```

**Step 2: ANALYZE**

**What went well:**
- Change was straightforward
- Documentation was easy to find and update
- No blockers or delays

**What went poorly:**
- (Nothing significant)

**Step 3: IDENTIFY**

No skill opportunities identified.

**Step 6: COMMIT**

**Present to user:**
```
## Retrospective Summary

### What Went Well ✅
- Straightforward documentation update
- No blockers encountered
- Process worked smoothly

### What Could Improve 🔄
- (No significant issues)

### Recommended Actions
- None - current process is effective for this type of work

Great work! The current process handled this efficiently.
```

**Result:**
✅ Retro complete, no action needed

---

## Common Skill Opportunities

**These patterns frequently emerge in retrospectives:**

**Development Workflow:**
- Edge case checklists
- API design patterns
- Schema validation patterns
- Migration best practices
- Test data factory patterns

**Quality & Performance:**
- Performance profiling workflow
- Load testing patterns
- Security review checklist
- Accessibility audit process

**Process Improvements:**
- Estimation accuracy (track actual vs estimated)
- PR review feedback patterns
- Deployment checklist
- Rollback procedures

**Knowledge Gaps:**
- Third-party library patterns (e.g., OpenAPI, Ecto)
- Framework conventions (Phoenix, Next.js)
- Project-specific patterns (Atomic Design, context boundaries)

## Anti-Patterns to Avoid

**❌ Vague findings:**
```
What went poorly: "Things were slow"
```

**✅ Specific findings:**
```
What went poorly: "Spent 30 min finding OpenAPI schema examples (happens on every new endpoint)"
```

---

**❌ No prioritization:**
```
Actions:
- Create 5 new skills
- Update all documentation
- Change entire process
```

**✅ Focused prioritization:**
```
Top Action: Create api-schema-patterns skill (saves 1 hour/week, high frequency)
Backlog: Update CLAUDE.md with findings (low urgency)
```

---

**❌ Analysis without action:**
```
Finding: We should document API patterns better
Action: (none)
```

**✅ Analysis with clear action:**
```
Finding: Spent 30 min on OpenAPI schemas
Action: Create api-schema-patterns skill
Next step: Run `skill-maker: create api-schema-patterns skill`
```

---

**❌ Blaming individuals:**
```
What went poorly: "Developer forgot to add tests"
```

**✅ Identifying system gaps:**
```
What went poorly: "Edge case wasn't considered - no checklist exists"
Action: Create edge-case-checklist skill to prompt during PLAN phase
```

## Quality Standards

**Every retrospective should:**
- ✅ Identify at least 3 successes (even in difficult work)
- ✅ Identify at least 2 improvement areas (even in smooth work)
- ✅ Prioritize using objective scoring (Frequency × Impact × Effort)
- ✅ Recommend maximum 3 actions (prevent overwhelm)
- ✅ Provide concrete next steps (skill name, file to edit, specific change)
- ✅ Be completed within 10 minutes (keep it lightweight)

**Red flags (incomplete retro):**
- Only lists positives (not honest about gaps)
- Only lists negatives (ignoring what works)
- No prioritization (everything is "high priority")
- No concrete actions (vague suggestions only)
- Recommends creating 5+ skills at once (unsustainable)

## Tools and Skills

**Tools:**
- `TodoWrite` - Track retro analysis steps
- `Bash` - Review git log, PR details
- `Grep` - Search for related patterns
- `Read` - Review changed files
- MCP GitHub tools - Fetch PR details, commit history
- MCP Atlassian tools - Fetch Jira tickets

**Related Skills:**
- `skill-maker` - Create skills identified in retro (invoked frequently)
- `bug-fix` - Reference when analyzing bug fix work
- `tdd` - Reference when analyzing development work
- `vertical-slice` - Reference when analyzing feature work

**Related Agents:**
- @codebase-explorer can help analyze patterns across multiple files
- @business-analyst can help break down complex improvement actions

## Success Criteria

Retrospective is complete when:
- ✅ Successes identified and acknowledged
- ✅ Pain points identified with root causes
- ✅ Skill opportunities prioritized (ranked by score)
- ✅ Top 3 actions recommended with concrete next steps
- ✅ User decides whether to act now or defer
- ✅ If acted: Skills created or changes committed
- ✅ If deferred: Backlog captured in `.claude/retros/`

## Dependencies

**This skill invokes/references:**
- `skill-maker` (frequent: creates skills identified in retro)
- Other skills mentioned in analysis (reference only, not invoked)

**This skill is invoked by:**
- Engineers (after completing work)
- Automatic prompt (after PR merge, bug fix, feature delivery)

**Skill type:** Workflow (Level 2)
**Dependency depth:** 1 (invokes skill-maker which is Meta, but doesn't cascade further)
**Context cost:** ~650 lines (self only, +1,168 if skill-maker invoked)
**Circular risk:** None (skill-maker doesn't reference retro)

## Context Cost

**This skill:**
- Lines: 650
- Type: Workflow (Level 2)

**Dependencies:**
- `skill-maker`: 1,168 lines (frequent - when creating new skills)

**Total context when invoked:**
- Standalone: 650 lines
- With skill-maker: 1,818 lines

**Budget status:**
- Standalone: 🟢 Low cost (good)
- With skill-maker: 🟡 Medium cost (acceptable for improvement workflow)

Workflow skills can invoke Foundation + Definition + Meta skills. Total <2,000 lines ✅

## Usage

**Automatic invocation:**
After PR merge, bug fix, or feature completion, proactively ask:
```
"Would you like to run a retrospective on [what was just completed]?"
```

**Manual invocation:**
```
retro: [optional context]
```

Examples:
```
retro: PR #44 feature flag backend
retro: last week's work
retro: bug fix ES-48641
retro
```
