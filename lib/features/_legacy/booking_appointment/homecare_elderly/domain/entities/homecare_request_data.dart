import 'package:equatable/equatable.dart';

class HomecareRequestData extends Equatable {
  final int id;
  final int appointmentId;
  final String billingType; // hourly or subscription
  final List<String> services;

  const HomecareRequestData({
    required this.id,
    required this.appointmentId,
    required this.billingType,
    required this.services,
  });

  @override
  List<Object?> get props => [
        id,
        appointmentId,
        billingType,
        services,
      ];
}
