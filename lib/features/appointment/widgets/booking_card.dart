import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:m2health/features/settings/language/locale_cubit.dart';
import 'package:m2health/i18n/translations.g.dart';

/// The patient booking-card visual shared by the appointment tabs and the
/// pending inbox: avatar, title, subtitle + status chip, date/time, optional
/// price line. The action row is parameterized — appointment cards wire
/// Cancel/Reschedule/Pay; pre-acceptance care-task cards pass none (tap only).
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
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage:
                          (avatarUrl != null && avatarUrl!.isNotEmpty)
                              ? NetworkImage(avatarUrl!)
                              : null,
                      child: (avatarUrl == null || avatarUrl!.isEmpty)
                          ? const Icon(Icons.person,
                              size: 30, color: Colors.grey)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              if (subtitle != null) ...[
                                Flexible(
                                  child: Text(
                                    '$subtitle |',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 5),
                              ],
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  statusLabel,
                                  style: TextStyle(color: statusColor),
                                ),
                              ),
                            ],
                          ),
                          if (scheduledStart != null)
                            BlocBuilder<LocaleCubit, AppLocale>(
                              builder: (context, locale) {
                                final localStartTime =
                                    scheduledStart!.toLocal();
                                final date =
                                    DateFormat.yMMMd(locale.languageCode)
                                        .format(localStartTime);
                                final hour = DateFormat.jm(locale.languageCode)
                                    .format(localStartTime);
                                return Text('$date | $hour');
                              },
                            ),
                          if (priceLabel != null)
                            Text(
                              priceLabel!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF35C5CF),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (actions.isNotEmpty) ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
