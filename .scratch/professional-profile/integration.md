# Integrating Professional 360 with the existing profile screens

Follows [ADR 0006](../../../homecare-backend/docs/adr/0006-competence-is-a-level-not-a-catalogue.md).
Supersedes the six-chapter structure in [prototype.md](prototype.md), which bolted new
screens onto the existing three without asking whether the existing three were coherent.

**Status: implemented.** The hub is grouped, the skills screen is gone, proficiency sits
on services, scope text is in place, and location is on one screen. What is *not* done is
listed under "Still outstanding" at the end — the two free-text columns are still being
written by Edit Profile.

## The three overlaps, and why they are not the same kind of problem

**Availability vs schedule vs working hours — duplication.**
`professionals.working_hours` is a free-text string the professional types by hand. No
scheduling logic reads it anywhere in the backend; it is written by the update validator
and displayed to patients. The real bookable times live in `provider_availabilities`.
A professional can type "Mon–Fri 9–5", set their availability to weekends, and the patient
is shown the false one. **Delete the column, derive the display string from the schedule.**

**Workplace vs radius vs service areas — duplication plus three real concepts.**
`professionals.workplace` is another free-text string shadowing the structured geocoded
workplace address that distance matching actually uses. Same fix: **delete the string.**
What remains is genuinely three things and all three earn their place — the base address is
the origin, the radius is how far they will travel from it, and service areas are the coarse
"will I go to that district at all" filter. They belong on one screen, named so the
difference is obvious.

**Skills vs services — neither.** Settled by ADR 0006: competence becomes a proficiency
level on `professional_services`, and what a visit includes becomes scope text on the
category. The separate skills screen is dropped.

## The hub

Seven screens in three groups. The Care DNA card stays as the summary at the top.

| Group | Screen | Built from |
| --- | --- | --- |
| **Me** | Personal details | existing Edit Profile, minus working hours and workplace strings, plus gender, emergency contact, work eligibility, residential area |
| | Credentials & verification | existing certificates + the shipped verification hub |
| **My practice** | Services & expertise | existing My Services + proficiency level per service + read-only scope panel |
| | Condition experience | new, unchanged from the prototype |
| | Languages & care style | new, minus the Daily Care entries that moved to scope |
| **My work setup** | Schedule | existing Working Schedule, now the single source of truth for when someone works |
| | Where I work | base address + travel radius (both moved out of Edit Profile) + service areas |
| | Work preferences | capacity, shift types, client and household preferences |

## What changes per screen

**Edit Profile** loses the working hours field and the workplace picker. Both move or die.
It becomes what its name says: who this person is.

**My Services** gains a level control on each selected service and a panel showing what the
category includes. This is where the prototype's skills screen went.

**Working Schedule** is unchanged in function but becomes authoritative — the patient-facing
"working hours" line is now generated from it rather than typed.

**Languages & care style** keeps languages and the ten communication traits. Personal
hygiene, feeding assistance, toileting, companionship and family communication leave: they
are the scope of the elderly homecare service, not personality.

**Where I work** is new as a screen but mostly relocation. Only service areas are new data.

## Deleted

- `SkillsExperiencePage` and the whole skills catalogue. Condition experience moved to its
  own screen, `ConditionExperiencePage`.
- Service areas from Work preferences — they belong with the other two location concepts.

## Still outstanding

The two free-text columns are **not** yet removed. `professionals.working_hours` and
`professionals.workplace` are still written by Edit Profile and still displayed to
patients, so the contradiction described above is still live. Removing them is a change to
shipped code plus a backend migration, and it wants doing deliberately rather than folded
into a prototype:

1. Stop collecting them in `edit_professional_profile.dart`.
2. Derive the patient-facing working-hours line from `provider_availabilities`, and the
   location line from the geocoded workplace address.
3. Drop both columns once nothing reads them.

Personal details is also unbuilt — gender, emergency contact, work eligibility and
residential area. Work eligibility is blocked on the per-country document research, so the
chapter is currently the existing Edit Profile screen under a clearer name.

## Spun out, not decided here

**Nursing has no visit base.** A single injection books at $10, which does not cover travel.
Fixing it means reversing the unified-catalogue migration's recorded position that
"procedures are not add-ons, they are the service". Additive is the instinct, per category
rather than per role — the structural reason being that conversational booking quotes a
price from category alone, before any professional is chosen, so a per-role base could not
be quoted upfront. This is a price change with revenue implications and belongs to the PM
and the client, not to this work.

**Homecare is billed twice differently.** Self-service multiplies the catalog price by
duration (`durationHours * price`, $50 for two hours); conversational booking takes the
price raw ($25). The catalog documents `hourly_rate` as multiplying; the conversational
strategy comment asserts the price is already the flat visit total. Both are internally
consistent and they disagree. Needs a ticket.
