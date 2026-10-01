import 'package:m2health/features/chatbot/domain/entities/assistant_block.dart';

AssistantBlock assistantBlockFromJson(Map<String, dynamic> json) {
  try {
    return _parse(json);
  } catch (_) {
    return UnknownAssistantBlock(
      id: (json['id'] as num?)?.toInt() ?? 0,
      kind: json['kind'] as String? ?? 'unknown',
    );
  }
}

AssistantBlock _parse(Map<String, dynamic> json) {
  final id = (json['id'] as num?)?.toInt() ?? 0;
  final kind = json['kind'] as String? ?? 'unknown';

  switch (kind) {
    case 'assistant_text':
    case 'location_request':
    case 'user_location':
      return AssistantTextBlock(id: id, text: json['text'] as String);
    case 'staff_text':
      return AssistantTextBlock(
        id: id,
        text: json['text'] as String,
        fromTeam: true,
      );
    case 'user_text':
      return UserTextBlock(id: id, text: json['text'] as String);
    case 'topic_grid':
      return TopicGridBlock(
        id: id,
        title: json['title'] as String,
        topics: _list(json['topics'], _topic),
      );
    case 'question':
      return QuestionBlock(
        id: id,
        questionId: json['questionId'] as String,
        text: json['text'] as String,
        mode:
            json['mode'] == 'multi' ? QuestionMode.multi : QuestionMode.single,
        hint: json['hint'] as String?,
        options: _list(json['options'], _option),
        continueLabel: json['continueLabel'] as String?,
        exclusiveIndex: (json['exclusiveIndex'] as num?)?.toInt(),
      );
    case 'summary':
      return SummaryBlock(
        id: id,
        title: json['title'] as String,
        rows: _list(json['rows'], _row),
        footnote: json['footnote'] as String?,
        editLabel: json['editLabel'] as String,
        confirmLabel: json['confirmLabel'] as String,
        editReplyId: json['editReplyId'] as String,
        confirmReplyId: json['confirmReplyId'] as String,
      );
    case 'guidance':
      return GuidanceBlock(
        id: id,
        title: json['title'] as String,
        body: json['body'] as String,
        disclaimer: json['disclaimer'] as String?,
        suggestionsTitle: json['suggestionsTitle'] as String?,
        suggestions: _list(json['suggestions'], _suggestion),
      );
    case 'next_step':
      return NextStepBlock(id: id, actions: _list(json['actions'], _action));
    case 'confirm_request':
      return ConfirmRequestBlock(
        id: id,
        text: json['text'] as String,
        confirmId: json['confirmId'] as String,
        cancelId: json['cancelId'] as String,
      );
    default:
      return UnknownAssistantBlock(id: id, kind: kind);
  }
}

List<T> _list<T>(Object? raw, T Function(Map<String, dynamic>) parse) {
  return (raw as List<dynamic>)
      .map((item) => parse(item as Map<String, dynamic>))
      .toList();
}

AssistantTopic _topic(Map<String, dynamic> json) => AssistantTopic(
      replyId: json['replyId'] as String,
      label: json['label'] as String,
      icon: json['icon'] as String,
      tone: json['tone'] as String,
    );

QuestionOption _option(Map<String, dynamic> json) => QuestionOption(
      index: (json['index'] as num).toInt(),
      label: json['label'] as String,
    );

SummaryRow _row(Map<String, dynamic> json) => SummaryRow(
      icon: json['icon'] as String,
      label: json['label'] as String,
      value: json['value'] as String,
    );

ServiceSuggestion _suggestion(Map<String, dynamic> json) {
  final booking = json['booking'];
  return ServiceSuggestion(
    replyId: json['replyId'] as String,
    title: json['title'] as String,
    subtitle: json['subtitle'] as String,
    icon: json['icon'] as String,
    tone: json['tone'] as String,
    booking: booking == null ? null : _booking(booking as Map<String, dynamic>),
  );
}

BookingPrefill _booking(Map<String, dynamic> json) => BookingPrefill(
      category: json['category'] as String,
      subCategory: json['subCategory'] as String?,
      issueCodes: (json['issueCodes'] as List<dynamic>? ?? const [])
          .map((code) => code as String)
          .toList(),
      remarks: json['remarks'] as String? ?? '',
    );

NextStepAction _action(Map<String, dynamic> json) => NextStepAction(
      replyId: json['replyId'] as String,
      kind: switch (json['action']) {
        'explore_services' => NextStepKind.exploreServices,
        'new_conversation' => NextStepKind.newConversation,
        'reply' => NextStepKind.reply,
        _ => NextStepKind.unknown,
      },
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      icon: json['icon'] as String,
      tone: json['tone'] as String,
    );
