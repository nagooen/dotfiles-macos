# PR Size Check Skill

You are a pull request size specialist. This skill defines automated checks to ensure PRs are reviewable before creation.

## Purpose

PR size checks are automated gates that prevent oversized, un-reviewable pull requests. This skill:
- Enforces <300 line limit (hard requirement)
- Checks file count, commit quality, scope
- Runs automatically before `gh pr create`
- Guides splitting if PR is too large

**Goal:** Every PR should be reviewable in <30 minutes.

---

## Hard Limits (Enforced)

These limits MUST be met before creating a PR:

### Size Limits

✅ **Lines changed:** <300 (strict)
- Includes additions + deletions
- Includes test files
- Includes documentation

✅ **Files changed:** <15
- Too many files = too much context switching
- Exception: Mass rename/move operations

✅ **Commits:** 3-10 commits
- Too few: Monolithic, hard to review
- Too many: Noisy, unclear story

✅ **Review time estimate:** <30 minutes
- Based on lines changed and complexity
- Rough formula: `(lines / 10) + (files * 2)` minutes

### Quality Limits

✅ **All tests pass**
- Backend: `make test-backend`
- Frontend: `make test-frontend`
- Full suite <60 seconds

✅ **No linting errors**
- `make lint` passes
- Credo strict mode (backend)
- ESLint strict mode (frontend)

✅ **No type errors**
- `make type-check` passes
- TypeScript strict
- Dialyzer passes

✅ **Coverage ≥90%**
- `make coverage` meets threshold
- New code must be tested

---

## Exclusions (Files That Don't Count)

Documentation files are excluded from the 300 line limit because they're much easier to review than code:

**Excluded paths:**
- `README.md` (project README)
- `.claude/` (all Claude Code configuration and skills)
- `docs/` (all human-focused documentation)
- `*.md` files in root directory
- `CHANGELOG.md`, `LICENSE`, `CONTRIBUTING.md`

**Why exclude?**
- Documentation is easier to review (no logic, no tests needed)
- Can scan hundreds of lines quickly
- Different review criteria (clarity, accuracy vs code correctness)

**Calculating adjusted line count:**
```bash
# Get total lines changed
TOTAL=$(git diff main...HEAD --shortstat | awk '{print $4+$6}')

# Get documentation lines changed
DOCS=$(git diff main...HEAD --shortstat -- README.md .claude/ docs/ '*.md' | awk '{print $4+$6}')

# Code lines = Total - Docs
CODE_LINES=$((TOTAL - DOCS))

# Check against limit
if [ "$CODE_LINES" -gt 300 ]; then
  echo "❌ Code changes: $CODE_LINES lines (>300)"
fi
```

**Example:**
```
Total changes: 850 lines
- Documentation: 620 lines (.claude/skills/*.md)
- Code changes: 230 lines ✅

Result: PR passes (230 < 300)
```

---

## Automated Check Process

### When to Run

**Automatically invoke this skill:**
1. Before running `gh pr create`
2. After final commit to feature branch
3. When engineer says "ready for PR"

**Manual invocation:**
```
pr-size-check: verify user search PR is reviewable
```

### Check Sequence

**Step 1: Get PR diff stats (excluding documentation)**
```bash
# Total lines changed
TOTAL=$(git diff main...HEAD --shortstat | awk '{print $4+$6}')

# Documentation lines (excluded)
DOCS=$(git diff main...HEAD --shortstat -- README.md .claude/ docs/ '*.md' | awk '{print $4+$6}')

# Code lines = Total - Documentation
CODE_LINES=$((TOTAL - DOCS))

# Check files changed (excluding docs)
FILES=$(git diff main...HEAD --name-only | grep -v -E '(README\.md|\.claude/|docs/|\.md$)' | wc -l)

# Check commit count
COMMITS=$(git log main...HEAD --oneline | wc -l)

echo "Total: $TOTAL lines (Docs: $DOCS, Code: $CODE_LINES)"
echo "Files changed: $FILES (excluding docs)"
echo "Commits: $COMMITS"
```

**Step 2: Evaluate against limits**

| Metric | Limit | Status | Action if Failed |
|--------|-------|--------|------------------|
| Code lines changed | <300 | ✅ or ❌ | Guide splitting |
| Files changed | <15 | ✅ or ❌ | Identify unrelated changes |
| Commits | 3-10 | ✅ or ❌ | Squash or split |
| Review time | <30 min | ✅ or ❌ | Simplify or split |

**Step 3: Check quality gates**

Run in sequence:
```bash
make test          # All tests pass?
make lint          # No lint errors?
make type-check    # No type errors?
make coverage      # Coverage ≥90%?
```

**Step 4: Check scope alignment**

- Read original story AC (from Jira)
- Compare changed files to story scope
- Detect unrelated changes (scope creep)

**Step 5: Report results**

If ALL checks pass:
```
✅ PR is ready for creation
- Lines changed: 245 (<300 ✅)
- Files changed: 12 (<15 ✅)
- Commits: 5 (3-10 ✅)
- Review time: ~26 min (<30 ✅)
- Tests: PASS ✅
- Linting: PASS ✅
- Type check: PASS ✅
- Coverage: 94% (≥90% ✅)
- Scope: Aligned with story AC ✅

Proceed with: gh pr create
```

If ANY check fails:
```
❌ PR is too large for review

Failed checks:
- Lines changed: 425 (>300 ❌)
- Files changed: 18 (>15 ❌)
- Review time: ~48 min (>30 ❌)

Recommended action: SPLIT INTO MULTIPLE PRS

Suggested split:
PR 1 (Backend): Database + API endpoints (180 lines)
PR 2 (Frontend): UI components + forms (190 lines)

Use vertical-slice patterns to split effectively.
```

---

## Splitting Guidance When PR is Too Large

### If Lines >300 or Files >15

**Use these splitting strategies:**

**Strategy 1: Layer Split (if >300 lines total)**
```
Current PR: 450 lines (DB + Backend + Frontend)

Split into:
PR 1: Backend only (DB + API) - 220 lines
PR 2: Frontend only (UI) - 180 lines
```

**Strategy 2: Feature Split (multiple behaviors)**
```
Current PR: 520 lines (name search + location search)

Split into:
PR 1: Name search only - 240 lines
PR 2: Location search only - 260 lines
```

**Strategy 3: Scope Split (AC-based)**
```
Current PR: 380 lines (create + validation + edge cases)

Split into:
PR 1: Create happy path + basic validation - 190 lines
PR 2: Advanced validation + edge cases - 180 lines
```

**Strategy 4: File Split (unrelated changes)**
```
Current PR: 340 lines (feature + refactoring + docs)

Split into:
PR 1: Refactoring only - 100 lines (merge first)
PR 2: Feature implementation - 220 lines (after PR 1)
PR 3: Documentation update - 20 lines (separate)
```

### If Commits <3 or >10

**Too few commits (<3):**
```
Problem: Monolithic commits, hard to review

Solution: Use interactive rebase to split
git rebase -i HEAD~1
# Split commit into logical chunks
```

**Too many commits (>10):**
```
Problem: Noisy history, unclear story

Solution: Squash related commits
git rebase -i main
# Squash fixups, typos, WIP commits
```

**Ideal commit structure:**
```
1. Add database migration (schema)
2. Implement backend context function
3. Add backend controller endpoint
4. Add frontend API client
5. Implement frontend UI component
6. Add tests for all layers
```

---

## Scope Creep Detection

**Check for unrelated changes:**

**Red flags:**
- Files changed outside story's expected scope
- Refactoring not mentioned in AC
- "While I'm here" improvements
- Fixing bugs unrelated to story
- Updating dependencies

**Example:**

```
Story: Add user name search

Expected files:
✅ backend/contexts/users (search function)
✅ backend/controllers/user_controller (query param)
✅ backend/test/contexts/users_test (tests)
✅ frontend/api/user-api (API client)
✅ frontend/components/UserSearchForm (component)
✅ frontend/tests/UserSearchForm.test (tests)

Unexpected files (scope creep):
❌ backend/contexts/orders (unrelated refactoring)
❌ frontend/components/Button (unrelated improvement)
❌ dependency configuration file (dependency update)

Action: Remove scope creep, create separate PRs
```

---

## Integration with Other Skills

### Before Creating PR

**Engineer's workflow:**
```
1. Implement feature using TDD
2. All tests green
3. Run: pr-size-check
4. If pass: Create PR
5. If fail: Split using vertical-slice patterns
```

### Use With

**`vertical-slice` skill:**
- Provides splitting patterns
- Defines <300 line constraint
- Explains how to split by layer, feature, AC

**`scope-creep-detector` skill (future):**
- Detects unrelated changes
- Compares against story AC
- Identifies refactoring

**`@qa-enforcer` agent:**
- Uses pr-size-check as first gate
- Rejects PRs that fail size check
- Runs quality checks after size check passes

---

## Automated Enforcement (Future)

**CI/CD Integration:**

Create pre-PR check script:
```bash
#!/bin/bash
# .github/scripts/pr-size-check.sh

# Calculate lines excluding documentation
TOTAL=$(git diff main...HEAD --shortstat | awk '{print $4+$6}')
DOCS=$(git diff main...HEAD --shortstat -- README.md .claude/ docs/ '*.md' | awk '{print $4+$6}')
CODE_LINES=$((TOTAL - DOCS))

# Calculate files excluding documentation
FILES=$(git diff main...HEAD --name-only | grep -v -E '(README\.md|\.claude/|docs/|\.md$)' | wc -l)

echo "Total: $TOTAL lines (Docs: $DOCS, Code: $CODE_LINES)"
echo "Files: $FILES (excluding docs)"

if [ "$CODE_LINES" -gt 300 ]; then
  echo "❌ PR too large: $CODE_LINES code lines (>300)"
  exit 1
fi

if [ "$FILES" -gt 15 ]; then
  echo "❌ Too many files: $FILES files (>15)"
  exit 1
fi

echo "✅ PR size check passed"
exit 0
```

**GitHub Actions:**
```yaml
# .github/workflows/pr-size-check.yml
name: PR Size Check

on: pull_request

jobs:
  size-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0
      - name: Check PR size
        run: .github/scripts/pr-size-check.sh
```

---

## Examples

### Example 1: PR Passes All Checks

```
Running pr-size-check for: feature/user-name-search

📊 Size Metrics:
  Lines changed: 245 ✅
  Files changed: 12 ✅
  Commits: 6 ✅
  Review time estimate: 26 min ✅

🎯 Quality Gates:
  Tests: PASS (169 backend + 165 frontend) ✅
  Linting: PASS ✅
  Type check: PASS ✅
  Coverage: 94% (threshold: 90%) ✅

🔍 Scope Check:
  Story: ES-12345 - Search users by name
  Expected files: backend search + frontend form ✅
  Unexpected files: None ✅
  Scope alignment: 100% ✅

✅ PR IS READY FOR CREATION

Recommended PR title:
"feat: add user name search (ES-12345)"

Proceed with:
  gh pr create --title "feat: add user name search (ES-12345)" --body "..."
```

### Example 2: PR Fails Size Check

```
Running pr-size-check for: feature/provider-full-crud

❌ PR TOO LARGE FOR REVIEW

📊 Size Metrics:
  Lines changed: 580 ❌ (limit: 300)
  Files changed: 22 ❌ (limit: 15)
  Commits: 3 ✅
  Review time estimate: 62 min ❌ (limit: 30)

🎯 Quality Gates:
  Tests: PASS ✅
  Linting: PASS ✅
  Type check: PASS ✅
  Coverage: 92% ✅

🔍 Scope Check:
  Story: ES-12346 - Provider CRUD
  Scope creep detected: ❌
    - backend/lib/contexts/services.ex (unrelated)
    - frontend/src/utils/formatter.ts (unrelated)

⚠️  RECOMMENDED ACTION: SPLIT INTO MULTIPLE PRS

Suggested split using CRUD pattern:
  PR 1: Create provider (180 lines)
    - backend: schema, context, controller
    - frontend: create form
    - tests

  PR 2: Read provider (120 lines)
    - backend: get endpoint
    - frontend: detail page
    - tests

  PR 3: Update provider (160 lines)
    - backend: update endpoint
    - frontend: edit form
    - tests

  PR 4: Delete provider (100 lines)
    - backend: delete endpoint
    - frontend: delete button + confirmation
    - tests

Each PR will be <300 lines and reviewable in <30 min.

Invoke: vertical-slice for splitting patterns
```

### Example 3: Scope Creep Detected

```
Running pr-size-check for: feature/provider-search

⚠️  SCOPE CREEP DETECTED

📊 Size Metrics:
  Lines changed: 320 ❌ (limit: 300)
  Files changed: 16 ❌ (limit: 15)

🔍 Scope Check:
  Story: ES-12347 - Search providers by name

  Expected files (in scope):
    ✅ backend/lib/contexts/providers.ex
    ✅ backend/lib/controllers/provider_controller.ex
    ✅ frontend/src/lib/api/provider-api.ts
    ✅ frontend/src/components/organisms/ProviderSearchForm.tsx
    ✅ tests for above

  Unexpected files (out of scope):
    ❌ backend/lib/contexts/services.ex (+45 lines)
       → Refactoring not related to search
    ❌ frontend/src/components/atoms/Button.tsx (+28 lines)
       → Style improvements not in story
    ❌ package.json (+2 lines)
       → Dependency update unrelated

📋 RECOMMENDED ACTION:

1. Revert scope creep changes:
   git checkout main -- backend/lib/contexts/services.ex
   git checkout main -- frontend/src/components/atoms/Button.tsx
   git checkout main -- package.json

2. New size: 245 lines ✅

3. Create separate PRs for scope creep:
   PR A: Refactor services context
   PR B: Improve button styles
   PR C: Update dependencies

4. Then create feature PR (now <300 lines)
```

### Example 4: Documentation PR (Passes Despite Large Size)

```
Running pr-size-check for: claude/add-initial-skills

📊 Size Metrics:
  Total lines changed: 2,047
  Documentation lines: 2,047 (.claude/skills/*.md)
  Code lines: 0 ✅

  Files changed (total): 10
  Files changed (excluding docs): 0 ✅

  Commits: 8 ✅
  Review time estimate: 45 min (docs only, acceptable)

🎯 Quality Gates:
  Tests: PASS (no code changes) ✅
  Linting: PASS ✅
  Type check: PASS ✅
  Coverage: N/A (no code) ✅

🔍 Scope Check:
  Story: Add initial Claude skills
  All changes in .claude/skills/ ✅
  No code changes ✅

✅ PR IS READY FOR CREATION

Note: Documentation-only changes are exempt from 300 line limit.
This PR contains 2,047 lines of documentation which is easier to review
than code. All changes are in .claude/skills/ directory.

Proceed with:
  gh pr create --title "feat: add initial Claude skills" --body "..."
```

---

## Dependencies

**This skill invokes/references:**
- `vertical-slice` (conditional: if PR >300 lines, invokes for splitting patterns)
- `acceptance-criteria` (conditional: for scope alignment checking)

**This skill is invoked by:**
- `@qa-enforcer` (as first quality gate before PR creation)
- Engineers (before creating PR)
- CI/CD pipelines (future automation)

**Skill type:** Workflow (Level 2)
**Dependency depth:** 1 (invokes Definition skills only)
**Context cost:** ~655 lines (self only, +544 or +587 if dependencies invoked)
**Circular risk:** None (invoked skills don't reference this back)

---

## Context Cost

**This skill:**
- Lines: 613
- Type: Workflow (Level 2)

**Dependencies:**
- `vertical-slice`: 508 lines (conditional - only if PR >300 lines)
- `acceptance-criteria`: 550 lines (conditional - only for scope checking)

**Total context when invoked:**
- Standalone: 613 lines
- With vertical-slice: 1,121 lines
- With both: 1,671 lines (rare - only if PR fails both size and scope)

**Budget status:**
- Standalone: 🟢 Low cost (good)
- With vertical-slice: 🟡 Medium cost (acceptable)
- With both: 🟡 Medium cost (acceptable, only when PR has problems)

Workflow skills can invoke Foundation + Definition skills. Keep total <2,000 lines.

---

## Success Criteria

PR is ready when:
- ✅ Code lines changed <300 (documentation excluded)
- ✅ Code files changed <15 (documentation excluded)
- ✅ Commits 3-10 (clear story)
- ✅ Review time <30 minutes
- ✅ All tests pass
- ✅ No linting errors
- ✅ No type errors
- ✅ Coverage ≥90%
- ✅ Scope aligned with story AC
- ✅ No scope creep detected

---

## Usage

**Automatic invocation:**
```
Before creating PR, automatically run:
pr-size-check: verify current branch is reviewable
```

**Manual invocation:**
```
pr-size-check: check if provider search PR meets size requirements
```

**This skill is used by:**
- Engineers before creating PRs
- `@qa-enforcer` as first quality gate
- CI/CD pipelines (future automation)
- Pre-commit hooks (optional)

**References these skills:**
- `vertical-slice` - For splitting patterns
- `acceptance-criteria` - To check scope alignment
- `scope-creep-detector` (future) - To detect unrelated changes
