# Verify the assistant and prepare the release build

Status: ready-for-human
Priority: P0
Size: S
Depends on: M01 to M05

The agent does the static checks; the lead does the device checks.

## Agent

- `fvm flutter analyze`: no new issues compared with `develop`.
- `fvm dart format` on every changed Dart file.
- `fvm flutter test`: all pass.
- `grep` that no file under `lib/` imports from `lib/features/_legacy/chat_intake_booking`.
- `grep` that nothing references the deleted files.
- Write a short list of what changed for the release notes (patient-facing, three or four lines) in the Comments below.

## Lead, on a device or emulator

Against the production backend **before** it is patched (degraded mode):

- [ ] The assistant opens after consent, shows the hero and composer, no crash.
- [ ] A typed question gets a text reply.
- [ ] History opens.

Against a local backend with the backend issues 05 to 09 and `MODEL_PROVIDER=mock`:

- [ ] Topic grid, two mock questions (single then multi with "None of these"), summary, Looks good, guidance with disclaimer, next steps.
- [ ] Edit Answers restarts the questions.
- [ ] The suggestion opens guided booking on Pharmacist Review → Medication Support with "Questions about my medication" ticked and the remarks filled.
- [ ] Explore services opens All Services. Save My Summary gets the saved reply. Ask Another Question asks for confirmation and starts a new conversation.
- [ ] Airplane mode while open: the reconnecting bar shows and the conversation resumes afterwards without duplicates.
- [ ] Pharmacy page AI button opens the new assistant.

Then the full check with the real model is backend issue 11.

## Comments
