# The health profile reads and saves through the API

Status: ready-for-agent
Priority: P0
Size: M
Depends on: none

The feature `lib/features/health_profile` existed until `f15cd738` ("chore: delete unused health profile module", 13 September 2026). It was complete, but it ran behind the `healthProfileFlow` flag with a local fixture data source, which decision D4 bans. Several of its imports point at folders that have since moved (`features/profiles` is now `features/user_profiles`, `features/file_upload` is now `features/etc/file_upload`), and `AppRoutes.healthProfile` and the `healthProfile` strings were removed in `7356f42b`.

## Outcome

The health profile is a working feature on `develop` that talks only to `/v2/health-profile/sections` (contract C1 to C4) for the profile selected in the profile switcher. The pages from `f15cd738^` (section list and section page) work again. Rendering by layout is M02; the profile page entry is M03.

## Acceptance criteria

- [ ] `lib/features/health_profile` follows `AGENTS.md`: `domain`, `data`, `presentation`; repository returns `Either<Failure, T>`; Cubits; `go_router`; its own `injection.dart` registered in `service_locator.dart`; routes in `app_router.dart`.
- [ ] One data source, the remote one. No local data source, no fixture, no flag, nothing under `lib/` that returns made-up data.
- [ ] Entities match contract C3 (`layout`, `icon`, no `chip_multi_choice` type, no attachments). Parsing follows the forward-compatibility rules in C3, including `chip_multi_choice` read as `multi_choice` with `layout: chips`.
- [ ] Saving sends the whole answer set (C4): answers to questions the app does not show are sent back unchanged; answers to follow-ups that no longer apply are left out.
- [ ] `patient_profile_id` is the active profile's id, or omitted for the account holder.
- [ ] A `404` or `422` from the API becomes a failure with a translated message; the raw server text is never shown.
- [ ] Strings live in `lib/i18n/features/healthProfile/` in en, id, and zh, generated with `fvm dart run slang`. Only the strings the pages use; no subtitles.
- [ ] Tests under `test/features/health_profile/`: model parsing (every C3 field, unknown values, `chip_multi_choice`), cubit behaviour (load, select, exclusive, own text, follow-up hidden and dropped, dirty state, save success and failure), with fakes under `test/`.
- [ ] `fvm flutter analyze` shows no new issues against the `develop` baseline; `fvm flutter test` passes; changed files formatted.

## Comments
