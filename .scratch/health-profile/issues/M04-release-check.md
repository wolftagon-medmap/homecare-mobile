# Release check

Status: ready-for-human
Priority: P0
Size: S
Depends on: M02, M03; backend B01 to B03 deployed to the API the app is checked against

The feature ships in the same app release as the AI Assistant (spec, decision 8). No design from Adel exists for it, so the PM and Adel see it before release.

## Outcome

The feature is verified end to end against a real API with seed data, the PM and Adel have approved screenshots, and the release notes mention it.

## Acceptance criteria

- [ ] Against a local backend with B01 to B03: every section loads, saves, and reloads with the same answers, for the account holder and for one family profile. Recorded step by step in the comments.
- [ ] A `422` (for example 101 characters of own text sent by a test client) leaves the app's answers on screen with a translated error.
- [ ] Against the production API as it is on release day: the section list loads (proves `/v2/health-profile/sections` is deployed).
- [ ] Screenshots of the list and each section, in English and Indonesian, on a small and a large phone, sent to the PM for Adel. Their answer recorded in the comments.
- [ ] One line for the release notes, agreed with the PM.
- [ ] Antislop Delivery Gate report attached to the comments.
- [ ] Implementation log entry `Health profile (agent) · done`.

## Comments

2026-10-02, agent check (backend branch at `33ae3c41` on a local MySQL 8, app web build pointed at it, phone viewport 375 to 390 wide; the build and the `BASE_URL` change were not committed):

- Scripted API check, 13 of 13 passed: list of four sections; no question carries `allows_attachments`; activities is `grid` with five icons; a lifestyle save stores trimmed own text and reloads the same; 101 characters of own text gives `422` with rule `length`; `PUT` on Mental Wellbeing gives `404`; a family profile's answers stay apart from the account holder's; an unknown profile id gives `404 Profile not found`.
- In the app: the profile page shows Basic Information and Health Profile; the list shows four titles; My Lifestyle shows its saved answers, "Last updated Oct 2, 2026", chips, the grid with icons, the own answer "Yoga" as a tile; picking Gym and saving returns to the list and the API holds `["walking","Yoga","gym"]`; in My Health, "I'm not sure" clears Diabetes and an own condition clears "I'm not sure"; Mental Wellbeing opens the existing mental state page. The discard prompt is covered by a widget test (the browser pane mis-placed clicks at that zoom).
- Found and fixed during the check: the notes hint said "You can also attach reports." although attachments are not offered (backend `24e72f78`, a data migration plus the config); the entry label now matches the title case of its neighbours (mobile `722482ad`).
- Production (`homecare-api.med-map.org`) answers `401` on `/v2/health-profile/sections` without a token and `404` on an unknown path, so the health profile routes are deployed there (without B01 to B03). The app works against it: activities then show as chips, and bad answers are not rejected until the backend branch is deployed.

Antislop Delivery Gate (UI of this feature):
- R-02 PASS: no em dash in the feature's strings (the en dash in "1–5 sticks" is the client's own wording from the API).
- R-03 PASS: widget test at 320 dp width and 130% text, no overflow; checked at 375 and 390 in the browser.
- R-25 PASS: every text pair 4.68:1 or more (pairs listed in M02).
- R-26 PASS: every control has a behaviour (rows, chips, tiles toggle; own answer adds and removes; Save saves; Retry reloads).
- R-27 PASS: loading, load error with Retry, save error with the reason, empty list.
- R-32 PASS: InkWell and buttons are focusable; Flutter draws the focus highlight.
- R-35 PASS with a limit: run in a web build against a real API; not run on an Android or iOS device.
- R-04: grid icons are Material icons named after the activity (walk, gym, run, swim, bike); no decorative icons elsewhere.
- Dials ENERGY 1 / RHYTHM 1 / MOTION 1, direction from the guided booking screens (Adel's design).

Still for a person: screenshots in English and Indonesian on a small and a large phone, sent to the PM for Adel; one line for the release notes (draft: "Keep a health profile for yourself and your family: conditions, lifestyle, and family history, updated whenever you like."); a run on a real Android or iOS device.
