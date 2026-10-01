import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/chatbot/chatbot_routes.dart';
import 'package:m2health/features/dashboard/presentation/dashboard_palette.dart';
import 'package:m2health/i18n/translations.g.dart';

class AiAssistantBar extends StatelessWidget {
  const AiAssistantBar({super.key});

  static const _titleSize = 15.0;
  static const _subtitleSize = 12.0;
  static const _lineHeight = 1.25;
  static const _lineGap = 2.0;

  static double textHeightOf(TextScaler scaler) =>
      (scaler.scale(_titleSize) + scaler.scale(_subtitleSize)) * _lineHeight +
      _lineGap;

  @override
  Widget build(BuildContext context) {
    final t = context.t.dashboard;

    return Semantics(
      button: true,
      label: t.chat_ai_title,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        shadowColor: Colors.black.withValues(alpha: 0.18),
        child: InkWell(
          onTap: () => context.push(ChatbotRoutes.aiAssistant),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 9, 9, 9),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/ic_ai_robot.svg',
                  width: 34,
                  height: 34,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        t.chat_ai_title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: DashboardPalette.navy,
                          fontSize: _titleSize,
                          height: _lineHeight,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: _lineGap),
                      Text(
                        t.chat_ai_subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: DashboardPalette.muted,
                          fontSize: _subtitleSize,
                          height: _lineHeight,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: Color(0xFF038E9F),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_forward,
                      size: 18, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
