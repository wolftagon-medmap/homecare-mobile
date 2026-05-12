import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/features/booking_appointment/services_selection/domain/usecases/get_services.dart';
import 'package:m2health/features/booking_appointment/services_selection/presentation/bloc/services_selection_state.dart';

class AddOnServiceCubit extends Cubit<ServicesSelectionState> {
  final GetServices getServices;

  AddOnServiceCubit(
    this.getServices, {
    List<ServiceEntity> initialSelectedServices = const [],
  }) : super(ServicesSelectionState.initial(
          selectedServices: initialSelectedServices,
        ));

  // category maps to the unified service catalog category (e.g. 'nursing', 'screening').
  // Kept as serviceType param name for backward compat with existing callers.
  Future<void> loadAddOnServices(String serviceType) async {
    emit(state.copyWith(status: ServicesSelectionStateStatus.loading));
    final result = await getServices(serviceType);
    result.fold(
      (failure) {
        log('Error loading services for category=$serviceType: $failure',
            name: 'AddOnServiceCubit');
        emit(ServicesSelectionState.error('Failed to load services'));
      },
      (services) {
        emit(state.copyWith(
          status: ServicesSelectionStateStatus.loaded,
          services: services,
        ));
      },
    );
  }

  // Alias for new code that uses the v2 category terminology.
  Future<void> loadServices(String category) => loadAddOnServices(category);

  Future<void> toggleAddOnServiceSelection(ServiceEntity service) async {
    final currentState = state;
    if (currentState.status != ServicesSelectionStateStatus.loaded) return;

    final selectedServices =
        List<ServiceEntity>.from(currentState.selectedServices);
    if (selectedServices.contains(service)) {
      selectedServices.remove(service);
    } else {
      selectedServices.add(service);
    }

    emit(currentState.copyWith(selectedServices: selectedServices));
  }
}

// Alias for new code — ServiceCatalogCubit is the v2 name for AddOnServiceCubit.
typedef ServiceCatalogCubit = AddOnServiceCubit;
