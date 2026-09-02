import 'package:m2health/features/pricing/data/datasources/price_table_datasource.dart';
import 'package:m2health/features/pricing/data/datasources/pricing_endpoint_client.dart';
import 'package:m2health/features/pricing/data/models/provider_service_rate_model.dart';

abstract class ProviderRateDataSource {
  Future<List<ProviderServiceRateModel>> myRates();

  /// serviceId -> price, or null to fall back to the standard price.
  Future<List<ProviderServiceRateModel>> save(Map<int, double?> basePrices);
}

/// Fixture-backed. The signed-in professional is [demoProfessionalId] because
/// the fixture's rate rows hang off the six demo professionals; the remote path
/// takes the professional from the auth token instead.
class ProviderRateLocalDataSource implements ProviderRateDataSource {
  static const int demoProfessionalId = 101;

  final PriceTableDataSource priceTable;

  ProviderRateLocalDataSource(this.priceTable);

  /// Edits survive for the session so the demo can save and come back.
  final Map<int, double?> _edits = {};

  @override
  Future<List<ProviderServiceRateModel>> myRates() async {
    final table = await priceTable.fetch();
    final pro = table.professionals
        .where((p) => p.id == demoProfessionalId)
        .firstOrNull;
    if (pro == null) return [];

    final rates = table.ratesFor(demoProfessionalId);

    return [
      for (final service in table.servicesFor(pro.category))
        ProviderServiceRateModel(
          service: service,
          basePrice: _edits.containsKey(service.id)
              ? _edits[service.id]
              : rates[service.id],
        ),
    ];
  }

  @override
  Future<List<ProviderServiceRateModel>> save(
      Map<int, double?> basePrices) async {
    _edits.addAll(basePrices);
    return myRates();
  }
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
