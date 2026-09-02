import 'package:flutter/material.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_block.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_bubbles.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_theme.dart';

class SingleChoiceCard extends StatelessWidget {
  final SingleChoiceBlock block;
  final bool active;
  final String? chosenReplyId;
  final ValueChanged<String>? onSelect;

  const SingleChoiceCard({
    super.key,
    required this.block,
    required this.active,
    required this.chosenReplyId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ChoicePrompt(prompt: block.prompt, hint: block.hint),
        AssistantCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < block.options.length; i++) ...[
                if (i > 0) const _RowDivider(),
                _ChoiceRow(
                  label: block.options[i].label,
                  selected: chosenReplyId == block.options[i].replyId,
                  multi: false,
                  onTap: active && onSelect != null
                      ? () => onSelect!(block.options[i].replyId)
                      : null,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class MultiChoiceCard extends StatelessWidget {
  final MultiChoiceBlock block;
  final bool active;
  final List<String> selected;
  final bool resolved;
  final ValueChanged<String>? onToggle;
  final VoidCallback? onSubmit;

  const MultiChoiceCard({
    super.key,
    required this.block,
    required this.active,
    required this.selected,
    required this.resolved,
    required this.onToggle,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final canSubmit = active && selected.isNotEmpty && onSubmit != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ChoicePrompt(prompt: block.prompt, hint: block.hint),
        AssistantCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < block.options.length; i++) ...[
                if (i > 0) const _RowDivider(),
                _ChoiceRow(
                  label: block.options[i].label,
                  selected: selected.contains(block.options[i].replyId),
                  multi: true,
                  onTap: active && onToggle != null
                      ? () => onToggle!(block.options[i].replyId)
                      : null,
                ),
              ],
              if (!resolved) ...[
                const _RowDivider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: canSubmit ? onSubmit : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: AssistantPalette.primary,
                        disabledBackgroundColor: AssistantPalette.border,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        block.continueLabel,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ChoicePrompt extends StatelessWidget {
  final String prompt;
  final String? hint;

  const _ChoicePrompt({required this.prompt, required this.hint});

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.sizeOf(context).width * 0.72;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AssistantAvatar(),
          const SizedBox(width: 10),
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: maxWidth),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: const BoxDecoration(
                color: AssistantPalette.bubble,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    prompt,
                    style: const TextStyle(
                      color: AssistantPalette.body,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  if (hint != null)
                    Text(
                      hint!,
                      style: const TextStyle(
                        color: AssistantPalette.muted,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChoiceRow extends StatelessWidget {
  final String label;
  final bool selected;
  final bool multi;
  final VoidCallback? onTap;

  const _ChoiceRow({
    required this.label,
    required this.selected,
    required this.multi,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AssistantPalette.primary.withValues(alpha: 0.06)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              _ChoiceMark(selected: selected, multi: multi),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: AssistantPalette.navy,
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChoiceMark extends StatelessWidget {
  final bool selected;
  final bool multi;

  const _ChoiceMark({required this.selected, required this.multi});

  @override
  Widget build(BuildContext context) {
    if (multi) {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: selected ? AssistantPalette.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: selected ? AssistantPalette.primary : AssistantPalette.muted,
            width: 1.5,
          ),
        ),
        child: selected
            ? const Icon(Icons.check, size: 14, color: Colors.white)
            : null,
      );
    }
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AssistantPalette.primary : AssistantPalette.muted,
          width: 1.5,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AssistantPalette.primary,
                ),
              ),
            )
          : null,
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      color: AssistantPalette.border,
      indent: 14,
      endIndent: 14,
    );
  }
}
