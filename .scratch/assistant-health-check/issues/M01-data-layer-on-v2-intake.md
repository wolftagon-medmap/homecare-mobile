# Move the assistant's data layer onto `/v2/intake`

Status: ready-for-agent
Priority: P0
Size: M

Replace the on-device script with the server conversation of contract A1 and A2. This issue changes entities, parsing, the data source, the repository, and dependency registration. The cubit and widgets are changed in M02 and M03; to keep the build green between issues, do M01 to M03 on the same branch and run `fvm flutter analyze` only at the end of M03 if M01 alone cannot compile. Commit M01 to M03 together if needed.

## 1. Entities

Rewrite `lib/features/chatbot/domain/entities/assistant_block.dart`. Keep `Equatable`. Every block has `final int id`. Remove `copyWithId`. Classes, exactly:

```dart
sealed class AssistantBlock extends Equatable { final int id; }

class AssistantTextBlock  // kind assistant_text, staff_text, location_request, user_location
  final String text;
  final bool fromTeam;        // true only for staff_text

class UserTextBlock       // kind user_text
  final String text;

class TopicGridBlock      // kind topic_grid
  final String title;
  final List<AssistantTopic> topics;

class QuestionBlock       // kind question
  final String questionId;
  final String text;
  final QuestionMode mode;    // enum QuestionMode { single, multi }
  final String? hint;
  final List<QuestionOption> options;
  final String? continueLabel;
  final int? exclusiveIndex;

class SummaryBlock        // kind summary
  final String title;
  final List<SummaryRow> rows;
  final String? footnote;
  final String editLabel;
  final String confirmLabel;
  final String editReplyId;
  final String confirmReplyId;

class GuidanceBlock       // kind guidance
  final String title;
  final String body;
  final String? disclaimer;
  final String? suggestionsTitle;
  final List<ServiceSuggestion> suggestions;

class NextStepBlock       // kind next_step
  final List<NextStepAction> actions;

class ConfirmRequestBlock // kind confirm_request
  final String text;
  final String confirmId;
  final String cancelId;

class UnknownAssistantBlock // anything else, including professional_shortlist
  final String kind;
```

Value classes (all `Equatable`):

```dart
class AssistantTopic { String replyId; String label; String icon; String tone; }
class QuestionOption { int index; String label; }
class SummaryRow { String icon; String label; String value; }
class BookingPrefill { String category; String? subCategory; List<String> issueCodes; String remarks; }
class ServiceSuggestion { String replyId; String title; String subtitle; String icon; String tone; BookingPrefill? booking; }
enum NextStepKind { exploreServices, newConversation, reply, unknown }
class NextStepAction { String replyId; NextStepKind kind; String title; String subtitle; String icon; String tone; }
```

New file `lib/features/chatbot/domain/entities/assistant_session_summary.dart`:

```dart
class AssistantSessionSummary extends Equatable {
  final String id;
  final bool active;
  final String? preview;
  final DateTime? lastMessageAt;
  final DateTime? createdAt;
}
```

## 2. Repository interface

Rewrite `lib/features/chatbot/domain/repositories/assistant_repository.dart`:

```dart
abstract class AssistantRepository {
  Future<Either<Failure, String>> startSession({bool fresh = false});
  Future<Either<Failure, List<AssistantBlock>>> history(String sessionId);
  Future<Either<Failure, Unit>> sendText(String sessionId, String text);
  Future<Either<Failure, Unit>> sendReply(String sessionId, {required String replyId, required String label});
  Stream<AssistantBlock> stream(String sessionId, {int? lastEventId});
  Future<Either<Failure, List<AssistantSessionSummary>>> sessions();
  Future<Either<Failure, Unit>> deleteSession(String sessionId);
}
```

`Failure` and `ServerFailure` come from `package:m2health/core/error/failures.dart` (check the exact class names there). `Unit` and `Either` from `dartz`.

## 3. Parser

New `lib/features/chatbot/data/models/assistant_block_model.dart` with one top-level function:

```dart
AssistantBlock assistantBlockFromJson(Map<String, dynamic> json)
```

- Wrap the whole parse in `try`; on any error return `UnknownAssistantBlock(id: <id or 0>, kind: <kind or 'unknown'>)`. One bad block never breaks a whole history.
- `id` = `(json['id'] as num?)?.toInt() ?? 0`.
- Keys are camelCase, exactly as contract A2. Map by `kind`:
  - `assistant_text`: `AssistantTextBlock(text, fromTeam: false)`
  - `staff_text`: `AssistantTextBlock(text, fromTeam: true)`
  - `location_request`, `user_location`: `AssistantTextBlock(text, fromTeam: false)`
  - `user_text`: `UserTextBlock(text)`
  - `topic_grid`, `question`, `summary`, `guidance`, `next_step`, `confirm_request`: field by field from contract A2. `mode` `"multi"` maps to `QuestionMode.multi`, anything else to `single`. `action` maps `explore_services`, `new_conversation`, `reply` to `NextStepKind`, anything else to `unknown`. A suggestion without `booking` gets `booking: null`.
  - anything else: `UnknownAssistantBlock`.

## 4. Remote data source

New `lib/features/chatbot/data/datasources/assistant_remote_datasource.dart`: an abstract `AssistantRemoteDataSource` and `AssistantRemoteDataSourceImpl(Dio)`. Port the logic of `lib/features/_legacy/chat_intake_booking/data/datasources/intake_remote_datasource.dart` (read it; same endpoints, same SSE parsing, same auth header via `Utils.getSpString(Const.TOKEN)`), with these differences:

- Parse blocks with `assistantBlockFromJson`.
- `send` takes `{required String sessionId, String? text, String? replyId}` and posts `{sessionId, text?, replyId?}` with `Options(receiveTimeout: const Duration(seconds: 60))` in addition to the auth header (contract A1).
- `listSessions` returns `List<AssistantSessionSummary>`.
- No `location` parameter.

## 5. Repository implementation

Rewrite `lib/features/chatbot/data/repositories/assistant_repository_impl.dart` as `AssistantRepositoryImpl(AssistantRemoteDataSource)`. Every method catches `DioException` (and any other exception) and returns `Left(ServerFailure(<message>))`. `stream` passes the data source stream through unchanged (errors surface to the cubit's `onError`). `sendReply` posts `replyId` and `text: label`.

## 6. Dependency registration

Rewrite `lib/features/chatbot/injection.dart`:

- `AssistantRemoteDataSource` → `AssistantRemoteDataSourceImpl(sl<Dio>())`
- `AssistantRepository` → `AssistantRepositoryImpl(sl<AssistantRemoteDataSource>())`
- `AssistantCubit` factory → `AssistantCubit(repository: sl<AssistantRepository>())` (M02 defines the constructor)
- Remove the script and session store registrations.

## 7. Delete

The files listed in `spec.md`, "Approved deletion list".

## 8. Tests

- New `test/features/chatbot/fixtures/contract_blocks.dart`: one `Map<String, dynamic>` constant per example in contract A2 (copy the JSON exactly, including `topic_grid` with all eight topics from the contract's topic table).
- New `test/features/chatbot/assistant_block_model_test.dart`: each fixture parses to the right class with the right fields; an unknown kind becomes `UnknownAssistantBlock`; a block with a wrong field type (for example `options: "x"`) becomes `UnknownAssistantBlock` without throwing; `staff_text` sets `fromTeam`.
- New `test/features/chatbot/fakes/fake_assistant_repository.dart`: an in-memory `AssistantRepository` for M02 tests. It records every `sendText` and `sendReply` call, exposes a `StreamController<AssistantBlock>` the test can push to, returns a configurable history, and can be told to fail the next send.

## Acceptance criteria

- [ ] The parser test passes.
- [ ] No file outside `lib/features/chatbot`, `test/features/chatbot`, and the deletion list is changed.
- [ ] Commit (may be combined with M02 and M03): `feat(chatbot): load the assistant from the server conversation`
