import 'package:m2health/features/pricing/data/datasources/pricing_endpoint_client.dart';
import 'package:m2health/features/pricing/data/fixtures/price_table_fixture.dart';
import 'package:m2health/features/pricing/data/models/price_table_model.dart';

abstract class PriceTableDataSource {
  Future<PriceTableModel> fetch();
}

class PriceTableLocalDataSource implements PriceTableDataSource {
  const PriceTableLocalDataSource();

  @override
  Future<PriceTableModel> fetch() async =>
      PriceTableModel.fromJson(kPriceTableFixture);
}

class PriceTableRemoteDataSource extends PricingEndpointClient
    implements PriceTableDataSource {
  PriceTableRemoteDataSource({required super.dio});

  @override
  Future<PriceTableModel> fetch() => guard('load prices', () async {
        final response = await dio.get<dynamic>(
          url('/pricing/table'),
          options: await authHeaders(),
        );
        return PriceTableModel.fromJson(unwrap(response.data));
      });
}
