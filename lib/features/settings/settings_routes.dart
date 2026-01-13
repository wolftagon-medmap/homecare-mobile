import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/settings/account/account_settings_page.dart';
import 'package:m2health/features/settings/account/delete_account/bloc/delete_account_cubit.dart';
import 'package:m2health/features/settings/account/delete_account/pages/delete_account_info_page.dart';
import 'package:m2health/features/settings/account/delete_account/pages/delete_account_otp_page.dart';
import 'package:m2health/features/settings/account/delete_account/pages/delete_account_reason_page.dart';
import 'package:m2health/features/settings/account/delete_account/pages/delete_account_success_page.dart';
import 'package:m2health/features/settings/language/app_languages_setting.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/route/navigator_keys.dart';
import 'package:m2health/service_locator.dart';

final GlobalKey<NavigatorState> _deleteAccountKey = GlobalKey<NavigatorState>();

class SettingsRoutes {
  static List<RouteBase> routes = [
    // Account Settings
    GoRoute(
      path: AppRoutes.accountSettings,
      name: AppRoutes.accountSettings,
      builder: (context, state) {
        return const AccountSettingsPage();
      },
    ),

    // Account > Delete Account
    ShellRoute(
      parentNavigatorKey: rootNavigatorKey,
      navigatorKey: _deleteAccountKey,
      builder: (context, state, child) {
        return BlocProvider(
          create: (context) =>
              DeleteAccountCubit(deleteAccountRepository: sl()),
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: AppRoutes.deleteAccount,
          name: AppRoutes.deleteAccount,
          builder: (context, state) => const DeleteAccountInfoPage(),
        ),
        GoRoute(
          path: AppRoutes.deleteAccountReason,
          name: AppRoutes.deleteAccountReason,
          builder: (context, state) => const DeleteAccountReasonPage(),
        ),
        GoRoute(
          path: AppRoutes.deleteAccountOtp,
          name: AppRoutes.deleteAccountOtp,
          builder: (context, state) => const DeleteAccountOtpPage(),
        ),
        GoRoute(
          path: AppRoutes.deleteAccountSuccess,
          name: AppRoutes.deleteAccountSuccess,
          builder: (context, state) => const DeleteAccountSuccessPage(),
        ),
      ],
    ),

    // App Language
    GoRoute(
      path: AppRoutes.appLanguageSetting,
      name: AppRoutes.appLanguageSetting,
      builder: (context, state) {
        return const AppLanguagesSetting();
      },
    ),
  ];
}
