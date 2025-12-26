import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/features/booking_appointment/add_on_services/domain/entities/add_on_service.dart';
import 'package:m2health/features/homecare_elderly/admin/bloc/admin_homecare_cubit.dart';
import 'package:m2health/features/homecare_elderly/admin/bloc/admin_homecare_state.dart';
import 'package:m2health/features/subscription/domain/entities/subscription_plan_entity.dart';
import 'package:m2health/service_locator.dart';

class AdminHomecareConfigurationPage extends StatelessWidget {
  const AdminHomecareConfigurationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AdminHomecareCubit>()..fetchData(),
      child: const _AdminHomecareConfigurationView(),
    );
  }
}

class _AdminHomecareConfigurationView extends StatelessWidget {
  const _AdminHomecareConfigurationView();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.l10n.profile_admin_homecare_config,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: context.l10n.admin_homecare_service_rates),
              Tab(text: context.l10n.admin_homecare_subscription_plans),
            ],
            indicatorColor: Const.tosca,
            labelColor: Const.tosca,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: BlocConsumer<AdminHomecareCubit, AdminHomecareState>(
          listenWhen: (previous, current) =>
              previous.actionStatus != current.actionStatus,
          listener: (context, state) {
            if (state.actionStatus == AdminActionStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.admin_homecare_update_successful),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state.actionStatus == AdminActionStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n
                      .admin_homecare_update_failed(state.actionError ?? '')),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return TabBarView(
              children: [
                _ServiceRatesTab(services: state.services),
                _SubscriptionPlansTab(plans: state.plans),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ServiceRatesTab extends StatelessWidget {
  final List<AddOnService> services;

  const _ServiceRatesTab({required this.services});

  void _showEditRateDialog(BuildContext context, AddOnService service) {
    // Changed to AddOnService
    final controller = TextEditingController(text: service.price.toString());
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.l10n.admin_homecare_edit_rate(service.name)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: context.l10n.admin_homecare_price,
            prefixText: '\$',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.common_cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final price = double.tryParse(controller.text);
              if (price != null) {
                context
                    .read<AdminHomecareCubit>()
                    .updateRate(service.id, price);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Const.tosca),
            child: Text(context.l10n.common_save,
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return Center(child: Text(context.l10n.admin_homecare_no_service_rates));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return Card(
          child: ListTile(
            title: Text(service.name),
            subtitle: Text('\$${service.price.toStringAsFixed(2)}'),
            trailing: const Icon(Icons.edit, color: Const.tosca),
            onTap: () => _showEditRateDialog(context, service),
          ),
        );
      },
    );
  }
}

class _SubscriptionPlansTab extends StatelessWidget {
  final List<SubscriptionPlanEntity> plans;

  const _SubscriptionPlansTab({required this.plans});

  void _showEditPlanSheet(BuildContext context, SubscriptionPlanEntity plan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<AdminHomecareCubit>(),
        child: _EditPlanSheet(plan: plan),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (plans.isEmpty) {
      return Center(
          child: Text(context.l10n.admin_homecare_no_subscription_plans));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        return Card(
          child: ListTile(
            title: Text(plan.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.admin_homecare_plan_details(
                    plan.price.toString(), plan.quotaAmount, plan.validityDays)),
                Text(
                  plan.isActive
                      ? context.l10n.admin_homecare_active
                      : context.l10n.admin_homecare_inactive,
                  style: TextStyle(
                    color: plan.isActive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            isThreeLine: true,
            trailing: Switch(
              value: plan.isActive,
              activeColor: Const.tosca,
              onChanged: (val) {
                context.read<AdminHomecareCubit>().togglePlan(plan.id);
              },
            ),
            onTap: () => _showEditPlanSheet(context, plan),
          ),
        );
      },
    );
  }
}

class _EditPlanSheet extends StatefulWidget {
  final SubscriptionPlanEntity plan;

  const _EditPlanSheet({required this.plan});

  @override
  State<_EditPlanSheet> createState() => _EditPlanSheetState();
}

class _EditPlanSheetState extends State<_EditPlanSheet> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _quotaController;
  late TextEditingController _validityController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.plan.name);
    _priceController =
        TextEditingController(text: widget.plan.price.toString());
    _quotaController =
        TextEditingController(text: widget.plan.quotaAmount.toString());
    _validityController =
        TextEditingController(text: widget.plan.validityDays.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quotaController.dispose();
    _validityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.l10n.admin_homecare_edit_plan,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: context.l10n.name),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: context.l10n.admin_homecare_price,
                prefixText: '\$'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _quotaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: context.l10n.admin_homecare_quota_hours),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _validityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: context.l10n.admin_homecare_validity_days),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final price = double.tryParse(_priceController.text);
                final quota = int.tryParse(_quotaController.text);
                final validity = int.tryParse(_validityController.text);

                if (price != null && quota != null && validity != null) {
                  context
                      .read<AdminHomecareCubit>()
                      .updatePlan(widget.plan.id, {
                    'name': _nameController.text,
                    'price': price,
                    'quota_amount': quota,
                    'validity_days': validity,
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Const.tosca,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(context.l10n.admin_homecare_save_changes,
                  style: const TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
