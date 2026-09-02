import 'package:flutter/material.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/widgets/visit_address_bar.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';

class BookingLocationBar extends StatelessWidget {
  const BookingLocationBar({
    super.key,
    required this.address,
    required this.isLoading,
    required this.onTap,
  });

  final Address? address;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: VisitAddressBar(
          selectedAddress: address,
          isLoading: isLoading,
          onTap: onTap,
        ),
      ),
    );
  }
}
