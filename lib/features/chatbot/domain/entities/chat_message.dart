import 'dart:io';
import 'package:equatable/equatable.dart';

class Attachment extends Equatable {
  final String? url;
  final String? name;
  final File? localFile;
  final AttachmentType type;

  const Attachment({
    this.url,
    this.name,
    this.localFile,
    required this.type,
  });

  const Attachment.local({required File file, this.name})
      : localFile = file,
        url = null,
        type = AttachmentType.file;

  const Attachment.remote({required this.url, this.name})
      : localFile = null,
        type = AttachmentType.file;

  bool get isLocal => localFile != null;

  @override
  List<Object?> get props => [url, name, localFile, type];
}

enum AttachmentType { file, image }
