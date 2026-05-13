import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/features/booking_appointment/services_selection/domain/usecases/get_services.dart';
import 'package:m2health/features/booking_appointment/services_selection/presentation/bloc/services_selection_state.dart';

class ServicesSelectionCubit extends Cubit<ServicesSelectionState> {
  final GetServices getServices;

  ServicesSelectionCubit(
    this.getServices, {
    List<ServiceEntity> initialSelectedServices = const [],
  }) : super(ServicesSelectionState.initial(
          selectedServices: initialSelectedServices,
        ));


  Future<void> loadServices({required String category, String? subCategory}) async {
    emit(state.copyWith(status: ServicesSelectionStateStatus.loading));
    final result = await getServices(category: category, subCategory: subCategory);
    result.fold(
      (failure) {
        log('Error loading services for category=$category: $failure',
            name: 'ServicesSelectionCubit');
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

// Alias for new code — ServiceCatalogCubit is the v2 name for ServicesSelectionCubit.
typedef ServiceCatalogCubit = ServicesSelectionCubit;
