import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/booking_appointment/add_on_services/domain/entities/add_on_service.dart';
import 'package:m2health/features/booking_appointment/add_on_services/domain/usecases/get_add_on_services.dart';
import 'package:m2health/features/booking_appointment/add_on_services/presentation/bloc/add_on_service_state.dart';

class AddOnServiceCubit extends Cubit<AddOnServiceState> {
  final GetAddOnServices getAddOnServices;

  AddOnServiceCubit(
    this.getAddOnServices, {
    // ignore: deprecated_member_use
    List<AddOnService> initialSelectedServices = const [],
  }) : super(AddOnServiceState.initial(
          selectedServices: initialSelectedServices,
        ));

  // category maps to the unified service catalog category (e.g. 'nursing', 'screening').
  // Kept as serviceType param name for backward compat with existing callers.
  Future<void> loadAddOnServices(String serviceType) async {
    emit(state.copyWith(status: AddOnServiceStateStatus.loading));
    final result = await getAddOnServices(serviceType);
    result.fold(
      (failure) {
        log('Error loading services for category=$serviceType: $failure',
            name: 'AddOnServiceCubit');
        emit(AddOnServiceState.error('Failed to load services'));
      },
      (services) {
        emit(state.copyWith(
          status: AddOnServiceStateStatus.loaded,
          addOnServices: services,
        ));
      },
    );
  }

  // Alias for new code that uses the v2 category terminology.
  Future<void> loadServices(String category) => loadAddOnServices(category);

  // ignore: deprecated_member_use
  Future<void> toggleAddOnServiceSelection(AddOnService service) async {
    final currentState = state;
    if (currentState.status != AddOnServiceStateStatus.loaded) return;

    // ignore: deprecated_member_use
    final selectedServices =
        // ignore: deprecated_member_use
        List<AddOnService>.from(currentState.selectedAddOnServices);
    if (selectedServices.contains(service)) {
      selectedServices.remove(service);
    } else {
      selectedServices.add(service);
    }

    emit(currentState.copyWith(selectedAddOnServices: selectedServices));
  }
}

// Alias for new code — ServiceCatalogCubit is the v2 name for AddOnServiceCubit.
typedef ServiceCatalogCubit = AddOnServiceCubit;
