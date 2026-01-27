# SP Liftoff Squad - Ownership Map

## Squad Information

**Squad Name:** SP Liftoff
**GitHub Team:** @bettercaring/sp-lift-off-squad
**Domain:** Support Provider / Worker Onboarding, Qualifications, Availability and Preferred Services

---

## Rake Tasks Owned

| Task Name | Purpose |
|-----------|---------|
| `carer_profile.rake` | Onboarding and profile management |
| `carer_location.rake` | Location management for support providers |
| `care_knowledge.rake` | Care knowledge and skills management |
| `worker_type.rake` | Worker type definitions and management |
| `worker_type_service_categories.rake` | Mapping worker types to service categories |
| `worker_review.rake` | Worker reviews and ratings |
| `workers.rake` | General worker-related tasks (if onboarding-related) |
| `bulk_import_availability_data.rake` | Bulk import of availability schedules |
| `oho.rake` | OHO (Onboarding Health Organisation) related tasks |
| `asset.rake` | Document and asset management (if document-related) |
| `modify_qualification_names.rake` | Qualification name modifications |
| `service_qualifications.rake` | Service qualification mappings |
| `response_rate_fix.rake` | Carer response rate calculations |

**Total Rake Tasks:** 13

---

## Packs Owned

| Pack Name | Purpose |
|-----------|---------|
| `packs/oho/` | Onboarding Health Organisation functionality |
| `packs/personal_documents/` | Personal document management for providers |

**Total Packs:** 2

---

## Domain Responsibilities Breakdown

### 1. Support Provider Onboarding
- Profile creation and management (`carer_profile.rake`)
- Location setup (`carer_location.rake`)
- Document management (`packs/personal_documents/`, `asset.rake`)
- OHO onboarding workflows (`oho.rake`, `packs/oho/`)

### 2. Qualifications
- Service qualifications (`service_qualifications.rake`)
- Qualification name management (`modify_qualification_names.rake`)
- Care knowledge tracking (`care_knowledge.rake`)

### 3. Availability
- Availability data import (`bulk_import_availability_data.rake`)
- Response rate tracking (`response_rate_fix.rake`)

### 4. Preferred Services
- Worker types (`worker_type.rake`)
- Service category mappings (`worker_type_service_categories.rake`)

### 5. Reviews & Ratings
- Worker reviews (`worker_review.rake`)

---

## Related Squads

When working on cross-squad features, coordinate with:

- **Client Trailblazers** (@bettercaring/seekers) - For matching qualifications to client needs
- **Marketplace** (@bettercaring/matching-be) - For search and job matching based on SP profiles
- **Connectors** (@bettercaring/care-force-one) - For connection requests after onboarding
- **Sessioneers** (@bettercaring/networkers) - For session delivery after onboarding complete

---

## Quick Reference

**Total Ownership:**
- 13 Rake Tasks
- 2 Packs
- Focus: Support Provider journey from signup to ready-for-work

**Key Files Locations:**
```
better_caring/
├── lib/tasks/
│   ├── carer_profile.rake
│   ├── carer_location.rake
│   ├── care_knowledge.rake
│   ├── worker_type.rake
│   ├── worker_type_service_categories.rake
│   ├── worker_review.rake
│   ├── workers.rake
│   ├── bulk_import_availability_data.rake
│   ├── oho.rake
│   ├── asset.rake
│   ├── modify_qualification_names.rake
│   ├── service_qualifications.rake
│   └── response_rate_fix.rake
└── packs/
    ├── oho/
    └── personal_documents/
```
