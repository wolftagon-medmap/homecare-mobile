import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/settings/language/locale_cubit.dart';
import 'package:m2health/i18n/translations.g.dart';

/// The patient booking-card visual shared by the appointment tabs and the
/// pending inbox: avatar, title, subtitle + status chip, date/time, optional
/// price line. The action row is parameterized — appointment cards wire
/// Cancel/Reschedule/Pay; pre-acceptance care-task cards pass a chat entry.
class BookingCard extends StatelessWidget {
  final String? avatarUrl;
  final String title;
  final String? subtitle;
  final String statusLabel;
  final Color statusColor;
  final DateTime? scheduledStart;
  final String? priceLabel;
  final VoidCallback? onTap;
  final List<Widget> actions;

  const BookingCard({
    super.key,
    required this.title,
    required this.statusLabel,
    required this.statusColor,
    this.avatarUrl,
    this.subtitle,
    this.scheduledStart,
    this.priceLabel,
    this.onTap,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withValues(alpha: 0.08),
              spreadRadius: 0,
              blurRadius: 40,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: (avatarUrl != null && avatarUrl!.isNotEmpty)
                      ? NetworkImage(avatarUrl!)
                      : null,
                  child: (avatarUrl == null || avatarUrl!.isEmpty)
                      ? const Icon(Icons.person, size: 28, color: Colors.grey)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: ProText.sectionTitle,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          if (subtitle != null) ...[
                            Flexible(
                              child: Text(
                                subtitle!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: ProText.caption,
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],
                          Flexible(
                            child: _StatusChip(
                              label: statusLabel,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                      if (scheduledStart != null) ...[
                        const SizedBox(height: 3),
                        BlocBuilder<LocaleCubit, AppLocale>(
                          builder: (context, locale) {
                            final localStartTime = scheduledStart!.toLocal();
                            final date = DateFormat.yMMMd(locale.languageCode)
                                .format(localStartTime);
                            final hour = DateFormat.jm(locale.languageCode)
                                .format(localStartTime);
                            return Text(
                              '$date | $hour',
                              style: ProText.caption,
                            );
                          },
                        ),
                      ],
                      if (priceLabel != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          priceLabel!,
                          style: ProText.bodyStrong.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Const.aqua,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (actions.isNotEmpty) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Sized to sit beside the subtitle on one line, so a long status shortens
/// itself instead of squeezing the job title out of the card.
class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
