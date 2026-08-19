import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/professional_profile/domain/entities/service_area.dart';
import 'package:m2health/features/professional_profile/domain/repositories/professional_profile_repository.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/coverage_area_cubit.dart';

class PersonalDetailsState extends Equatable {
  const PersonalDetailsState({
    this.availability = CoverageAvailability.countryUnknown,
    this.areas = const [],
    this.selectedCode,
    this.isDirty = false,
    this.isSaving = false,
    this.error,
    this.saved,
  });

  final CoverageAvailability availability;
  final List<AreaOption> areas;
  final String? selectedCode;
  final bool isDirty;
  final bool isSaving;
  final String? error;
  final ServiceArea? saved;

  AreaOption? get selectedArea {
    for (final area in areas) {
      if (area.code == selectedCode) return area;
    }
    return null;
  }

  PersonalDetailsState copyWith({
    CoverageAvailability? availability,
    List<AreaOption>? areas,
    String? selectedCode,
    bool clearSelection = false,
    bool? isDirty,
    bool? isSaving,
    String? error,
    ServiceArea? saved,
  }) =>
      PersonalDetailsState(
        availability: availability ?? this.availability,
        areas: areas ?? this.areas,
        selectedCode: clearSelection ? null : selectedCode ?? this.selectedCode,
        isDirty: isDirty ?? this.isDirty,
        isSaving: isSaving ?? this.isSaving,
        error: error,
        saved: saved,
      );

  @override
  List<Object?> get props => [
        availability,
        areas,
        selectedCode,
        isDirty,
        isSaving,
        error,
        saved,
      ];
}

class PersonalDetailsCubit extends Cubit<PersonalDetailsState> {
  PersonalDetailsCubit({required this.repository})
      : super(const PersonalDetailsState());

  final ProfessionalProfileRepository repository;

  String? _countryCode;

  Future<void> load({
    required String? countryCode,
    required ServiceArea? residentialArea,
  }) async {
    _countryCode = countryCode;

    if (countryCode == null || countryCode.isEmpty) {
      return emit(PersonalDetailsState(
        availability: CoverageAvailability.countryUnknown,
        selectedCode: residentialArea?.code,
      ));
    }

    final result = await repository.areas(countryCode);
    result.fold(
      (failure) => emit(PersonalDetailsState(
        availability: CoverageAvailability.countryUnknown,
        selectedCode: residentialArea?.code,
        error: failure.message,
      )),
      (areas) => emit(PersonalDetailsState(
        availability: areas.isEmpty
            ? CoverageAvailability.noAreasForCountry
            : CoverageAvailability.ready,
        areas: areas,
        selectedCode: residentialArea?.code,
      )),
    );
  }

  void select(String? code) => emit(state.copyWith(
        selectedCode: code,
        clearSelection: code == null,
        isDirty: true,
      ));

  Future<void> save() async {
    if (!state.isDirty || state.isSaving || _countryCode == null) return;

    emit(state.copyWith(isSaving: true));

    final result =
        await repository.saveResidentialArea(_countryCode!, state.selectedCode);
    result.fold(
      (failure) =>
          emit(state.copyWith(isSaving: false, error: failure.message)),
      (saved) => emit(state.copyWith(
        isSaving: false,
        isDirty: false,
        selectedCode: saved?.code,
        clearSelection: saved == null,
        saved: saved,
      )),
    );
  }
}
