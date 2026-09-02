import 'package:equatable/equatable.dart';

/// A priced catalogue row. [floorPrice] is the admin-set standardised price —
/// the floor a professional may charge upward from, never below.
class ServicePrice extends Equatable {
  final int id;
  final String code;
  final String name;
  final String category;
  final String? subCategory;

  /// `per_item` · `per_package` · `hourly_rate`
  final String pricingModel;

  final double floorPrice;

  const ServicePrice({
    required this.id,
    required this.code,
    required this.name,
    required this.category,
    required this.pricingModel,
    required this.floorPrice,
    this.subCategory,
  });

  bool get isHourly => pricingModel == 'hourly_rate';

  @override
  List<Object?> get props => [
        id,
        code,
        name,
        category,
        subCategory,
        pricingModel,
        floorPrice,
      ];
}
