import 'package:m2health/features/etc/pricing/domain/entities/professional_rate.dart';

class ProfessionalRateModel extends ProfessionalRate {
  const ProfessionalRateModel({
    required super.professionalId,
    required super.serviceId,
    required super.basePrice,
  });

  factory ProfessionalRateModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalRateModel(
      professionalId: json['professional_id'] as int,
      serviceId: json['service_id'] as int,
      basePrice: double.parse((json['base_price'] ?? 0).toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        'professional_id': professionalId,
        'service_id': serviceId,
        'base_price': basePrice,
      };
}

class PricedProfessionalModel extends PricedProfessional {
  const PricedProfessionalModel({
    required super.id,
    required super.name,
    required super.category,
  });

  factory PricedProfessionalModel.fromJson(Map<String, dynamic> json) {
    return PricedProfessionalModel(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
      };
}
