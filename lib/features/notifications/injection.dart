import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:m2health/features/notifications/presentation/bloc/notifications_cubit.dart';

void initNotificationsModule(GetIt sl) {
  sl.registerFactory(() => NotificationsCubit(sl<Dio>()));
}
