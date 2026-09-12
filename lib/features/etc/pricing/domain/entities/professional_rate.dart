import 'package:equatable/equatable.dart';

/// What one professional charges for one service. Always at or above that
/// service's floor; there is deliberately no upper cap.
class ProfessionalRate extends Equatable {
  final int professionalId;
  final int serviceId;
  final double basePrice;

  const ProfessionalRate({
    required this.professionalId,
    required this.serviceId,
    required this.basePrice,
  });

  @override
  List<Object?> get props => [professionalId, serviceId, basePrice];
}

/// The join key and a label — nothing more. The professional card belongs to
/// the booking feature, which joins on [id].
class PricedProfessional extends Equatable {
  final int id;
  final String name;
  final String category;

  const PricedProfessional({
    required this.id,
    required this.name,
    required this.category,
  });

  @override
  List<Object?> get props => [id, name, category];
}
