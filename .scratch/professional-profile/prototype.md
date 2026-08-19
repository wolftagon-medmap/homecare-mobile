# Professional Care DNA — demo prototype

> **Status: throwaway prototype.** Built for the client demo. Mock data only, no
> API, no persistence beyond the running process. Nothing here is wired to
> matching. Read it as a design proposal made concrete, not as shipped work.
>
> **Superseded in part.** The six-chapter structure below was replaced by the
> three-group hub in [integration.md](integration.md), and the standalone skills
> screen was deleted when ADR 0006 settled that competence is a level on a
> service. Both changes are implemented. What remains accurate here is the
> select-then-rate reasoning and the level-label proposal.

Branch `proto/professional-360`, worktree `D:\Wolftagon\Homecare\worktrees\professional-360`.

## What the PRD asked for versus what this is

The PRD names six modules but only specifies two of them field-by-field
(Healthcare Professional Digital Profile, Professional Care DNA). Professional
Score, Client Digital Profile, Dynamic Profile Update After Service and
Bidirectional Matching Foundation are named with no detail at all, so they are
not built here.

"Care DNA" and "360" are not new records. They are the professional profile
seen whole — a formatted view over fields that other parts of the profile
already own. There is no `CareDna` table in this design and there should not be
one.

## The design problem

The PRD asks a professional for roughly 66 leveled data points: 7 languages,
13 conditions, 22 clinical skills, 10 style traits, 14 preferences — most
needing a level on a 0–5 scale.

Rendered as 66 dropdowns, nobody finishes the form and the whole feature dies on
completion rate. So the entry pattern mattered more than the layout.

**Select-then-rate.** Tap chips to claim the handful that apply, then rate only
those. Everything unclaimed stays at level 0 and is never touched. Claiming six
conditions out of thirteen is about ten seconds of tapping instead of thirteen
dropdown interactions. Implemented once in `SelectThenRate` and reused by every
leveled catalogue.

## Information architecture

Six chapters, grouped by the professional's mental model rather than PRD section
order. The existing profile hub had three rows; this takes it to six.

| Chapter | Holds | State |
| --- | --- | --- |
| Personal details | name, photo, contact, emergency contact, work eligibility, residential area | existing screen, not extended in this prototype |
| Credentials | certificates | existing |
| Skills & experience | clinical skills (S), condition experience (E) | **new** |
| Languages & care style | languages (L), communication traits | **new** |
| Services & pricing | bookable services | existing |
| Availability & coverage | schedule, work preferences, service areas | **new** (preferences + areas) |

## Decisions worth knowing

**Care DNA completeness is not verification progress.** Verification asks
whether someone may legally work at all. Care DNA completeness asks whether the
profile is compelling enough to get picked. A fully licensed nurse can be
verified and still sit at 2 of 6 here. They are shown as separate indicators and
the shipped verification hub was left untouched.

**Level labels are a proposal.** The PRD defines only the endpoints (L0/E0 none,
L5/E5 expert) and never says what 1–4 mean. This prototype proposes
Basic / Elementary / Conversational / Fluent / Native for languages, and
Some exposure / Basic / Competent / Experienced / Expert for conditions and
skills. Needs sign-off.

**Style traits are claimed, not rated.** A self-assigned "Empathy 5/5" carries
no information. The PRD lists four sources for these (self, client feedback,
coordinator review, service records); only self-declaration exists here, and the
screen says so.

**The patient view is curated, not exhaustive.** Each section shows its
strongest five and collapses the rest behind "show all". A patient scanning for
"speaks Hokkien, knows dementia" should get that in the first screenful.

**Nothing feeds matching.** Condition experience is the obvious candidate for a
scoring boost, and it is deliberately not wired. Doing so needs the patient's
condition captured as a structured tag at intake, and today
`service_requests.chief_complaint` is free text. That is a separate piece of
work. The preferences screen states this on-screen so nobody demoing promises
filtering that does not exist.

## Files

```
lib/features/care_dna/
├── domain/care_dna.dart                    entities, level scales
├── data/care_dna_catalog.dart              the PRD lists verbatim
├── data/care_dna_store.dart                in-memory demo state
└── presentation/
    ├── widgets/select_then_rate.dart       the entry pattern
    ├── widgets/care_dna_card.dart          professional-facing hero
    ├── widgets/care_dna_public_sections.dart  patient-facing sections + strip
    ├── widgets/dna_chip.dart
    └── pages/{skills_experience,languages_style,work_preferences,care_dna_preview}_page.dart
```

Touched outside the feature: `route/app_routes.dart` and
`features/profiles/profile_detail_routes.dart` (four routes),
`professional_profile_page.dart` (card + three rows),
`professional_details_page.dart` (strip + sections).

The store is deliberately a plain `ValueNotifier` singleton rather than a Cubit
in the DI graph, so deleting this feature is a directory removal plus unwinding
those four call sites.

## Demo path

1. Professional profile → **Care DNA card**, chips and completeness
2. *Skills & experience* → claim a condition, set its level, back out
3. Card has updated live
4. *Preview* → the same profile through a patient's eyes
5. Patient side: professional detail → Care DNA strip and the curated sections

## Known gaps

- Personal details chapter (gender, emergency contact, work eligibility,
  residential area) is designed but not built — lowest visual payoff for a demo,
  and work eligibility is blocked on per-country document research anyway.
- Service areas are a hardcoded Jakarta list. Real data is admin-level-2
  (kabupaten/kota) from the shared dataset, not yet sourced.
- Skills here are their own catalogue, separate from bookable `services`. Whether
  they should instead be levels on `professional_services` is unresolved — the
  PRD's skill list contains entries that are not billable line items
  (Companionship, Family Communication), which is what makes the merge awkward.
