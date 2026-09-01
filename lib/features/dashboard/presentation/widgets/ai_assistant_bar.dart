import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/route/app_routes.dart';

class AiAssistantBar extends StatelessWidget {
  const AiAssistantBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: GestureDetector(
        onTap: () => context.push(AppRoutes.intakeBooking),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 9, 9, 9),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF7C8AA5),
                    fontSize: 11,
                    height: 1.25,
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
    );
  }
}
