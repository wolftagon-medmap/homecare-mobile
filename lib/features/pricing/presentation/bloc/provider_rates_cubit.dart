import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/pricing/domain/entities/provider_service_rate.dart';
import 'package:m2health/features/pricing/domain/repositories/pricing_repository.dart';

enum ProviderRatesStatus { initial, loading, loaded, saving, failure }

class ProviderRatesState extends Equatable {
  final ProviderRatesStatus status;
  final List<ProviderServiceRate> rates;

  /// serviceId -> the text the professional has typed but not yet saved.
  final Map<int, String> drafts;

  final String? error;
  final bool justSaved;

  const ProviderRatesState({
    this.status = ProviderRatesStatus.initial,
    this.rates = const [],
    this.drafts = const {},
    this.error,
    this.justSaved = false,
  });

  ProviderRatesState copyWith({
    ProviderRatesStatus? status,
    List<ProviderServiceRate>? rates,
    Map<int, String>? drafts,
    String? error,
    bool justSaved = false,
  }) =>
      ProviderRatesState(
        status: status ?? this.status,
        rates: rates ?? this.rates,
        drafts: drafts ?? this.drafts,
        error: error,
        justSaved: justSaved,
      );

  /// Blank means "charge the standard price" and is always allowed.
  bool isValid(int serviceId) {
    final draft = drafts[serviceId];
    if (draft == null || draft.trim().isEmpty) return true;

    final parsed = double.tryParse(draft.trim());
    if (parsed == null) return false;

    final rate = rates.where((r) => r.service.id == serviceId).firstOrNull;
    return rate == null || parsed >= rate.service.floorPrice;
  }

  bool get hasChanges => drafts.isNotEmpty;

  bool get canSave =>
      hasChanges &&
      status != ProviderRatesStatus.saving &&
      drafts.keys.every(isValid);

  @override
  List<Object?> get props => [status, rates, drafts, error, justSaved];
}

class ProviderRatesCubit extends Cubit<ProviderRatesState> {
  final PricingRepository repository;

  ProviderRatesCubit(this.repository) : super(const ProviderRatesState());

  Future<void> load() async {
    emit(state.copyWith(status: ProviderRatesStatus.loading));

    final result = await repository.myRates();
    emit(result.fold(
      (failure) => state.copyWith(
        status: ProviderRatesStatus.failure,
        error: failure.message,
      ),
      (rates) => ProviderRatesState(
        status: ProviderRatesStatus.loaded,
        rates: rates,
      ),
    ));
  }

  void edit(int serviceId, String value) {
    emit(state.copyWith(drafts: {...state.drafts, serviceId: value}));
  }

  Future<void> save() async {
    if (!state.canSave) return;
    emit(state.copyWith(status: ProviderRatesStatus.saving));

    final basePrices = <int, double?>{
      for (final entry in state.drafts.entries)
        entry.key: double.tryParse(entry.value.trim()),
    };

    final result = await repository.saveMyRates(basePrices);
    emit(result.fold(
      (failure) => state.copyWith(
        status: ProviderRatesStatus.loaded,
        error: failure.message,
      ),
      (rates) => ProviderRatesState(
        status: ProviderRatesStatus.loaded,
        rates: rates,
        justSaved: true,
      ),
    ));
  }
}
