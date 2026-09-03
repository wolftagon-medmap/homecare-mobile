import 'package:equatable/equatable.dart';

/// One rendered turn in the assistant transcript.
///
/// The shape mirrors the server-driven block pattern used by conversational
/// booking, but the kinds are the assistant's own. The client holds no clinical
/// logic: it renders what the script describes and echoes back reply tokens.
sealed class AssistantBlock extends Equatable {
  final int id;

  const AssistantBlock({required this.id});

  /// A copy carrying a fresh transcript id. Script blocks are templates: the
  /// same step can be entered twice, so every appended block is re-identified.
  AssistantBlock copyWithId(int id);

  @override
  List<Object?> get props => [id];
}

class AssistantTextBlock extends AssistantBlock {
  final String text;

  const AssistantTextBlock({required super.id, required this.text});

  @override
  AssistantTextBlock copyWithId(int id) =>
      AssistantTextBlock(id: id, text: text);

  @override
  List<Object?> get props => [...super.props, text];
}

class UserTextBlock extends AssistantBlock {
  final String text;

  const UserTextBlock({required super.id, required this.text});

  @override
  UserTextBlock copyWithId(int id) => UserTextBlock(id: id, text: text);

  @override
  List<Object?> get props => [...super.props, text];
}

class TopicGridBlock extends AssistantBlock {
  final String title;
  final List<AssistantTopic> topics;

  const TopicGridBlock({
    required super.id,
    required this.title,
    required this.topics,
  });

  @override
  TopicGridBlock copyWithId(int id) =>
      TopicGridBlock(id: id, title: title, topics: topics);

  @override
  List<Object?> get props => [...super.props, title, topics];
}

class SingleChoiceBlock extends AssistantBlock {
  final String prompt;
  final String? hint;
  final List<AssistantChoice> options;

  const SingleChoiceBlock({
    required super.id,
    required this.prompt,
    required this.hint,
    required this.options,
  });

  @override
  SingleChoiceBlock copyWithId(int id) => SingleChoiceBlock(
        id: id,
        prompt: prompt,
        hint: hint,
        options: options,
      );

  @override
  List<Object?> get props => [...super.props, prompt, hint, options];
}

class MultiChoiceBlock extends AssistantBlock {
  final String prompt;
  final String? hint;
  final List<AssistantChoice> options;
  final String continueLabel;

  /// Selecting this option clears every other one — the mock's
  /// `None of the above`.
  final String? exclusiveOptionId;

  const MultiChoiceBlock({
    required super.id,
    required this.prompt,
    required this.hint,
    required this.options,
    required this.continueLabel,
    required this.exclusiveOptionId,
  });

  @override
  MultiChoiceBlock copyWithId(int id) => MultiChoiceBlock(
        id: id,
        prompt: prompt,
        hint: hint,
        options: options,
        continueLabel: continueLabel,
        exclusiveOptionId: exclusiveOptionId,
      );

  @override
  List<Object?> get props =>
      [...super.props, prompt, hint, options, continueLabel, exclusiveOptionId];
}

class SummaryBlock extends AssistantBlock {
  final String title;
  final List<SummaryRow> rows;
  final String? footnote;
  final String editLabel;
  final String confirmLabel;
  final String editReplyId;
  final String confirmReplyId;

  const SummaryBlock({
    required super.id,
    required this.title,
    required this.rows,
    required this.footnote,
    required this.editLabel,
    required this.confirmLabel,
    required this.editReplyId,
    required this.confirmReplyId,
  });

  @override
  SummaryBlock copyWithId(int id) => SummaryBlock(
        id: id,
        title: title,
        rows: rows,
        footnote: footnote,
        editLabel: editLabel,
        confirmLabel: confirmLabel,
        editReplyId: editReplyId,
        confirmReplyId: confirmReplyId,
      );

  @override
  List<Object?> get props => [
        ...super.props,
        title,
        rows,
        footnote,
        editLabel,
        confirmLabel,
        editReplyId,
        confirmReplyId,
      ];
}

class GuidanceBlock extends AssistantBlock {
  final String title;
  final String body;
  final String? suggestionsTitle;
  final List<ServiceSuggestion> suggestions;

  const GuidanceBlock({
    required super.id,
    required this.title,
    required this.body,
    required this.suggestionsTitle,
    required this.suggestions,
  });

  @override
  GuidanceBlock copyWithId(int id) => GuidanceBlock(
        id: id,
        title: title,
        body: body,
        suggestionsTitle: suggestionsTitle,
        suggestions: suggestions,
      );

  @override
  List<Object?> get props =>
      [...super.props, title, body, suggestionsTitle, suggestions];
}

class NextStepBlock extends AssistantBlock {
  final List<NextStepAction> actions;

  const NextStepBlock({required super.id, required this.actions});

  @override
  NextStepBlock copyWithId(int id) => NextStepBlock(id: id, actions: actions);

  @override
  List<Object?> get props => [...super.props, actions];
}

/// A kind this client version cannot render. Keeps a future server payload from
/// breaking the transcript.
class UnknownAssistantBlock extends AssistantBlock {
  final String kind;

  const UnknownAssistantBlock({required super.id, required this.kind});

  @override
  UnknownAssistantBlock copyWithId(int id) =>
      UnknownAssistantBlock(id: id, kind: kind);

  @override
  List<Object?> get props => [...super.props, kind];
}

class AssistantTopic extends Equatable {
  final String replyId;
  final String label;
  final String icon;
  final String tone;
  final String? echo;

  const AssistantTopic({
    required this.replyId,
    required this.label,
    required this.icon,
    required this.tone,
    required this.echo,
  });

  String get echoText => echo ?? label;

  @override
  List<Object?> get props => [replyId, label, icon, tone, echo];
}

class AssistantChoice extends Equatable {
  final String replyId;
  final String label;

  /// What the user's own bubble reads once this option is picked.
  final String? echo;

  /// The short phrase this answer contributes to the summary and to any
  /// `{stepId}` placeholder in later copy.
  final String? summary;

  const AssistantChoice({
    required this.replyId,
    required this.label,
    required this.echo,
    required this.summary,
  });

  String get echoText => echo ?? label;
  String get summaryText => summary ?? label;

  @override
  List<Object?> get props => [replyId, label, echo, summary];
}

class SummaryRow extends Equatable {
  final String icon;
  final String label;

  /// Literal value, used when [fromStep] recorded no answer.
  final String? value;

  /// Step whose recorded answer fills this row.
  final String? fromStep;

  const SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.fromStep,
  });

  @override
  List<Object?> get props => [icon, label, value, fromStep];
}

class ServiceSuggestion extends Equatable {
  final String replyId;
  final String title;
  final String subtitle;
  final String icon;
  final String tone;
  final String? route;

  const ServiceSuggestion({
    required this.replyId,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tone,
    required this.route,
  });

  @override
  List<Object?> get props => [replyId, title, subtitle, icon, tone, route];
}

class NextStepAction extends Equatable {
  final String replyId;
  final String title;
  final String subtitle;
  final String icon;
  final String tone;

  /// App route to push, or null when the action only appends a scripted reply.
  final String? route;

  /// Scripted assistant line appended when the action is taken.
  final String? reply;

  /// Clears the transcript and re-enters the entry step.
  final bool restart;

  const NextStepAction({
    required this.replyId,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tone,
    required this.route,
    required this.reply,
    required this.restart,
  });

  @override
  List<Object?> get props =>
      [replyId, title, subtitle, icon, tone, route, reply, restart];
}
