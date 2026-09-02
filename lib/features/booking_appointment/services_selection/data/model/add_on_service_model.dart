import 'package:m2health/core/data/models/service_model.dart';
import 'package:m2health/features/booking_appointment/services_selection/domain/entities/add_on_service.dart';

@Deprecated('Use ServiceModel instead. TODO: delete after migration.')
class AddOnServiceModel extends AddOnService {
  const AddOnServiceModel({
    required super.id,
    required super.name,
    required super.price,
    required super.serviceType,
    super.subCategory,
    super.pricingModel,
    super.durationMinutes,
    super.code,
    super.isPublished,
  });

  @Deprecated('Use ServiceModel.fromJson instead. TODO: delete after migration.')
  factory AddOnServiceModel.fromJson(Map<String, dynamic> json) {
    // Delegate to ServiceModel which handles both v1 and v2 field names.
    final s = ServiceModel.fromJson(json);
    return AddOnServiceModel(
      id: s.id,
      name: s.name,
      price: s.price,
      serviceType: s.category ?? '',
      subCategory: s.subCategory,
      pricingModel: s.pricingModel,
      durationMinutes: s.durationMinutes,
      code: s.code,
      isPublished: s.isPublished,
    );
  }
}
