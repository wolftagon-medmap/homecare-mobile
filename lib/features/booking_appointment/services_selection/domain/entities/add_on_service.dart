import 'package:m2health/core/domain/entities/service_entity.dart';

// TODO: Remove in next refactor cycle — use ServiceEntity directly.
// serviceType is now ServiceEntity.category (renamed in v2 unified catalog).
@Deprecated(
    'Use ServiceEntity with category field instead. TODO: delete after migration.')
class AddOnService extends ServiceEntity {
  // Legacy field — maps to ServiceEntity.category in v2.
  final String serviceType;

  const AddOnService({
    required super.id,
    required super.name,
    required super.price,
    required this.serviceType,
    super.subCategory,
    super.pricingModel,
    super.durationMinutes,
    super.code,
    super.isPublished,
  }) : super(category: serviceType);

  @override
  List<Object?> get props =>
      [id, name, price, serviceType, subCategory, pricingModel, code];
}
