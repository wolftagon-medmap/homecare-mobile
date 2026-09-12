import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/etc/pricing/domain/entities/price_table.dart';
import 'package:m2health/features/etc/pricing/domain/repositories/pricing_repository.dart';

enum PriceTableStatus { initial, loading, loaded, failure }

class PriceTableState extends Equatable {
  final PriceTableStatus status;
  final PriceTable table;
  final String? error;

  const PriceTableState({
    this.status = PriceTableStatus.initial,
    this.table = PriceTable.empty,
    this.error,
  });

  @override
  List<Object?> get props => [status, table, error];
}

/// App-wide, because a price pill can appear on any service card and a widget
/// cannot await. Loaded once at startup; [PriceTable.empty] until it is, which
/// renders as no pill rather than a spinner on the home page.
class PriceTableCubit extends Cubit<PriceTableState> {
  final PricingRepository repository;

  PriceTableCubit(this.repository) : super(const PriceTableState());

  /// Read the loaded table from anywhere. Returns [PriceTable.empty] when
  /// pricing has not loaded, so callers never need a null check.
  static PriceTable of(BuildContext context) =>
      context.watch<PriceTableCubit>().state.table;

  Future<void> load({bool refresh = false}) async {
    if (state.status == PriceTableStatus.loading) return;
    emit(PriceTableState(
      status: PriceTableStatus.loading,
      table: state.table,
    ));

    final result = await repository.priceTable(refresh: refresh);
    emit(result.fold(
      (failure) => PriceTableState(
        status: PriceTableStatus.failure,
        table: state.table,
        error: failure.message,
      ),
      (table) => PriceTableState(status: PriceTableStatus.loaded, table: table),
    ));
  }
}
