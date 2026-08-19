import 'package:m2health/core/domain/entities/service_entity.dart';

class ServiceModel extends ServiceEntity {
  const ServiceModel({
    required super.id,
    required super.name,
    required super.price,
    super.category,
    super.subCategory,
    super.pricingModel,
    super.durationMinutes,
    super.code,
    super.isPublished,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as int,
      // v2 uses 'name'; legacy used 'title'
      name: (json['name'] ?? json['title']) as String? ?? '',
      price: double.parse((json['price'] ?? 0).toString()),
      // v2 uses 'category'; legacy used 'service_type'
      category: (json['category'] ?? json['service_type']) as String?,
      subCategory: json['sub_category'] as String?,
      pricingModel: json['pricing_model'] as String?,
      durationMinutes: json['detail']?['duration'],
      code: json['code'] as String?,
      isPublished: json['is_published'] as bool?,
    );
  }
}
