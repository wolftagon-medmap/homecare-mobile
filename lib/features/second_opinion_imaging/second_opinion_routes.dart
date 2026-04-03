import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/second_opinion_imaging/presentation/bloc/second_opinion_request_detail_cubit.dart';
import 'package:m2health/features/second_opinion_imaging/presentation/pages/second_opinion_request_detail_page.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/route/navigator_keys.dart';
import 'package:m2health/service_locator.dart';

class SecondOpinionRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      path: AppRoutes.secondOpinionRequestDetail,
      name: AppRoutes.secondOpinionRequestDetail,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final params = state.extra as SecondOpinionRequestDetailPageParams;
        return BlocProvider(
          create: (context) =>
              SecondOpinionRequestDetailCubit(repository: sl()),
          child: SecondOpinionRequestDetailPage(params: params),
        );
      },
    )
  ];
}
