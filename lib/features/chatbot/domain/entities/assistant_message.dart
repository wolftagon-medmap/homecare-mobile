import 'dart:convert';

import 'package:equatable/equatable.dart';

class CitationSource extends Equatable {
  final int id;
  final String source;
  final String url;

  const CitationSource(
      {required this.id, required this.source, required this.url});

  @override
  List<Object?> get props => [id, source, url];

  factory CitationSource.fromJson(Map<String, dynamic> json) {
    return CitationSource(
      id: json['id'] as int,
      source: json['source'] as String,
      url: json['url'] as String,
    );
  }
}

class AssistantMessage extends Equatable {
  final String message;
  final List<CitationSource> sources;

  const AssistantMessage({required this.message, required this.sources});

  @override
  List<Object?> get props => [message, sources];

  /// Raw text format expected from the assistant:
  ///
  /// ```
  /// [Answer Text]
  /// ---METADATA---
  /// {
  ///   "citations": [
  ///     {
  ///       "id": 1,
  ///       "source": "Title of the specific article/page",
  ///       "url": "https://direct-link-to-source.com/page",
  ///     }
  ///   ]
  ///}
  ///```
  factory AssistantMessage.parse(String rawText) {
    final parts = rawText.split('---METADATA---');
    final text = parts[0].trim();
    try {
      List<CitationSource> sourcesList = [];

      if (parts.length > 1) {
        final jsonString = parts[1].trim();
        if (jsonString.isNotEmpty) {
          final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
          if (jsonMap['citations'] != null) {
            sourcesList = (jsonMap['citations'] as List)
                .map((e) => CitationSource.fromJson(e))
                .toList();
          }
        }
      }
      return AssistantMessage(message: text, sources: sourcesList);
    } catch (e) {
      return AssistantMessage(message: text, sources: const []);
    }
  }
}
