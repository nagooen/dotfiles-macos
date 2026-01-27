# Infrastructure Deployment Workflow

**Repository:** `inf-attainhealth` (separate repo from provider_directory)
**Suggested relative path:** `../inf-attainhealth` (may vary based on your local setup)

## Overview

Infrastructure changes (Terraform/Terragrunt) are deployed via GitHub Actions workflows, NOT local commands.

## Workflow Pattern

### 1. Create Feature Branch & Make Changes
```bash
cd <path-to-inf-attainhealth-repo>
git checkout -b fix/description-of-change

# Edit Terraform files (e.g., stg/cdn/provider-directory/main.tf)
# Edit for BOTH staging and production if needed

git add .
git commit -m "fix: description of change"
git push origin fix/description-of-change
```

### 2. Create Pull Request
```bash
gh pr create --base main --title "..." --body "..."
```

**What happens automatically:**
- **plan.yml workflow triggers** (on push to non-main branches)
- Runs `terraform fmt --check` (format validation)
- Runs `terragrunt validate` for both stg and prd
- Runs `terragrunt plan` for both stg and prd
- Shows planned changes in workflow logs

**Review the plan output in GitHub Actions to verify expected changes.**

### 3. Merge to Main
```bash
gh pr merge --squash
```

**What happens automatically:**
- **apply.yml workflow triggers** (on push to main)
- Runs `terragrunt apply` for staging
- Runs `terragrunt apply` for production
- Changes are deployed to both environments simultaneously

## GitHub Workflows

### plan.yml
**Trigger:** Push to any branch except `main`

**Jobs:**
1. `format-check` - Validates Terraform formatting
2. `validate-stg` - Validates staging config
3. `validate-prd` - Validates production config
4. `plan-stg` - Shows staging changes (dry-run)
5. `plan-prd` - Shows production changes (dry-run)

**Command:** `terragrunt run --all plan --queue-include-external --non-interactive`

### apply.yml
**Trigger:** Push to `main` branch (i.e., PR merge)

**Jobs:**
1. `apply-stg` - Applies changes to staging
2. `apply-prd` - Applies changes to production

**Command:** `terragrunt run --all apply --queue-include-external --non-interactive`

## Important Notes

### NO Local Terraform Commands
❌ **NEVER run these locally:**
```bash
terragrunt plan
terragrunt apply
terraform apply
```

✅ **ALWAYS use GitHub workflows:**
- Create PR → see plan
- Merge PR → apply changes

### Both Environments Deploy Together
- Staging and production deploy simultaneously from the same merge
- If you only want to change staging, you still need to ensure production config is correct
- Common pattern: Make identical changes to both `stg/` and `prd/` directories

### CloudFront Propagation Time
After `terragrunt apply` completes:
- CloudFront distribution status: "In Progress" → "Deployed"
- Initial propagation: 5-10 minutes
- Full global propagation: up to 30 minutes
- Test changes after seeing "Deployed" status in AWS Console

### Checking Workflow Status
```bash
cd <path-to-inf-attainhealth-repo>
gh run list --limit 5
gh run view <run-id>  # See detailed logs
```

## Common Infrastructure Changes

### CloudFront Configuration
**Files:**
- `stg/cdn/provider-directory/main.tf`
- `prd/cdn/provider-directory/main.tf`

**Examples:**
- Custom error responses (403, 404)
- Origin configurations
- Cache behaviors
- SSL/TLS settings

### Environment Variables (ECS)
**Files:**
- `stg/ecs/provider-directory/main.tf`
- `prd/ecs/provider-directory/main.tf`

**Examples:**
- `AUTH_ENABLED`
- `ALLOWED_EMAIL_DOMAINS`
- `FUSIONAUTH_ISSUER`
- Database connection strings

### Database Parameters
**Files:**
- `stg/rds/provider-directory/main.tf`
- `prd/rds/provider-directory/main.tf`

**Examples:**
- Instance sizes
- Backup retention
- Parameter groups
- Security groups

## Troubleshooting

### Plan Shows Unexpected Changes
1. Check if you edited the right files (stg vs prd)
2. Verify you're on the correct branch
3. Review recent commits: `git log --oneline -5`

### Apply Failed
1. Check workflow logs in GitHub Actions
2. Look for AWS permission errors
3. Check for resource conflicts (e.g., duplicate names)
4. May need to manually fix state via AWS Console + import

### Changes Not Taking Effect
1. Wait 10-15 minutes (CloudFront propagation)
2. Check AWS Console → CloudFront → Distribution status
3. Create CloudFront invalidation if needed (rare)
4. Verify apply workflow succeeded

## Related
- **Provider Directory Deployment:** See `.claude/CLAUDE.md` for app-level deployment
- **GitHub Workflows:** `.github/workflows/` in inf-attainhealth repo
- **Terraform Docs:** Individual module READMEs in stg/prd directories
