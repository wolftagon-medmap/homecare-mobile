import 'package:m2health/features/professional_profile/domain/entities/service_area.dart';

class ServiceAreaModel extends ServiceArea {
  const ServiceAreaModel({
    required super.code,
    required super.name,
    super.parentName,
  });

  factory ServiceAreaModel.fromJson(Map<String, dynamic> json) {
    return ServiceAreaModel(
      code: json['code'] as String,
      name: json['name'] as String? ?? json['code'] as String,
      parentName: json['parent_name'] as String?,
    );
  }
}

class AreaOptionModel extends AreaOption {
  const AreaOptionModel({
    required super.countryCode,
    required super.code,
    required super.name,
    super.parentName,
  });

  factory AreaOptionModel.fromJson(Map<String, dynamic> json) {
    return AreaOptionModel(
      countryCode: (json['country_code'] as String? ?? '').toUpperCase(),
      code: json['code'] as String,
      name: json['name'] as String? ?? json['code'] as String,
      parentName: json['parent_name'] as String?,
    );
  }
}
