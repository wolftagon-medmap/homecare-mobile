# Show server history and point the old AI entry at the new assistant

Status: ready-for-agent
Priority: P1
Size: S
Depends on: M03-render-the-server-blocks

## History

- `presentation/bloc/assistant_sessions_cubit.dart` and `assistant_sessions_state.dart`: take `AssistantRepository` (from M01) instead of the deleted session repository; `load()` calls `repository.sessions()`, `delete(id)` calls `repository.deleteSession(id)` then reloads. The loaded state holds `List<AssistantSessionSummary>`.
- `presentation/pages/assistant_sessions_page.dart`: list `AssistantSessionSummary` items: title = `preview ?? t.chatbot.sessionUntitled`, date = `lastMessageAt ?? createdAt`, `t.chatbot.sessionActive` badge when `active`, otherwise `t.chatbot.sessionReadOnly`. The active session cannot be deleted (hide the delete action for it; the server returns 409 anyway). Popping returns the picked summary.
- `presentation/pages/assistant_session_viewer_page.dart`: takes `AssistantSessionSummary` (or just the session id). `initState` calls `cubit.view(id)`. Renders blocks with `AssistantBlockView(..., cubit: null)` so nothing is tappable, shows `t.chatbot.readOnlyNotice` instead of the composer.
- `ai_assistant_page.dart` `_openHistory`: provide `AssistantSessionsCubit(repository: sl<AssistantRepository>(), currentSessionId: <current state's sessionId>)`; picking the current session just pops; picking another opens the viewer with a fresh `sl<AssistantCubit>()`.

## Entry points

- `lib/features/_legacy/booking_appointment/pharmacy/presentation/pages/pharmacy_services_page.dart` line 43 pushes `AppRoutes.chatPharmaAI` (the old pharmacy AI chat). Change only that call to `GoRouter.of(context).push(ChatbotRoutes.aiAssistant)` and import `ChatbotRoutes`. This is the one approved change inside `_legacy`. Do not remove the old route or its screens.
- `lib/features/dashboard/presentation/widgets/ai_assistant_bar.dart` already opens `ChatbotRoutes.aiAssistant`; leave it.

## Tests

- Sessions cubit: load maps summaries; delete calls the repository and reloads; a failure shows the failed state.
- Viewer: blocks render and tapping a topic sends nothing.

## Acceptance criteria

- [ ] `fvm flutter analyze` shows no new issues; tests pass.
- [ ] Commit: `feat(chatbot): server history and new assistant entry from pharmacy`
