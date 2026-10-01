# AI Assistant Health Check (app)

Status: ready-for-agent (plan agreed with the lead, 1 October 2026)
Contract: `contract.md` in this folder, section A. Read it before any issue.
Backend side: backend repository, `api/.scratch/assistant-health-check/` (spec, contract, issues 01 to 11).
Branch: `feat/assistant-health-check`, based on `refactor/remove-data-source-flags` (that branch already changed `features/chatbot/injection.dart`).

## What changes for the patient

The AI Assistant screen (`features/chatbot`) keeps its look, but the conversation now comes from the server:

- The topic grid, the questions, the summary, the guidance, and the next steps are blocks the backend sends over `/v2/intake` (contract A2). The questions are written by the model for whatever the patient describes; the app never decides what to ask.
- Typed messages go to the server too: they can start a health check, answer the open question, ask a general question, or reschedule or cancel a booking (a Confirm/Cancel card).
- A service suggestion opens guided booking with the category, sub-category, issues, and remarks already filled in (contract A5).
- History lives on the server, so it works across devices.

## Why the app goes first

The app needs a store release through the project manager's device. The backend and AI service are patched later by the lead. Everything in the app is built and tested against `contract.md` with fakes; no backend is needed to finish issues M01 to M05.

A build of this branch against a backend that is not patched yet must not crash: the session starts, the transcript is empty, the hero and composer show, and typed messages get the existing text replies.

## What the app does not do

- No medical logic, no question script, no answer storage on the device.
- No new booking inside the chat; bookings go through guided booking.
- No WhatsApp-specific behaviour.

## Approved deletion list

These files are replaced by the server-driven version. The lead approved deleting them together with this plan. Delete exactly these and nothing else.

- `lib/features/chatbot/data/datasources/assistant_script_datasource.dart`
- `lib/features/chatbot/data/datasources/assistant_session_store.dart`
- `lib/features/chatbot/data/models/assistant_script_model.dart`
- `lib/features/chatbot/data/models/assistant_session_model.dart`
- `lib/features/chatbot/data/repositories/assistant_session_repository_impl.dart`
- `lib/features/chatbot/domain/entities/assistant_script.dart`
- `lib/features/chatbot/domain/entities/assistant_session.dart`
- `lib/features/chatbot/domain/repositories/assistant_session_repository.dart`
- `test/features/chatbot/fakes/assistant_script_fixture.dart`
- `test/features/chatbot/fakes/assistant_script_local_datasource.dart`
- `test/features/chatbot/ai_assistant_flow_test.dart`
- `test/features/chatbot/assistant_session_navigation_test.dart`

Do not touch `lib/features/_legacy/**`. The legacy chat code (`_legacy/chat_intake_booking`) is only a reference for the stream client; copy what you need, do not import from it.

## Issues, in order

1. `M04-guided-booking-prefill.md` (independent and small; do it first, M03 uses it)
2. `M01-data-layer-on-v2-intake.md`
3. `M02-thin-assistant-cubit.md`
4. `M03-render-the-server-blocks.md` (M01 to M03 may share one commit, because the build only compiles again at the end of M03)
5. `M05-history-and-entry-points.md`
6. `M06-verify-and-prepare-the-release.md`

Each issue ends with `fvm flutter analyze` (no new issues), `fvm dart format` on changed files, `fvm flutter test`, and a one-line conventional commit with no body.
