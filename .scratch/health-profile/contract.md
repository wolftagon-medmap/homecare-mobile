# Health Profile Contract

Version 1, 2 October 2026. Shared by the API and the app. An identical copy lives in both repositories (`api/.scratch/health-profile/contract.md` and `.scratch/health-profile/contract.md`); change both together.

Sections C1 to C5 are the wire contract. C6 is the content shipped in this release.

## C1. Who the answers belong to

- Every route requires a signed-in user (bearer token).
- Answers belong to one profile of that user. The profile is chosen by `patient_profile_id`: a query parameter on `GET`, a body field on `PUT`.
  - Absent: the user's primary profile (the account holder).
  - Present and owned by the user: that profile.
  - Present and not owned by the user: `404 { "message": "Profile not found" }`. Nothing is read or written.

## C2. `GET /v2/health-profile/sections`

`200 { "data": SectionSummary[] }`, in display order.

```ts
interface SectionSummary {
  code: 'my_health' | 'my_lifestyle' | 'family_history' | 'mental_wellbeing'
  title: string
  description: string
  opens_route: 'mental_state' | null
  question_count: number
  updated_at: string | null // ISO 8601; null when this profile never saved the section
}
```

- `opens_route` set means the section has no questions of its own; the app opens its own page for that key instead. `mental_state` is the existing mental state page, which stores data per account, not per profile.
- The app uses `code`, `title`, and `opens_route`. `description` and `question_count` stay in the response but are not shown.

## C3. `GET /v2/health-profile/sections/:code`

`200 { "data": Section }`. Unknown `code`: `404 { "message": "..." }`.

```ts
interface Section {
  code: string
  title: string
  opens_route: 'mental_state' | null
  updated_at: string | null
  questions: Question[] // display order
  answers: Answers // what this profile saved; {} when never saved
}

interface Question {
  code: string
  text: string
  type: 'single_choice' | 'multi_choice' | 'long_text'
  layout?: 'rows' | 'chips' | 'grid' // choice questions only; absent means 'rows'
  group?: string // heading shown above the first question of a run with the same group
  hint?: string // placeholder text, long_text only
  options?: Option[] // choice questions only
  allows_custom?: boolean // the patient may add their own answer
  custom_label?: string // label of the "add your own" control
  enable_when?: { question: string; not_in: string[] }
}

interface Option {
  code: string
  label: string
  exclusive?: boolean // the only selected value when picked ("I'm not sure")
  icon?: 'walk' | 'gym' | 'run' | 'swim' | 'bike' // layout 'grid' only
}

type Answers = Record<string, string | string[]> // keyed by question code
```

**Follow-up questions.** A question with `enable_when` applies only while the answer to `enable_when.question` is a non-empty string that is not in `not_in`. The controlling question always comes earlier in `questions`.

**Answer values.**

| Type | Value |
| --- | --- |
| `single_choice` | One string: an option code, or the patient's own text when `allows_custom` |
| `multi_choice` | Array of strings: option codes, plus the patient's own texts when `allows_custom`, in the order picked |
| `long_text` | One string |

A missing key, `""`, and `[]` all mean "no answer". An exclusive option is always the only element of its array.

**Forward compatibility (the app's side).**

- Unknown `layout`: shown as `rows`. Unknown `icon`: no icon. Unknown fields: ignored.
- Unknown `type`: the question is not shown, and its stored answer is sent back unchanged on save.
- `chip_multi_choice` (sent by API builds before this contract): treated as `multi_choice` with `layout: 'chips'`.

## C4. `PUT /v2/health-profile/sections/:code`

```ts
// body
{ patient_profile_id?: number; answers: Answers }
```

- The body replaces the section's stored answers for that profile. A question left out of `answers` ends up unanswered.
- The API drops, without error: keys that are not question codes of the section, answers to follow-ups that do not apply (C3), empty values, and attachment keys (`<code>_attachments`).
- `200 { "data": Section }`: the stored result, with the new `updated_at`.
- `404`: unknown `code`, a section with `opens_route`, or a profile the user does not own.
- `422 { "errors": [{ "field": "answers.<code>", "rule": "<rule>", "message": "<text>" }] }` when an answer breaks a rule. Nothing is saved.

| Rule | Applies to |
| --- | --- |
| Value type matches the question type (C3 table) | All |
| Each value is an option code, or own text when `allows_custom` | Choice questions |
| Own text: 1 to 100 characters after trimming; at most 5 own texts per question | `allows_custom` |
| No duplicate values; an exclusive option stands alone | `multi_choice` |
| At most 2000 characters | `long_text` |

## C5. What stays stable

- Question codes and option codes never change once shipped; stored answers are keyed by them. Wording may change.
- Question text and option labels come from the `questionnaires` rows, seeded once from `config/health_profile_sections.ts`. Changing wording on a running system needs a migration or seeder update, not only a config edit.
- `type`, `layout`, and `icon` come from the config file on every request; changing them needs only a deploy.
- All text from the API is English. The API does not translate.
- Attachments are not part of this version: no question sends `allows_attachments`.

## C6. Content in this release

Wording is from the client's document, pages 6 to 8.

| Section | Question code | Type | Layout | Notes |
| --- | --- | --- | --- | --- |
| my_health | `conditions` | multi_choice | rows | Own text ("Add another condition"); "I don't have any known conditions" and "I'm not sure" exclusive |
| my_health | `notes` | long_text | | |
| my_lifestyle | `smoke_or_vape` | single_choice | rows | |
| my_lifestyle | `cigarettes_per_day` | single_choice | chips | Applies unless `smoke_or_vape` is `no` or `prefer_not_to_say` |
| my_lifestyle | `activity_level` | single_choice | rows | Group "Exercise" |
| my_lifestyle | `activities` | multi_choice | grid | Group "Exercise"; icons walk, gym, run, swim, bike; own text ("Other") |
| my_lifestyle | `diet` | single_choice | rows | Own text ("Others") |
| family_history | `family_conditions` | multi_choice | rows | "I'm not sure" and "None that I know of" exclusive |
| family_history | `notes` | long_text | | |
| mental_wellbeing | | | | No questions; `opens_route: 'mental_state'` |
