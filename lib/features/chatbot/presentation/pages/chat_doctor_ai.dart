import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/features/chatbot/presentation/widgets/chat_view.dart';

class ChatDoctorAIPage extends StatelessWidget {
  const ChatDoctorAIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChatView(
      service: 'general',
      appBarTitle: _ChatDoctorAIHeader(),
    );
  }
}

class _ChatDoctorAIHeader extends StatelessWidget {
  const _ChatDoctorAIHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset('assets/icons/ic_doctor_ai.png', width: 36, height: 36),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "MedDoctor AI",
              style: TextStyle(
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
