import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/features/home_health_screening/domain/usecases/get_screening_services.dart';

// Simple state class for this cubit
class ScreeningServicesState {
  final bool isLoading;
  final List<ServiceEntity> services;
  final String? error;

  ScreeningServicesState({this.isLoading = false, this.services = const [], this.error});
}

class ScreeningServicesCubit extends Cubit<ScreeningServicesState> {
  final GetScreeningServices getScreeningServices;

  ScreeningServicesCubit(this.getScreeningServices) : super(ScreeningServicesState(isLoading: true));

  Future<void> loadServices() async {
    emit(ScreeningServicesState(isLoading: true));
    final result = await getScreeningServices();
    result.fold(
      (failure) => emit(ScreeningServicesState(isLoading: false, error: failure.message)),
      (services) => emit(ScreeningServicesState(isLoading: false, services: services)),
    );
  }
}