import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
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
          title: const Text(
            'Homecare Configuration',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Service Rates'),
              Tab(text: 'Subscription Plans'),
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
                const SnackBar(
                  content: Text('Update successful'),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state.actionStatus == AdminActionStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Update failed: ${state.actionError}'),
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
        title: Text('Edit Rate: ${service.name}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Price',
            prefixText: '\$',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
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
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return const Center(child: Text('No service rates found.'));
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
      return const Center(child: Text('No subscription plans found.'));
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
                Text(
                    'Price: \$${plan.price} | Quota: ${plan.quotaAmount}h | Validity: ${plan.validityDays}d'),
                Text(
                  plan.isActive ? 'Active' : 'Inactive',
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
          const Text('Edit Plan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Plan Name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration:
                const InputDecoration(labelText: 'Price', prefixText: '\$'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _quotaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Quota (Hours)'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _validityController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Validity (Days)'),
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
              child: const Text('Save Changes',
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
