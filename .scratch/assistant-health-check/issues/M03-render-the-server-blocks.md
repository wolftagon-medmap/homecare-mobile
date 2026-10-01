# Render the server blocks on the assistant screen

Status: ready-for-agent
Priority: P0
Size: M
Depends on: M02-thin-assistant-cubit, M04-guided-booking-prefill

Keep the current look of Adel's design (existing widgets in `lib/features/chatbot/presentation/widgets`); change what they read and what they call.

## Widgets

- `assistant_block_view.dart`: rewrite the `switch` for the new classes. New constructor:

  ```dart
  AssistantBlockView({required AssistantBlock block, required AssistantReady state, required AssistantCubit? cubit})
  ```

  `cubit` is `null` in read-only mode. Interactive state comes from `isInteractive` (M02). Chosen values come from `state.resolved` and `state.selections`.
  - `AssistantTextBlock`: `AssistantBubble`; when `fromTeam`, show a small label above it with `t.chatbot.teamLabel`.
  - `UserTextBlock`: `AssistantUserBubble`.
  - `TopicGridBlock`: `TopicGrid` (fields unchanged: `replyId`, `label`, `icon`, `tone`); on tap `cubit.selectTopic`.
  - `QuestionBlock`: `SingleChoiceCard` or `MultiChoiceCard` by `mode`.
  - `SummaryBlock`: `SummaryCard`.
  - `GuidanceBlock`: `GuidanceCard`.
  - `NextStepBlock`: `NextStepList`.
  - `ConfirmRequestBlock`: new `ConfirmRequestCard`.
  - `UnknownAssistantBlock`: `SizedBox.shrink()`.
- `choice_cards.dart`: both cards take a `QuestionBlock`. Use `block.text` as the prompt, `block.hint` as the hint, `option.label` for rows, `option.index` for selection. Single: `selected` is `state.resolved[block.id] == '${option.index}'`; tap calls `onSelect(index)`. Multi: `selected` from `state.selections[block.id]`; `continueLabel ?? 'Continue'`; `onToggle(index)` and `onSubmit()`.
- `summary_card.dart`: remove `answers` and `fromStep`; show `row.label` and `row.value` directly. Icons: `issue` uses the current main-issue icon, everything else uses the current generic row icon. Buttons call `onAnswer(confirm: false/true)`.
- `guidance_card.dart`: add the `disclaimer` (small text under the body, when not null). Suggestions show when the list is non-empty; tapping calls `onOpen(suggestion)`; a suggestion with `booking == null` is shown without the chevron and is not tappable. Remove the use of `route`.
- `next_step_list.dart`: `onAct(action)`; rows with `NextStepKind.unknown` are shown disabled.
- New `confirm_request_card.dart`: the text in an assistant bubble, then two buttons in the style of the summary buttons: `t.chatbot.confirm` and `t.chatbot.cancel`. After a choice, the chosen button stays highlighted and both are disabled.
- New `assistant_typing_bubble.dart`: a small assistant bubble with three animated dots, shown as the last list item while `awaitingReply`.

## Page (`presentation/pages/ai_assistant_page.dart`)

Keep the consent flow (`Utils.hasAcceptedAiConsent`, `AiDataConsentModal`) exactly as it is; then call `start()`.

- Hero: show `AssistantHero` at the top when the first block is a `TopicGridBlock`, **or when `blocks` is empty** (a backend without the welcome must still look right).
- Composer: disabled while `awaitingReply`; hint `composerHintWelcome` while the only block is the topic grid (or there are no blocks), else `composerHint`; `onSend` calls `cubit.sendText`.
- When `!state.connected`, show a thin bar under the privacy label with `t.chatbot.reconnecting`.
- Listener:
  - `navigation is OpenGuidedBooking`: `navigationConsumed()`, then `context.push(GuidedBookingRoutes.entry, extra: GuidedBookingArgs(category: b.category, subCategory: b.subCategory, issueCodes: b.issueCodes, remarks: b.remarks))` (the new fields come from M04).
  - `navigation is OpenAllServices`: `navigationConsumed()`, then `context.push(AppRoutes.allServices)`.
  - `actionError != null`: `errorShown()`, then a SnackBar with the message.
  - Auto-scroll to the end when blocks change (keep the current behaviour).
- New-conversation button (app bar) and the `newConversation` next-step action both use the existing confirmation dialog, then `cubit.start(fresh: true)`.
- History button: see M05.
- Failure state: unchanged (retry calls `start()`).

## Strings

Add to `lib/i18n/features/chatbot/chatbot_en.i18n.json`, `_id`, and `_zh` (then run `fvm dart run slang`; never edit the generated files):

| key | en | id | zh |
| --- | --- | --- | --- |
| `teamLabel` | M2Health team | Tim M2Health | M2Health 团队 |
| `confirm` | Confirm | Konfirmasi | 确认 |
| `reconnecting` | Reconnecting… | Menyambungkan ulang… | 正在重新连接… |
| `readOnlyNotice` | This conversation is read-only. | Percakapan ini hanya bisa dibaca. | 此对话为只读。 |

`cancel` already exists. Change `deleteBody` (all three files) to: en `This conversation will be deleted. This cannot be undone.`, id `Percakapan ini akan dihapus. Tindakan ini tidak dapat dibatalkan.`, zh `此对话将被删除，且无法恢复。`

## Tests

- `test/features/chatbot/assistant_page_test.dart` (widget test, fake repository, consent pre-accepted with `SharedPreferences.setMockInitialValues({'ai_consent_accepted': true})`; check the key name in `Utils.hasAcceptedAiConsent`): history with the `topic_grid` fixture shows the hero and the eight topics; tapping a topic sends `topic:<code>`; a `question` block pushed on the stream renders its options; tapping one sends `hc:q1:<i>`; a `guidance` block renders the disclaimer; an empty history still shows the hero and the composer.
- Wrap in `TranslationProvider` as the deleted `assistant_session_navigation_test.dart` did.

## Acceptance criteria

- [ ] `fvm flutter analyze` shows no new issues; `fvm flutter test` passes.
- [ ] Commit (may be combined with M01 and M02): `feat(chatbot): load the assistant from the server conversation`
