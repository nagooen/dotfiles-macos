# Vertical Slice Skill

You are a vertical slice specialist for the Provider Directory project. This skill defines what constitutes a proper vertical slice with enforced size constraints for reviewable pull requests.

## Purpose

A vertical slice is a complete, independently deployable feature increment that:
- Spans all layers (Database → Backend → Frontend)
- Delivers one specific user-facing behavior
- Can be reviewed in <30 minutes
- Is small enough to merge quickly (<300 lines)

This skill enforces **small, reviewable PRs** by defining concrete limits.

## The Vertical Slice Definition

### Core Principle
**One slice = One user behavior = One PR = <300 lines changed**

A vertical slice must be:
1. **Vertical** - Touches all necessary layers
2. **Complete** - Fully implements one behavior
3. **Independent** - Can deploy without other slices
4. **Testable** - Has end-to-end tests
5. **Reviewable** - Can review in <30 minutes

---

## Hard Constraints

### Size Limits (Enforced)

**Maximum changes per PR:**
- ✅ **Lines changed:** <300 (hard limit)
- ✅ **Files changed:** <15
- ✅ **Commits:** 3-10 (tells clear story)
- ✅ **Review time:** <30 minutes

**If exceeded:**
- ❌ PR is too large, must split into multiple PRs
- ❌ Cannot proceed until split
- ❌ Use splitting strategies (see below)

### Scope Limits

**One slice should:**
- ✅ Implement ONE user behavior
- ✅ Have 3-5 acceptance criteria max
- ✅ Take 2-4 hours to implement
- ✅ Include tests for that behavior only

**One slice should NOT:**
- ❌ Implement multiple features at once
- ❌ Include refactoring not related to the behavior
- ❌ Add "while I'm here" improvements
- ❌ Implement future stories early

---

## What Makes a Slice "Vertical"

### Required Layers

A vertical slice touches only the layers needed for one behavior:

**Example: "Search providers by name"**

✅ **Touches these layers:**
```
Database Layer:
- No schema changes (providers table exists)

Backend Layer:
- GET /api/providers?name=query endpoint
- ProvidersController.index/2 with name filter
- Providers.list_providers/1 with name query
- Tests for name filtering

Frontend Layer:
- SearchForm component with name input
- API call to /api/providers?name=query
- Display results list
- Tests for search behavior
```

❌ **Does NOT touch:**
- Location filtering (different slice)
- Service filtering (different slice)
- Pagination (different slice, unless required for AC)
- Provider creation (different feature)

### Dependency Rule

**A slice can depend on previous slices but not future ones:**

✅ **Good dependency:**
```
Slice 1: Create provider (name only)
Slice 2: Add email to provider
Slice 3: Add phone to provider
```

❌ **Bad dependency:**
```
Slice 1: Search providers by name AND location (too big)
Slice 2: Create provider (should come first!)
```

---

## What Makes a Slice "Reviewable"

### Reviewer Can Answer These in <30 Minutes:

1. **What does this do?** (Clear from PR title and description)
2. **Does it meet AC?** (All criteria from story covered)
3. **Is it tested?** (Tests for all AC present and passing)
4. **Is it safe?** (No security issues, proper validation)
5. **Is it maintainable?** (Follows project patterns, clear naming)

### PR Must Include:

✅ **Clear description:**
```markdown
## Story
[ES-XXXXX] Search providers by name

## What Changed
- Added name parameter to GET /api/providers
- Backend filters providers by name (case-insensitive)
- Frontend search form with name input
- Results update on form submit

## Acceptance Criteria Met
- ✅ AC1: Search by name returns matching providers
- ✅ AC2: Search is case-insensitive
- ✅ AC3: Empty search returns all providers

## Testing
- 5 backend tests (name filtering, case-insensitive, empty query)
- 3 frontend tests (form submission, results display, empty state)
```

✅ **Link to Jira story** (shows AC and scope)
✅ **All tests pass** (CI green)
✅ **No unrelated changes** (scope creep detector passed)

---

## Vertical Slice Patterns

### Pattern 1: CRUD Operation Slicing

**Don't:** Implement all CRUD in one PR
**Do:** One operation per slice

```
❌ Bad: "Implement provider CRUD" (500+ lines)

✅ Good:
Slice 1: Create provider (name, email only) - 150 lines
Slice 2: Read provider by ID - 80 lines
Slice 3: Update provider - 120 lines
Slice 4: Delete provider - 100 lines
```

### Pattern 2: Field-by-Field Slicing

**Don't:** Add all fields at once
**Do:** Start with minimal fields, add incrementally

```
❌ Bad: "Provider with all fields" (400+ lines)

✅ Good:
Slice 1: Provider with name and email (core fields) - 150 lines
Slice 2: Add phone and bio fields - 100 lines
Slice 3: Add location field - 120 lines
Slice 4: Add services array - 150 lines
```

### Pattern 3: Search Filter Slicing

**Don't:** Implement all filters together
**Do:** One filter per slice

```
❌ Bad: "Provider search with all filters" (600+ lines)

✅ Good:
Slice 1: Search by name - 150 lines
Slice 2: Search by location - 180 lines
Slice 3: Search by service - 160 lines
Slice 4: Combine filters (AND logic) - 100 lines
```

### Pattern 4: Happy Path First

**Don't:** Implement all edge cases at once
**Do:** Happy path first, edge cases in later slices

```
❌ Bad: "Provider creation with all validations" (350+ lines)

✅ Good:
Slice 1: Create provider (happy path, basic validation) - 150 lines
Slice 2: Email format validation - 80 lines
Slice 3: Duplicate email detection - 100 lines
Slice 4: Phone format validation - 70 lines
```

### Pattern 5: API First, Then UI

**Don't:** Build full stack in one go
**Do:** API endpoint first, UI in separate slice (if >300 lines combined)

```
❌ Bad: "Provider search API + UI" (450 lines)

✅ Good:
Slice 1: Provider search API with tests - 200 lines
Slice 2: Provider search UI with tests - 180 lines
```

**Note:** For small features (<300 lines total), keep API + UI together.

---

## Splitting Strategies

### When a Slice is Too Large (>300 Lines)

**Use these strategies to split:**

**1. Split by Layer** (if total >300 lines)
- Slice A: Backend API only
- Slice B: Frontend UI only

**2. Split by Data Variation**
- Slice A: Search by name
- Slice B: Search by location
- Slice C: Search by service

**3. Split by Operation**
- Slice A: Create
- Slice B: Read
- Slice C: Update
- Slice D: Delete

**4. Split by Test Scenario**
- Slice A: Happy path only
- Slice B: Validation errors
- Slice C: Edge cases

**5. Split by Complexity**
- Slice A: Simple version (core behavior)
- Slice B: Add complexity (filters, sorting)
- Slice C: Add polish (pagination, loading states)

---

## Examples: Good vs Bad Slicing

### Example 1: Provider Search

❌ **Bad Slice** (Too Large - 650 lines):
```
Title: "Implement provider search"

Changes:
- Search by name, location, service (3 filters)
- Pagination (25 per page)
- Sorting (by name, date)
- Loading states
- Error handling
- Empty states
- Search debouncing
- URL query params
- Backend tests (20)
- Frontend tests (15)

Total: 650 lines, 18 files
Review time: 90 minutes
```

✅ **Good Slices** (Split into 4):
```
Slice 1: "Search providers by name" - 150 lines
- Name filter only
- Returns all results (no pagination yet)
- Basic loading state
- 5 backend tests, 3 frontend tests
Review time: 20 minutes

Slice 2: "Add location filter to search" - 180 lines
- Location filter (combines with name using AND)
- 6 backend tests, 4 frontend tests
Review time: 25 minutes

Slice 3: "Add pagination to search" - 120 lines
- Pagination (25 per page)
- URL query params for page
- 4 backend tests, 3 frontend tests
Review time: 18 minutes

Slice 4: "Add service filter to search" - 140 lines
- Service filter (combines with name and location)
- 5 backend tests, 3 frontend tests
Review time: 20 minutes
```

### Example 2: Provider CRUD

❌ **Bad Slice** (Too Large - 580 lines):
```
Title: "Implement provider CRUD"

Changes:
- Create provider (all fields)
- Read provider
- Update provider
- Delete provider
- All validations
- OpenAPI specs
- Backend tests (25)
- Frontend forms and displays (12 components)

Total: 580 lines, 22 files
Review time: 2 hours
```

✅ **Good Slices** (Split into 3):
```
Slice 1: "Create provider with core fields" - 200 lines
- POST /api/providers (name, email only)
- Basic validations
- OpenAPI spec
- 8 backend tests
- Frontend form (simple)
- 4 frontend tests
Review time: 28 minutes

Slice 2: "Read and display provider" - 150 lines
- GET /api/providers/:id
- OpenAPI spec
- 5 backend tests
- Frontend detail page
- 3 frontend tests
Review time: 22 minutes

Slice 3: "Update provider" - 180 lines
- PUT /api/providers/:id
- OpenAPI spec
- 7 backend tests
- Frontend edit form
- 4 frontend tests
Review time: 26 minutes

Slice 4: "Delete provider" - 100 lines
- DELETE /api/providers/:id
- Soft delete
- 4 backend tests
- Frontend delete button with confirmation
- 2 frontend tests
Review time: 15 minutes
```

---

## Integration with Other Skills

### For Business Analysts

**When planning features:**
```
1. Read feature requirements
2. Invoke: feature-breakdown (epic → stories)
3. For each story, apply vertical-slice principles:
   - Check size estimate
   - If >300 lines, split using patterns above
   - Ensure each slice is truly vertical
4. Create Jira stories for each slice
```

**Use with:**
- `story-splitting` - To split large stories
- `acceptance-criteria` - To define slice scope
- `story-estimation` - To estimate slice size

### For Engineers

**When implementing:**
```
1. Read story and acceptance criteria
2. Review vertical-slice definition (this file)
3. Implement using TDD (invoke tdd skill)
4. During implementation:
   - Monitor line count (stay <300)
   - Use scope-creep-detector
5. Before PR:
   - Invoke pr-size-check
   - If >300 lines, split into multiple PRs
```

**Use with:**
- `tdd` - For implementation
- `scope-creep-detector` - To prevent bloat
- `pr-size-check` - Before creating PR

### For QA

**When reviewing PRs:**
```
1. Check size first (lines changed <300)
2. If too large, reject with comment:
   "PR exceeds 300 line limit. Please split using vertical-slice patterns."
3. Verify slice is truly vertical
4. Check all AC from story are met
5. Ensure no unrelated changes
```

**Use with:**
- `definition-of-done` - Completion criteria
- `code-review-checklist` - Structured review

---

## Measuring Success

### Metrics to Track

**Per PR:**
- Lines changed (target: <300)
- Review time (target: <30 min)
- Time to merge (target: <24 hours)

**Per Sprint:**
- Average PR size (target: 150-250 lines)
- PRs merged (target: 15-25 per sprint)
- PRs rejected for size (target: <10%)

### Red Flags

❌ **PR size creeping up:**
- Average >300 lines → Need better slicing at planning
- Many rejections → Engineers not following vertical-slice

❌ **Long review times:**
- >30 min average → PRs still too complex
- >48 hours to merge → Process bottleneck

❌ **Scope creep detected:**
- Unrelated changes in PRs → Invoke scope-creep-detector more
- Refactoring in feature PRs → Separate refactoring PRs

---

## Common Questions

**Q: What if the smallest possible slice is >300 lines?**
A: Very rare. Use field-by-field or layer splitting. If truly unavoidable, get approval from tech lead and split review across 2 sessions.

**Q: Can I include refactoring in a feature slice?**
A: Only if directly required for the feature. Otherwise, separate refactoring PR first, then feature PR.

**Q: What about bug fixes?**
A: Same rules apply. Use bug-fix skill, but keep fix <300 lines. If larger, fix is probably doing too much.

**Q: Should tests count toward 300 line limit?**
A: Yes. Tests are part of the slice. If tests push you over 300, slice is too big.

**Q: What if CI/CD changes are needed?**
A: Separate PR for infrastructure changes, then feature PR.

---

## Dependencies

**This skill invokes/references:**
- None (Definition skill - defines standards, doesn't invoke others)

**This skill is invoked by:**
- `pr-size-check` (to guide splitting when PR too large)
- `acceptance-criteria` (conditional: if story >4 hours, mentions splitting)
- `@business-analyst` (for feature planning and slice definition)
- `@full-stack-engineer` (for understanding slice constraints)

**Skill type:** Definition (Level 1)
**Dependency depth:** 0 (defines standards, doesn't invoke)
**Context cost:** ~544 lines (self only)
**Circular risk:** None (only provides definitions, never invokes)

---

## Context Cost

**This skill:**
- Lines: 508
- Type: Definition (Level 1)

**Dependencies:**
- None (definition skill)

**Total context when invoked:**
508 lines

**Budget status:** 🟢 Low cost (good)

Definition skills should remain <700 lines and only reference Foundation skills if needed.

---

## Success Criteria

A vertical slice is well-defined when:
- ✅ Size constraints are enforced (<300 lines)
- ✅ Slice spans only necessary layers
- ✅ One user behavior implemented
- ✅ Independently deployable
- ✅ Reviewable in <30 minutes
- ✅ All acceptance criteria met
- ✅ Tests included and passing
- ✅ No unrelated changes

---

## Usage

Invoke this skill when:
- BA is planning features (to understand slicing)
- Engineer is starting implementation (to understand scope)
- PR is being reviewed (to verify size)
- Teaching team about small PRs

```
vertical-slice: explain how to slice provider search feature
```

This skill is referenced by:
- `story-splitting` - Uses these patterns to split stories
- `pr-size-check` - Enforces these size limits
- `scope-creep-detector` - Detects violations of these rules
- `@business-analyst` - For feature planning
- `@full-stack-engineer` - For implementation guidance
