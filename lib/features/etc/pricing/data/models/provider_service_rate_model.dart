import 'package:m2health/features/etc/pricing/data/models/service_price_model.dart';
import 'package:m2health/features/etc/pricing/domain/entities/provider_service_rate.dart';

class ProviderServiceRateModel extends ProviderServiceRate {
  const ProviderServiceRateModel({required super.service, super.basePrice});

  /// The row the rates endpoint sends: the service, flattened, plus what this
  /// professional charges for it.
  factory ProviderServiceRateModel.fromJson(Map<String, dynamic> json) {
    final basePrice = json['base_price'];

    return ProviderServiceRateModel(
      service: ServicePriceModel.fromJson(json),
      basePrice: basePrice == null ? null : double.parse(basePrice.toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        ...ServicePriceModel(
          id: service.id,
          code: service.code,
          name: service.name,
          category: service.category,
          subCategory: service.subCategory,
          pricingModel: service.pricingModel,
          floorPrice: service.floorPrice,
        ).toJson(),
        'base_price': basePrice,
      };
}
