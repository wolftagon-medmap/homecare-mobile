# Release check

Status: ready-for-agent
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
