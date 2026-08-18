# Professional 360 — start here

Prototype for the Professional & Client Digital Profile Upgrade PRD. Branch
`proto/professional-360`, worktree `D:\Wolftagon\Homecare\codebase\worktrees\professional-360`.
Source PRD: `D:\Wolftagon\Homecare\M2Health_Professional_Client_Digital_Profile_Upgrade_PRD.pdf`.

> **The backend now exists.** Every field these screens hold in memory has real storage and
> endpoints — see `.scratch/professional-profile/spec.md` in `homecare-backend`, branch
> `feat/professional-expertise`. Read that before wiring anything here.
>
> Two things will bite during integration. **The naming differs**: this side says
> `care_dna` throughout, the backend deliberately does not — it uses expertise, work
> preference and service area, because Care DNA is PRD language rather than a system
> concept. And **the skills catalogue here is wrong**: the backend puts proficiency on the
> services a professional already offers, per ADR 0006, with no separate skills table.

Read this file first. The others go deeper:

| File | Covers |
| --- | --- |
| [prd-review.md](prd-review.md) | What the PRD asks for versus what exists |
| [integration.md](integration.md) | How the new screens merged with the old ones |
| [navigation.md](navigation.md) | Why professionals got their own navigation |
| [prototype.md](prototype.md) | The original design thinking. Partly superseded |
| `homecare-backend/docs/adr/0006-competence-is-a-level-not-a-catalogue.md` | Why there is no skills table |

## What this is

The PRD names six modules but only specifies two. This prototype builds those two —
Healthcare Professional Digital Profile and Professional Care DNA — as working Flutter
screens with mock state, plus a professional-specific navigation.

**Care DNA is not a record.** It is the professional profile seen whole. No table, no
model, no screen of its own — just a formatted view over fields other chapters own.

## Decisions already made

Do not reopen these without reason. Each was argued through.

- **Competence is a level on a service, not a skills catalogue** (ADR 0006). The PRD's
  22 "skills" split three ways: procedures are services and get a proficiency level, Daily
  Care items are the task scope of the hourly homecare service, and vitals and medication
  support are what any nursing visit includes. Scope text carries the last two.
- **Nothing feeds matching yet.** Condition experience, preferences and districts are
  captured and displayed only. Bidirectional matching is deliberately deferred.
- **Care DNA completeness is separate from verification.** Verification asks whether
  someone may work at all; completeness asks whether their profile is compelling. A
  verified nurse can sit at 2 of 6.
- **Districts filter, radius scores.** Both stay. Named districts are the coarse
  "will I go there" gate; the travel radius is what ranks a professional for a patient.
  District granularity is admin level 2 — kabupaten/kota in Indonesia, equivalent tier
  elsewhere. Real data not yet sourced.
- **Style traits are claimed, not rated.** A self-assigned "Empathy 5/5" says nothing.
- **Profile status collapses** to one extra state, `suspended`. Restricted and Suspended
  merge; Expired is dropped because no expiry date is stored anywhere.
- **Level labels are a proposal**, not from the PRD, which only defines 0 and 5.
  Languages: Basic, Elementary, Conversational, Fluent, Native. Conditions and services:
  Some exposure, Basic, Competent, Experienced, Expert.
- **Say suspended, not blocked.** "Blocked" already means a time slot taken by an
  appointment.

## What is built

**Profile hub**, three groups. Profile: personal details, credentials. Practice: services
& expertise, condition experience, languages & care style. Availability: working hours,
coverage area, work preferences. A Care DNA card sits on top with the summary chips and a
preview of the patient's view.

**Navigation.** Professionals get Home, Visits, Profile with labels. Patients keep their
five icon-only tabs, untouched. Home shows offers awaiting response, today's visits, and a
week summary.

**Patient-facing.** The professional detail page gained a Care DNA strip and curated chip
sections.

## What is not built

- **Work eligibility.** Blocked on knowing which document each market needs — SIP and STR
  in Indonesia, unknown for Singapore, Malaysia, China.
- **Reliability**, one of the seven Care DNA components. No data source.
- **Professional Score, Client Digital Profile, Dynamic Profile Update, Bidirectional
  Matching** — the four PRD modules that were never specified.
- **Suspended status.**

## Known gaps to close for production

1. **Mock state.** `CareDnaStore` is an in-memory `ValueNotifier` singleton. Everything it
   holds — languages, conditions, service proficiency, style, preferences, districts,
   gender, residential area, emergency contact — resets on restart. **No backend columns
   exist for any of it.** This is the single biggest gap.
2. **Onboarding split.** The base address moved to Coverage area, but the server still
   counts it inside the profile step. `computeOnboarding` needs splitting into `profile`
   and `coverage`. The prototype computes the fifth step client-side as a stopgap.
3. **Free-text columns.** `professionals.working_hours` and `professionals.workplace` are
   no longer written by the app, but the columns still exist and are still read by the
   patient-facing page. Derive the display from `provider_availabilities` and the geocoded
   address, then drop both columns.
4. **Role flicker.** Role loads asynchronously, so a cold launch briefly renders the
   patient navigation before correcting.
5. **District data.** `CareDnaCatalog.serviceAreas` is a hardcoded Jakarta list.

## Two bugs found along the way, neither ours

- **Homecare is billed twice differently.** Self-service multiplies the catalog price by
  duration ($50 for two hours); conversational booking takes the price raw ($25).
- **Nursing has no visit base.** A single injection books at $10, which does not cover
  travel. Fixing it reverses the unified-catalogue migration's recorded position that
  "procedures are not add-ons, they are the service". Additive and per category was the
  instinct — per category because conversational booking quotes a price from category
  alone, before any professional is chosen.

Both are pricing decisions for the PM, not engineering choices.
