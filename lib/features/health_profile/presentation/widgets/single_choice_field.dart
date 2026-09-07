import 'package:flutter/material.dart';
import 'package:m2health/const.dart';

class SingleChoiceField extends StatelessWidget {
  const SingleChoiceField({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<({String code, String label})> options;
  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return RadioGroup<String>(
      groupValue: selected,
      onChanged: (value) {
        if (value != null) onSelected(value);
      },
      child: Column(
        children: [
          for (final option in options)
            InkWell(
              onTap: () => onSelected(option.code),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Radio<String>(
                      value: option.code,
                      activeColor: Const.tosca,
                    ),
                    Expanded(
                      child: Text(
                        option.label,
                        style: const TextStyle(fontSize: 15),
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
