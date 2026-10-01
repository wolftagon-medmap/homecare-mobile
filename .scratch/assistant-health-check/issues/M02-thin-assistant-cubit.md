# Rewrite `AssistantCubit` as a thin server-conversation cubit

Status: ready-for-agent
Priority: P0
Size: M
Depends on: M01-data-layer-on-v2-intake

The cubit holds no medical logic. It loads the transcript, follows the stream, shows the patient's own bubble immediately, sends taps and text with the exact reply ids of contract A4, and asks the page to navigate. Model it on `lib/features/_legacy/chat_intake_booking/presentation/bloc/intake_cubit.dart` (read it; copy the stream, dedupe, and reconnect logic), but write it in `features/chatbot`.

## State (`presentation/bloc/assistant_state.dart`, rewrite)

```dart
sealed class AssistantState extends Equatable

class AssistantLoading extends AssistantState
class AssistantFailed extends AssistantState { final String message; }

class AssistantReady extends AssistantState {
  final String sessionId;
  final bool readOnly;                    // history viewer
  final List<AssistantBlock> blocks;
  final Map<int, String> resolved;        // block id -> what was chosen; resolved blocks are inert
  final Map<int, Set<int>> selections;    // multi-choice ticks in progress, block id -> option indices
  final bool awaitingReply;               // true from a send until the next server block (or a failure)
  final bool connected;                   // stream state
  final String? actionError;              // one-shot; page shows a SnackBar then calls errorShown()
  final AssistantNavigation? navigation;  // one-shot; page navigates then calls navigationConsumed()
}

sealed class AssistantNavigation extends Equatable
class OpenGuidedBooking extends AssistantNavigation { final BookingPrefill booking; }
class OpenAllServices extends AssistantNavigation {}
```

`copyWith` must be able to clear `actionError` and `navigation` (use explicit `clearActionError`/`clearNavigation` flags, as in `IntakeState`).

## Cubit (`presentation/bloc/assistant_cubit.dart`, rewrite)

Constructor: `AssistantCubit({required AssistantRepository repository})`.

Private fields: the stream subscription, a reconnect `Timer` (3 seconds), a reply-watchdog `Timer`, `Set<int> _seen`, `int _lastEventId`, `int _localId = 0` (decremented for optimistic bubbles).

### Lifecycle

- `Future<void> start({bool fresh = false})`: cancel the subscription and timers, clear `_seen` and `_lastEventId`, emit `AssistantLoading`, call `startSession(fresh: fresh)` then `history(sessionId)`. On failure emit `AssistantFailed('Something went wrong. Please try again.')`. On success: record every block id in `_seen` and the highest in `_lastEventId`; emit `AssistantReady(readOnly: false, connected: false, ...)`; subscribe.
- `Future<void> view(String sessionId)`: read-only. `history(sessionId)` only, no stream, `readOnly: true`. Failure as above.
- `close()`: cancel subscription and timers.

### Stream

- Subscribe with `repository.stream(sessionId, lastEventId: _lastEventId)`; on listen, `connected: true`.
- On block: ignore when `_seen` contains its id; otherwise add it, update `_lastEventId`, append to `blocks`, set `awaitingReply: false`, `connected: true`, cancel the watchdog.
- `onError` or `onDone`: `connected: false`, schedule a resubscribe after 3 seconds if not closed and still `AssistantReady` and not `readOnly`.

### Sending (all no-ops when not `AssistantReady`, when `readOnly`, or when `awaitingReply`)

Every send: append a `UserTextBlock(id: --_localId, text: <label>)`, set `awaitingReply: true`, start the watchdog (70 seconds: if it fires, `awaitingReply: false` and `actionError: 'No reply yet. Please try again.'`), then call the repository. On `Left`: `awaitingReply: false`, `actionError: 'Could not send. Please try again.'`, remove the block id from `resolved` if this send had resolved one, cancel the watchdog. Keep the optimistic bubble.

| Method | Guard | Marks resolved | Repository call |
| --- | --- | --- | --- |
| `sendText(String text)` | trimmed text non-empty | — | `sendText(sessionId, trimmed)` |
| `selectTopic(int blockId, AssistantTopic topic)` | block not resolved | `blockId → topic.replyId` | `sendReply(replyId: topic.replyId, label: topic.label)` |
| `chooseOption(int blockId, QuestionBlock q, int index)` | `q.mode == single`, block not resolved | `blockId → '$index'` | `sendReply(replyId: 'hc:${q.questionId}:$index', label: <option label>)` |
| `toggleOption(int blockId, QuestionBlock q, int index)` | `q.mode == multi`, block not resolved | — | none; update `selections` with the exclusive rule of contract A2 |
| `submitSelection(int blockId, QuestionBlock q)` | multi, not resolved, at least one selected | `blockId → 'submitted'` | `sendReply(replyId: 'hc:${q.questionId}:<sorted indices joined by ','>', label: <labels in index order joined by ', '>)` |
| `answerSummary(int blockId, SummaryBlock s, {required bool confirm})` | not resolved | `blockId → replyId` | `sendReply(replyId: confirm ? s.confirmReplyId : s.editReplyId, label: confirm ? s.confirmLabel : s.editLabel)` |
| `answerConfirmRequest(int blockId, ConfirmRequestBlock c, {required bool confirm, required String label})` | not resolved | `blockId → replyId` | `sendReply(replyId: confirm ? c.confirmId : c.cancelId, label: label)` |

Exclusive rule for `toggleOption`: if `index` is already selected, remove it. Else if `index == q.exclusiveIndex`, the selection becomes `{index}`. Else add `index` and remove `q.exclusiveIndex`.

### Actions that do not send

- `act(NextStepAction action)`:
  - `exploreServices`: emit `navigation: OpenAllServices()`.
  - `newConversation`: do nothing here; the page asks for confirmation and then calls `start(fresh: true)`.
  - `reply`: same as a send, with `sendReply(replyId: action.replyId, label: action.title)`; no block is resolved.
  - `unknown`: nothing.
- `openSuggestion(ServiceSuggestion s)`: when `s.booking != null` and not `readOnly`, emit `navigation: OpenGuidedBooking(s.booking!)`.
- `navigationConsumed()`, `errorShown()`: clear the one-shot fields.

### Interactivity rule (used by M03)

Expose `bool isInteractive(AssistantReady state, AssistantBlock block)`, a static or top-level helper: `!state.readOnly && !state.awaitingReply && !state.resolved.containsKey(block.id) && block is the last block of an interactive kind in the list` (interactive kinds: `TopicGridBlock`, `QuestionBlock`, `SummaryBlock`, `ConfirmRequestBlock`). `NextStepBlock` and `GuidanceBlock` stay tappable while not `readOnly`.

## Tests (`test/features/chatbot/assistant_cubit_test.dart`)

Use the fake repository from M01 and plain `test` with awaits (no bloc_test package). At least:

- `start` loads history and subscribes; a duplicate block id from the stream is ignored.
- `selectTopic` sends `topic:symptom` with the label, resolves the block, sets `awaitingReply`; a server block clears it.
- `chooseOption` sends `hc:q1:2` and the option label.
- multi: toggling 0 and 2 then the exclusive index leaves only the exclusive index; toggling 1 then clears the exclusive; `submitSelection` sends `hc:q2:0,1` and `"<label0>, <label1>"`.
- A failed send sets `actionError`, clears `awaitingReply`, and un-resolves the block.
- Sends are ignored while `awaitingReply` and when `readOnly`.
- `openSuggestion` emits `OpenGuidedBooking` with the prefill; `act(exploreServices)` emits `OpenAllServices`.
- Stream `onDone` sets `connected: false`.

## Acceptance criteria

- [ ] Tests pass.
- [ ] Commit (may be combined with M01 and M03): `feat(chatbot): load the assistant from the server conversation`
