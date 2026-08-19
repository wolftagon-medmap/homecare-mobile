# Professional 360 — start here

The professional side of the Professional & Client Digital Profile PRD. Branch
`proto/professional-360`, worktree `D:\Wolftagon\Homecare\codebase\worktrees\professional-360`.
Source PRD: `D:\Wolftagon\Homecare\M2Health_Professional_Client_Digital_Profile_Upgrade_PRD.pdf`.

> **This is no longer a prototype.** Every editor screen reads and writes the real
> backend. `CareDnaStore` is deleted. The backend spec is
> `homecare-backend/.scratch/professional-profile/spec.md`, branch
> `feat/professional-expertise`.

Read this file first. The others go deeper:

| File | Covers |
| --- | --- |
| [handoff.md](handoff.md) | **What is done, what is left, and how to resume** |
| [prd-review.md](prd-review.md) | What the PRD asks for versus what exists |
| [integration.md](integration.md) | How the new screens merged with the old ones |
| [navigation.md](navigation.md) | Why professionals got their own navigation |
| [prototype.md](prototype.md) | The original design thinking. Largely superseded |
| `homecare-backend/docs/adr/0006-competence-is-a-level-not-a-catalogue.md` | Why there is no skills table. **Lives on branch `docs/care-dna-decisions`, not merged** |

## What this is

The PRD names six modules but only specifies two. This builds those two —
Healthcare Professional Digital Profile and Professional Care DNA — plus a
professional-specific navigation.

**Care DNA is not a record.** It is the professional profile seen whole. No
table, no model, no service carries the name. In the app it is
`ProfileSummary`, a presentation-layer view assembled from fields other
chapters own. The words "Care DNA" appear only on screen, as PRD language for
users.

## Where the code lives

`lib/features/professional_profile/` — extracted from `features/profiles` so the
professional side stops competing with patient profiles for the same folder.

```
data/         models, three datasources mirroring the backend services
              (Expertise / WorkPreference / ServiceArea), repositories
domain/       entities, repository interfaces, use cases
presentation/ bloc, pages, widgets, view (ProfileSummary)
```

`lib/features/profiles/` keeps patient profiles, addresses, place search and
countries. `lib/core/presentation/` holds the role switcher and the shared
profile widgets.

## Decisions already made

Do not reopen these without reason. Each was argued through.

- **Competence is a level on a service, not a skills catalogue** (ADR 0006). The
  PRD's 22 "skills" split three ways: procedures are services and get a
  proficiency level, Daily Care items are the task scope of the hourly homecare
  service, and vitals and medication support are what any nursing visit
  includes. Scope text carries the last two.
- **Nothing feeds matching yet.** Captured and displayed only. The work
  preferences screen says so on itself, deliberately.
- **Care DNA completeness is separate from verification.** Verification asks
  whether someone may work at all; completeness asks whether their profile is
  compelling. A verified nurse can sit at 2 of 6.
- **Districts filter, radius scores.** Both stay.
- **Style traits are claimed, not rated.**
- **Level labels are a proposal**, not from the PRD, which defines only 0 and 5.
  Languages: Basic, Elementary, Conversational, Fluent, Native. Conditions and
  services: Some exposure, Basic, Competent, Experienced, Expert.
- **Say suspended, not blocked.** "Blocked" already means a taken time slot.
- **The server owns which preferences are public.** `preference_highlights` is
  computed backend-side and served on both `my-profile` and the public endpoint,
  so the professional's preview and the patient view cannot disagree.
- **The preview is not a mirror, it is the real thing.** It fetches
  `GET /v1/professionals/:id` on the professional's own id and renders the same
  widget the patient page renders.

## What is built

**Six editor screens**, all persisting: condition experience, languages & care
style, services & expertise (with proficiency), coverage area (districts,
radius, base address), work preferences, personal details (gender, emergency
contact, residential area).

**Profile hub**, three groups — Profile, Practice, Availability — with a Care DNA
summary card on top showing the PRD summary line and a six-chapter completeness
bar.

**Navigation.** Three tabs: Home, Appointments, Profile.

**Patient-facing.** `PublicProfileBody`, shared by the directory page and the
preview, laid out to the original mockup with a collapsible Care DNA block.

## What is not built

- **Work eligibility.** Blocked on per-country document research. The agreed
  interim is to treat certificates as work eligibility — see handoff.md.
- **Reliability**, one of the seven Care DNA components. No data source.
- **Professional Score, Client Digital Profile, Dynamic Profile Update,
  Bidirectional Matching** — the four PRD modules never specified.
- **Suspended status.**
