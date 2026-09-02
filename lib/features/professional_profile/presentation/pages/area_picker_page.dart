import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/professional_profile/domain/entities/service_area.dart';

class AreaPickerPage extends StatefulWidget {
  const AreaPickerPage({
    super.key,
    required this.areas,
    required this.initialSelection,
    this.title = 'Districts',
    this.singleSelect = false,
  });

  final List<AreaOption> areas;
  final Set<String> initialSelection;
  final String title;
  final bool singleSelect;

  @override
  State<AreaPickerPage> createState() => _AreaPickerPageState();
}

class _AreaPickerPageState extends State<AreaPickerPage> {
  late Set<String> _selected = {...widget.initialSelection};
  String _query = '';

  List<AreaOption> get _matches {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return widget.areas;

    return widget.areas
        .where((a) =>
            a.name.toLowerCase().contains(query) ||
            (a.parentName?.toLowerCase().contains(query) ?? false))
        .toList();
  }

  void _toggle(AreaOption area) {
    setState(() {
      if (widget.singleSelect) {
        _selected = _selected.contains(area.code) ? {} : {area.code};
        return;
      }
      _selected.contains(area.code)
          ? _selected.remove(area.code)
          : _selected.add(area.code);
    });
  }

  @override
  Widget build(BuildContext context) {
    final grouped = groupBy(_matches, (AreaOption a) => a.parentName ?? '');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: ProText.pageTitle,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, _selected),
            child: const Text('Done'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Search districts',
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          if (!widget.singleSelect)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    '${_selected.length} selected',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  if (_selected.isNotEmpty)
                    TextButton(
                      onPressed: () => setState(_selected.clear),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Clear', style: ProText.hint),
                    ),
                ],
              ),
            ),
          const SizedBox(height: 4),
          Expanded(
            child: _matches.isEmpty
                ? Center(
                    child: Text(
                      'No district matches "$_query".',
                      style: ProText.caption,
                    ),
                  )
                : ListView(
                    children: [
                      for (final entry in grouped.entries) ...[
                        if (entry.key.isNotEmpty) _GroupHeader(entry.key),
                        for (final area in entry.value)
                          CheckboxListTile(
                            value: _selected.contains(area.code),
                            onChanged: (_) => _toggle(area),
                            activeColor: Const.aqua,
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(
                              area.name,
                              style: ProText.body,
                            ),
                          ),
                      ],
                      const SizedBox(height: 24),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}
