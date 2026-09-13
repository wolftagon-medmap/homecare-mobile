import 'package:m2health/features/etc/pricing/data/models/professional_rate_model.dart';
import 'package:m2health/features/etc/pricing/data/models/service_price_model.dart';
import 'package:m2health/features/etc/pricing/domain/entities/price_table.dart';

class PriceTableModel extends PriceTable {
  const PriceTableModel({
    super.services,
    super.addOns,
    super.rates,
    super.professionals,
  });

  factory PriceTableModel.fromJson(Map<String, dynamic> json) {
    return PriceTableModel(
      services: _list(json['services'], ServicePriceModel.fromJson),
      addOns: _list(json['add_ons'], ServicePriceModel.fromJson),
      rates: _list(json['professional_rates'], ProfessionalRateModel.fromJson),
      professionals:
          _list(json['professionals'], PricedProfessionalModel.fromJson),
    );
  }

  static List<T> _list<T>(
    dynamic raw,
    T Function(Map<String, dynamic>) parse,
  ) =>
      (raw as List<dynamic>? ?? [])
          .map((e) => parse(Map<String, dynamic>.from(e as Map)))
          .toList();
}
