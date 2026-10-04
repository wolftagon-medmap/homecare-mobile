import 'package:m2health/features/etc/pricing/data/datasources/pricing_endpoint_client.dart';
import 'package:m2health/features/etc/pricing/data/models/provider_service_rate_model.dart';

abstract class ProviderRateDataSource {
  Future<List<ProviderServiceRateModel>> myRates();

  /// serviceId -> price, or null to fall back to the standard price.
  Future<List<ProviderServiceRateModel>> save(Map<int, double?> basePrices);
}

class ProviderRateRemoteDataSource extends PricingEndpointClient
    implements ProviderRateDataSource {
  ProviderRateRemoteDataSource({required super.dio});

  @override
  Future<List<ProviderServiceRateModel>> myRates() =>
      guard('load your rates', () async {
        final response = await dio.get<dynamic>(
          url('/provider/service-rates'),
          options: await authHeaders(),
        );
        return _parse(response.data);
      });

  @override
  Future<List<ProviderServiceRateModel>> save(Map<int, double?> basePrices) =>
      guard('save your rates', () async {
        final response = await dio.put<dynamic>(
          url('/provider/service-rates'),
          data: {
            'rates': [
              for (final entry in basePrices.entries)
                {'service_id': entry.key, 'base_price': entry.value},
            ],
          },
          options: await authHeaders(),
        );
        return _parse(response.data);
      });

  List<ProviderServiceRateModel> _parse(dynamic body) =>
      unwrapList(body).map(ProviderServiceRateModel.fromJson).toList();
}
