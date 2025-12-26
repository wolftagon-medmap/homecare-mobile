import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/features/payment/presentation/pages/subscription_payment_page.dart';
import 'package:m2health/features/subscription/domain/entities/subscription_plan_entity.dart';
import 'package:m2health/features/subscription/domain/entities/user_subscription_entity.dart';
import 'package:m2health/features/subscription/presentation/bloc/subscription_cubit.dart';
import 'package:m2health/features/subscription/presentation/bloc/subscription_state.dart';

class HomecarePackageDetailsPage extends StatefulWidget {
  const HomecarePackageDetailsPage({super.key});

  @override
  State<HomecarePackageDetailsPage> createState() =>
      _HomecarePackageDetailsPageState();
}

class _HomecarePackageDetailsPageState
    extends State<HomecarePackageDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SubscriptionCubit>().fetchSubscriptionData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.homecare_subscription_plans_title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<SubscriptionCubit, SubscriptionState>(
        listenWhen: (prev, current) =>
            prev.purchaseStatus != current.purchaseStatus,
        listener: (context, state) {
          // Listener logic moved to SubscriptionPaymentPage, but we keep error handling here if needed
          // or just refresh data.
          if (state.purchaseStatus == SubscriptionPurchaseStatus.success) {
            // If we came back from payment page and success was emitted, we might want to refresh
            // But fetchSubscriptionData is usually enough.
          }
        },
        builder: (context, state) {
          if (state.status == SubscriptionStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.plans.isEmpty) {
            if (state.status == SubscriptionStatus.error) {
              return Center(
                  child: Text(state.errorMessage ?? 'Error loading plans'));
            }
            return Center(child: Text(context.l10n.common_no_data));
          }

          // Find active subscription if any
          UserSubscriptionEntity? activeSub;
          try {
            activeSub = state.userSubscriptions.firstWhere(
                (sub) => sub.isActive && sub.expiresAt.isAfter(DateTime.now()));
          } catch (e) {
            activeSub = null;
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: state.plans.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final plan = state.plans[index];
              return _buildPlanCard(
                context,
                plan,
                state.purchaseStatus == SubscriptionPurchaseStatus.submitting,
                activeSub,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, SubscriptionPlanEntity plan,
      bool isSubmitting, UserSubscriptionEntity? activeSub) {
    final bool hasActiveSub = activeSub != null;
    final locale = Localizations.localeOf(context).toString();
    // Assuming we only block purchase if *any* subscription is active,
    // or specifically this plan. Prompt says "when there is an active subscription".
    // We'll block if any is active for simplicity as per requirement.

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.2), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // const Icon(Icons.stars, size: 60, color: Const.aqua),
            // const SizedBox(height: 16),
            Text(
              plan.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.homecare_care_hours(plan.quotaAmount),
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            _buildFeatureRow(Icons.check_circle,
                context.l10n.homecare_valid_for_days(plan.validityDays)),
            const SizedBox(height: 12),
            _buildFeatureRow(Icons.check_circle,
                context.l10n.homecare_experienced_caregivers),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: hasActiveSub
                  ? Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Column(
                        children: [
                          Text(
                            context.l10n.homecare_active_subscription,
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.l10n.homecare_expires_on(
                                DateFormat.yMMMd(locale)
                                    .format(activeSub.expiresAt)),
                            style: TextStyle(
                              color: Colors.green[700],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SubscriptionPaymentPage(plan: plan),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Const.aqua,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        context.l10n.homecare_purchase_now(
                            '\$${plan.price.toStringAsFixed(2)}'),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Const.aqua, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
