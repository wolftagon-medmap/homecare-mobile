# Domain docs

Configuration for the engineering skills. It tells them which documents to read before they explore the codebase, and how to treat what they find.

## Read these before exploring

1. [CONTEXT.md](../../CONTEXT.md) at the repository root. The glossary, covering both the shared domain words and the app's own vocabulary.
2. [backend-api-reference.md](backend-api-reference.md). The API this app calls.

The architecture and the shared domain language live in the **backend repository**, not here, so that they do not drift out of step. Read `docs/agents/ARCHITECTURE.md` and `CONTEXT.md` there. If your task touches the booking assistant or the professional's offer inbox, read `docs/agents/subsystems/conversational-booking.md` there as well, and not otherwise. Decisions are recorded in `docs/adr` in that repository too.

If you do not have the backend repository checked out, carry on without it. Do not point out that it is missing, and do not recreate those documents here.

## This is a single context repository

There is one `CONTEXT.md`, at the root, and no `CONTEXT-MAP.md`. The features under `lib/features` are separate areas, but they share one vocabulary today.

## Use the words the glossary uses

When you name something, whether a cubit, an entity, a test, or an issue title, use the term as `CONTEXT.md` defines it, and keep the domain vocabulary and the app vocabulary apart. Do not reach for a synonym it tells you to avoid. The ones that cause the most trouble are "v1" and "v2", "booking" on its own, "slot" on its own, "screen", and "model" used for a domain object.

## Say so when you disagree with a decision

If what you are proposing contradicts the backend's architecture document or one of its decision records, say so out loud rather than quietly doing it anyway. A change that affects both sides belongs in the backend's documents, not in a note here.
