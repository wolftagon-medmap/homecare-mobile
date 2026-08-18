# PRD compliance review

Checked the prototype against `M2Health_Professional_Client_Digital_Profile_Upgrade_PRD.pdf`,
section by section. Legend: **done** in the prototype, **partial**, **not built**.

## Section 3 — Healthcare Professional Digital Profile

| PRD field | State | Where |
| --- | --- | --- |
| Full Name | done | Personal details |
| Profile Photo | done | Personal details |
| Gender | done | Personal details (prototype store — no backend column) |
| Work Eligibility | **not built** | needs per-country document research first |
| Phone | partial | on the account, not editable as a profile field |
| Email | partial | same |
| Residential Area | done | Personal details (prototype store) |
| Service Areas | done | Coverage area |
| Emergency Contact | done | Personal details (prototype store) |
| Profile Status | partial | four states live; `suspended` agreed but not built |

## Sections 4-8

| PRD section | State | Notes |
| --- | --- | --- |
| 4 Language proficiency L0-L5 | done | 7 languages, select-then-rate |
| 5 Condition experience E0-E5 | done | all 13 conditions |
| 6 Clinical & service skills | done, restructured | per ADR 0006 these are a level on a service plus category scope text, not a catalogue |
| 7 Communication & service style | done | 10 traits, self-declared only. The PRD's other three sources (client feedback, coordinator review, service records) are not built |
| 8 Availability & preferences | done | all 16 items across Working hours, Coverage area and Work preferences |

## Section 9 — Care DNA

The summary line renders as the PRD example does: role, languages, conditions,
services, style, district, shift.

Of the seven named components, five are real: professional qualification (role and
credentials), clinical capability, condition experience, communication fit, service style.
**Mobility & safety support** is only partly covered — lift transfer is a preference
toggle, but there is no mobility-specific capability. **Reliability** is not built and has
no data source; it would have to come from completion and punctuality history.

## The other four PRD modules

The PRD names six modules and specifies two. Of the rest:

- **Professional Score** — not built. Still undefined in the PRD; no formula, no inputs.
- **Client Digital Profile** — not built here. Closest existing work is the multi-profile
  and saved-addresses branches, which are not merged.
- **Dynamic Profile Update After Service** — not built. There is nothing to update
  automatically while every field is self-declared.
- **Bidirectional Matching Foundation** — not built, deliberately. Nothing on these
  screens affects matching yet.

## Honest gaps

Everything marked "prototype store" is held in memory and disappears when the app
restarts. Gender, residential area and emergency contact have no backend columns, so they
demonstrate the target screen rather than working end to end.

Work eligibility is the one PRD field with nothing at all behind it. It stays blocked on
knowing which document each market requires — SIP and STR in Indonesia, and the
equivalents in Singapore, Malaysia and China.
