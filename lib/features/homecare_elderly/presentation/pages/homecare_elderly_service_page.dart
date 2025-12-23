import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/features/homecare_elderly/presentation/pages/homecare_package_details_page.dart';
import 'package:m2health/features/homecare_elderly/presentation/pages/house_cleaning_page.dart';
import 'package:m2health/features/homecare_elderly/presentation/pages/kitchen_bathroom_repair_page.dart';
import 'package:m2health/features/homecare_elderly/presentation/pages/living_security_page.dart';
import 'package:m2health/features/subscription/presentation/bloc/subscription_cubit.dart';
import 'package:m2health/features/subscription/presentation/bloc/subscription_state.dart';

class HomecareElderlyServicePage extends StatefulWidget {
  const HomecareElderlyServicePage({super.key});

  @override
  State<HomecareElderlyServicePage> createState() =>
      _HomecareElderlyServicePageState();
}

class _HomecareElderlyServicePageState
    extends State<HomecareElderlyServicePage> {
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
          context.l10n.homecare_elderly_title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(bottom: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubscriptionHeader(context),
              MenuCard(
                title: context.l10n.homecare_house_bedding_cleaning,
                description: context.l10n.homecare_house_bedding_cleaning_desc,
                imagePath: 'assets/illustration/house_n_bedding_cleaning.png',
                backgroundColor: const Color.fromRGBO(247, 158, 27, 0.1),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HouseCleaningPage(),
                    ),
                  );
                },
              ),
              MenuCard(
                title: context.l10n.homecare_living_security_safety,
                description: context.l10n.homecare_living_security_safety_desc,
                imagePath: 'assets/illustration/living_security_n_safety.png',
                backgroundColor: const Color.fromRGBO(178, 140, 255, 0.2),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LivingSecurityPage(),
                    ),
                  );
                },
              ),
              MenuCard(
                title: context.l10n.homecare_kitchen_bathroom_repair,
                description: context.l10n.homecare_kitchen_bathroom_repair_desc,
                imagePath: 'assets/illustration/kitchen_n_bathroom_repair.png',
                backgroundColor: const Color.fromRGBO(154, 225, 255, 0.33),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KitchenBathroomRepairPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionHeader(BuildContext context) {
    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      builder: (context, state) {
        final hasSubscription = state.hasActiveSubscription;
        final balance = state.totalBalance;
        final plans = state.plans;
        final defaultPlan = plans.isNotEmpty ? plans.first : null;
        final offerText = defaultPlan != null
            ? context.l10n.homecare_subscription_offer(
                defaultPlan.quotaAmount,
                '\$${defaultPlan.price.toStringAsFixed(2)}')
            : context.l10n.homecare_subscription_offer(12, '\$300.00');

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomecarePackageDetailsPage(),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF35C5CF), Color(0xFF2FA2AA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF35C5CF).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.card_membership,
                      color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasSubscription
                            ? context.l10n.homecare_plus_active
                            : context.l10n.homecare_get_plus,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        hasSubscription
                            ? context.l10n.homecare_balance(balance)
                            : offerText,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    color: Colors.white, size: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MenuCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final Color backgroundColor;
  final VoidCallback onTap;

  const MenuCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 240),
        padding: const EdgeInsets.all(20.0),
        color: backgroundColor,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              bottom: -16,
              right: -20,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Image.asset(
                  imagePath,
                  width: 160,
                  height: 120,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomRight,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300, // Light font weight
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: onTap,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          context.l10n.common_book_now,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF35C5CF),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Image.asset(
                          'assets/icons/ic_play.png',
                          width: 20,
                          height: 20,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
