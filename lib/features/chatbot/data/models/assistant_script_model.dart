import 'package:m2health/features/chatbot/domain/entities/assistant_block.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_script.dart';

/// Parses the guided-conversation payload. The fixture and the remote endpoint
/// both go through here, so swapping the flag cannot change the shape.
class AssistantScriptModel {
  const AssistantScriptModel._();

  static AssistantScript fromJson(Map<String, dynamic> json) {
    final rawSteps = (json['steps'] as List?) ?? const [];
    return AssistantScript(
      scriptId: json['script_id'] as String? ?? 'assistant_script',
      entryStep: json['entry_step'] as String? ?? '',
      offTopicReply: json['off_topic_reply'] as String? ?? '',
      steps: rawSteps
          .map((step) => _stepFromJson(step as Map<String, dynamic>))
          .toList(growable: false),
    );
  }

  static ScriptStep _stepFromJson(Map<String, dynamic> json) {
    final rawBlocks = (json['blocks'] as List?) ?? const [];
    final rawTransitions = (json['transitions'] as Map?) ?? const {};
    return ScriptStep(
      id: json['id'] as String,
      answerKey: json['answer_key'] as String?,
      fallbackNext: json['fallback_next'] as String?,
      textNext: json['text_next'] as String?,
      textReply: json['text_reply'] as String?,
      transitions: rawTransitions.map(
        (key, value) => MapEntry(key as String, value as String),
      ),
      blocks: rawBlocks
          .map((block) => blockFromJson(block as Map<String, dynamic>))
          .toList(growable: false),
    );
  }

  static AssistantBlock blockFromJson(Map<String, dynamic> json) {
    final id = json['id'] as int? ?? 0;
    return switch (json['kind'] as String?) {
      'assistant_text' =>
        AssistantTextBlock(id: id, text: json['text'] as String? ?? ''),
      'user_text' => UserTextBlock(id: id, text: json['text'] as String? ?? ''),
      'topic_grid' => TopicGridBlock(
          id: id,
          title: json['title'] as String? ?? '',
          topics: _list(json['topics'], _topicFromJson),
        ),
      'single_choice' => SingleChoiceBlock(
          id: id,
          prompt: json['prompt'] as String? ?? '',
          hint: json['hint'] as String?,
          options: _list(json['options'], _choiceFromJson),
        ),
      'multi_choice' => MultiChoiceBlock(
          id: id,
          prompt: json['prompt'] as String? ?? '',
          hint: json['hint'] as String?,
          options: _list(json['options'], _choiceFromJson),
          continueLabel: json['continue_label'] as String? ?? 'Continue',
          exclusiveOptionId: json['exclusive_option_id'] as String?,
        ),
      'summary' => SummaryBlock(
          id: id,
          title: json['title'] as String? ?? '',
          rows: _list(json['rows'], _rowFromJson),
          footnote: json['footnote'] as String?,
          editLabel: json['edit_label'] as String? ?? 'Edit',
          confirmLabel: json['confirm_label'] as String? ?? 'Confirm',
          editReplyId: json['edit_reply_id'] as String? ?? 'edit',
          confirmReplyId: json['confirm_reply_id'] as String? ?? 'confirm',
        ),
      'guidance' => GuidanceBlock(
          id: id,
          title: json['title'] as String? ?? '',
          body: json['body'] as String? ?? '',
          suggestionsTitle: json['suggestions_title'] as String?,
          suggestions: _list(json['suggestions'], _suggestionFromJson),
        ),
      'next_step' => NextStepBlock(
          id: id,
          actions: _list(json['actions'], _actionFromJson),
        ),
      final kind => UnknownAssistantBlock(id: id, kind: kind ?? 'unknown'),
    };
  }

  static List<T> _list<T>(
    Object? raw,
    T Function(Map<String, dynamic>) parse,
  ) {
    final items = (raw as List?) ?? const [];
    return items
        .map((item) => parse(item as Map<String, dynamic>))
        .toList(growable: false);
  }

  static AssistantTopic _topicFromJson(Map<String, dynamic> json) =>
      AssistantTopic(
        replyId: json['reply_id'] as String,
        label: json['label'] as String? ?? '',
        icon: json['icon'] as String? ?? 'other',
        tone: json['tone'] as String? ?? 'grey',
        echo: json['echo'] as String?,
      );

  static AssistantChoice _choiceFromJson(Map<String, dynamic> json) =>
      AssistantChoice(
        replyId: json['reply_id'] as String,
        label: json['label'] as String? ?? '',
        echo: json['echo'] as String?,
        summary: json['summary'] as String?,
      );

  static SummaryRow _rowFromJson(Map<String, dynamic> json) => SummaryRow(
        icon: json['icon'] as String? ?? 'issue',
        label: json['label'] as String? ?? '',
        value: json['value'] as String?,
        fromStep: json['from_step'] as String?,
      );

  static ServiceSuggestion _suggestionFromJson(Map<String, dynamic> json) =>
      ServiceSuggestion(
        replyId: json['reply_id'] as String,
        title: json['title'] as String? ?? '',
        subtitle: json['subtitle'] as String? ?? '',
        icon: json['icon'] as String? ?? 'services',
        tone: json['tone'] as String? ?? 'teal',
        route: json['route'] as String?,
      );

  static NextStepAction _actionFromJson(Map<String, dynamic> json) =>
      NextStepAction(
        replyId: json['reply_id'] as String,
        title: json['title'] as String? ?? '',
        subtitle: json['subtitle'] as String? ?? '',
        icon: json['icon'] as String? ?? 'services',
        tone: json['tone'] as String? ?? 'teal',
        route: json['route'] as String?,
        reply: json['reply'] as String?,
        restart: json['restart'] as bool? ?? false,
      );
}
