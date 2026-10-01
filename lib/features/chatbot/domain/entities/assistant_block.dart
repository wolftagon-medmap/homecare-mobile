import 'package:equatable/equatable.dart';

sealed class AssistantBlock extends Equatable {
  final int id;

  const AssistantBlock({required this.id});

  @override
  List<Object?> get props => [id];
}

class AssistantTextBlock extends AssistantBlock {
  final String text;
  final bool fromTeam;

  const AssistantTextBlock({
    required super.id,
    required this.text,
    this.fromTeam = false,
  });

  @override
  List<Object?> get props => [...super.props, text, fromTeam];
}

class UserTextBlock extends AssistantBlock {
  final String text;

  const UserTextBlock({required super.id, required this.text});

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
  List<Object?> get props => [...super.props, title, topics];
}

enum QuestionMode { single, multi }

class QuestionBlock extends AssistantBlock {
  final String questionId;
  final String text;
  final QuestionMode mode;
  final String? hint;
  final List<QuestionOption> options;
  final String? continueLabel;
  final int? exclusiveIndex;

  const QuestionBlock({
    required super.id,
    required this.questionId,
    required this.text,
    required this.mode,
    required this.hint,
    required this.options,
    required this.continueLabel,
    required this.exclusiveIndex,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        questionId,
        text,
        mode,
        hint,
        options,
        continueLabel,
        exclusiveIndex,
      ];
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
  final String? disclaimer;
  final String? suggestionsTitle;
  final List<ServiceSuggestion> suggestions;

  const GuidanceBlock({
    required super.id,
    required this.title,
    required this.body,
    required this.disclaimer,
    required this.suggestionsTitle,
    required this.suggestions,
  });

  @override
  List<Object?> get props =>
      [...super.props, title, body, disclaimer, suggestionsTitle, suggestions];
}

class NextStepBlock extends AssistantBlock {
  final List<NextStepAction> actions;

  const NextStepBlock({required super.id, required this.actions});

  @override
  List<Object?> get props => [...super.props, actions];
}

class ConfirmRequestBlock extends AssistantBlock {
  final String text;
  final String confirmId;
  final String cancelId;

  const ConfirmRequestBlock({
    required super.id,
    required this.text,
    required this.confirmId,
    required this.cancelId,
  });

  @override
  List<Object?> get props => [...super.props, text, confirmId, cancelId];
}

class UnknownAssistantBlock extends AssistantBlock {
  final String kind;

  const UnknownAssistantBlock({required super.id, required this.kind});

  @override
  List<Object?> get props => [...super.props, kind];
}

class AssistantTopic extends Equatable {
  final String replyId;
  final String label;
  final String icon;
  final String tone;

  const AssistantTopic({
    required this.replyId,
    required this.label,
    required this.icon,
    required this.tone,
  });

  @override
  List<Object?> get props => [replyId, label, icon, tone];
}

class QuestionOption extends Equatable {
  final int index;
  final String label;

  const QuestionOption({required this.index, required this.label});

  @override
  List<Object?> get props => [index, label];
}

class SummaryRow extends Equatable {
  final String icon;
  final String label;
  final String value;

  const SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  List<Object?> get props => [icon, label, value];
}

class BookingPrefill extends Equatable {
  final String category;
  final String? subCategory;
  final List<String> issueCodes;
  final String remarks;

  const BookingPrefill({
    required this.category,
    required this.subCategory,
    required this.issueCodes,
    required this.remarks,
  });

  @override
  List<Object?> get props => [category, subCategory, issueCodes, remarks];
}

class ServiceSuggestion extends Equatable {
  final String replyId;
  final String title;
  final String subtitle;
  final String icon;
  final String tone;
  final BookingPrefill? booking;

  const ServiceSuggestion({
    required this.replyId,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tone,
    required this.booking,
  });

  @override
  List<Object?> get props => [replyId, title, subtitle, icon, tone, booking];
}

enum NextStepKind { exploreServices, newConversation, reply, unknown }

class NextStepAction extends Equatable {
  final String replyId;
  final NextStepKind kind;
  final String title;
  final String subtitle;
  final String icon;
  final String tone;

  const NextStepAction({
    required this.replyId,
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tone,
  });

  @override
  List<Object?> get props => [replyId, kind, title, subtitle, icon, tone];
}
