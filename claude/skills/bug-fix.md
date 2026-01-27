# Bug Fix Skill

You are a bug fixing specialist. Follow this workflow to fix bugs systematically using TDD and quality gates.

## Workflow Steps

### 1. IDENTIFY - Understand the Bug
- Ask user to describe the bug symptoms
- Reproduce the bug if possible (steps to reproduce)
- Investigate code to identify root cause
- Document affected files with line numbers

**For complex or recurring bugs:** If the cause isn't immediately clear, invoke `root-cause-analysis` skill first.

### 2. CHECK JIRA - Verify Ticket Exists
**CRITICAL:** Ask user: "Does a Jira ticket already exist for this bug?"

**If YES:**
- Ask for ticket number (e.g., ES-48277)
- Fetch ticket using `mcp__atlassian__getJiraIssue`
- Read ticket details to understand context
- Proceed to step 3

**If NO:**
- Create detailed Jira bug ticket (see requirements below)
- Get ticket number from response
- Proceed to step 3

### 3. CREATE BRANCH - Isolate Bug Fix
- Create git branch: `fix/ES-XXXXX` (using Jira ticket number)
- Switch to the new branch before starting TDD
- Example: `git checkout -b fix/ES-48277`

### 4. FIX - Implement with TDD
**Use the TDD skill to implement the fix:**

Complex bugs may need 2-4 TDD cycles. For each cycle:
- Invoke `tdd` skill or follow RED-GREEN-REFACTOR cycle
- Write failing test that exposes the bug
- Write minimal code to fix
- Refactor while keeping tests green
- Use TodoWrite to track progress

**See:** `.claude/skills/tdd.md` for complete TDD workflow and testing patterns.

### 5. VERIFY - Quality Checks
Run quality verification:
- ✅ All tests pass (green)
- ✅ No linting errors
- ✅ No type errors
- ✅ Coverage ≥90%
- ✅ Test suite <60 seconds

Run your project's verification command (e.g., `make verify`, `npm run verify`, etc.)

**Note:** The @qa-enforcer agent can help with comprehensive verification if needed.

### 6. COMMIT - User Reviews and Commits
- Present green code for user review
- User commits with message format:
  ```
  fix: <short description> (Fixes ES-XXXXX)

  <detailed explanation>

  🤖 Generated with [Claude Code](https://claude.com/claude-code)

  Co-Authored-By: Claude <noreply@anthropic.com>
  ```

### 7. UPDATE JIRA - Mark as Done (After Merge)
**Only after commit is merged to main:**
- Get available transitions: `mcp__atlassian__getTransitionsForJiraIssue`
- Find transition ID for "Done" status
- Execute transition: `mcp__atlassian__transitionJiraIssue`

---

## Jira Bug Ticket Requirements

When creating a Jira ticket, use these fields:

**Required Fields:**
- **Project**: [Your project key] (e.g., ES, PROJ, etc.)
- **Issue Type**: Bug
- **Label**: [Your component label] (optional)
- **Summary**: Clear, concise bug description

**Description Template:**
```markdown
## Summary
[Brief description of the bug]

## Steps to Reproduce
1. [Step 1]
2. [Step 2]
3. [Step 3]

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## Root Cause
[Technical explanation of why bug occurs]

## Affected Files
- file_path:line_number
- file_path:line_number

## Suggested Fix
[How to fix the bug]

## Impact Assessment
- **Severity**: [Critical/High/Medium/Low]
- **User Experience**: [Description]
- **Data Integrity**: [Yes/No - explanation]

## Workaround
[Temporary workaround if available, or "None"]
```

**Jira API Configuration:**
- Load cloudId from `.claude/jira-preferences.local.md`
- Use `mcp__atlassian__createJiraIssue` tool
- Store ticket number for branch creation

---

## Key Principles

1. **NEVER skip Jira ticket** - Even for trivial bugs
2. **NEVER start coding without creating branch** - Isolate bug fixes
3. **ALWAYS use TDD** - Test-first approach catches regressions
4. **ALWAYS verify with QA** - Quality gates prevent broken code
5. **NEVER commit automatically** - User reviews and approves
6. **Update Jira ONLY after merge** - Ticket reflects actual completion

---

## Examples

### Example 1: Bug Fix Succeeds (Field Not Saving)

**Scenario:** Tags field not being saved when creating a record

**User:** "Tags are not being saved when creating a record"

**Process:**

**Step 1: IDENTIFY**
```
Reproduce: Create record with tags array → Check DB → Tags is null
Root cause: Record.changeset/2 missing :tags in cast()
Affected: lib/app/schemas/record.ex:15
```

**Step 2: CHECK JIRA**
```
Ask: "Does a Jira ticket exist?"
User: "No"
Create: ES-48277 - "Tags field not persisted on record creation"
```

**Step 3: CREATE BRANCH**
```bash
git checkout -b fix/ES-48277
```

**Step 4: FIX (TDD Cycle)**

**RED:**
```
test "persists tags array" do
  attrs = %{name: "Item", description: "...", tags: ["urgent", "review"]}
  {:ok, record} = Records.create_record(attrs)
  assert record.tags == ["urgent", "review"]
end
```
Run: **FAILS** (tags is nil)

**GREEN:**
```
def changeset(record, attrs) do
  record
  |> cast(attrs, [:name, :description, :tags])  # Added :tags
  |> validate_required([:name, :description])
end
```
Run: **PASSES** ✅

**REFACTOR:**
No refactoring needed (simple fix)

**Step 5: VERIFY**
```bash
# Run your project's verify command
# All tests pass ✅
# No lint errors ✅
# Coverage 94% ✅
```

**Step 6: COMMIT**
```
User reviews and commits:
"fix: persist tags field on record creation (Fixes ES-48277)"
```

**Step 7: UPDATE JIRA** (after merge to main)
```
Transition ES-48277 to "Done"
```

**Result:**
✅ Bug identified and fixed with TDD
✅ All quality checks passed
✅ Jira ticket created and closed

---

### Example 2: Bug Fix Fails Quality Check (Test Suite Timeout)

**Scenario:** Bug fix causes test suite to exceed 60 second limit

**User:** "Pagination returns incorrect total_pages count"

**Process:**

**Step 1-3:** IDENTIFY → CHECK JIRA → CREATE BRANCH
```
Created: ES-48299
Branch: fix/ES-48299
```

**Step 4: FIX (TDD Cycle)**

**RED:**
```
test "total_pages calculated correctly" do
  insert_list(75, :record)
  {:ok, result} = Records.list_records(%{page: 1, per_page: 25})
  assert result.total_pages == 3
end
```
Run: **FAILS** (returns 2 instead of 3)

**GREEN (Problematic Implementation):**
```
def list_records(%{page: page, per_page: per_page}) do
  # Added expensive query in every call!
  total = Repo.aggregate(Record, :count)
  all_records = Repo.all(Record)  # ❌ Loading ALL records

  data = Enum.slice(all_records, (page - 1) * per_page, per_page)

  {:ok, %{
    data: data,
    total_pages: ceil(total / per_page)
  }}
end
```

Run test: **PASSES** ✅ (but...)

**Step 5: VERIFY (FAILS)**
```bash
# Run your project's verify command
# 96 tests, 0 failures
# Finished in 78.4 seconds ❌

ERROR: Test suite exceeded 60 second limit!
```

**Problem Identified:**
- Loading ALL records into memory (N+1 problem)
- Test suite now too slow

**Recovery - Refactor to Fix Performance:**
```
def list_records(%{page: page, per_page: per_page}) do
  offset = (page - 1) * per_page

  # Use efficient database pagination
  data = Record
    |> limit(^per_page)
    |> offset(^offset)
    |> Repo.all()

  total = Repo.aggregate(Record, :count)

  {:ok, %{
    data: data,
    total_pages: ceil(total / per_page)
  }}
end
```

Run your verify command

**Output:**
```
96 tests, 0 failures
Finished in 2.8 seconds ✅
```

**Step 6: COMMIT**
```
User reviews and commits fixed version
```

**Result after recovery:**
✅ Bug fixed correctly
✅ Performance issue caught by quality gate
✅ Fixed implementation passes all checks

**Key Lesson:** Quality gates (test suite <60s) catch inefficient implementations

---

## Tools and Skills

**Tools:**
- `mcp__atlassian__getJiraIssue` - Fetch existing ticket
- `mcp__atlassian__createJiraIssue` - Create new bug ticket
- `mcp__atlassian__getTransitionsForJiraIssue` - Get available transitions
- `mcp__atlassian__transitionJiraIssue` - Update ticket status
- `TodoWrite` - Track TDD cycle progress
- `make verify` - Run all quality checks

**Related Skills:**
- `root-cause-analysis` - For complex/recurring bugs (invoke before fixing)
- `tdd` - For implementation (RED-GREEN-REFACTOR)
- `pr-size-check` - Before creating PR

**Related Agents:**
- @qa-enforcer can help with comprehensive quality verification

---

## Dependencies

**This skill invokes/references:**
- `tdd` (conditional: if unclear about TDD cycle, for implementation guidance)

**This skill is invoked by:**
- Engineers (when fixing bugs)
- `@backend-engineer` (for backend bug fixes)
- `@frontend-engineer` (for frontend bug fixes)

**Skill type:** Workflow (Level 2)
**Dependency depth:** 1 (may conditionally invoke tdd)
**Context cost:** ~386 lines (self only, +449 if tdd invoked)
**Circular risk:** None (tdd doesn't reference this back)

---

## Context Cost

**This skill:**
- Lines: 386
- Type: Workflow (Level 2)

**Dependencies:**
- `tdd`: 449 lines (conditional - only if unclear about TDD)

**Total context when invoked:**
- Standalone: 386 lines
- With tdd: 835 lines

**Budget status:**
- Standalone: 🟢 Low cost (good)
- With tdd: 🟢 Low cost (good)

Workflow skills can invoke Foundation + Definition skills. Keep total <2,000 lines.

---

## Success Criteria

Bug is fixed when:
- ✅ Jira ticket created/updated
- ✅ Git branch created with ticket number
- ✅ All TDD cycles completed (RED→GREEN→REFACTOR)
- ✅ Quality checks pass (make verify)
- ✅ User reviews and commits code
- ✅ Ticket transitioned to Done after merge
