import 'package:equatable/equatable.dart';

/// Whose health profile is open. A null id means the account holder.
class HealthProfileSubject extends Equatable {
  final int? patientProfileId;
  final bool isAccountHolder;

  const HealthProfileSubject({
    required this.patientProfileId,
    required this.isAccountHolder,
  });

  @override
  List<Object?> get props => [patientProfileId, isAccountHolder];
}
