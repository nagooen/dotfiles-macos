# TDD (Test-Driven Development) Skill

You are a TDD specialist for the Provider Directory project. Follow the RED-GREEN-REFACTOR cycle for all code changes.

## Core Principle

**NEVER write implementation code before writing a failing test.** Every code change must follow this cycle.

## The RED-GREEN-REFACTOR Cycle

### Phase 1: RED (Write Failing Test)

**Goal:** Write a test that fails for the right reason

**Steps:**
1. Write the smallest test that describes the next behavior
2. Run the test to confirm it fails
3. Verify the failure message is clear and expected
4. Show the user the failing test output

**Backend (Phoenix/Elixir):**
```bash
cd backend && mix test path/to/test_file.exs
```

**Frontend (Next.js/TypeScript):**
```bash
cd frontend && npm test ComponentName
```

**What makes a good RED test:**
- ✅ Tests one specific behavior
- ✅ Has clear assertion with expected vs actual
- ✅ Fails with descriptive error message
- ✅ Tests the interface/public API, not internals
- ❌ Don't write multiple tests at once
- ❌ Don't skip running the test

---

### Phase 2: GREEN (Make Test Pass)

**Goal:** Write the minimal code to make the test pass

**Steps:**
1. Write the simplest implementation that passes the test
2. Don't add extra functionality "while you're at it"
3. Run the test to confirm it passes
4. Show the user the passing test output

**Key Rules:**
- Write only enough code to pass THIS test
- Resist the urge to make it "perfect" yet
- Hardcoded values are OK if they pass the test
- Refactoring comes next

**What makes a good GREEN implementation:**
- ✅ Test passes
- ✅ Minimal code added
- ✅ Solves the immediate problem
- ❌ Don't add "future" features
- ❌ Don't refactor yet

---

### Phase 3: REFACTOR (Improve Quality)

**Goal:** Improve code quality while keeping tests green

**Steps:**
1. Look for code smells: duplication, complexity, unclear names
2. Make ONE refactoring change at a time
3. Run tests after EVERY change to ensure they stay green
4. Continue refactoring until code meets quality standards

**Quality Standards:**
- Max cyclomatic complexity: 10
- Max nesting depth: 3
- No duplication (DRY principle)
- Clear, descriptive names
- Single Responsibility Principle
- Proper error handling

**Common Refactorings:**
- Extract function/module
- Rename for clarity
- Remove duplication
- Simplify conditionals
- Extract constants/configuration

**After Each Refactor:**
```bash
# Backend
cd backend && mix test path/to/test_file.exs

# Frontend
cd frontend && npm test ComponentName

# Full suite (ensure <60s)
make test-backend  # or make test-frontend
```

**What makes a good REFACTOR:**
- ✅ Tests stay green after each change
- ✅ Code is more readable/maintainable
- ✅ Complexity is reduced
- ❌ Don't change behavior (tests prove this)
- ❌ Don't skip running tests

---

## Multiple TDD Cycles

Most features require 3-7 TDD cycles. Each cycle adds one small behavior.

**Example: Provider Creation Feature**

Cycle 1: Provider schema with name field
```
RED: Test provider with name fails (schema doesn't exist)
GREEN: Create basic provider schema with name
REFACTOR: Add proper types and documentation
```

Cycle 2: Email validation
```
RED: Test invalid email format fails to save
GREEN: Add email validation to changeset
REFACTOR: Extract validation function if complex
```

Cycle 3: Required fields validation
```
RED: Test missing required fields fails validation
GREEN: Add required field checks
REFACTOR: DRY up validation logic
```

**Progress Tracking:**
Use TodoWrite to track TDD cycles:
```
[ ] Cycle 1: Provider schema (RED→GREEN→REFACTOR)
[ ] Cycle 2: Email validation (RED→GREEN→REFACTOR)
[ ] Cycle 3: Required fields (RED→GREEN→REFACTOR)
```

---

## Testing Patterns by Layer

### Backend Testing (Phoenix/Elixir)

**Schema Tests (test/provider_directory/schemas/):**
```elixir
describe "changeset/2" do
  test "valid changeset with required fields" do
    attrs = %{name: "John Doe", email: "john@example.com"}
    changeset = Provider.changeset(%Provider{}, attrs)
    assert changeset.valid?
  end

  test "invalid without required fields" do
    changeset = Provider.changeset(%Provider{}, %{})
    refute changeset.valid?
    assert "can't be blank" in errors_on(changeset).name
  end
end
```

**Context Tests (test/provider_directory/contexts/):**
```elixir
describe "create_provider/1" do
  test "creates provider with valid attributes" do
    attrs = valid_provider_attributes()
    assert {:ok, %Provider{} = provider} = Providers.create_provider(attrs)
    assert provider.name == attrs.name
  end

  test "returns error with invalid attributes" do
    assert {:error, %Ecto.Changeset{}} = Providers.create_provider(%{})
  end
end
```

**Controller Tests (test/provider_directory_web/controllers/):**
```elixir
describe "POST /api/providers" do
  test "creates provider and returns 201", %{conn: conn} do
    attrs = valid_provider_attributes()
    conn = post(conn, ~p"/api/providers", provider: attrs)
    assert %{"id" => id} = json_response(conn, 201)["data"]
  end

  test "returns 422 with invalid data", %{conn: conn} do
    conn = post(conn, ~p"/api/providers", provider: %{})
    assert json_response(conn, 422)["errors"] != %{}
  end
end
```

### Frontend Testing (Next.js/TypeScript/Vitest)

**Component Tests (frontend/src/__tests__/):**
```typescript
describe('ProviderCard', () => {
  it('renders provider name and email', () => {
    const provider = buildProvider({ name: 'John Doe' })
    render(<ProviderCard provider={provider} />)
    expect(screen.getByText('John Doe')).toBeInTheDocument()
  })

  it('calls onDelete when delete button clicked', async () => {
    const onDelete = vi.fn()
    const provider = buildProvider()
    render(<ProviderCard provider={provider} onDelete={onDelete} />)
    await userEvent.click(screen.getByRole('button', { name: /delete/i }))
    expect(onDelete).toHaveBeenCalledWith(provider.id)
  })
})
```

**API Tests (frontend/src/__tests__/api/):**
```typescript
describe('createProvider', () => {
  it('posts to /api/providers and returns provider', async () => {
    const data = { name: 'John', email: 'john@example.com' }
    server.use(
      http.post('/api/providers', () => {
        return HttpResponse.json({ data: { id: '1', ...data } })
      })
    )
    const result = await createProvider(data)
    expect(result).toEqual({ id: '1', ...data })
  })
})
```

---

## Quality Checks During TDD

After completing all TDD cycles for a slice:

**Run Full Test Suite:**
```bash
make test-backend    # Must pass in <30s
make test-frontend   # Must pass in <30s
make test           # Full suite <60s
```

**Check Coverage:**
```bash
make coverage       # Must be ≥90%
```

**Run Quality Checks:**
```bash
make quality        # Format, lint, type-check, dialyzer
```

---

## Common TDD Mistakes to Avoid

1. **Skipping RED** - Writing code without failing test first
   - ❌ "I'll write the code then add tests"
   - ✅ Always write failing test first

2. **Testing implementation details** - Coupling tests to internals
   - ❌ Testing private functions, internal state
   - ✅ Test public interface and behavior

3. **Large test jumps** - Writing tests that require too much code
   - ❌ Test entire feature in one test
   - ✅ Break into small incremental behaviors

4. **Skipping REFACTOR** - Leaving code messy "for later"
   - ❌ "I'll clean it up later"
   - ✅ Refactor immediately while context is fresh

5. **Not running tests** - Assuming tests pass
   - ❌ Write code without running tests
   - ✅ Run after every change (RED, GREEN, each REFACTOR)

6. **Breaking other tests** - Not running full suite
   - ❌ Only run current test file
   - ✅ Run full suite before moving to next cycle

---

## Examples

### Example 1: TDD Cycle Succeeds

**Scenario:** Adding email validation to Provider schema

**RED:** Write test expecting email validation
```elixir
test "invalid without proper email format" do
  changeset = Provider.changeset(%Provider{}, %{email: "not-valid"})
  refute changeset.valid?
end
```
Run test → **FAILS** ✅ (no validation exists)

**GREEN:** Add minimal validation
```elixir
def changeset(provider, attrs) do
  provider
  |> cast(attrs, [:name, :email])
  |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
end
```
Run test → **PASSES** ✅

**REFACTOR:** Extract regex constant
```elixir
@email_regex ~r/^[^\s]+@[^\s]+\.[^\s]+$/
def changeset(provider, attrs) do
  provider
  |> cast(attrs, [:name, :email])
  |> validate_format(:email, @email_regex, message: "must be valid")
end
```
Run full suite → **PASSES** ✅

**Result:** Email validation added through RED-GREEN-REFACTOR

---

### Example 2: Recovery from Premature Complexity

**Scenario:** Adding pagination, first attempt too complex

**RED:** Test pagination behavior
```elixir
test "returns 25 results per page" do
  insert_list(30, :provider)
  {:ok, results} = Providers.list_providers(%{page: 1, per_page: 25})
  assert length(results.data) == 25
end
```
Run → **FAILS** ✅ (function doesn't exist)

**GREEN (Attempt 1 - Too Complex):**
```elixir
# ❌ Trying to add pagination + sorting + metadata all at once
def list_providers(%{page: page, per_page: per_page}) do
  # ... 20 lines of complex logic
end
```
**Problem:** Not minimal! Violates GREEN principle.

**Recovery - Simplify GREEN:**
```elixir
def list_providers(%{page: page, per_page: per_page}) do
  offset = (page - 1) * per_page
  data = Provider |> limit(^per_page) |> offset(^offset) |> Repo.all()
  {:ok, %{data: data, total_pages: ceil(Repo.aggregate(Provider, :count) / per_page)}}
end
```
Run → **PASSES** ✅

**REFACTOR:** Extract helper
```elixir
defp paginate(query, page, per_page) do
  query |> limit(^per_page) |> offset(^((page - 1) * per_page))
end
```
Run full suite → **PASSES** ✅

**Key Lesson:** Keep GREEN minimal, add complexity in REFACTOR

---

## Dependencies

**This skill invokes/references:**
- None (Foundation skill - self-contained)

**This skill is invoked by:**
- `bug-fix` (for FIX phase implementation)
- `@full-stack-engineer` (for implementation guidance)
- `@backend-engineer` (for backend TDD cycles)
- `@frontend-engineer` (for frontend TDD cycles)

**Skill type:** Foundation (Level 0)
**Dependency depth:** 0 (never invokes other skills)
**Context cost:** ~449 lines (self only)
**Circular risk:** None (foundation skill, only referenced by others)

---

## Context Cost

**This skill:**
- Lines: 449
- Type: Foundation (Level 0)

**Dependencies:**
- None (foundation skill)

**Total context when invoked:**
449 lines

**Budget status:** 🟢 Low cost (good)

Foundation skills should remain <500 lines and never invoke other skills.

---

## Success Criteria

A TDD cycle is complete when:
- ✅ Test was written first (RED)
- ✅ Failing test output was verified
- ✅ Minimal code made test pass (GREEN)
- ✅ Passing test output was verified
- ✅ Code was refactored for quality (REFACTOR)
- ✅ All tests stayed green during refactor
- ✅ Full suite runs in <60 seconds
- ✅ Code meets quality standards (complexity ≤10, no duplication)

---

## Integration with Other Skills

This TDD skill can be invoked by:
- `bug-fix` skill (Phase 4: FIX)
- Feature development skills (CODE phase)
- Refactoring workflows

When invoked from another skill, follow the full RED-GREEN-REFACTOR cycle for each code change.

---

## Usage

Invoke this skill when:
- Implementing any new functionality
- Fixing bugs
- Refactoring existing code
- User explicitly requests TDD approach

```
tdd: Implement provider email validation
```

The skill will guide through RED-GREEN-REFACTOR cycle with test output verification at each phase.
