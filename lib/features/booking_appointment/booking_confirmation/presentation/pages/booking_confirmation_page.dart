import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';
import 'package:m2health/i18n/translations.g.dart';

/// Shared "review before you book" step: patient, visit address, services,
/// professional, time and price. Presentational only — the calling flow owns
/// all state and wires [onConfirm]/[onChangePatient] back into its own bloc.
class BookingConfirmationPage extends StatelessWidget {
  final String patientName;
  final VoidCallback onChangePatient;
  final Address? address;
  final List<ServiceEntity> services;
  final String professionalName;
  final String? professionalRole;
  final DateTime timeSlot;
  final bool isSubmitting;
  final VoidCallback onConfirm;

  const BookingConfirmationPage({
    super.key,
    required this.patientName,
    required this.onChangePatient,
    required this.address,
    required this.services,
    required this.professionalName,
    this.professionalRole,
    required this.timeSlot,
    required this.isSubmitting,
    required this.onConfirm,
  });

  double get _totalPrice => services.fold(0.0, (sum, s) => sum + s.price);

  @override
  Widget build(BuildContext context) {
    final t = context.t.booking.confirmation;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: t.patient_label,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    patientName,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                TextButton(
                  onPressed: isSubmitting ? null : onChangePatient,
                  child: Text(t.change_button),
                ),
              ],
            ),
          ),
          _Section(
            title: t.address_label,
            child: Text(
              address?.formattedAddress ?? address?.label ?? t.no_address,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          _Section(
            title: t.services_label,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: services
                  .map(
                    (service) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(service.name,
                                style: const TextStyle(fontSize: 14)),
                          ),
                          Text(
                            '\$${service.price.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          _Section(
            title: t.professional_label,
            child: Text(
              professionalRole != null
                  ? '$professionalName · $professionalRole'
                  : professionalName,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          _Section(
            title: t.time_label,
            child: Text(
              DateFormat('MMM d, y, HH:mm').format(timeSlot),
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                t.total_label,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const Spacer(),
              Text(
                '\$${_totalPrice.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: isSubmitting ? null : onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Const.aqua,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
                child: isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        t.confirm_button,
                        style: const TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}
