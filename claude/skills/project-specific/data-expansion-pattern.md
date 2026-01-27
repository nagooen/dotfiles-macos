# Data Expansion Pattern Skill

You are implementing a feature that expands 1 record into N records on write (e.g., selecting an LGA creates provider_service records for every postcode in that LGA). This pattern requires careful design to handle the full read-edit-save cycle.

## When This Skill Applies

Use this skill when:
- User selects ONE thing (e.g., an LGA, a category, a region)
- System creates MANY records (e.g., one per postcode, one per item in category)
- Records need to be editable after creation

**Examples:**
- LGA selection → provider_service per postcode
- Bulk discount → discount record per product
- Region selection → shipping rule per zone

## The Problem

Without proper design, you'll encounter:
1. **Exponential duplication on edit**: Load N records → display N rows → user saves → each row expands to N records → now N² records
2. **UI confusion**: User selected "Melbourne LGA" but sees 50 individual postcode rows
3. **Lost context**: Can't tell which records came from the same expansion

## Required Design Steps

### Step 1: Track the Source

Add a field to track the original selection:

**Backend (Elixir/Ecto):**
```elixir
# Migration
add :source_code, :string, null: true  # e.g., lga_code, category_id

# Index for efficient grouping
create index(:table_name, [:source_code], where: "source_code IS NOT NULL")
```

**Schema:**
```elixir
field :source_code, :string
field :source_type, :string  # "lga", "category", etc.
```

### Step 2: Create a Separate Changeset

Don't modify the existing changeset. Create a new one for expansion mode:

```elixir
def expansion_changeset(struct, attrs) do
  struct
  |> cast(attrs, [:source_code, :source_type, ...])
  |> validate_required([:source_code, ...])
  |> validate_expansion_rules()
end
```

### Step 3: Use Atomic Transactions

Expand and insert all records atomically:

```elixir
def create_for_expansion(parent_id, source_code) do
  items = lookup_items_for(source_code)

  if Enum.empty?(items), do: {:error, :no_items_found}

  multi =
    items
    |> Enum.with_index()
    |> Enum.reduce(Ecto.Multi.new(), fn {item, index}, multi ->
      attrs = %{parent_id: parent_id, item_id: item.id, source_code: source_code}
      changeset = Schema.expansion_changeset(%Schema{}, attrs)
      Multi.insert(multi, {:record, index}, changeset)
    end)

  case Repo.transaction(multi) do
    {:ok, results} -> {:ok, Map.values(results)}
    {:error, _, changeset, _} -> {:error, changeset}
  end
end
```

### Step 4: Include Source in API Response

Return derived fields so frontend doesn't have to compute:

```elixir
def render_record(record) do
  source_type = if record.source_code, do: "expansion", else: "single"

  %{
    id: record.id,
    source_code: record.source_code,
    source_type: source_type,
    source_name: if(record.source_code, do: lookup_name(record), else: nil),
    ...
  }
end
```

### Step 5: Implement Collapse Logic (CRITICAL)

**This is where most bugs occur.** Before implementing expansion, design the collapse:

**Frontend (TypeScript):**
```typescript
function deduplicateRecords(records: Record[]): Record[] {
  if (!records) return [];

  const seen = new Map<string, Record>();

  for (const record of records) {
    if (record.source_type === "expansion" && record.source_code) {
      // Collapse expanded records by source
      const key = `expansion:${record.parent_id}:${record.source_code}`;
      if (!seen.has(key)) {
        seen.set(key, record);
      }
    } else {
      // Keep single records as-is
      const key = `single:${record.id}`;
      seen.set(key, record);
    }
  }

  return Array.from(seen.values());
}
```

### Step 6: Write Round-Trip Tests

**BEFORE implementing**, write tests for the full cycle:

```typescript
describe('data expansion round-trip', () => {
  it('collapses expanded records on load', () => {
    // API returns 4 records from 1 LGA expansion
    const apiResponse = [
      { id: '1', source_code: 'LGA123', source_type: 'expansion' },
      { id: '2', source_code: 'LGA123', source_type: 'expansion' },
      { id: '3', source_code: 'LGA123', source_type: 'expansion' },
      { id: '4', source_code: 'LGA123', source_type: 'expansion' },
    ];

    const collapsed = deduplicateRecords(apiResponse);

    // Should show 1 row in the UI
    expect(collapsed).toHaveLength(1);
    expect(collapsed[0].source_code).toBe('LGA123');
  });

  it('keeps different expansions separate', () => {
    const apiResponse = [
      { id: '1', source_code: 'LGA123', source_type: 'expansion' },
      { id: '2', source_code: 'LGA456', source_type: 'expansion' },
    ];

    const collapsed = deduplicateRecords(apiResponse);

    expect(collapsed).toHaveLength(2);
  });

  it('handles mixed expansion and single records', () => {
    const apiResponse = [
      { id: '1', source_code: null, source_type: 'single' },
      { id: '2', source_code: 'LGA123', source_type: 'expansion' },
      { id: '3', source_code: 'LGA123', source_type: 'expansion' },
    ];

    const collapsed = deduplicateRecords(apiResponse);

    // 1 single + 1 collapsed expansion = 2
    expect(collapsed).toHaveLength(2);
  });
});
```

## Checklist

Before implementing a data expansion feature, verify:

- [ ] **Source tracking**: Added field to track original selection
- [ ] **Separate changeset**: Created expansion-specific validation
- [ ] **Atomic creation**: Using Multi/transaction for batch inserts
- [ ] **API response**: Including source_type and source_name
- [ ] **Collapse logic**: Implemented deduplication for edit flow
- [ ] **Round-trip tests**: Tested create → read → edit → save cycle
- [ ] **Edge cases**: Empty source, invalid source, mixed types

## Common Mistakes

1. **Testing only the happy path**: Write edit flow tests BEFORE implementation
2. **Forgetting source_name**: Frontend needs display name, not just code
3. **Not using transactions**: Partial failures leave inconsistent data
4. **Modifying existing changeset**: Keep expansion validation separate
5. **Relying on record count**: Use source_code for grouping, not counting

## Origin

This skill was created from the PR #100 retrospective (LGA Expansion feature, ES-50053). The de-duplication bug (exponential record growth on edit) was discovered after initial implementation because the edit flow wasn't considered during design.

**Key Lesson:** When expanding data on write, design the collapse logic FIRST.
