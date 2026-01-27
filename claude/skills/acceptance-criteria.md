# Acceptance Criteria Skill

You are an acceptance criteria specialist. This skill defines the standard format for writing testable, size-limited acceptance criteria for any software project.

## Purpose

Acceptance criteria (AC) define what "done" means for a story. Well-written AC:
- Are testable (can verify pass/fail)
- Force small scope (3-5 AC max per story)
- Use standard format (GIVEN-WHEN-THEN)
- Include positive and negative cases
- Enable accurate estimation

## Standard Format: GIVEN-WHEN-THEN

**Every acceptance criterion MUST use this format:**

```
GIVEN [initial context/precondition]
WHEN [action/event occurs]
THEN [expected outcome]
AND [additional outcomes, if any]
```

This BDD (Behavior-Driven Development) format ensures:
- ✅ Clear test setup (GIVEN)
- ✅ Specific trigger (WHEN)
- ✅ Measurable result (THEN)
- ✅ Independently testable

---

## Core Rules

### Rule 1: Max 3-5 Acceptance Criteria Per Story

**Why:** More than 5 AC indicates story is too large.

✅ **Good** (3 AC):
```
Story: Search users by name

AC1:
GIVEN I am on the search page
WHEN I enter "John" in the name field AND click Search
THEN I see users with "John" in their name
AND results are limited to 25 per page
AND results are sorted alphabetically by name

AC2:
GIVEN I am on the search page
WHEN I submit an empty name field
THEN I see all users (no filtering)
AND results are limited to 25 per page

AC3:
GIVEN I am on the search page
WHEN I enter "xyz123" (no matches)
THEN I see "No users found" message
AND I see an empty results list
```

❌ **Bad** (8 AC - story too large):
```
Story: User search with filters

AC1: Search by name
AC2: Search by location
AC3: Search by role
AC4: Combine filters with AND logic
AC5: Pagination (25 per page)
AC6: Sort by name
AC7: Sort by location
AC8: Empty state handling

→ This should be 4-5 separate stories!
```

### Rule 2: Each AC Must Be Independently Testable

**Why:** AC should not depend on other AC being tested first.

✅ **Good** (Independent):
```
AC1: Can create user with name and email
AC2: Cannot create user without email
AC3: Cannot create user with invalid email format
```
Each can be tested in isolation.

❌ **Bad** (Dependent):
```
AC1: Create a user
AC2: Edit the user's email
AC3: Delete the user
```
AC2 and AC3 depend on AC1 succeeding. Split into separate stories.

### Rule 3: Include Both Positive and Negative Cases

**Why:** Edge cases and validation are part of the behavior.

✅ **Good** (Both cases):
```
AC1 (Positive):
GIVEN I am on the user registration form
WHEN I submit with valid name and email
THEN user account is created
AND I see success message
AND I am redirected to user profile page

AC2 (Negative - missing field):
GIVEN I am on the user registration form
WHEN I submit without an email
THEN I see "Email is required" error
AND form is not submitted
AND I remain on the form page

AC3 (Negative - invalid format):
GIVEN I am on the user registration form
WHEN I submit with invalid email format
THEN I see "Email must be valid" error
AND form is not submitted
```

❌ **Bad** (Only happy path):
```
AC1:
GIVEN I am on the user registration form
WHEN I submit with name and email
THEN user account is created
```
Missing validation cases!

### Rule 4: AC Must Be User-Facing Behavior

**Why:** AC describes what the user experiences, not implementation.

✅ **Good** (User behavior):
```
GIVEN I am viewing a user profile
WHEN I click the Delete button
THEN I see a confirmation dialog
AND when I confirm, the user is deleted
AND I am redirected to the users list
```

❌ **Bad** (Implementation details):
```
GIVEN the database has a users table
WHEN the DELETE API endpoint is called
THEN the user row is soft-deleted
AND deleted_at timestamp is set
```
This is implementation, not user-facing AC!

---

## Writing Process

### Step 1: Identify the User Story

Start with a user story in this format:
```
As a [user type]
I want to [action]
So that [benefit]
```

**Example:**
```
As a system administrator
I want to search for users by name
So that I can quickly find a specific user
```

### Step 2: List Expected Behaviors

What should happen? What shouldn't happen?

**Example:**
- Search with name returns matching users
- Search is case-insensitive
- Empty search shows all users
- No results shows empty state
- Results are paginated (25 per page)
- Results are sorted alphabetically

### Step 3: Write GIVEN-WHEN-THEN for Each

**Transform behaviors into AC format:**

```
AC1: Successful name search
GIVEN I am on the users search page
WHEN I enter "Smith" in the name field AND click Search
THEN I see users with "Smith" in their name
AND search is case-insensitive
AND results show max 25 users per page
AND results are sorted alphabetically

AC2: Empty search returns all
GIVEN I am on the users search page
WHEN I submit without entering a name
THEN I see all users
AND results show max 25 users per page

AC3: No results found
GIVEN I am on the users search page
WHEN I search for "XYZ999" (no matches)
THEN I see "No users found" message
AND I see an empty results list
```

### Step 4: Review for Size

**Count your AC. If >5, story is too large.**

Split using vertical-slice patterns:
- By data variation (name search → separate from location search)
- By operation (search → separate from create/update/delete)
- By complexity (happy path → separate from edge cases)

**If story >4 hours estimated:** Invoke `story-splitting` skill.

---

## Size Estimation with AC

Use AC count to estimate story size:

**1-2 AC:** ~2 hours (XS)
- Single behavior, minimal edge cases
- Example: "Display user name and email"

**3-4 AC:** ~3-4 hours (S)
- Multiple related behaviors
- Example: "Search users by name"

**5 AC:** ~5-6 hours (M - borderline, consider splitting)
- Complex behavior with many edge cases
- Example: "Create user with validations"

**6+ AC:** >6 hours (L - MUST SPLIT)
- Story is too large
- Invoke `story-splitting` skill

**Estimation Rule:**
```
If AC count > 5 OR estimated hours > 4:
  → Invoke story-splitting skill
  → Create multiple smaller stories
```

---

## Examples: Good vs Bad AC

### Example 1: User Registration

✅ **Good AC** (3 criteria, testable, 3 hours):
```
Story: Create user account with name and email

AC1: Successful creation
GIVEN I am on the create user form
WHEN I enter name "John Doe" AND email "john@example.com"
AND I click Create
THEN user account is created
AND I see "Account created successfully" message
AND I am redirected to the user profile page

AC2: Missing required field
GIVEN I am on the create user form
WHEN I click Create without entering email
THEN I see "Email is required" error
AND form is not submitted

AC3: Invalid email format
GIVEN I am on the create user form
WHEN I enter email "notanemail"
AND I click Create
THEN I see "Email must be valid format" error
AND form is not submitted
```

❌ **Bad AC** (Too vague, not testable):
```
Story: Create user

AC1: User can create an account
AC2: Form validates inputs
AC3: User is saved to database
```
Problems:
- Not in GIVEN-WHEN-THEN format
- "Can create" - what inputs? what happens?
- "Validates" - which validations?
- "Saved to database" - implementation detail, not user-facing

### Example 2: User Search

✅ **Good AC** (4 criteria, specific, 4 hours):
```
Story: Search users by name only

AC1: Successful search with results
GIVEN I am on the users page
WHEN I enter "Smith" in the name search field
AND I click Search
THEN I see users with "Smith" in their name (case-insensitive)
AND I see max 25 results per page
AND results are sorted alphabetically by last name

AC2: Search with no results
GIVEN I am on the users page
WHEN I search for "XYZ999" (no matches)
THEN I see "No users found" message
AND I see empty results list

AC3: Empty search shows all
GIVEN I am on the users page
WHEN I click Search without entering a name
THEN I see all users (unfiltered)
AND I see max 25 results per page

AC4: Search is case-insensitive
GIVEN I am on the users page
WHEN I search for "SMITH" (uppercase)
THEN I see same results as searching "smith" (lowercase)
```

❌ **Bad AC** (Too large - 8 criteria, 8+ hours):
```
Story: User search

AC1: Search by name
AC2: Search by location
AC3: Search by role
AC4: Search by status
AC5: Combine filters with AND logic
AC6: Pagination works
AC7: Sort by name
AC8: Sort by location

→ This is 4-5 separate stories!
Slice 1: Search by name only
Slice 2: Search by location only
Slice 3: Search by role only
Slice 4: Combine filters
Slice 5: Sorting options
```

### Example 3: User Update

✅ **Good AC** (3 criteria, 3 hours):
```
Story: Update user email

AC1: Successful email update
GIVEN I am viewing a user profile
WHEN I click Edit, change email to "new@example.com", and click Save
THEN email is updated
AND I see "Profile updated successfully" message
AND I see the new email displayed

AC2: Cannot update to invalid email
GIVEN I am editing a user profile
WHEN I change email to "notvalid" AND click Save
THEN I see "Email must be valid format" error
AND email is not updated

AC3: Cannot update to duplicate email
GIVEN another user exists with email "existing@example.com"
WHEN I update current user's email to "existing@example.com"
THEN I see "Email already in use" error
AND email is not updated
```

---

## Checklist for Writing AC

Before finalizing AC, verify:

✅ **Format:**
- [ ] Uses GIVEN-WHEN-THEN format
- [ ] Each clause is clear and specific
- [ ] No ambiguous words ("properly", "correctly", "as expected")

✅ **Scope:**
- [ ] Story has 3-5 AC max
- [ ] Each AC is independently testable
- [ ] No AC dependencies on other AC

✅ **Coverage:**
- [ ] Includes positive (happy path) cases
- [ ] Includes negative (validation) cases
- [ ] Includes edge cases (empty, missing, invalid)

✅ **User-Facing:**
- [ ] Describes user behavior, not implementation
- [ ] No mention of database, API, or code
- [ ] Testable from UI perspective

✅ **Size:**
- [ ] Estimated < 4 hours
- [ ] If > 4 hours, invoke `story-splitting`

---

## Integration with Other Skills

### For Business Analysts

**When creating stories:**
```
1. Write user story (As a... I want... So that...)
2. List expected behaviors
3. Write AC using this skill's format
4. Count AC - if >5, invoke `story-splitting`
5. Estimate hours - if >4, invoke `story-splitting`
6. Create Jira story with AC
```

**Use with:**
- `vertical-slice` - Ensure AC fits in <300 line PR
- `story-splitting` - Split if AC count > 5
- `story-estimation` - Convert AC count to hours

### For Engineers

**Before starting implementation:**
```
1. Read story AC (in GIVEN-WHEN-THEN format)
2. Understand exact behavior expected
3. Write tests that match each AC
4. Implement to pass AC tests
```

**Use with:**
- `tdd` - Write tests matching AC, then implement
- `scope-creep-detector` - AC defines scope boundary

### For QA

**When verifying story:**
```
1. Read each AC
2. Test exactly what's described
3. Verify GIVEN setup works
4. Trigger WHEN action
5. Confirm THEN outcome
6. All AC must pass to accept story
```

**Use with:**
- `definition-of-done` - AC passing is part of DoD

---

## Common Mistakes to Avoid

**❌ Mistake 1: Too vague**
```
AC: User can search for users
```
✅ **Fix:** Be specific
```
GIVEN I am on the users page
WHEN I enter "Smith" in the name field AND click Search
THEN I see users with "Smith" in their name
```

**❌ Mistake 2: Implementation details**
```
AC:
GIVEN database has users table
WHEN GET /api/users is called with ?name=Smith
THEN SQL query filters by LIKE '%Smith%'
```
✅ **Fix:** User-facing behavior
```
GIVEN I am on the users page
WHEN I search for "Smith"
THEN I see users with "Smith" in their name
```

**❌ Mistake 3: Multiple behaviors in one AC**
```
AC: User can create, edit, and delete users
```
✅ **Fix:** Separate AC per behavior (or separate stories)
```
Story 1: Create user
  AC1: Successful creation
  AC2: Validation errors

Story 2: Edit user
  AC1: Successful edit
  AC2: Validation errors

Story 3: Delete user
  AC1: Successful deletion
  AC2: Confirmation dialog
```

**❌ Mistake 4: No negative cases**
```
AC: User can create an account
```
✅ **Fix:** Add validation cases
```
AC1: Successful creation with valid data
AC2: Cannot create without required email
AC3: Cannot create with invalid email format
```

---

## Dependencies

**This skill invokes/references:**
- `vertical-slice` (conditional: if AC count >5, suggests invoking for splitting patterns)

**This skill is invoked by:**
- `@business-analyst` (for story creation and AC writing)
- `@product-manager` (for requirements definition)

**Skill type:** Definition (Level 1)
**Dependency depth:** 1 (may conditionally reference vertical-slice)
**Context cost:** ~587 lines (self only, +544 if vertical-slice invoked)
**Circular risk:** None (vertical-slice doesn't reference this back)

---

## Context Cost

**This skill:**
- Lines: 550
- Type: Definition (Level 1)

**Dependencies:**
- `vertical-slice`: 508 lines (conditional - only if story >5 AC)

**Total context when invoked:**
- Standalone: 550 lines
- With vertical-slice: 1,058 lines

**Budget status:**
- Standalone: 🟢 Low cost (good)
- With dependency: 🟡 Medium cost (acceptable)

Definition skills should remain <700 lines and only reference Foundation/Definition skills.

---

## Success Criteria

Acceptance criteria are well-written when:
- ✅ Use GIVEN-WHEN-THEN format consistently
- ✅ Story has 3-5 AC (not more)
- ✅ Each AC is independently testable
- ✅ Include positive and negative cases
- ✅ User-facing (no implementation details)
- ✅ Specific and measurable
- ✅ Story can be estimated <4 hours

---

## Usage

Invoke this skill when:
- BA is creating new Jira stories
- PM is writing feature requirements
- AC format is unclear or inconsistent
- Story scope needs validation

```
acceptance-criteria: write AC for user search by name
```

This skill is referenced by:
- `story-splitting` - Uses AC count to detect large stories
- `story-estimation` - Estimates hours based on AC count
- `definition-of-done` - All AC must pass
- `@business-analyst` - For story creation
