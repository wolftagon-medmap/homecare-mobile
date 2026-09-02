import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_message.dart';
import 'package:m2health/features/chatbot/domain/entities/message.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:m2health/features/chatbot/presentation/widgets/source_list_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'copy_helper.dart';

class AssistantBubble extends StatelessWidget {
  final Message message;
  const AssistantBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final parsedData = AssistantMessage.parse(message.content);

    return RepaintBoundary(
      child: GestureDetector(
        onLongPress: () => copyToClipboard(context, parsedData.message),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.only(left: 20)),
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(right: 24, bottom: 8),
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 12, left: 20, right: 20),
                  decoration: const BoxDecoration(
                    color: Const.grayLight,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 4)
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AssistantMessageWidget(parsedData: parsedData),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                          onTap: () =>
                              copyToClipboard(context, parsedData.message),
                          child: const Icon(Icons.copy_rounded,
                              size: 16, color: Colors.grey),
                        ),
                      ),
                    ],
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

const String CITATION_ELEMENT = 'citation';

class AssistantMessageWidget extends StatelessWidget {
  final AssistantMessage parsedData;

  const AssistantMessageWidget({super.key, required this.parsedData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MarkdownBody(
          key: ValueKey(
              "${parsedData.message.hashCode}-${parsedData.sources.length}"),
          data: parsedData.message,
          selectable: true,
          onTapLink: (text, href, title) {
            if (href != null) {
              launchUrl(Uri.parse(href), mode: LaunchMode.externalApplication);
            }
          },
          inlineSyntaxes: [CitationSyntax()],
          builders: {
            CITATION_ELEMENT: CitationBuilder(
              sources: parsedData.sources,
              onTap: (s) => _showSourcesSheet(context, s),
            ),
          },
          styleSheet: MarkdownStyleSheet(
            h1: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            h2: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            h3: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            h4: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            h5: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            p: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.normal,
            ),
            strong: const TextStyle(fontWeight: FontWeight.bold),
            listBullet: const TextStyle(fontSize: 12, color: Colors.black87),
            horizontalRuleDecoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
        if (parsedData.sources.isNotEmpty) ...[
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _showSourcesSheet(context, parsedData.sources),
            icon: const Icon(Icons.link_rounded, size: 20),
            label: const Text("Sources", style: TextStyle(fontSize: 14)),
            style: OutlinedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              foregroundColor: Colors.grey.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ]
      ],
    );
  }

  void _showSourcesSheet(
      BuildContext context, List<CitationSource> sourcesToShow) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SourceListSheet(sources: sourcesToShow),
    );
  }
}

// --- The Syntax: How to find [n] in markdown ---
class CitationSyntax extends md.InlineSyntax {
  CitationSyntax() : super(r'\[(\d+)\]');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final citationId = match.group(1);
    final element = md.Element.text(CITATION_ELEMENT, citationId!);
    parser.addNode(element);
    return true;
  }
}

// --- The Builder: How to draw the chip ---
class CitationBuilder extends MarkdownElementBuilder {
  final List<CitationSource> sources;
  final Function(List<CitationSource>) onTap;

  CitationBuilder({required this.sources, required this.onTap});

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final id = element.textContent;
    final source = sources.firstWhere(
      (s) => s.id.toString() == id,
      orElse: () => const CitationSource(id: -1, source: '', url: ''),
    );

    if (source.id == -1) return Text("[$id]");

    return GestureDetector(
      onTap: () => onTap([source]),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.blue.shade300, width: 0.5),
        ),
        child: Text(
          id,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
