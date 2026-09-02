import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/features/chatbot/presentation/widgets/chat_view.dart';
import 'package:m2health/route/app_routes.dart';

class ChatPharmaPage extends StatelessWidget {
  const ChatPharmaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChatView(
      service: 'pharmacy',
      appBarTitle: _ChatPharmaHeader(),
      footer: _PharmaHelpRequestButton(),
    );
  }
}

class _ChatPharmaHeader extends StatelessWidget {
  const _ChatPharmaHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset('assets/icons/ic_pharma_ai.png', width: 36, height: 36),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.chat_pharma_title,
              style: const TextStyle(
                color: Const.aqua,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                const Icon(Icons.circle, color: Colors.green, size: 6),
                const SizedBox(width: 4),
                Text(
                  context.l10n.chat_pharma_online,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _PharmaHelpRequestButton extends StatelessWidget {
  const _PharmaHelpRequestButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline_rounded, color: Colors.grey),
          const SizedBox(width: 5),
          Text(
            context.l10n.chat_pharma_need_help,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          GestureDetector(
            onTap: () {
              GoRouter.of(context).push(AppRoutes.pharmacyBookAppointmentFlow);
            },
            child: Text(
              context.l10n.chat_pharma_request_help,
              style: const TextStyle(
                color: Color(0xFF35C5CF),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
