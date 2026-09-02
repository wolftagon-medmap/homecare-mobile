import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/dashboard/domain/entities/home_service.dart';
import 'package:m2health/features/dashboard/domain/usecases/index.dart';

part 'home_services_state.dart';

/// Owns the grid/list choice while the client compares the two layouts.
class HomeServicesCubit extends Cubit<HomeServicesState> {
  final GetHomeLayout getHomeLayout;
  final SetHomeLayout setHomeLayout;

  HomeServicesCubit({
    required this.getHomeLayout,
    required this.setHomeLayout,
  }) : super(const HomeServicesState());

  Future<void> restore() async {
    final result = await getHomeLayout();
    result.fold(
      (failure) => log('Keeping the default layout: ${failure.message}',
          name: 'dashboard.layout'),
      (layout) => emit(HomeServicesState(layout: layout)),
    );
  }

  /// Flips first, persists after, so a write failure costs the preference on
  /// next launch rather than the interaction.
  Future<void> toggle() async {
    final next = state.layout == HomeServicesLayout.grid
        ? HomeServicesLayout.list
        : HomeServicesLayout.grid;
    emit(HomeServicesState(layout: next));

    final result = await setHomeLayout(next);
    result.fold(
      (failure) => log('Layout not persisted: ${failure.message}',
          name: 'dashboard.layout'),
      (_) {},
    );
  }
}
