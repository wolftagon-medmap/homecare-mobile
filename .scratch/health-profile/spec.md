# Health Profile (app)

Source: `m2Health App Suggestions.pdf`, pages 6 to 8 ("Updating my health profile in the app"). Wire contract: [contract.md](contract.md). Backend counterpart: `api/.scratch/health-profile/` in the backend repository.

## Outcome

A patient keeps a health profile for themselves and for each family member, and updates it whenever they want. From Profile they open Health profile, pick a section, change only what they want, save, and come back later to the same answers.

## What the patient sees

**Profile page.** The Profile information card holds two entries: Basic info and Health profile. The four older entries (medical history and risk factors, lifestyle and self care, physical signs, mental state) are no longer on the page. Health profile is shown for every profile in the profile switcher.

**Health profile page.** One row per section, showing the section title only: My Health, My Lifestyle, Family Health History, Mental Wellbeing. A family member's profile shows the first three; Mental Wellbeing is only on the account holder's profile, because the mental state page stores data per account.

**Section page.**

- The section title, and under it "Last updated 28 Sep 2026" once the section has been saved for this profile. Nothing under the title before that.
- The questions in the order the API sends them, with a group heading (for example "Exercise") above the first question of a group.
- Each choice question drawn in its layout from the API:
  - `rows`: one bordered row per option, radio for single choice, checkbox for multi choice.
  - `chips`: wrapping chips.
  - `grid`: tiles, three per row on a phone, each with its icon above the label.
- Exclusive options ("I'm not sure", "I don't have any known conditions") sit after the other options, separated by a divider. Picking one clears the others; picking another option clears it.
- Where the patient may add their own answer, an "Add another condition" or "Other" control opens a text field in place. What they type becomes a selected option they can remove.
- A follow-up question ("How many cigarettes...") appears straight after the question that controls it, only while it applies. When it stops applying, it disappears and its answer is not saved.
- Free-text questions are a multi-line text box.
- Save sits at the bottom. It is enabled only when something changed. Saving shows "Saved" and returns to the list. Going back with unsaved changes asks whether to discard them.
- No subtitles or helper text beyond the questions themselves.

**Mental Wellbeing** opens the existing mental state page, unchanged.

**States.** Loading shows a spinner with what is loading. A failed load shows what failed and a Retry button. A failed save keeps the patient's answers on screen and says the section was not saved.

## Quality bar

- Text contrast at least 4.5:1. Selected options use `#0B5F66` on `#E6F8F9` (6.7:1); the Save button uses white on `#0B7A82` (5.1:1). The app's current aqua button is 2.1:1 and is not used here (decision 9).
- Every tap target at least 48 dp high.
- Screen readers announce each option's label and whether it is selected, and each question's text.
- No clipping or horizontal overflow at 320 dp width or with system text size at 130%.
- App-owned strings in English, Indonesian, and Chinese (slang namespace `healthProfile`). Question text is English, as the API sends it.
- Design direction: the guided booking components and colours (Adel's design); antislop dials ENERGY 1, RHYTHM 1, MOTION 1. No decoration without a purpose.

## Data that does not change

- The older forms' data (diabetes profile, mental health state) stays in the database, untouched and not migrated. The v1 endpoints keep working; the legacy diabetic care booking flow still uses the diabetes profile.
- Nothing in the app reads the new answers except the health profile pages.

## Not in this release

- Attachments on "Anything else you'd like to add?" (needs an ownership check on uploaded files first).
- A "My Health" tab and the new bottom navigation bar (waits for Adel's design).
- Questions of its own for Mental Wellbeing (waits for Adel, through the PM).
- Translated question text.
- A history of earlier answers; only the latest save is kept.

## Decisions

| # | Decision | By | Date |
| --- | --- | --- | --- |
| 1 | Entry point is a Health profile entry on the existing profile page | User | 2026-10-02 |
| 2 | Restore the feature deleted in `f15cd738` and adapt it; no local data source, fixture, or flag (D4) | User | 2026-10-02 |
| 3 | The four older entries leave the profile page; physical signs is dropped; mental state is reached through Mental Wellbeing | User | 2026-10-02 |
| 4 | Mental Wellbeing ships as the existing mental state page; Adel is asked through the PM to confirm or supply questions | User | 2026-10-02 |
| 5 | Family profiles are in scope, except Mental Wellbeing | User | 2026-10-02 |
| 6 | Attachments are out of this release | User | 2026-10-02 |
| 7 | The screen is built from templates; the API sends layout hints (`rows`, `chips`, `grid`) and grid icons | User | 2026-10-02 |
| 8 | Ships in the same app release as the AI Assistant | User | 2026-10-02 |
| 9 | Save button is darker teal `#0B7A82` for this feature only; the shared `StickyBottomCta` stays as it is | User | 2026-10-02 |
| 10 | Antislop rules apply during the work | User | 2026-10-02 |
| 11 | Backend hardening: validation (B02) and own-profile check (B03) | User | 2026-10-02 |

## Deletion list

**Nothing is deleted.** After M03 these files and entries are no longer reachable from the app. They stay in place as clean-up candidates until the user confirms their removal:

- `lib/features/patient_health_profile/etc/presentation/pages/edit_medical_history_n_risk_factor_page.dart`
- `lib/features/patient_health_profile/etc/presentation/pages/edit_lifestyle_n_selfcare_page.dart`
- `lib/features/patient_health_profile/etc/presentation/pages/edit_physical_sign_page.dart`
- In `lib/features/user_profiles/profile_detail_routes.dart`: the routes for `AppRoutes.profileMedicalHistory`, `AppRoutes.profileLifestyle`, `AppRoutes.profilePhysicalSigns`
- In `lib/route/app_routes.dart`: those three constants
- In `lib/l10n/app_*.arb`: `profile_patient_medical_history_n_risk_factor`, `profile_patient_lifestyle_n_selfcare`, `profile_patient_physical_sign`, `profile_patient_mental_state`

The restored feature leaves out, from `f15cd738^`: `data/datasources/health_profile_local_datasource.dart`, `data/fixtures/health_profile_fixture.dart`, `presentation/widgets/attachment_field.dart`, the attachment data source and use case, and the `.gitkeep` files. They are not restored, so nothing in the repository is removed.

## Issues, in order

| # | Issue | Depends on |
| --- | --- | --- |
| M01 | [The health profile reads and saves through the API](issues/M01-health-profile-on-the-api.md) | |
| M02 | [Questions render from the contract's layouts](issues/M02-questions-render-from-layouts.md) | M01 |
| M03 | [Profile page leads to the health profile](issues/M03-profile-page-entry.md) | M01 |
| M04 | [Release check](issues/M04-release-check.md) | M02, M03; backend B01 to B03 deployed |

The app works against an API without the backend issues: activities then show as chips instead of a grid, and invalid answers are not rejected. The release still waits for B01 to B03.
