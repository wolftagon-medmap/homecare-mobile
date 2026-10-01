# AI Assistant Health Check: Contract

Status: agreed with the lead on 1 October 2026. **This is a copy.** The source of truth is the backend repository, `api/.scratch/assistant-health-check/contract.md`. If the two differ, the backend copy wins; update this one in the same change.

The app only implements section A. Sections B and C are here so you know what the backend can and cannot send; do not implement them in the app.

Read `spec.md` in this folder first for what the feature is and why. This file only says what crosses each boundary, exactly.

Three boundaries:

- **A. App ↔ Backend**: HTTP endpoints, the block JSON the app renders, and the reply ids the app sends back.
- **B. Backend ↔ AI service**: the `/turns` request and result.
- **C. AI service ↔ model**: the prompt and the JSON the model must return.

Names are case-sensitive. JSON keys are camelCase in A and B, snake_case in C (model output only). Never invent a field that is not listed here.

---

## Shared constants

| Name | Value | Owner |
| --- | --- | --- |
| `MAX_QUESTIONS` | `4` | Backend |
| Options per question | 2 to 6, before the backend adds its own extra option | Backend validates |
| Option label length | at most 60 characters | Backend validates |
| Question text length | at most 200 characters | Backend validates |
| `mainIssue` length | at most 120 characters | Backend validates |
| `guidance` length | at most 600 characters | Backend validates |
| Services per assessment | 1 to 3 | Backend validates |
| `remarks` length (booking prefill) | at most 300 characters | Backend builds, app trusts it |
| Single-choice extra option | `"I'm not sure"` | Backend appends if no option already matches it (case-insensitive) |
| Multi-choice extra option | `"None of these"`, marked exclusive | Backend appends |

### Topic codes

Fixed list, owned by the backend config (`assistant_gateway/config/assistant_topics.ts`, see backend issues). Labels, icons, and tones are the ones the current app script uses.

| code | label | icon | tone |
| --- | --- | --- | --- |
| `symptom` | I have a symptom | `symptom` | `teal` |
| `medication` | I have a medication question | `medication` | `red` |
| `concern` | I have a health concern | `concern` | `purple` |
| `lifestyle` | I want to improve my lifestyle | `lifestyle` | `green` |
| `stress` | I'm feeling stressed or worried | `stress` | `pink` |
| `results` | I want to understand my health results | `results` | `blue` |
| `someone` | I'm asking for someone else | `someone` | `amber` |
| `other` | Something else | `other` | `grey` |

### Service categories the assistant may suggest

`pharmacy`, `physiotherapy`, `psychology`, `optometry`, `nursing`, `screening`, `diabetes_screening`.

`nutrition` exists in the issue catalogue but is excluded: the home screen keeps the dietitian on its legacy page. Adding it later is a one-line change in `assistant_topics.ts`.

Sub-category and issue codes come from `api/app/modules/care_task/config/issue_catalogue.ts` (`ISSUE_CATALOGUE`). Nothing else is a valid code.

---

## A. App ↔ Backend

All endpoints exist today (`start/routes/v2/channels.ts`, controller `channels/controllers/in_app_controller.ts`). All require `Authorization: Bearer <token>`. Base path: `${Const.URL_API_V2}/intake`.

### A1. Endpoints

| Method and path | Body | Response | Notes |
| --- | --- | --- | --- |
| `POST /v2/intake/sessions` | `{}` or `{"fresh": true}` | `200 {"conversationId": "<uuid>"}` | Starts or resumes the user's one active session. `fresh: true` archives the active one first. **New:** when the session has no messages yet, the backend sends the welcome blocks (A3) before responding, so they are already in A1 `messages`. |
| `GET /v2/intake/sessions` | — | `200 {"sessions": [Session]}` | Newest first. |
| `DELETE /v2/intake/sessions/:id` | — | `200 {"deleted": true}`, `404`, `409` (active session) | |
| `GET /v2/intake/sessions/:id/messages` | — | `200 {"blocks": [Block]}` | Full transcript, oldest first. Includes the patient's own turns as `user_text`. |
| `POST /v2/intake/messages` | `{"sessionId": "...", "text": "..."}` or `{"sessionId": "...", "replyId": "...", "text": "<label shown to the user>"}` | `202 {"queued": true}`, `404`, `409` (archived session) | The server may take up to about 60 seconds to answer this call, because the AI turn runs before it returns. The app must use a 60-second receive timeout for this call. Replies arrive on the stream, not in this response. |
| `GET /v2/intake/stream/:id` | Header `Accept: text/event-stream`, optional `Last-Event-ID: <int>` | Server-sent events | Each event: `id: <int>`, `event: <kind>`, `data: <Block JSON>`. A comment line `: ping` arrives every 25 seconds. On reconnect, send the highest block id seen; the server replays everything after it. The stream only carries outbound blocks, never `user_text`. |

`Session`:

```json
{ "id": "uuid", "active": true, "preview": "text or null", "lastMessageAt": "ISO-8601 or null", "createdAt": "ISO-8601" }
```

### A2. Block JSON

Every block has `id` (integer, the stored message id, unique and increasing within a session) and `kind`. The app dedupes by `id`. Unknown `kind` values must be ignored without error (render nothing).

#### Existing kinds the assistant screen must render

```json
{ "id": 11, "kind": "user_text", "text": "I've been feeling dizzy" }
{ "id": 12, "kind": "assistant_text", "text": "...", "origin": "ai" }
{ "id": 13, "kind": "staff_text", "text": "...", "authorUserId": 42 }
{ "id": 14, "kind": "confirm_request", "text": "...", "confirmId": "confirm:abc", "cancelId": "decline:abc" }
```

- `origin` is `"ai"` or `"system"`. Both render as an assistant bubble.
- `staff_text` renders as an assistant bubble labelled as the M2Health team.
- `confirm_request` renders the text plus two buttons, **Confirm** and **Cancel**. Tapping sends A4 with `replyId` = `confirmId` or `cancelId`. One-shot.
- `location_request`, `user_location`, `professional_shortlist`: the assistant screen renders `location_request` and `user_location` as a plain assistant bubble showing `text`, and ignores `professional_shortlist`. They should not occur on the app channel (see spec), but must not crash.

#### New kinds

`topic_grid`:

```json
{
  "id": 1,
  "kind": "topic_grid",
  "title": "What can I help you with today?",
  "topics": [
    { "replyId": "topic:symptom", "label": "I have a symptom", "icon": "symptom", "tone": "teal" }
  ]
}
```

`question`:

```json
{
  "id": 20,
  "kind": "question",
  "questionId": "q1",
  "text": "When do you usually feel dizzy?",
  "mode": "single",
  "hint": "Please choose one.",
  "options": [
    { "index": 0, "label": "When standing up" },
    { "index": 1, "label": "When walking" },
    { "index": 2, "label": "I'm not sure" }
  ],
  "continueLabel": null,
  "exclusiveIndex": null
}
```

- `mode` is `"single"` or `"multi"`.
- `hint` is `"Please choose one."` for single and `"You can choose more than one."` for multi.
- For `multi`: `continueLabel` is `"Continue"`, and `exclusiveIndex` is the index of `"None of these"`. Selecting the exclusive option clears the others; selecting any other option clears the exclusive one.
- For `single`: both are `null`.

`summary`:

```json
{
  "id": 30,
  "kind": "summary",
  "title": "Your Summary",
  "rows": [
    { "icon": "issue", "label": "Main issue", "value": "Dizziness for about 3 days" },
    { "icon": "answer", "label": "When do you usually feel dizzy?", "value": "When standing up" }
  ],
  "footnote": "Please review and let me know if I've missed anything.",
  "editLabel": "Edit Answers",
  "confirmLabel": "Looks good",
  "editReplyId": "summary:edit",
  "confirmReplyId": "summary:ok"
}
```

- `icon` is one of `issue`, `answer`. Unknown icons fall back to `answer`.

`guidance`:

```json
{
  "id": 31,
  "kind": "guidance",
  "title": "General guidance",
  "body": "Dizziness can have many causes ...",
  "disclaimer": "This is general information, not a diagnosis. If your symptoms are severe or getting worse, seek medical care.",
  "suggestionsTitle": "You may also consider:",
  "suggestions": [
    {
      "replyId": "svc:0",
      "title": "Medication Support",
      "subtitle": "Review your medications with a pharmacist.",
      "icon": "pharmacy",
      "tone": "red",
      "booking": {
        "category": "pharmacy",
        "subCategory": "medication_support",
        "issueCodes": ["med_side_effects"],
        "remarks": "Dizziness for about 3 days. When standing up."
      }
    }
  ]
}
```

- `suggestions` may be empty. Then `suggestionsTitle` is `null`.
- `icon` equals the `category` code. `tone` per category: `pharmacy` red, `physiotherapy` blue, `psychology` pink, `optometry` purple, `nursing` teal, `screening` green, `diabetes_screening` amber.
- `subCategory` may be `null`. `issueCodes` may be empty.
- Tapping a suggestion is handled **in the app only**: open guided booking with `booking` (A5). Nothing is sent to the backend.

`next_step`:

```json
{
  "id": 32,
  "kind": "next_step",
  "actions": [
    { "replyId": "next:explore", "action": "explore_services", "title": "Explore M2Health Services", "subtitle": "Find the right service for you", "icon": "services", "tone": "red" },
    { "replyId": "next:save", "action": "reply", "title": "Save My Summary", "subtitle": "Save and come back later", "icon": "save", "tone": "green" },
    { "replyId": "next:new", "action": "new_conversation", "title": "Ask Another Question", "subtitle": "I still have more questions", "icon": "ask", "tone": "blue" }
  ]
}
```

`action` tells the app what to do:

| `action` | App does |
| --- | --- |
| `explore_services` | Push the all-services page (`AppRoutes.allServices`; see mobile issue M5). Nothing sent. |
| `new_conversation` | Ask for confirmation, then `POST /sessions` with `fresh: true` and reload. Nothing else sent. |
| `reply` | Send A4 with this `replyId` and `text` = `title`. |

Unknown `action` values render the row disabled.

### A3. Server-sent sequences

Welcome (new session, before `POST /sessions` returns):

1. `topic_grid`

Health check, step by step:

1. Patient taps a topic or types a concern.
2. Server sends `question` (q1). Repeats after each answer, up to `MAX_QUESTIONS`.
3. Server sends `assistant_text` ("Thanks! Here's what I understand so far.") then `summary`.
4. On `summary:ok`: `assistant_text` ("Based on what you've shared, here are some possible next steps."), `guidance`, `assistant_text` ("What would you like to do next?"), `next_step`.
5. On `summary:edit`: the answers are cleared and step 2 starts again with the same concern.

Any other typed message: one or more `assistant_text` blocks, or a `confirm_request` (reschedule or cancel of an existing booking).

### A4. Reply ids the app sends

`POST /v2/intake/messages` with `replyId`. Always also send `text` with the label the app showed for the tap, so the server can store the patient's side of the transcript.

| `replyId` | Sent when | `text` to send |
| --- | --- | --- |
| `topic:<code>` | Topic tapped | the topic label |
| `hc:<questionId>:<index>` | Single-choice option tapped | the option label |
| `hc:<questionId>:<index>,<index>,...` | Multi-choice **Continue** tapped (indices ascending, no spaces) | labels joined with `", "` |
| `summary:ok` / `summary:edit` | Summary buttons | the button label |
| `next:save` | Next-step action with `action: reply` | the action title |
| `confirm:<token>` / `decline:<token>` | `confirm_request` buttons | `Confirm` / `Cancel` |

Free text: `{"sessionId": "...", "text": "..."}` with no `replyId`.

The app shows the patient's own bubble immediately (optimistic, local id below zero) for both text and taps. The stream never echoes it back. A reload shows the server's stored `user_text` instead.

### A5. Booking hand-off (app only)

A `guidance` suggestion's `booking` object opens guided booking:

```dart
context.push(
  GuidedBookingRoutes.entry,
  extra: GuidedBookingArgs(
    category: booking.category,
    subCategory: booking.subCategory,
    issueCodes: booking.issueCodes,
    remarks: booking.remarks,
  ),
);
```

`GuidedBookingArgs.issueCodes` and `.remarks` are new (mobile issue M4). The guided booking flow starts with these pre-selected and does not restore a previously saved draft for that category.

---

## B. Backend ↔ AI service

`POST {AI_SERVICE_URL}/turns`, header `X-Internal-Token`. Existing endpoint (`ai/app/api/routes.py`); the fields marked **new** are added.

### B1. Request

```json
{
  "conversationId": "uuid",
  "patientMessage": "text the patient sent, or the label of the tap",
  "history": [{ "role": "user", "content": "..." }],
  "draftSnapshot": null,
  "pendingProposal": null,
  "channel": "app",
  "mode": "auto",
  "healthCheck": null,
  "catalogue": null
}
```

New fields:

| Field | Type | Meaning |
| --- | --- | --- |
| `channel` | `"app"` \| `"whatsapp"` | Where the patient is. |
| `mode` | `"auto"` \| `"health_check"` | `health_check` skips intent classification and runs the health check node directly. The backend sends it when the patient answered a question, tapped a topic, or tapped Edit. |
| `healthCheck` | `HealthCheckSnapshot` \| `null` | Present when `mode` is `health_check`. |
| `catalogue` | `CatalogueEntry[]` \| `null` | Present whenever `healthCheck` is present, and also on every `auto` turn, so that a typed concern can start a health check in the same turn. |

`HealthCheckSnapshot`:

```json
{
  "concern": "I have a symptom: I've been feeling dizzy",
  "turns": [
    { "questionId": "q1", "text": "When do you usually feel dizzy?", "mode": "single", "options": ["When standing up", "When walking", "I'm not sure"], "answer": "When standing up" }
  ],
  "forceAssessment": false
}
```

- `answer` is always a string: the chosen label, multiple labels joined with `", "`, or the patient's typed text.
- `forceAssessment` is `true` when `turns.length >= MAX_QUESTIONS`.

`CatalogueEntry` (built by the backend from `ISSUE_CATALOGUE`, filtered to the allowed categories):

```json
{
  "category": "pharmacy",
  "title": "Pharmacist Review",
  "issues": [{ "code": "x", "label": "..." }],
  "subCategories": [
    { "code": "medication_support", "label": "Medication Support", "issues": [{ "code": "med_side_effects", "label": "Medication side effects" }] }
  ]
}
```

### B2. Result

```json
{ "replyText": "...", "requestsLocation": false, "ui": null }
```

New field `ui`: `null`, or one of:

```json
{ "type": "question", "text": "When do you usually feel dizzy?", "mode": "single", "options": ["When standing up", "When walking"] }
```

```json
{
  "type": "assessment",
  "mainIssue": "Dizziness for about 3 days, mostly when standing up",
  "guidance": "Dizziness can have many causes ...",
  "services": [
    { "category": "pharmacy", "subCategory": "medication_support", "issueCodes": ["med_side_effects"], "reason": "Review your medications with a pharmacist." }
  ]
}
```

Rules:

- When `ui` is present, `replyText` is a short lead-in sentence or an empty string; the backend ignores it for `question` and `assessment`.
- In `mode: auto`, the AI service returns a `question` or `assessment` only when the message was classified as a health concern (or, on `channel: app`, as a new booking). The backend treats such a result as the start of a new health check whose `concern` is `patientMessage`.
- In `mode: health_check`, `ui` must be present. If the AI service cannot produce a valid one, it returns `ui: null` and the backend falls back (spec, "Fallbacks").

### B3. What the backend validates in `ui`

Before sending anything to the app, the backend:

1. `question`: trims; drops empty and duplicate options; truncates labels to 60 characters and text to 200; requires at least 2 options remaining and cuts to the first 6; appends the extra option (Shared constants). Invalid: treated as a failure.
2. `assessment`: truncates `mainIssue` and `guidance`; keeps services whose `category` is allowed; sets `subCategory` to `null` when it is not a sub-category of that category; keeps only issue codes from the valid list, which is the sub-category's `issues` when the sub-category has any, otherwise the category's `issues` (the same rule as the app's `IssueCatalogue.issuesFor`); keeps the first 3 services; de-duplicates by `category` + `subCategory`. Zero services left is allowed (guidance with no suggestions).
3. A `question` received when `forceAssessment` was `true` is a failure.

---

## C. AI service ↔ model

The in-house model (about 32B parameters, OpenAI-compatible) has no system role and no native tool calling. Every instruction goes into one `user` message (already done by `PromptedChatModel`). The health check makes **one model call per turn, with no tools**.

### C1. Prompt for the health check node

Built by `ai/app/prompts/health_check_prompt.py`. The exact text is in AI issue A3. It contains, in this order: the role and the rules, the output format with one example of each shape, the catalogue as compact lines, the concern, the questions and answers so far, and the instruction for this turn (`Ask the next question` or `You must now give the assessment`).

### C2. Output the model must return

Exactly one JSON object, nothing else. Either:

```json
{"type": "question", "text": "...", "mode": "single", "options": ["...", "..."]}
```

or:

```json
{"type": "assessment", "main_issue": "...", "guidance": "...", "services": [{"category": "...", "sub_category": "... or null", "issue_codes": ["..."], "reason": "..."}]}
```

The AI service extracts the first JSON object from the reply (code fences and text around it are tolerated), validates it with pydantic, retries once with the validation error quoted, and converts snake_case to the camelCase of B2. Codes are not checked against the catalogue in the AI service; the backend does that (B3).

### C3. Intent classification

`classify_intent` gains one intent id, `health_concern`: "describes a symptom, a health problem, or asks what kind of care they need".

| Intent | `channel: app` | `channel: whatsapp` |
| --- | --- | --- |
| `health_concern` | `health_check` | `answer_question` (WhatsApp cannot show the cards yet) |
| `book` | `health_check` (new bookings in the app go through the guided booking screens) | `progress_booking` (unchanged) |
| all others | unchanged | unchanged |

So in this MVP, `ui` is only ever returned for `channel: app`.
