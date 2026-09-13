import 'package:m2health/features/etc/pricing/domain/entities/estimate.dart';

class EstimateLineModel extends EstimateLine {
  const EstimateLineModel({
    required super.code,
    required super.label,
    required super.unitPrice,
    required super.kind,
    super.quantity,
  });

  factory EstimateLineModel.fromJson(Map<String, dynamic> json) {
    return EstimateLineModel(
      code: json['code'] as String? ?? '',
      label: json['label'] as String? ?? '',
      unitPrice: double.parse((json['unit_price'] ?? 0).toString()),
      quantity: double.parse((json['quantity'] ?? 1).toString()),
      kind: json['kind'] == 'add_on'
          ? EstimateLineKind.addOn
          : EstimateLineKind.base,
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'label': label,
        'unit_price': unitPrice,
        'quantity': quantity,
        'amount': amount,
        'kind': kind == EstimateLineKind.addOn ? 'add_on' : 'base',
      };
}

class EstimateModel extends Estimate {
  const EstimateModel({required super.lines});

  factory EstimateModel.fromJson(Map<String, dynamic> json) {
    return EstimateModel(
      lines: (json['lines'] as List<dynamic>? ?? [])
          .map((e) => EstimateLineModel.fromJson(Map<String, dynamic>.from(
                e as Map,
              )))
          .toList(),
    );
  }

  static Map<String, dynamic> toJsonOf(Estimate estimate) => {
        'lines': [
          for (final line in estimate.lines)
            EstimateLineModel(
              code: line.code,
              label: line.label,
              unitPrice: line.unitPrice,
              quantity: line.quantity,
              kind: line.kind,
            ).toJson(),
        ],
        'total': estimate.total,
      };
}
