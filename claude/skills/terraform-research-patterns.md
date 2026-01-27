# Terraform Research Patterns Skill

You are a Terraform provider research specialist for the Provider Directory project. This skill provides systematic approaches for researching Terraform provider attributes and configurations when official documentation is inaccessible.

## Purpose

When working with Terraform configurations, official Terraform Registry documentation is often inaccessible due to JavaScript requirements in WebFetch. This skill documents effective research patterns to find correct attribute structures, resource schemas, and configuration examples through alternative sources.

Use this skill to avoid trial-and-error and reduce research time from 30+ minutes to 5-10 minutes.

## Workflow Steps

### Step 1: Try Official Documentation First

**Always start with the official source:**

```bash
WebFetch: https://registry.terraform.io/providers/[org]/[provider]/latest/docs/resources/[resource]
```

**Example:**
```
https://registry.terraform.io/providers/FusionAuth/fusionauth/latest/docs/resources/application
```

**If successful:**
- Read the attribute documentation carefully
- Note nested block structures (not always obvious)
- Check for examples at the bottom of the page

**If JavaScript-blocked:**
- Error: "Please enable Javascript to use this application"
- Move to Step 2

### Step 2: Search Provider GitHub Repository

**Find the provider's source code on GitHub:**

```bash
WebSearch: site:github.com terraform-provider-[name] [resource] schema
```

**Example:**
```
site:github.com terraform-provider-fusionauth application schema
```

**What to look for:**
- Schema definitions in Go files (usually `resource_*.go`)
- Look for `Schema:` maps with attribute definitions
- Note attribute types: `TypeString`, `TypeBool`, `TypeList`, `TypeSet`
- Identify required vs optional attributes
- Find nested block structures (`Elem: &schema.Resource{}`)

**File patterns:**
- `fusionauth/resource_fusionauth_application.go`
- `fusionauth/schema_*.go`
- Look for functions like `resourceFusionAuthApplicationSchema()`

### Step 3: Find Examples in Provider Repository

**Search for example configurations:**

```bash
WebSearch: site:github.com/[org]/terraform-provider-[name] "resource \"[type]\" \"[name]\""
```

**Example:**
```
site:github.com/FusionAuth/terraform-provider-fusionauth "resource \"fusionauth_application\""
```

**Also check:**
- `examples/` directory in the provider repository
- `testdata/` or `test/` directories with fixture files
- Provider's own Terraform configurations
- Integration test files (`*_test.go`) often have complete examples

### Step 4: Check Local Codebase for Patterns

**Search existing configurations:**

```bash
Grep: pattern=[resource-type] path=[terraform-directory] output_mode=content
```

**Example:**
```
pattern: fusionauth_application
path: /Users/.../inf-fusionauth
output_mode: content
```

**What to look for:**
- How similar resources are configured in your project
- Patterns for common attributes (IDs, names, configurations)
- Nested block structures that work
- Compare working resources to broken ones

**If you find a working similar resource:**
- This is often the fastest path to success
- Copy the structure and adapt it
- Validate differences with API documentation

### Step 5: Consult Service API Documentation

**Terraform providers often mirror their service's API structure:**

```bash
WebSearch: [service-name] API [resource-type] documentation
```

**Example:**
```
FusionAuth API application oauth configuration
```

**Look for:**
- API endpoint documentation (often at `/docs/apis/`)
- Request/response body structures
- Field names in API often match Terraform attributes
- Nested object structures map to Terraform blocks

**Mapping API to Terraform:**
```
API JSON:                  Terraform HCL:
{                          oauth_configuration {
  "oauthConfiguration": {    client_id = "..."
    "clientId": "..."        provided_scope_policy {
    "providedScopePolicy": {   email {
      "email": {                 enabled = true
        "enabled": true        }
      }                       }
    }                       }
  }
}
```

### Step 6: Verify with Terraform Commands

**Once you think you have the correct structure:**

```bash
# Check syntax
terraform fmt -check [file.tf]

# Validate configuration (catches type errors, missing required fields)
terraform validate

# See what would change (catches runtime errors)
terraform plan
```

**Common validation errors and fixes:**
- `Unsupported argument`: Attribute doesn't exist → Check spelling, check provider version
- `Missing required argument`: Field is required → Add it or check if it's in wrong block
- `Incorrect attribute value type`: Wrong type → Check schema for `TypeString` vs `TypeBool` vs `TypeList`
- `Blocks of type X are not expected`: Using wrong structure → Should be attribute, not block (or vice versa)

## Examples

### Example 1: Researching FusionAuth OAuth Scopes (Success)

**Scenario:** Need to enable email scope for FusionAuth application, but `provided_scopes = ["email"]` causes validation error.

**Step 1: Official Docs (Failed)**
```
WebFetch: https://registry.terraform.io/providers/FusionAuth/fusionauth/latest/docs/resources/application
Error: "Please enable Javascript to use this application"
```

**Step 2: GitHub Schema Search**
```
WebSearch: site:github.com terraform-provider-fusionauth application oauth_configuration schema
Found: Reference to provided_scope_policy as nested block structure
```

**Step 3: Provider Examples**
```
WebSearch: site:github.com/FusionAuth/terraform-provider-fusionauth "provided_scope_policy"
Result: No direct examples found (new feature)
```

**Step 4: Local Codebase**
```
Grep: pattern=fusionauth_application path=inf-fusionauth
Found: app_example.tf uses scope_handling_policy and unknown_scope_policy
Does NOT use provided_scope_policy (not needed for that app)
```

**Step 5: FusionAuth API Docs**
```
WebSearch: FusionAuth API application oauth scopes
Found: FusionAuth docs mention address, email, phone, profile scopes
Describes "enabled" and "required" properties for each scope
```

**Step 6: Inferred Structure**
```hcl
provided_scope_policy {
  address {
    enabled  = false
    required = false
  }
  email {
    enabled  = true
    required = false
  }
  phone {
    enabled  = false
    required = false
  }
  profile {
    enabled  = false
    required = false
  }
}
```

**Validation:**
```bash
terraform validate
✅ Success: Configuration is valid
```

**Result:**
- Research time: ~15 minutes
- Found correct nested block structure
- All scopes must be explicitly declared
- Validation passed on first try after research

### Example 2: AWS Resource Attribute (Quick Success)

**Scenario:** Need to configure S3 bucket lifecycle rules but unsure of exact attribute names.

**Step 1: Official Docs (Success)**
```
WebFetch: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration
Success: Full documentation retrieved
```

**Result:**
- Research time: ~2 minutes
- Official docs worked (no JavaScript blocking)
- Complete examples provided
- No additional research needed

**Key Takeaway:** Always try official docs first - when they work, they're the fastest and most reliable source.

### Example 3: Custom Provider with No Documentation (Multiple Steps)

**Scenario:** Internal company provider with minimal documentation, need to configure a complex nested resource.

**Step 1-3: Limited Information**
- Official docs: Minimal/non-existent
- GitHub: Private repository, schema not easily readable
- Examples: None in repository

**Step 4: Local Codebase (Breakthrough)**
```
Grep: pattern=company_resource path=terraform/
Found: Similar resource in different environment
Structure shows nested blocks with specific attribute patterns
```

**Step 5: API Documentation**
```
WebSearch: company internal API resource_type documentation
Found: API specs show JSON structure
```

**Step 6: Map API to Terraform**
```
API JSON structure → Terraform HCL blocks
Validate with terraform plan
Iterate based on error messages
```

**Result:**
- Research time: ~25 minutes
- Required multiple sources
- Local codebase examples were most helpful
- API docs helped clarify attribute types

## Common Patterns

### Pattern 1: Simple Attributes vs Blocks

**Simple attribute (no nesting):**
```hcl
resource "example" "test" {
  name  = "value"     # TypeString
  count = 5           # TypeInt
  enabled = true      # TypeBool
}
```

**Block (nesting):**
```hcl
resource "example" "test" {
  configuration {     # Nested block
    setting = "value"
    options {         # Doubly nested
      key = "value"
    }
  }
}
```

**How to tell:**
- Schema shows `Type: schema.TypeString` → simple attribute with `=`
- Schema shows `Type: schema.TypeList` with `Elem: &schema.Resource{}` → block with `{}`

### Pattern 2: Lists vs Sets

**List (ordered, duplicates allowed):**
```hcl
urls = [
  "https://example.com",
  "https://example.org",
]
```

**Set (unordered, no duplicates):**
```hcl
# Same syntax in HCL, but provider enforces uniqueness
tags = ["web", "api", "prod"]
```

### Pattern 3: Optional vs Required Attributes

**In schema:**
```go
"client_id": {
    Type:     schema.TypeString,
    Required: true,              // Must provide
},
"description": {
    Type:     schema.TypeString,
    Optional: true,              // Can omit
},
```

**Error message for missing required:**
```
Error: Missing required argument
The argument "client_id" is required, but no definition was found.
```

## Troubleshooting

### WebFetch Fails Due to JavaScript

**Problem:** Can't access Terraform Registry documentation

**Solution:** Use Steps 2-5 (GitHub, examples, local code, API docs)

**Prevention:** Don't rely solely on official docs; always have backup research methods

### Schema Conflicts with Working Code

**Problem:** Schema says attribute X doesn't exist, but you see it in working code

**Possible causes:**
- Different provider versions (check `terraform { required_providers { ... version = "..." } }`)
- Attribute was renamed (check provider changelog)
- Wrong resource type (similar names, different resources)

**Solution:**
```bash
# Check provider version
terraform version

# Check required provider version in .tf files
grep -r "required_providers" terraform/

# Search changelog for deprecated attributes
WebSearch: terraform-provider-[name] changelog [attribute-name]
```

### Validation Passes but Plan Fails

**Problem:** `terraform validate` succeeds but `terraform plan` fails

**Possible causes:**
- Attribute value doesn't match allowed values (e.g., enum mismatch)
- Resource references don't exist
- Provider authentication issues

**Solution:**
```bash
# Check provider authentication
terraform init

# Run plan with detailed logging
TF_LOG=DEBUG terraform plan

# Check if referenced resources exist
terraform state list
```

## Success Criteria

Research is complete when:
- ✅ Correct attribute structure identified (nested blocks vs simple attributes)
- ✅ Required vs optional attributes understood
- ✅ `terraform validate` passes with no errors
- ✅ `terraform plan` runs successfully (or shows expected changes only)
- ✅ Attribute types match schema (string, bool, int, list, set)
- ✅ Nested block structures correctly represented

## Tools and Skills

**Tools:**
- WebFetch - Try official Terraform Registry docs
- WebSearch - Find GitHub schema definitions and examples
- Grep - Search local codebase for patterns
- Bash (`terraform validate`, `terraform plan`, `terraform fmt`)

**Related Skills:**
- None (this is a Foundation skill, doesn't invoke others)

**Related Agents:**
- @codebase-explorer - Can help find patterns across multiple Terraform files
- @full-stack-engineer - May invoke this skill when working with infrastructure code

## Integration

**This skill is used by:**
- Engineers working with Terraform configurations
- Agents implementing infrastructure changes
- Anyone encountering Terraform validation errors

**When to invoke:**
```
terraform-research-patterns: help find [provider] [resource] [attribute] structure
```

**Common triggers:**
- "Unsupported argument" validation error
- "Missing required argument" error
- Need to understand nested block structure
- Official documentation inaccessible

## Dependencies

**This skill invokes/references:**
- None (Foundation skill - self-contained)

**This skill is invoked by:**
- Engineers (when working with Terraform)
- Agents (when implementing infrastructure changes)
- Other skills may reference as guidance

**Skill type:** Definition (Level 1)
**Dependency depth:** 0 (no dependencies)
**Context cost:** ~425 lines (self only)
**Circular risk:** None (doesn't invoke other skills)

## Context Cost

**This skill:**
- Lines: 425
- Type: Definition (Level 1)

**Dependencies:**
- None

**Total context when invoked:**
425 lines

**Budget status:** 🟢 Low cost (well within 500-line ideal range)

## Usage

**Invoke this skill when:**
- Terraform validation errors occur due to unknown attributes
- WebFetch fails to retrieve Terraform Registry documentation
- Need to understand Terraform resource schema structure
- Researching how to configure complex nested blocks
- Converting API documentation to Terraform configuration

**Manual invocation:**
```
terraform-research-patterns: help research [provider] [resource] [specific-attribute]
```

**Examples:**
```
terraform-research-patterns: help find FusionAuth application oauth scope configuration
terraform-research-patterns: help research AWS S3 bucket lifecycle rules
terraform-research-patterns: how to structure nested blocks in Terraform
```
