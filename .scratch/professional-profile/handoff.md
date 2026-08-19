# Handoff — professional profile

State as of the end of the mobile integration run. Read [README.md](README.md)
first for the decisions; this file is what was done, what is left, and how to
pick it up.

## Repos and branches

| Repo | Branch | State |
| --- | --- | --- |
| `homecare-mobile` (worktree `professional-360`) | `proto/professional-360` | 26 commits ahead of `develop` |
| `homecare-backend` | `feat/professional-expertise` | 12 commits ahead of `develop`, 3 added this run |

Migrations and the SG area seeder **have been run** on the local dev database.
The backend was live on `http://127.0.0.1:3333` throughout, and every endpoint
below was round-tripped with curl against it.

`lib/const.dart` carries an uncommitted local switch to `BASE_URL =
http://127.0.0.1:3333`. Leave it out of commits.

## How it was verified

`fvm flutter analyze` sat at a **69-issue baseline** — all `info`, zero errors
and warnings — before this work and after every commit. That number is the
regression check. It is not zero because 69 pre-existing lints live outside this
feature.

Tests were dropped partway through at the user's request (deadline). Two test
files fail and predate this work: `test/sso_service_test.dart` does not compile,
and `test/widget_test.dart` is the stock Flutter counter test.

Nothing was clicked through in a running app by the agent; the user verified
visually and reported it "works smoothly".

## Three real bugs found and fixed

None were on the task list.

1. **The travel radius never saved.** `professionals.service_radius_preference`
   exists as a column and the validator accepted it, but `Professional` had no
   matching `@column()`, so `merge()` dropped it on write and `serialize()` could
   not emit it. Matching fell back to the 30 km default for everyone. Fixed in
   `f99319b`.
2. **The patient page showed your own Care DNA on every professional.**
   `CareDnaStore` was a singleton, never per-professional. Removed in `2faff2f`,
   replaced with real data in `e76fa1a`.
3. **Two dropdowns could never have saved.** Care style stored display labels
   where the API wants codes; client gender stored `"No preference"` against an
   `any|female|male` enum. Both confirmed 422 against the live server.

## Backend commits this run

```
510d4ee feat(provider): publish curated profile highlights on the public professional endpoint
f99319b fix(provider): persist the service radius preference
94a8415 fix(provider): answer in snake_case on the expertise endpoints
```

`94a8415` matters for anyone adding endpoints here: the expertise endpoints were
returning camelCase because the values never pass through Lucid. `provider_serializers.ts`
converts at the boundary. Keep new endpoints snake_case out.

`510d4ee` adds to the public `GET /v1/professionals/:id`: `condition_experience`,
`languages`, `care_style`, `service_areas`, `preference_highlights`. It
deliberately **withholds** `work_preferences` (raw, contains
`smoking_household`), `residential_area` and `emergency_contact`. Confirmed
absent by live check.

## Mobile work, in the order it happened

| Feature | What it did |
| --- | --- |
| 1 | Extracted `features/professional_profile/` out of `features/profiles` |
| 2 | Entities, models, three datasources, repository, catalogue cache |
| 3–8 | One editor screen per feature, each onto its real endpoint |
| 9 | Deleted `CareDnaStore`, `CareDnaCatalog`, `domain/care_dna.dart`; renamed the last `CareDna*` identifiers |
| 10 | Patient-facing highlights, backend commit first |
| 11 | Three-tab navigation |
| 12 | `ProText` type scale, guidance moved into a bottom sheet |
| 13 | Shared `PublicProfileBody`; preview repointed at the public endpoint; layout then restored to the original mockup |

**Patterns every editor screen follows.** A screen-scoped cubit, an explicit save
bar, a `PopScope` discard confirm, and the saved result folded into
`ProfessionalProfileCubit` in place rather than refetching — a refetch emits
`Loading` and flashes a spinner on the hub behind you. Where a screen spans two
endpoints, each half reports its own outcome so a half that saved is not reported
as a total failure.

## Next up — Care DNA terminology, planned and approved, not started

Agreed with the user, on the patient detail page's Care DNA sections
(`presentation/widgets/profile_highlights.dart`):

1. "Speaks" → **Language Proficiency**
2. "Services & expertise" → **Clinical & Service Skills**
3. "Covers" → **Service Area**
4. **Care style stays as is.** The PRD term is *Communication & Service Style*;
   the user said the current label is "quite ok". Do not rename without asking.
5. **An `(i)` per levelled category**, opening the F12 guidance sheet, explaining
   the scale — L1 Basic → L5 Native, E1/S1 Some exposure → E5/S5 Expert. Labels
   must come from `LevelScaleX.labelFor` so the sheet and the chips cannot
   disagree. **Not** on Care style, Works with or Service Area — those carry no
   level and an icon there would promise a scale that does not exist.
6. **Service Area grouped by country and parent region.** This is the only
   non-trivial part:
   - `ProfileSummary.serviceAreas` is currently `List<String>` of names and
     throws away `parentName`. It must carry `List<ServiceArea>`.
   - `ProfessionalEntity` must parse `country_code`, which the endpoint already
     returns.
   - Needs its own renderer; `_ChipSection` only knows flat strings.
   - Turning `SG` into "Singapore" needs a code-to-name map. Agreed to use a
     small local map for the four seeded markets with the raw code as fallback,
     and to record that it belongs on the server.

## Then — the remaining improvement notes

Numbered as discussed with the user.

**F14 — verification and work eligibility.** The largest remaining item, and the
only one that touches the backend.

- The Credentials menu does not represent the verification process it contains,
  and sitting under Profile is wrong — verification is a gate on whether you may
  work, not a profile detail.
- **An unverified professional should meet verification first**, before anything
  else.
- Certificates become work eligibility for now, extracted from
  `edit_professional_profile.dart` into their own screen. Two things to settle
  with it:
  - **Certificates have no expiry date.** Work eligibility documents do —
    Indonesian STR runs five years. The moment certificate *means* eligibility,
    "verified" can go stale silently. Needs `expires_on`, and verification needs
    to care about it.
  - **Per-country variation belongs in a document-type catalogue**, served like
    conditions and areas are. Do not build it yet; do not hardcode "Certificate"
    as the only shape.
- Note this changes the backend spec's recorded position that work eligibility
  was deliberately not built pending research.

**F15 — picker and services refinements.**

- Area picker: select/deselect all per region, so wide coverage is not ticked one
  by one.
- Services & expertise: an `(i)` per service opening a bottom sheet with the
  description, matching the patient services list. Remove the "Your expertise"
  label.

## Known gaps, carried

- **Reviews have never had data.** `GET /v1/professionals/:id` does not return
  `reviews` at all — `findVerifiedProfessional` preloads certificates, services
  and the workplace address but no feedback relation. `Feedback` exists as a
  model and `ratingCount` is maintained by a hook, so the data is there and
  simply never loaded. The section shows "No reviews yet" for everyone.
- **AGENTS.md rule 3 is violated.** `booking_appointment` imports view code from
  `professional_profile`, and `ProfessionalEntity` imports domain entities from
  it. Pre-existing, now load-bearing. Fixing it means moving the shared view
  model, widgets and `LeveledEntry` to `lib/core`.
- **Service scope text is hardcoded English in the app.** ADR 0006 makes scope a
  property of a category, so it belongs beside the catalogue on the server. A
  nurse in Jakarta and one in Singapore read the identical list.
- **The type scale is applied, not enforced.** Roughly half the raw `fontSize:`
  literals remain, concentrated in `edit_professional_profile.dart`,
  `admin_professional_detail_page.dart` and `verification_hub_page.dart`. The
  first and third get rewritten in F14 — cheapest moment to finish the sweep.
- **The green dot on the patient header is hardcoded.** Fixed colour, always
  rendered, nothing drives it. It is in the mockup so it stays, but it currently
  tells the patient something untrue.
- **Nav labels are hardcoded English** on both roles while the app has `.arb`
  localisation. Predates this work, applies to the patient bar too.
- **ADR 0006 is not on the feature branch.** It lives alone on
  `docs/care-dna-decisions` (`797882d`), which also carries the CONTEXT.md
  paragraph. Both the backend spec and this README link to a path that does not
  exist on `feat/professional-expertise`. Worth cherry-picking.
- **Indonesia and China have no seeded areas.** The schema handles them; the data
  is not loaded. `GET /areas?country_code=ID` returns an empty list, and the
  coverage screen has a state for exactly that.

## Working agreements with the user

- Feature by feature. Plan first, self-review it, **wait for explicit
  confirmation**, then implement. Review, then they say commit.
- Short chat replies, B2 English, important points only. Detail goes in repo
  docs.
- Minimal code comments — only constraints the code cannot show itself.
- No tests for now (deadline).
- Run `fvm flutter analyze` sparingly; check for errors, not style.
- Never `dart format` a whole directory — it rewrote 138 unrelated files once.
  Format only touched files.
- Commit messages: one conventional line, no body, no co-author (AGENTS.md 11).
- Migrations: `node ace make:migration`, then rename the slug after the
  timestamp.

## Dev credentials

`dev.nurse@medmap.local` / `secret`, professional id **1052**, country **SG**.
It has real saved data — conditions, languages, care style, one rated service,
three SG districts, radius 18, gender, emergency contact, residential area and
work preferences. The user asked for it to be kept. Its workplace address is
seeded with coordinates only, so the patient page's address row reads "Not
specified" until a real one is set.

Login returns the token at `data.token.token`:

```
curl -s -X POST http://127.0.0.1:3333/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"dev.nurse@medmap.local","password":"secret"}'
```
