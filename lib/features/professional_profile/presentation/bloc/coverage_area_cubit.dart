import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/professional_profile/domain/entities/service_area.dart';
import 'package:m2health/features/professional_profile/domain/repositories/professional_profile_repository.dart';
import 'package:m2health/features/professional_profile/domain/usecases/index.dart';

enum CoverageAvailability { ready, countryUnknown, noAreasForCountry }

sealed class CoverageAreaState extends Equatable {
  const CoverageAreaState();

  @override
  List<Object?> get props => [];
}

class CoverageAreaLoading extends CoverageAreaState {
  const CoverageAreaLoading();
}

class CoverageAreaUnavailable extends CoverageAreaState {
  const CoverageAreaUnavailable(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class CoverageAreaReady extends CoverageAreaState {
  const CoverageAreaReady({
    required this.availability,
    required this.areas,
    required this.selectedCodes,
    required this.radiusKm,
    this.areasDirty = false,
    this.radiusDirty = false,
    this.isSaving = false,
    this.error,
  });

  final CoverageAvailability availability;
  final List<AreaOption> areas;
  final Set<String> selectedCodes;
  final int radiusKm;
  final bool areasDirty;
  final bool radiusDirty;
  final bool isSaving;
  final String? error;

  bool get isDirty => areasDirty || radiusDirty;

  List<AreaOption> get selectedAreas => [
        for (final a in areas)
          if (selectedCodes.contains(a.code)) a
      ];

  CoverageAreaReady copyWith({
    Set<String>? selectedCodes,
    int? radiusKm,
    bool? areasDirty,
    bool? radiusDirty,
    bool? isSaving,
    String? error,
  }) =>
      CoverageAreaReady(
        availability: availability,
        areas: areas,
        selectedCodes: selectedCodes ?? this.selectedCodes,
        radiusKm: radiusKm ?? this.radiusKm,
        areasDirty: areasDirty ?? this.areasDirty,
        radiusDirty: radiusDirty ?? this.radiusDirty,
        isSaving: isSaving ?? this.isSaving,
        error: error,
      );

  @override
  List<Object?> get props => [
        availability,
        areas,
        selectedCodes,
        radiusKm,
        areasDirty,
        radiusDirty,
        isSaving,
        error,
      ];
}

class ServiceAreasSaved extends CoverageAreaState {
  const ServiceAreasSaved(this.areas);

  final List<ServiceArea> areas;

  @override
  List<Object?> get props => [areas];
}

class RadiusSaved extends CoverageAreaState {
  const RadiusSaved(this.radiusKm);

  final int radiusKm;

  @override
  List<Object?> get props => [radiusKm];
}

class CoverageAreaCubit extends Cubit<CoverageAreaState> {
  CoverageAreaCubit({required this.repository, required this.updateProfile})
      : super(const CoverageAreaLoading());

  final ProfessionalProfileRepository repository;
  final UpdateProfessionalProfile updateProfile;

  static const int defaultRadiusKm = 30;

  String? _countryCode;

  Future<void> load({
    required String? countryCode,
    required List<ServiceArea> selected,
    required int? radiusKm,
  }) async {
    emit(const CoverageAreaLoading());
    _countryCode = countryCode;

    final selectedCodes = {for (final a in selected) a.code};
    final radius = radiusKm ?? defaultRadiusKm;

    if (countryCode == null || countryCode.isEmpty) {
      return emit(CoverageAreaReady(
        availability: CoverageAvailability.countryUnknown,
        areas: const [],
        selectedCodes: selectedCodes,
        radiusKm: radius,
      ));
    }

    final result = await repository.areas(countryCode);
    result.fold(
      (failure) => emit(CoverageAreaUnavailable(failure.message)),
      (areas) => emit(CoverageAreaReady(
        availability: areas.isEmpty
            ? CoverageAvailability.noAreasForCountry
            : CoverageAvailability.ready,
        areas: areas,
        selectedCodes: selectedCodes,
        radiusKm: radius,
      )),
    );
  }

  void updateSelection(Set<String> codes) {
    final current = state;
    if (current is! CoverageAreaReady) return;

    emit(current.copyWith(selectedCodes: codes, areasDirty: true));
  }

  void updateRadius(int km) {
    final current = state;
    if (current is! CoverageAreaReady) return;

    emit(current.copyWith(radiusKm: km, radiusDirty: true));
  }

  Future<void> save() async {
    final current = state;
    if (current is! CoverageAreaReady || current.isSaving) return;

    emit(current.copyWith(isSaving: true));

    var areasDirty = current.areasDirty;
    var radiusDirty = current.radiusDirty;
    final failures = <String>[];

    if (current.areasDirty && _countryCode != null) {
      final result = await repository.saveServiceAreas(
        _countryCode!,
        current.selectedCodes.toList(),
      );
      result.fold(
        (failure) => failures.add('districts (${failure.message})'),
        (saved) {
          areasDirty = false;
          emit(ServiceAreasSaved(saved));
        },
      );
    }

    if (current.radiusDirty) {
      final result = await updateProfile(UpdateProfessionalProfileParams(
        role: '',
        serviceRadiusPreference: current.radiusKm,
      ));
      result.fold(
        (failure) => failures.add('travel radius (${failure.message})'),
        (_) {
          radiusDirty = false;
          emit(RadiusSaved(current.radiusKm));
        },
      );
    }

    emit(current.copyWith(
      isSaving: false,
      areasDirty: areasDirty,
      radiusDirty: radiusDirty,
      error:
          failures.isEmpty ? null : 'Could not save ${failures.join(' and ')}',
    ));
  }
}
