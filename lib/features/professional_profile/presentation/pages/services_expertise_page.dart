import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/features/professional_profile/data/care_dna_catalog.dart';
import 'package:m2health/features/professional_profile/data/care_dna_store.dart';
import 'package:m2health/features/professional_profile/domain/care_dna.dart';
import 'package:m2health/features/professional_profile/presentation/widgets/select_then_rate.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/manage_services_cubit.dart';

/// Choosing what you offer and rating it are the same job, so they are one
/// screen. Turning a service on reveals its rating straight away, which is the
/// select-then-rate pattern used for languages and conditions.
///
/// Service names run long in some categories, so this is a list rather than a
/// chip grid — the name and price both need room to stay readable.
class ServicesExpertisePage extends StatelessWidget {
  const ServicesExpertisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Services & expertise',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<ManageServicesCubit, ManageServicesState>(
        listener: (context, state) {
          if (state is ManageServicesSuccess) {
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
          if (state is ManageServicesLoading ||
              state is ManageServicesInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is! ManageServicesLoaded) {
            return const Center(child: Text('Could not load services.'));
          }
          if (state.allServices.isEmpty) {
            return const Center(child: Text('No services available yet.'));
          }

          final selectedIds = state.selectedServices.map((s) => s.id).toSet();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            CareDnaStore.instance.syncServices(state.selectedServices);
          });

          final byCategory = groupBy(
            state.allServices,
            (ServiceEntity s) => s.category ?? '',
          );

          return ValueListenableBuilder<CareDnaProfile>(
            valueListenable: CareDnaStore.instance,
            builder: (context, dna, _) {
              final levels = {
                for (final t in dna.serviceExpertise) t.id: t.level,
              };

              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                      children: [
                        Text(
                          'Turn on what you offer, then rate your expertise. '
                          'Patients compare these when several professionals '
                          'provide the same service.',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 16),
                        for (final entry in byCategory.entries) ...[
                          _CategoryBlock(
                            category: entry.key,
                            services: entry.value,
                            selectedIds: selectedIds,
                            levels: levels,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ],
                    ),
                  ),
                  _SaveBar(saving: state is ManageServicesSaving),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _CategoryBlock extends StatelessWidget {
  const _CategoryBlock({
    required this.category,
    required this.services,
    required this.selectedIds,
    required this.levels,
  });

  final String category;
  final List<ServiceEntity> services;
  final Set<int> selectedIds;
  final Map<String, int> levels;

  @override
  Widget build(BuildContext context) {
    final label = CareDnaCatalog.categoryLabels[category] ?? category;
    final scope = CareDnaCatalog.serviceScope[category];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        if (scope != null && scope.isNotEmpty) ...[
          const SizedBox(height: 6),
          _ScopeNote(label: label, tasks: scope),
        ],
        const SizedBox(height: 10),
        for (final s in services)
          _ServiceTile(
            service: s,
            selected: selectedIds.contains(s.id),
            level: levels['${s.id}'] ?? 0,
          ),
      ],
    );
  }
}

/// What every visit in this category covers, whatever else is booked. Read-only
/// because it belongs to the category rather than to the professional.
class _ScopeNote extends StatelessWidget {
  const _ScopeNote({required this.label, required this.tasks});

  final String label;
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
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
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
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Switch(
                value: selected,
                activeThumbColor: Const.aqua,
                onChanged: (_) =>
                    context.read<ManageServicesCubit>().toggleService(service),
              ),
            ],
          ),
          if (selected) ...[
            const Divider(height: 18),
            Row(
              children: [
                Text(
                  'Your expertise',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
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
              onChanged: (lvl) => _setLevel(service, lvl),
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

  void _setLevel(ServiceEntity service, int level) {
    final store = CareDnaStore.instance;
    final existing = store.value.serviceExpertise;
    final has = existing.any((t) => t.id == '${service.id}');

    store.setServiceExpertise([
      if (!has)
        LeveledTag(
          id: '${service.id}',
          label: service.name,
          group: service.category,
          level: level,
        ),
      for (final t in existing)
        if (t.id == '${service.id}') t.copyWith(level: level) else t,
    ]);
  }
}

class _SaveBar extends StatelessWidget {
  const _SaveBar({required this.saving});

  final bool saving;

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
        onPressed: saving
            ? null
            : () => context.read<ManageServicesCubit>().saveServices(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Const.aqua,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: saving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : const Text('Save'),
      ),
    );
  }
}
