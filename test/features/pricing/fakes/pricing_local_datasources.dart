import 'package:m2health/features/etc/pricing/data/datasources/estimate_revision_datasource.dart';
import 'package:m2health/features/etc/pricing/data/datasources/floor_price_datasource.dart';
import 'package:m2health/features/etc/pricing/data/datasources/price_table_datasource.dart';
import 'package:m2health/features/etc/pricing/data/datasources/provider_rate_datasource.dart';
import 'package:m2health/features/etc/pricing/data/models/estimate_revision_model.dart';
import 'package:m2health/features/etc/pricing/data/models/price_table_model.dart';
import 'package:m2health/features/etc/pricing/data/models/provider_service_rate_model.dart';
import 'package:m2health/features/etc/pricing/data/models/service_price_model.dart';
import 'package:m2health/features/etc/pricing/domain/entities/floor_price_update.dart';

import 'estimate_revision_fixture.dart';
import 'price_table_fixture.dart';

class PriceTableLocalDataSource implements PriceTableDataSource {
  const PriceTableLocalDataSource();

  @override
  Future<PriceTableModel> fetch() async =>
      PriceTableModel.fromJson(kPriceTableFixture);
}

/// The signed-in professional is [demoProfessionalId], because the fixture's
/// rate rows hang off its demo professionals.
class ProviderRateLocalDataSource implements ProviderRateDataSource {
  static const int demoProfessionalId = 101;

  final PriceTableDataSource priceTable;

  ProviderRateLocalDataSource(this.priceTable);

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

class EstimateRevisionLocalDataSource implements EstimateRevisionDataSource {
  EstimateRevisionLocalDataSource();

  final Map<int, String> _answers = {};

  @override
  Future<List<EstimateRevisionModel>> forCareTask(int careTaskId) async {
    final rows = kEstimateRevisionFixture[careTaskId] ?? const [];
    return rows.map(_parse).toList();
  }

  @override
  Future<EstimateRevisionModel> approve(int revisionId) =>
      _respond(revisionId, 'approved');

  @override
  Future<EstimateRevisionModel> reject(int revisionId) =>
      _respond(revisionId, 'rejected');

  Future<EstimateRevisionModel> _respond(int revisionId, String status) async {
    _answers[revisionId] = status;

    for (final rows in kEstimateRevisionFixture.values) {
      for (final row in rows) {
        if (row['id'] == revisionId) return _parse(row);
      }
    }
    throw StateError('no fixture revision $revisionId');
  }

  EstimateRevisionModel _parse(Map<String, dynamic> row) {
    final answered = _answers[row['id']];
    return EstimateRevisionModel.fromJson({
      ...row,
      if (answered != null) 'status': answered,
      if (answered != null) 'responded_at': DateTime.now().toIso8601String(),
    });
  }
}
