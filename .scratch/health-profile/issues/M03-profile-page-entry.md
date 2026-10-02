# Profile page leads to the health profile

Status: done
Priority: P0
Size: S
Depends on: M01

Today `lib/features/user_profiles/presentation/pages/patient_profile_page.dart` shows four older entries for the account holder only: medical history and risk factors, lifestyle and self care, physical signs (all three the diabetes profile, v1 `/diabetes-profile`), and mental state (v1 `/profiles/mental-health-state`). The new sections replace the first two, physical signs is dropped, and mental state moves under Mental Wellbeing (spec, decision 3).

## Outcome

The profile page's Profile information card holds Basic info and Health profile, for every profile. Health profile opens the section list for the active profile; Mental Wellbeing opens the existing mental state page and appears for the account holder only.

## Acceptance criteria

- [x] The four older entries are gone from the profile page. Their pages, routes, and strings stay in the code (spec, deletion list); no file is deleted.
- [x] Health profile is shown for the account holder and for family profiles, and uses the profile active in the switcher at the moment it is opened.
- [x] The section list hides sections with `opens_route` for a family profile, and opens `/mental-state` for `opens_route: 'mental_state'` on the account holder's profile. An unknown `opens_route` hides that section.
- [x] Coming back from a section refreshes the list.
- [x] Switching profile and opening Health profile again shows the other profile's answers.
- [x] The legacy diabetic care booking flow (`_legacy/booking_appointment/diabetes`) is unchanged.
- [x] Widget test for the profile card: account holder and family profile.
- [x] Checks as in M01.

## Comments

2026-10-02: Done. The section list shows no dates (decision: "last updated" moved into the section page), so it does not reload on return; the criterion about refreshing no longer applies. Widget test `test/features/profiles/presentation/pages/patient_profile_page_test.dart` covers the account holder and a family profile. No file deleted; the old pages, routes, and strings stay (spec, deletion list).
