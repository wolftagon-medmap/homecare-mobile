import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/blocs/user_role_cubit.dart';
import 'package:m2health/features/dashboard/domain/entities/dashboard_header.dart';
import 'package:m2health/features/notifications/presentation/bloc/notifications_cubit.dart';
import 'package:m2health/features/profiles/presentation/bloc/patient_profile_cubit.dart';
import 'package:m2health/features/profiles/presentation/bloc/patient_profile_state.dart';

part 'dashboard_state.dart';

/// Derives everything the dashboard chrome needs from the cubits the app
/// already owns, so the page holds no fetching or role logic of its own.
///
/// It keeps the last resolved header, because [PatientProfileCubit] drops its
/// loaded data on every save and reload — without this the greeting and avatar
/// blank out whenever a profile is edited anywhere in the app.
class DashboardCubit extends Cubit<DashboardState> {
  final PatientProfileCubit _profiles;
  final UserRoleCubit _userRole;
  final NotificationsCubit _notifications;

  late final StreamSubscription<PatientProfileState> _profilesSub;
  late final StreamSubscription<UserRoleState> _userRoleSub;
  late final StreamSubscription<NotificationsState> _notificationsSub;

  PatientProfileState _profilesState;
  UserRoleState _userRoleState;
  NotificationsState _notificationsState;

  DashboardCubit({
    required PatientProfileCubit profiles,
    required UserRoleCubit userRole,
    required NotificationsCubit notifications,
  })  : _profiles = profiles,
        _userRole = userRole,
        _notifications = notifications,
        _profilesState = profiles.state,
        _userRoleState = userRole.state,
        _notificationsState = notifications.state,
        super(const DashboardState()) {
    _recompute();
    _profilesSub = _profiles.stream.listen((state) {
      _profilesState = state;
      _recompute();
    });
    _userRoleSub = _userRole.stream.listen((state) {
      _userRoleState = state;
      _recompute();
    });
    _notificationsSub = _notifications.stream.listen((state) {
      _notificationsState = state;
      _recompute();
    });
  }

  /// Skips the profile fetch when another screen has already loaded it.
  Future<void> load() async {
    // Deferred: BlocProvider builds this cubit mid-build, and loadProfiles
    // emits on the shared PatientProfileCubit synchronously.
    await Future<void>.microtask(() {});

    final needsProfiles = _profilesState is! PatientProfileLoaded;
    await Future.wait([
      if (needsProfiles) _profiles.loadProfiles(),
      _notifications.load(),
    ]);
  }

  Future<void> refresh() async {
    await Future.wait([
      _profiles.loadProfiles(),
      _notifications.load(),
    ]);
  }

  void _recompute() {
    emit(state.copyWith(
      header: _header(),
      headerLoading: _headerLoading(),
      headerFailed: _profilesState is PatientProfileError,
      sessionExpired: _profilesState is PatientProfileUnauthenticated,
      unreadNotifications: _unread(),
      notificationsFailed: _notificationsState is NotificationsError,
    ));
  }

  DashboardHeader _header() {
    // Admins have no family profiles, so "not a professional" is not the same
    // as "can switch profile".
    final canSwitch = _userRoleState.isPatient;
    final profiles = _profilesState;

    if (profiles is PatientProfileLoaded) {
      final active = profiles.activeProfile;
      return DashboardHeader(
        firstName: DashboardHeader.firstNameOf(active.name),
        avatarUrl: active.avatar,
        canSwitchProfile: canSwitch,
      );
    }
    return state.header.copyWith(canSwitchProfile: canSwitch);
  }

  bool _headerLoading() {
    if (_profilesState is PatientProfileLoaded) return false;
    if (_profilesState is PatientProfileError ||
        _profilesState is PatientProfileUnauthenticated) {
      return false;
    }
    return !state.header.hasName;
  }

  /// A reload emits Loading before Loaded, so the badge holds its last count
  /// rather than blinking to zero under the user's finger.
  int _unread() {
    final notifications = _notificationsState;
    if (notifications is NotificationsLoaded) return notifications.unread;
    return state.unreadNotifications;
  }

  @override
  Future<void> close() {
    _profilesSub.cancel();
    _userRoleSub.cancel();
    _notificationsSub.cancel();
    return super.close();
  }
}
