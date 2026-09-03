import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:m2health/const.dart';

class AttachmentField extends StatelessWidget {
  const AttachmentField({
    super.key,
    required this.attachmentIds,
    required this.addLabel,
    required this.itemLabel,
    required this.uploading,
    required this.onPicked,
    required this.onRemoved,
  });

  final List<int> attachmentIds;
  final String addLabel;
  final String Function(int id) itemLabel;
  final bool uploading;
  final ValueChanged<String> onPicked;
  final ValueChanged<int> onRemoved;

  Future<void> _pick() async {
    final result = await FilePicker.platform.pickFiles(withReadStream: false);
    final path = result?.files.single.path;
    if (path != null) onPicked(path);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (attachmentIds.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final id in attachmentIds)
                Chip(
                  label: Text(itemLabel(id)),
                  avatar: const Icon(Icons.description_outlined, size: 18),
                  onDeleted: () => onRemoved(id),
                ),
            ],
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: uploading ? null : _pick,
            icon: uploading
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.attach_file, size: 18),
            label: Text(addLabel),
            style: TextButton.styleFrom(foregroundColor: Const.tosca),
          ),
        ),
      ],
    );
  }
}
