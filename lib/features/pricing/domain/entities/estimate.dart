import 'package:equatable/equatable.dart';

enum EstimateLineKind { base, addOn }

/// One row of the breakdown. [unitPrice] is what is charged per unit — the
/// professional's base price for a base line, the admin's flat price for an
/// add-on. [quantity] is hours for an hourly service and 1 otherwise.
class EstimateLine extends Equatable {
  final String code;
  final String label;
  final double unitPrice;
  final double quantity;
  final EstimateLineKind kind;

  const EstimateLine({
    required this.code,
    required this.label,
    required this.unitPrice,
    required this.kind,
    this.quantity = 1,
  });

  double get amount => unitPrice * quantity;

  bool get isHourly => kind == EstimateLineKind.base && quantity != 1;

  @override
  List<Object?> get props => [code, label, unitPrice, quantity, kind];
}

/// The result of the one estimate calculation. Never a bill: money changes
/// hands at the visit and no payment is modelled anywhere.
class Estimate extends Equatable {
  final List<EstimateLine> lines;

  const Estimate({required this.lines});

  static const Estimate empty = Estimate(lines: []);

  double get total =>
      lines.fold<double>(0, (running, line) => running + line.amount);

  Iterable<EstimateLine> get baseLines =>
      lines.where((line) => line.kind == EstimateLineKind.base);

  Iterable<EstimateLine> get addOnLines =>
      lines.where((line) => line.kind == EstimateLineKind.addOn);

  @override
  List<Object?> get props => [lines];
}
