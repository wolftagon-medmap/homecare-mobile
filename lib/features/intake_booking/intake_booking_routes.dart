import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/intake_booking/presentation/bloc/intake_cubit.dart';
import 'package:m2health/features/intake_booking/presentation/pages/intake_chat_page.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/route/navigator_keys.dart';
import 'package:m2health/service_locator.dart';

class IntakeBookingRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      path: AppRoutes.intakeBooking,
      name: AppRoutes.intakeBooking,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        return BlocProvider<IntakeCubit>(
          create: (context) => IntakeCubit(repository: sl()),
          child: const IntakeChatPage(),
        );
      },
    ),
  ];
}
