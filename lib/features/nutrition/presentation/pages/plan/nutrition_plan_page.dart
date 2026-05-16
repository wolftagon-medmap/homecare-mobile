import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/blocs/user_role_cubit.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/presentation/widgets/buttons/primary_button.dart';
import 'package:m2health/features/nutrition/presentation/bloc/nutrition_plan_cubit.dart';
import 'package:m2health/features/nutrition/presentation/pages/plan/weekly_meal_plan_page.dart';
import 'package:m2health/route/app_routes.dart';

class NutritionPlanPage extends StatefulWidget {
  final int? appointmentId;
  const NutritionPlanPage({super.key, this.appointmentId});

  @override
  State<NutritionPlanPage> createState() => _NutritionPlanPageState();
}

class _NutritionPlanPageState extends State<NutritionPlanPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<NutritionPlanCubit>()
        .loadNutritionPlan(knownAppointmentId: widget.appointmentId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NutritionPlanCubit, NutritionPlanState>(
      builder: (context, state) {
        // Loading
        if (state.status == NutritionPlanStatus.loading ||
            state.status == NutritionPlanStatus.initial) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        // No nutrition appointment booked yet
        if (state.status == NutritionPlanStatus.noAppointment) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: _NoAppointmentView(
              onBook: () => context.push(AppRoutes.nutritionBooking),
            ),
          );
        }

        // Appointment exists but plan not yet submitted by nutritionist
        if (state.status == NutritionPlanStatus.notFound) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: BlocBuilder<UserRoleCubit, UserRoleState>(
              builder: (context, state) {
                return _PlanPendingView(isProvider: state.isProvider);
              },
            ),
          );
        }

        // Error
        if (state.status == NutritionPlanStatus.failure) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage ?? 'Something went wrong.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context
                          .read<NutritionPlanCubit>()
                          .loadNutritionPlan(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Success — full plan view
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: BlocBuilder<UserRoleCubit, UserRoleState>(
                builder: (context, state) {
                  final text = state.isProvider
                      ? 'Nutrition Plan for Client'
                      : context.l10n.precision_plan_my_plan;
                  return Text(
                    text,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  );
                },
              ),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => GoRouter.of(context).pop(),
              ),
              bottom: TabBar(
                indicatorColor: Const.aqua,
                labelColor: Const.aqua,
                labelStyle: const TextStyle(fontSize: 16),
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: [
                  Tab(text: context.l10n.precision_plan_tab_dietary),
                  Tab(text: context.l10n.precision_plan_tab_supplements),
                  Tab(text: context.l10n.precision_plan_tab_lifestyle),
                ],
              ),
            ),
            body: const TabBarView(
              children: [
                _DietaryPlanView(),
                _SupplementsView(),
                _LifestyleView(),
              ],
            ),
            bottomNavigationBar: BlocBuilder<UserRoleCubit, UserRoleState>(
              builder: (context, state) {
                if (state.isProvider) return const SizedBox.shrink();

                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: PrimaryButton(
                    text: context.l10n.precision_plan_request_update,
                    onPressed: () {},
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: BlocBuilder<UserRoleCubit, UserRoleState>(
        builder: (context, state) {
          final text = state.isProvider
              ? 'Nutrition Plan for Client'
              : context.l10n.precision_plan_my_plan;
          return Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          );
        },
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => GoRouter.of(context).pop(),
      ),
    );
  }
}

// --- No appointment booked yet ---

class _NoAppointmentView extends StatelessWidget {
  final VoidCallback onBook;
  const _NoAppointmentView({required this.onBook});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/illustration/planning.png',
            height: 180,
          ),
          const SizedBox(height: 32),
          const Text(
            'No Consultation Booked',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            'Book a consultation with a nutritionist to receive your personalised nutrition plan.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: onBook,
            style: ElevatedButton.styleFrom(
              backgroundColor: Const.aqua,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Book Consultation'),
          ),
        ],
      ),
    );
  }
}

// --- Plan not yet submitted by nutritionist ---

class _PlanPendingView extends StatelessWidget {
  final bool isProvider;
  const _PlanPendingView({this.isProvider = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/illustration/planning.png',
            height: 180,
          ),
          const SizedBox(height: 32),
          Text(
            isProvider
                ? 'Plan Not Yet Submitted'
                : 'Your Plan Is Being Prepared',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            isProvider
                ? 'No nutrition plan has been submitted for this appointment yet. Go back and use "Submit Nutrition Plan" to create one.'
                : 'Your nutritionist is reviewing your assessment and will submit your personalised nutrition plan soon.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          OutlinedButton(
            onPressed: () => GoRouter.of(context).pop(),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              side: const BorderSide(color: Const.aqua),
              foregroundColor: Const.aqua,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }
}

// --- Dietary Plan Tab ---

class _DietaryPlanView extends StatelessWidget {
  const _DietaryPlanView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NutritionPlanCubit>().state;
    final plan = state.nutritionPlan?.dietaryPlan;

    log('Building DietaryPlanView with plan: ${plan?.toString() ?? "null"}');

    if (plan == null) return const SizedBox.shrink();

    const purple = Color(0xFF5782F1);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: purple),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.precision_plan_goal,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: purple,
                        ),
                      ),
                      Text(plan.goal),
                      const SizedBox(height: 8),
                      Text(context.l10n.precision_plan_strategy,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: purple,
                          )),
                      Text(plan.strategy),
                      const SizedBox(height: 8),
                      Text(context.l10n.precision_plan_daily_calory,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: purple,
                          )),
                      Text('${plan.dailyCaloryTarget} kcal'),
                    ],
                  ),
                ),
                Image.asset('assets/images/ilu_nutrition_diet.webp',
                    width: 160, height: 160),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(context.l10n.precision_plan_recommended_foods,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...plan.recommendedFoods
              .map((food) => _InfoCard(text: food, isRecommended: true)),
          const SizedBox(height: 24),
          Text(context.l10n.precision_plan_foods_to_limit,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...plan.foodsToLimit
              .map((food) => _InfoCard(text: food, isRecommended: false)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.l10n.precision_plan_weekly_meal_plan,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                  onPressed: () {
                    GoRouter.of(context).pushNamed(AppRoutes.weeklyMealPlan);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Const.aqua,
                    textStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  child: Text(context.l10n.precision_plan_view_all)),
            ],
          ),
          SizedBox(
            height: 160,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: state.nutritionPlan!.weeklyMealPlan.keys
                  .toList()
                  .asMap()
                  .entries
                  .map((entry) {
                final index = entry.key;
                final day = entry.value;
                return _DayCard(day: day, index: index);
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

// --- Supplements Tab ---

class _SupplementsView extends StatelessWidget {
  const _SupplementsView();

  @override
  Widget build(BuildContext context) {
    final supplements =
        context.watch<NutritionPlanCubit>().state.nutritionPlan?.supplements;
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: supplements?.length ?? 0,
      itemBuilder: (context, index) {
        final supplement = supplements![index];
        return _InfoCard(
          text: supplement.name,
          subtext: supplement.dosage,
          isRecommended: true,
        );
      },
    );
  }
}

// --- Lifestyle Tab ---

class _LifestyleView extends StatelessWidget {
  const _LifestyleView();

  @override
  Widget build(BuildContext context) {
    final adjustments = context
        .watch<NutritionPlanCubit>()
        .state
        .nutritionPlan
        ?.lifestyleAdjustments;
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: adjustments?.length ?? 0,
      itemBuilder: (context, index) {
        final adjustment = adjustments![index];
        return _InfoCard(
          text: adjustment.title,
          subtext: adjustment.description,
          isRecommended: true,
        );
      },
    );
  }
}

// --- Shared Widgets ---

class _InfoCard extends StatelessWidget {
  final String text;
  final String? subtext;
  final bool isRecommended;

  const _InfoCard(
      {required this.text, this.subtext, required this.isRecommended});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
                if (subtext != null) ...[
                  const SizedBox(height: 2),
                  Text(subtext!,
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ]
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(2),
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color:
                  isRecommended ? Colors.green.shade200 : Colors.red.shade200,
              shape: BoxShape.circle,
            ),
          )
        ],
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  final String day;
  final int index;
  const _DayCard({required this.day, required this.index});

  String _getLocalDayName(BuildContext context, String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return context.l10n.day_monday;
      case 'tuesday':
        return context.l10n.day_tuesday;
      case 'wednesday':
        return context.l10n.day_wednesday;
      case 'thursday':
        return context.l10n.day_thursday;
      case 'friday':
        return context.l10n.day_friday;
      case 'saturday':
        return context.l10n.day_saturday;
      case 'sunday':
        return context.l10n.day_sunday;
      default:
        return day;
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = weeklyFoodImagePaths[index % weeklyFoodImagePaths.length];
    return GestureDetector(
      onTap: () => GoRouter.of(context).pushNamed(
        AppRoutes.weeklyMealPlanDetail,
        queryParameters: {'day': day},
      ),
      child: Container(
        width: 240,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.4), BlendMode.darken))),
        child: Center(
          child: Text(
            _getLocalDayName(context, day).toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
      ),
    );
  }
}
