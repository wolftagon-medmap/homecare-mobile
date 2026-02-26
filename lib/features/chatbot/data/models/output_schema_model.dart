part of 'chat_event_model.dart';

class OutputSchemaModel {
  final dynamic message;
  final String? reasoningContent;
  final String? outputKey;
  final List<_FileModel>? files;
  final String? sourceUrl;
  final Map<String, dynamic>? extra;

  OutputSchemaModel({
    this.message,
    this.reasoningContent,
    this.outputKey,
    this.files,
    this.sourceUrl,
    this.extra,
  });

  factory OutputSchemaModel.fromJson(Map<String, dynamic> json) {
    return OutputSchemaModel(
      message: json['message'],
      reasoningContent: json['reasoning_content'] as String?,
      outputKey: json['output_key'] as String?,
      files: (json['files'] as List<dynamic>?)
          ?.map((e) => _FileModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      sourceUrl: json['source_url'] as String?,
      extra: json['extra'] as Map<String, dynamic>?,
    );
  }
}

class _FileModel {
  final String path;
  final String name;

  _FileModel({
    required this.path,
    required this.name,
  });

  factory _FileModel.fromJson(Map<String, dynamic> json) {
    return _FileModel(
      path: json['path'] as String,
      name: json['name'] as String,
    );
  }

  Attachment toAttachment() {
    return Attachment.remote(
      url: path,
      name: name,
    );
  }
}
