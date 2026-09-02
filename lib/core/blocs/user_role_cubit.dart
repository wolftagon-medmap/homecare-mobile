import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/auth/domain/entities/user_role.dart';
import 'package:m2health/utils.dart';

class UserRoleState {
  final UserRole? role;
  UserRoleState({this.role});

  UserRoleState copyWith({UserRole? role}) {
    return UserRoleState(role: role ?? this.role);
  }

  bool get isProvider => role != null && PROFESSIONAL_ROLES.contains(role!);
  bool get isPatient => role == UserRole.patient;
  bool get isAdmin => role == UserRole.admin;
}

class UserRoleCubit extends Cubit<UserRoleState> {
  UserRoleCubit() : super(UserRoleState());

  void loadUserRole() async {
    try {
      final roleString = await Utils.getSpString(Const.ROLE);
      if (roleString == null) {
        return;
      }
      log('Loaded user role from storage: $roleString', name: 'UserRoleCubit');
      final role = UserRole.fromString(roleString);
      emit(state.copyWith(role: role));
    } catch (e) {
      log('Error loading user role', error: e, name: 'UserRoleCubit');
    }
  }

  void setUserRole(UserRole role) {
    emit(state.copyWith(role: role));
  }
}
