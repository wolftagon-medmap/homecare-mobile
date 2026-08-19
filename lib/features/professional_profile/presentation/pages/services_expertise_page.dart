import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/professional_profile/presentation/widgets/guidance_sheet.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/features/professional_profile/domain/entities/expertise.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/manage_services_cubit.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/professional_profile_cubit.dart';
import 'package:m2health/features/professional_profile/presentation/widgets/select_then_rate.dart';
import 'package:m2health/features/professional_profile/presentation/widgets/service_category_copy.dart';

/// Choosing what you offer and rating it are the same job, so they are one
/// screen. Turning a service on reveals its rating straight away, which is the
/// select-then-rate pattern used for languages and conditions.
class ServicesExpertisePage extends StatelessWidget {
  const ServicesExpertisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManageServicesCubit, ManageServicesState>(
      listener: (context, state) {
        if (state is ManageServicesSuccess) {
          context.read<ProfessionalProfileCubit>().applyServices(state.saved);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Services saved')),
          );
        }
        if (state is ManageServicesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final loaded = state is ManageServicesLoaded ? state : null;

        return PopScope(
          canPop: !(loaded?.isDirty ?? false),
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _confirmDiscard(context);
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Services & expertise',
                style: ProText.pageTitle,
              ),
              actions: const [
                GuidanceAction(
                  title: 'Services & expertise',
                  points: [
                    'Turn on what you offer, then rate your expertise in each.',
                    'Patients compare these levels when several professionals provide the same service.',
                    'Every visit in a category includes its listed tasks, whatever else is booked.',
                  ],
                ),
              ],
            ),
            body: switch (state) {
              ManageServicesLoading() ||
              ManageServicesInitial() ||
              ManageServicesSaving() =>
                const Center(child: CircularProgressIndicator()),
              ManageServicesError() when loaded == null =>
                const Center(child: Text('Could not load services.')),
              _ => _Catalogue(state: loaded),
            },
            bottomNavigationBar:
                loaded == null ? null : _SaveBar(state: loaded),
          ),
        );
      },
    );
  }

  Future<void> _confirmDiscard(BuildContext context) async {
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('Your services have not been saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep editing'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    if (discard == true && context.mounted) Navigator.pop(context);
  }
}

class _Catalogue extends StatelessWidget {
  const _Catalogue({required this.state});

  final ManageServicesLoaded? state;

  @override
  Widget build(BuildContext context) {
    final loaded = state;
    if (loaded == null) return const SizedBox.shrink();
    if (loaded.allServices.isEmpty) {
      return const Center(child: Text('No services available yet.'));
    }

    final selectedIds = loaded.selectedServices.map((s) => s.id).toSet();
    final byCategory =
        groupBy(loaded.allServices, (ServiceEntity s) => s.category ?? '');

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        for (final entry in byCategory.entries) ...[
          _CategoryBlock(
            category: entry.key,
            services: entry.value,
            selectedIds: selectedIds,
            proficiency: loaded.proficiency,
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }
}

class _CategoryBlock extends StatelessWidget {
  const _CategoryBlock({
    required this.category,
    required this.services,
    required this.selectedIds,
    required this.proficiency,
  });

  final String category;
  final List<ServiceEntity> services;
  final Set<int> selectedIds;
  final Map<int, int> proficiency;

  @override
  Widget build(BuildContext context) {
    final label = ServiceCategoryCopy.labels[category] ?? category;
    final scope = ServiceCategoryCopy.scope[category];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: ProText.sectionTitle,
        ),
        if (scope != null && scope.isNotEmpty) ...[
          const SizedBox(height: 6),
          _ScopeNote(tasks: scope),
        ],
        const SizedBox(height: 10),
        for (final s in services)
          _ServiceTile(
            service: s,
            selected: selectedIds.contains(s.id),
            level: proficiency[s.id] ?? 0,
          ),
      ],
    );
  }
}

class _ScopeNote extends StatelessWidget {
  const _ScopeNote({required this.tasks});

  final List<String> tasks;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 15, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Every visit includes ${tasks.join(', ').toLowerCase()}.',
              style: ProText.hint,
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
    required this.service,
    required this.selected,
    required this.level,
  });

  final ServiceEntity service;
  final bool selected;
  final int level;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ManageServicesCubit>();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color:
            selected ? Const.aqua.withValues(alpha: 0.05) : Colors.transparent,
        border: Border.all(
          color: selected
              ? Const.aqua.withValues(alpha: 0.4)
              : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _priceLabel(service),
                      style: ProText.hint,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Switch(
                value: selected,
                activeThumbColor: Const.aqua,
                onChanged: (_) => cubit.toggleService(service),
              ),
            ],
          ),
          if (selected) ...[
            const Divider(height: 18),
            Row(
              children: [
                const Text(
                  'Your expertise',
                  style: ProText.hint,
                ),
                const Spacer(),
                Text(
                  level == 0
                      ? 'Not rated'
                      : '${LevelScale.proficiency.prefix}$level · '
                          '${LevelScale.proficiency.labelFor(level)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: level == 0 ? Colors.grey.shade500 : Const.tosca,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            LevelPills(
              level: level,
              onChanged: (lvl) => cubit.setLevel(service.id, lvl),
            ),
          ],
        ],
      ),
    );
  }

  static String _priceLabel(ServiceEntity s) {
    final price = '\$${s.price.toStringAsFixed(2)}';
    return switch (s.pricingModel) {
      'hourly_rate' => '$price per hour',
      'per_package' => '$price per session',
      _ => price,
    };
  }
}

class _SaveBar extends StatelessWidget {
  const _SaveBar({required this.state});

  final ManageServicesLoaded state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: !state.isDirty
            ? null
            : () => context.read<ManageServicesCubit>().saveServices(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Const.aqua,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('Save'),
      ),
    );
  }
}
