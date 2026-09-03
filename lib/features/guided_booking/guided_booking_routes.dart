import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_cubit.dart';
import 'package:m2health/features/guided_booking/presentation/pages/add_on_page.dart';
import 'package:m2health/features/guided_booking/presentation/pages/guided_booking_entry_page.dart';
import 'package:m2health/features/guided_booking/presentation/pages/issue_selection_page.dart';
import 'package:m2health/features/guided_booking/presentation/pages/preferred_datetime_page.dart';
import 'package:m2health/features/guided_booking/presentation/pages/professional_select_page.dart';
import 'package:m2health/features/guided_booking/presentation/pages/request_sent_page.dart';
import 'package:m2health/features/guided_booking/presentation/pages/review_and_send_page.dart';
import 'package:m2health/features/guided_booking/presentation/pages/sub_service_page.dart';
import 'package:m2health/route/app_routes.dart';

class GuidedBookingArgs {
  final String category;
  final String? subCategory;

  const GuidedBookingArgs({required this.category, this.subCategory});
}

/// Every step after the entry receives the one [GuidedBookingCubit] created
/// there — that is what makes back-and-edit work without a step refetching.
/// [returnToReview] flips a step's CTA from "push the next step" to "pop back
/// to review", so an edit link never stacks a second copy of the flow.
class GuidedBookingStepArgs {
  final GuidedBookingCubit cubit;
  final bool returnToReview;

  const GuidedBookingStepArgs(this.cubit, {this.returnToReview = false});
}

class GuidedBookingRoutes {
  static const String entry = AppRoutes.guidedBooking;

  /// The home tiles push this: the category rides in the path, so a tile stays
  /// one `route:` line with no `extra` to plumb.
  static const String categoryEntry = '/guided-booking/start/:category';

  static String entryFor(String category) => '/guided-booking/start/$category';

  static const String subService = '/guided-booking/sub-service';
  static const String issues = '/guided-booking/issues';
  static const String addOns = '/guided-booking/add-ons';
  static const String professional = '/guided-booking/professional';
  static const String dateTime = '/guided-booking/date-time';
  static const String review = '/guided-booking/review';
  static const String sent = '/guided-booking/sent';

  static List<RouteBase> routes = [
    GoRoute(
      path: entry,
      builder: (context, state) {
        final args = state.extra as GuidedBookingArgs?;
        return GuidedBookingEntryPage(
          args: args ?? const GuidedBookingArgs(category: 'pharmacy'),
        );
      },
    ),
    GoRoute(
      path: categoryEntry,
      builder: (context, state) => GuidedBookingEntryPage(
        args: GuidedBookingArgs(
          category: state.pathParameters['category'] ?? 'pharmacy',
        ),
      ),
    ),
    _step(subService, (_) => const SubServicePage()),
    _step(issues, (args) => IssueSelectionPage(args: args)),
    _step(addOns, (args) => AddOnPage(args: args)),
    _step(professional, (args) => ProfessionalSelectPage(args: args)),
    _step(dateTime, (args) => PreferredDateTimePage(args: args)),
    _step(review, (_) => const ReviewAndSendPage()),
    _step(sent, (_) => const RequestSentPage()),
  ];

  static GoRoute _step(
    String path,
    Widget Function(GuidedBookingStepArgs args) build,
  ) {
    return GoRoute(
      path: path,
      builder: (context, state) {
        final args = state.extra as GuidedBookingStepArgs;
        return BlocProvider<GuidedBookingCubit>.value(
          value: args.cubit,
          child: build(args),
        );
      },
    );
  }
}
