import 'package:flutter/widgets.dart';
import 'package:m2health/features/chatbot/presentation/bloc/assistant_state.dart';
import 'package:m2health/i18n/translations.g.dart';

String assistantErrorText(BuildContext context, AssistantError error) {
  final t = context.t.chatbot;
  return switch (error) {
    AssistantError.load => t.errorLoad,
    AssistantError.send => t.errorSend,
    AssistantError.noReply => t.errorNoReply,
  };
}
