import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/chatbot/chatbot_routes.dart';
import 'package:m2health/i18n/translations.g.dart';

class AiAssistantBar extends StatelessWidget {
  const AiAssistantBar({super.key});

  static const textSize = 11.0;
  static const textLineHeight = 1.25;
  static const textMaxLines = 2;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
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
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.t.dashboard.chat_ai_placeholder,
                    maxLines: textMaxLines,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF7C8AA5),
                      fontSize: textSize,
                      height: textLineHeight,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Color(0xFF038E9F),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_forward,
                      size: 17, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
