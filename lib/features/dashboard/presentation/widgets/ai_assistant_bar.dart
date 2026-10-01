import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/core/presentation/responsive/responsive.dart';
import 'package:m2health/features/chatbot/chatbot_routes.dart';
import 'package:m2health/features/dashboard/presentation/dashboard_palette.dart';
import 'package:m2health/i18n/translations.g.dart';

class AiAssistantBar extends StatelessWidget {
  const AiAssistantBar({super.key});

  static const _range = FluidRange(360, 834);
  static const _lineHeight = 1.25;
  static const _lineGap = 2.0;

  static double contentHeightOf(double screenWidth, TextScaler scaler) {
    final sizes = _AiBarSizes.of(screenWidth);
    final text = (scaler.scale(sizes.title) + scaler.scale(sizes.subtitle)) *
            _lineHeight +
        _lineGap;
    return math.max(text, sizes.button);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.dashboard;
    final sizes = _AiBarSizes.of(MediaQuery.sizeOf(context).width);

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
                  width: sizes.icon,
                  height: sizes.icon,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoSizeText(
                        t.chat_ai_title,
                        maxLines: 1,
                        minFontSize: 12,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: DashboardPalette.navy,
                          fontSize: sizes.title.roundToDouble(),
                          height: _lineHeight,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: _lineGap),
                      Text(
                        t.chat_ai_subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: DashboardPalette.muted,
                          fontSize: sizes.subtitle,
                          height: _lineHeight,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: sizes.button,
                  height: sizes.button,
                  decoration: const BoxDecoration(
                    color: Color(0xFF038E9F),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    size: sizes.button * 0.47,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AiBarSizes {
  final double title;
  final double subtitle;
  final double icon;
  final double button;

  const _AiBarSizes({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.button,
  });

  factory _AiBarSizes.of(double screenWidth) {
    double size(double min, double max) =>
        AiAssistantBar._range.lerp(screenWidth, min, max);

    return _AiBarSizes(
      title: size(15, 19),
      subtitle: size(12, 15),
      icon: size(34, 44),
      button: size(38, 48),
    );
  }
}
