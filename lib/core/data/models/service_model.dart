import 'package:m2health/core/domain/entities/service_entity.dart';

class ServiceModel extends ServiceEntity {
  const ServiceModel({
    required super.id,
    required super.name,
    required super.price,
    super.description,
    super.category,
    super.subCategory,
    super.pricingModel,
    super.durationMinutes,
    super.code,
    super.isPublished,
  });

  /// The API serialises model columns in camelCase and hand-assembled keys in
  /// snake_case, so both spellings have to be accepted.
  static dynamic _pick(Map<String, dynamic> json, String snake, String camel) =>
      json[snake] ?? json[camel];

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as int,
      // v2 uses 'name'; legacy used 'title'
      name: (json['name'] ?? json['title']) as String? ?? '',
      price: double.parse((json['price'] ?? 0).toString()),
      description: json['description'] as String?,
      // v2 uses 'category'; legacy used 'service_type'
      category: (json['category'] ?? json['service_type']) as String?,
      subCategory: _pick(json, 'sub_category', 'subCategory') as String?,
      pricingModel: _pick(json, 'pricing_model', 'pricingModel') as String?,
      durationMinutes: json['detail']?['duration'],
      code: json['code'] as String?,
      isPublished: _pick(json, 'is_published', 'isPublished') as bool?,
    );
  }
}
