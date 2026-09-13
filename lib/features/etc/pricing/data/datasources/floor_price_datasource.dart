import 'package:m2health/features/etc/pricing/data/datasources/price_table_datasource.dart';
import 'package:m2health/features/etc/pricing/data/datasources/pricing_endpoint_client.dart';
import 'package:m2health/features/etc/pricing/data/models/service_price_model.dart';
import 'package:m2health/features/etc/pricing/domain/entities/floor_price_update.dart';

abstract class FloorPriceDataSource {
  Future<List<ServicePriceModel>> all();

  Future<FloorPriceUpdate> setFloor(int serviceId, double price);
}

class FloorPriceLocalDataSource implements FloorPriceDataSource {
  final PriceTableDataSource priceTable;

  FloorPriceLocalDataSource(this.priceTable);

  final Map<int, double> _edits = {};

  @override
  Future<List<ServicePriceModel>> all() async {
    final table = await priceTable.fetch();

    return [
      for (final service in [...table.services, ...table.addOns])
        ServicePriceModel(
          id: service.id,
          code: service.code,
          name: service.name,
          category: service.category,
          subCategory: service.subCategory,
          pricingModel: service.pricingModel,
          floorPrice: _edits[service.id] ?? service.floorPrice,
        ),
    ]..sort(_byCategoryThenName);
  }

  @override
  Future<FloorPriceUpdate> setFloor(int serviceId, double price) async {
    final table = await priceTable.fetch();
    _edits[serviceId] = price;

    final lifted = table.rates
        .where((r) => r.serviceId == serviceId && r.basePrice < price)
        .length;

    return FloorPriceUpdate(services: await all(), liftedRates: lifted);
  }

  static int _byCategoryThenName(ServicePriceModel a, ServicePriceModel b) {
    final byCategory = a.category.compareTo(b.category);
    return byCategory != 0 ? byCategory : a.name.compareTo(b.name);
  }
}

class FloorPriceRemoteDataSource extends PricingEndpointClient
    implements FloorPriceDataSource {
  FloorPriceRemoteDataSource({required super.dio});

  @override
  Future<List<ServicePriceModel>> all() =>
      guard('load the standard prices', () async {
        final response = await dio.get<dynamic>(
          url('/admin/services/pricing'),
          options: await authHeaders(),
        );
        return unwrapList(response.data)
            .map(ServicePriceModel.fromJson)
            .toList();
      });

  @override
  Future<FloorPriceUpdate> setFloor(int serviceId, double price) =>
      guard('update the standard price', () async {
        final response = await dio.patch<dynamic>(
          url('/admin/services/$serviceId/price'),
          data: {'price': price},
          options: await authHeaders(),
        );
        final body = unwrap(response.data);
        return FloorPriceUpdate(
          services: (body['services'] as List<dynamic>? ?? [])
              .map((e) => ServicePriceModel.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList(),
          liftedRates: (body['lifted_rates'] as num?)?.toInt() ?? 0,
        );
      });
}
