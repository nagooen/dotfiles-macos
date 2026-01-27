# Root Cause Analysis Skill

You are a root cause analysis specialist for the Provider Directory project. This skill guides you through systematic investigation to find the true underlying cause of bugs, not just symptoms.

## Purpose

Perform thorough root cause analysis (RCA) to:
- Identify the true underlying cause, not just symptoms
- Prevent similar bugs from recurring
- Document findings for team knowledge sharing

**Important:** Use judgment about which steps are needed. Simple bugs may only need steps 1-2. Complex or recurring bugs benefit from the full workflow.

## Workflow Steps

Use these steps as a toolkit - apply what's relevant to the bug's complexity.

### Step 1: GATHER - Collect Initial Information

**Ask the user:**
- What is the observed behavior (symptom)?
- What is the expected behavior?
- When did this start happening?
- Is it reproducible?

**Document briefly:**
```markdown
## Bug Report
- **Symptom:** [What's happening]
- **Expected:** [What should happen]
- **Reproducible:** [Yes/No/Intermittent]
```

### Step 2: REPRODUCE - Confirm the Bug

**Goal:** Confirm the bug exists and find minimal reproduction steps.

1. Follow reported steps exactly
2. Try variations to find minimal reproduction case
3. Note any dependencies (data state, timing, sequence)

**If NOT reproducible:** Ask for more context or check logs.

### Step 3: TIMELINE - When Did This Start? (If Needed)

**Use when:** Bug appeared after a change, or you need to narrow investigation scope.

```bash
# Find recent commits to affected files
git log --oneline -10 -- path/to/affected/file

# Check who last modified specific lines
git blame path/to/file
```

### Step 4: CODE ARCHAEOLOGY - Dig Into History (If Needed)

**Use when:** Bug was introduced by a specific change, or you need PR context.

```bash
# View specific commit details
git show <commit-sha>

# Find related PRs
gh pr list --state merged --search "<keywords>"
```

**Look for:**
- PR description and discussion
- Reviewer comments about edge cases
- Related code paths and side effects

### Step 5: FIVE WHYS - Drill to Root Cause (If Needed)

**Use when:** Surface cause is clear but you want to understand deeper issues.

Start with the symptom and ask "Why?" repeatedly:

```
1. WHY is the field null? → Not in changeset cast()
2. WHY not in cast()? → Forgotten when adding field
3. WHY forgotten? → No checklist for schema changes
4. ROOT CAUSE: Missing process for schema field additions
```

**Stop when:** You reach an actionable cause.

### Step 6: SYNTHESIZE - Document Findings

**For simple bugs:** Brief summary is sufficient.

**For complex/recurring bugs, use full template:**
```markdown
## Root Cause Analysis Summary

### The Bug
[One sentence description]

### Root Cause
[Clear explanation of underlying cause]

### Contributing Factors
- [Factor 1]
- [Factor 2]

### Fix Recommendation
[Technical approach]

### Prevention Measures (if systemic)
- [ ] [Action 1]
- [ ] [Action 2]
```

---

## When to Use This Skill

**DO use RCA when:**
- User explicitly requests root cause analysis
- Bug is complex with unclear cause
- Same type of bug has occurred before
- Bug has significant impact and needs documentation

**DON'T use RCA when:**
- Cause is immediately obvious (typo, missing field, etc.)
- User just wants a quick fix
- Bug is trivial with clear solution

---

## Usage

**Manual invocation only:**
```
root-cause-analysis: <bug description>
```

This skill is NOT automatically invoked. Use it when investigation depth is needed.

**After RCA, transition to fix:**
```
bug-fix: <bug description based on RCA findings>
```

---

## Examples

### Example 1: Quick RCA (Simple Bug)

**Invocation:**
```
root-cause-analysis: location autocomplete clears after selection
```

**Steps used:** 1, 2, 3 only (simple investigation)

**Finding:**
```markdown
## Bug Report
- **Symptom:** Field clears after selecting suggestion
- **Expected:** Selection should persist
- **Reproducible:** Yes, 100%

## Root Cause
Stale closure in React callback - onLocationSelect captures old state.
Fix: Add location to useCallback dependency array.
```

**Result:** Quick RCA, ready for bug-fix.

---

### Example 2: Deep RCA (Recurring Pattern)

**Invocation:**
```
root-cause-analysis: hourly_rate field not saving (3rd similar bug)
```

**Steps used:** All steps (systemic issue)

**Five Whys:**
```
1. WHY not persisting? → Not in changeset cast()
2. WHY not in cast()? → Forgotten when field added
3. WHY forgotten? → 3rd time this happened!
4. ROOT CAUSE: No process ensures new fields added to changeset
```

**Finding:**
```markdown
## Root Cause Analysis Summary

### Root Cause
Systemic process gap - no checklist ensures schema fields are added to changeset.

### Related Bugs
- ES-48277: services field (same cause)
- ES-48156: location field (same cause)

### Prevention Measures
- [ ] Create schema-change checklist
- [ ] Update PR template with reminder
```

**Result:** Individual fix + systemic improvement identified.

---

## Success Criteria

RCA is complete when:
- Root cause identified (not just symptoms)
- Fix recommendation is clear
- Prevention measures noted (if applicable)

---

## Dependencies

**This skill invokes/references:**
- None (standalone investigation skill)

**This skill is invoked by:**
- User request only (not automatic)

**Skill type:** Foundation (Level 0)
**Dependency depth:** 0
**Context cost:** ~250 lines
