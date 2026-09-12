import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/_legacy/booking_appointment/professional_directory/domain/usecases/get_professionals.dart';
import 'package:m2health/features/_legacy/booking_appointment/professional_directory/domain/usecases/toggle_favorite.dart';
import 'package:m2health/features/_legacy/booking_appointment/professional_directory/presentation/bloc/professional/professional_event.dart';
import 'package:m2health/features/_legacy/booking_appointment/professional_directory/presentation/bloc/professional/professional_state.dart';

class ProfessionalBloc extends Bloc<ProfessionalEvent, ProfessionalState> {
  final GetProfessionals getProfessionals;
  final ToggleFavorite toggleFavorite;

  ProfessionalBloc({
    required this.getProfessionals,
    required this.toggleFavorite,
  }) : super(ProfessionalInitial()) {
    on<GetProfessionalsEvent>((event, emit) async {
      emit(ProfessionalLoading());
      try {
        final professionals = await getProfessionals(
          role: event.role,
          name: event.name,
          serviceIds: event.serviceIds,
          isHomeScreeningAuthorized: event.isHomeScreeningAuthorized,
          serviceSubCategory: event.serviceSubCategory,
          latitude: event.latitude,
          longitude: event.longitude,
        );
        log('Fetched professionals: ${professionals.length}');
        emit(ProfessionalLoaded(professionals));
      } catch (e) {
        emit(ProfessionalError(e.toString()));
      }
    });

    on<ToggleFavoriteEvent>((event, emit) async {
      final current = state;
      if (current is! ProfessionalLoaded) return;

      // Optimistic: flip the icon immediately so a fast second tap reads the
      // just-updated value instead of racing the still-in-flight request.
      final optimistic = current.professionals
          .map((p) => p.id == event.professionalId
              ? p.copyWith(isFavorite: event.isFavorite)
              : p)
          .toList();
      emit(ProfessionalLoaded(optimistic));

      try {
        await toggleFavorite(event.professionalId, event.isFavorite);
      } catch (e) {
        log('Failed to toggle favorite: $e');
        final reverted = optimistic
            .map((p) => p.id == event.professionalId
                ? p.copyWith(isFavorite: !event.isFavorite)
                : p)
            .toList();
        emit(ProfessionalLoaded(
          reverted,
          actionError: e.toString().replaceFirst('Exception: ', ''),
        ));
      }
    });
  }
}
