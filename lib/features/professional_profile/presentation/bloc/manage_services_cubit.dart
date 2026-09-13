import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/features/_legacy/booking_appointment/nursing/const.dart';
import 'package:m2health/features/_legacy/booking_appointment/services_selection/domain/repositories/services_repository.dart';
import 'package:m2health/features/professional_profile/data/datasources/professional_profile_remote_datasource.dart';
import 'package:m2health/features/professional_profile/domain/entities/provided_services.dart';

class ManageServicesArgs {
  final String role;
  final List<ServiceEntity> currentServices;
  final Map<int, int> proficiency;
  final bool isHomeScreeningAuthorized;

  ManageServicesArgs({
    required this.role,
    required this.currentServices,
    this.proficiency = const {},
    this.isHomeScreeningAuthorized = false,
  });
}

// --- STATE ---
abstract class ManageServicesState extends Equatable {
  @override
  List<Object> get props => [];
}

class ManageServicesInitial extends ManageServicesState {}

class ManageServicesLoading extends ManageServicesState {}

class ManageServicesLoaded extends ManageServicesState {
  final List<ServiceEntity> allServices;
  final List<ServiceEntity> selectedServices;

  final Map<int, int> proficiency;
  final bool isHomeScreeningAuthorized;
  final bool isDirty;

  ManageServicesLoaded(
    this.allServices,
    this.selectedServices, {
    this.proficiency = const {},
    this.isHomeScreeningAuthorized = false,
    this.isDirty = false,
  });

  ManageServicesLoaded copyWith({
    List<ServiceEntity>? selectedServices,
    Map<int, int>? proficiency,
    bool? isHomeScreeningAuthorized,
    bool? isDirty,
  }) =>
      ManageServicesLoaded(
        allServices,
        selectedServices ?? this.selectedServices,
        proficiency: proficiency ?? this.proficiency,
        isHomeScreeningAuthorized:
            isHomeScreeningAuthorized ?? this.isHomeScreeningAuthorized,
        isDirty: isDirty ?? this.isDirty,
      );

  @override
  List<Object> get props => [
        allServices,
        selectedServices,
        proficiency,
        isHomeScreeningAuthorized,
        isDirty,
      ];
}

class ManageServicesSaving extends ManageServicesState {}

class ManageServicesSuccess extends ManageServicesState {
  final ProvidedServices saved;

  ManageServicesSuccess(this.saved);

  @override
  List<Object> get props => [saved];
}

class ManageServicesError extends ManageServicesState {
  final String message;
  ManageServicesError(this.message);
}

// --- CUBIT ---
class ManageServicesCubit extends Cubit<ManageServicesState> {
  final ProfessionalProfileRemoteDatasource professionalProfileRemoteDatasource;
  final ServicesRepository servicesRepository;
  final String role;

  ManageServicesCubit({
    required this.professionalProfileRemoteDatasource,
    required this.servicesRepository,
    required this.role,
  }) : super(ManageServicesInitial());

  Future<void> loadServices(
    List<ServiceEntity> currentServices, {
    Map<int, int> proficiency = const {},
    bool isHomeScreeningAuthorized = false,
  }) async {
    emit(ManageServicesLoading());

    try {
      List<ServiceEntity> allAvailableServices = [];

      if (role == 'nurse') {
        // Fetch Primary Nursing
        NurseServiceType primaryType = NurseServiceType.primaryNurse;
        final primaryResult = await servicesRepository.getServices(
          category: primaryType.category,
          subCategory: primaryType.subCategory,
        );
        primaryResult.fold((l) => throw Exception(l.message),
            (r) => allAvailableServices.addAll(r));

        // Fetch Specialized Nursing
        NurseServiceType specializedType = NurseServiceType.specializedNurse;
        final specializedResult = await servicesRepository.getServices(
          category: specializedType.category,
          subCategory: specializedType.subCategory,
        );
        specializedResult.fold((l) => throw Exception(l.message),
            (r) => allAvailableServices.addAll(r));
      } else {
        // For Pharmacist/Radiologist
        String serviceType = role;
        if (role == 'pharmacist') serviceType = 'pharmacy';
        if (role == 'radiologist') serviceType = 'radiology';

        final result = await servicesRepository.getServices(
          category: serviceType,
        );
        result.fold((failure) => throw Exception(failure.message),
            (services) => allAvailableServices = services);
      }

      emit(ManageServicesLoaded(
        allAvailableServices,
        currentServices,
        proficiency: proficiency,
        isHomeScreeningAuthorized: isHomeScreeningAuthorized,
      ));
    } catch (e) {
      log('Error loading services: $e');
      emit(ManageServicesError(e.toString()));
    }
  }

  void toggleService(ServiceEntity service) {
    final current = state;
    if (current is! ManageServicesLoaded) return;

    final selected = List<ServiceEntity>.from(current.selectedServices);
    final proficiency = Map<int, int>.from(current.proficiency);

    if (selected.any((s) => s.id == service.id)) {
      selected.removeWhere((s) => s.id == service.id);
      proficiency.remove(service.id);
    } else {
      selected.add(service);
    }

    emit(current.copyWith(
      selectedServices: selected,
      proficiency: proficiency,
      isDirty: true,
    ));
  }

  void toggleCategoryServices(
      List<ServiceEntity> categoryServices, bool select) {
    final current = state;
    if (current is! ManageServicesLoaded) return;

    final selected = List<ServiceEntity>.from(current.selectedServices);
    final proficiency = Map<int, int>.from(current.proficiency);

    if (select) {
      for (final service in categoryServices) {
        if (!selected.any((s) => s.id == service.id)) selected.add(service);
      }
    } else {
      final removed = categoryServices.map((s) => s.id).toSet();
      selected.removeWhere((s) => removed.contains(s.id));
      proficiency.removeWhere((id, _) => removed.contains(id));
    }

    emit(current.copyWith(
      selectedServices: selected,
      proficiency: proficiency,
      isDirty: true,
    ));
  }

  void setLevel(int serviceId, int level) {
    final current = state;
    if (current is! ManageServicesLoaded) return;

    final proficiency = Map<int, int>.from(current.proficiency);
    level <= 0 ? proficiency.remove(serviceId) : proficiency[serviceId] = level;

    emit(current.copyWith(proficiency: proficiency, isDirty: true));
  }

  void toggleHomeScreeningAuthorization(bool value) {
    final current = state;
    if (current is! ManageServicesLoaded) return;

    emit(current.copyWith(isHomeScreeningAuthorized: value, isDirty: true));
  }

  Future<void> saveServices() async {
    final current = state;
    if (current is! ManageServicesLoaded) return;

    emit(ManageServicesSaving());

    try {
      final saved =
          await professionalProfileRemoteDatasource.updateProvidedServices(
        current.selectedServices.map((s) => s.id).toList(),
        proficiency: current.proficiency,
        isHomeScreeningAuthorized:
            role == 'nurse' ? current.isHomeScreeningAuthorized : null,
      );

      emit(ManageServicesSuccess(saved));
      emit(current.copyWith(
        selectedServices: saved.services,
        proficiency: saved.proficiency,
        isDirty: false,
      ));
    } catch (e, stackTrace) {
      log('Failed to save services',
          error: e, name: 'professional.services', stackTrace: stackTrace);
      emit(ManageServicesError(e.toString()));
      emit(current);
    }
  }
}
