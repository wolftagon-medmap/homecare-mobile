import 'package:equatable/equatable.dart';

class ServiceEntity extends Equatable {
  final int id;
  final String name;
  final double price;

  // Fields added in API v2 unified service catalog
  // nursing | pharmacy | homecare_elderly | physiotherapy | screening | second_opinion_imaging | nutrition
  final String? category;
  final String? subCategory;
  // per_item | per_package | hourly_rate
  final String? pricingModel;
  final int? durationMinutes;
  final String? code;
  final bool? isPublished;

  const ServiceEntity({
    required this.id,
    required this.name,
    required this.price,
    this.category,
    this.subCategory,
    this.pricingModel,
    this.durationMinutes,
    this.code,
    this.isPublished,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        category,
        subCategory,
        pricingModel,
        durationMinutes,
        code,
        isPublished,
      ];
}
