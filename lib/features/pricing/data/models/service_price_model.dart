import 'package:m2health/features/pricing/domain/entities/service_price.dart';

class ServicePriceModel extends ServicePrice {
  const ServicePriceModel({
    required super.id,
    required super.code,
    required super.name,
    required super.category,
    required super.pricingModel,
    required super.floorPrice,
    super.subCategory,
    super.description,
  });

  factory ServicePriceModel.fromJson(Map<String, dynamic> json) {
    return ServicePriceModel(
      id: json['id'] as int,
      code: json['code'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      subCategory: json['sub_category'] as String?,
      description: json['description'] as String?,
      pricingModel: json['pricing_model'] as String? ?? 'per_item',
      // `price` is the admin floor, the same column the services endpoint sends.
      floorPrice: double.parse((json['price'] ?? 0).toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
        'category': category,
        'sub_category': subCategory,
        'pricing_model': pricingModel,
        'price': floorPrice,
      };
}
