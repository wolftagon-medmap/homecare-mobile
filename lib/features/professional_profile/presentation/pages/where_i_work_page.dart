import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/professional_profile/domain/entities/service_area.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/coverage_area_cubit.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/professional_profile_cubit.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/professional_profile_state.dart';
import 'package:m2health/features/professional_profile/presentation/pages/area_picker_page.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';
import 'package:m2health/features/profiles/presentation/pages/address_map_page.dart';
import 'package:m2health/route/app_routes.dart';

/// The three location settings in one place, because splitting them across two
/// screens is what made them look like duplicates of each other.
///
/// They do different jobs and all three stay: the base address is the origin,
/// the radius scores how far a patient is from it, and the districts filter
/// which work is offered at all.
class WhereIWorkPage extends StatelessWidget {
  const WhereIWorkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoverageAreaCubit, CoverageAreaState>(
      listener: (context, state) {
        final profileCubit = context.read<ProfessionalProfileCubit>();
        switch (state) {
          case ServiceAreasSaved(:final areas):
            profileCubit.applyServiceAreas(areas);
          case RadiusSaved(:final radiusKm):
            profileCubit.applyServiceRadius(radiusKm);
          case CoverageAreaReady(:final error?):
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(error)));
          default:
            break;
        }
      },
      builder: (context, state) {
        final ready = state is CoverageAreaReady ? state : null;

        return PopScope(
          canPop: !(ready?.isDirty ?? false),
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _confirmDiscard(context);
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Coverage area',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            body: switch (state) {
              CoverageAreaLoading() =>
                const Center(child: CircularProgressIndicator()),
              CoverageAreaUnavailable(:final message) =>
                _Unavailable(message: message),
              _ => _Form(state: ready!),
            },
            bottomNavigationBar: ready == null ? null : _SaveBar(state: ready),
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
        content: const Text('Your coverage area has not been saved.'),
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

class _Form extends StatelessWidget {
  const _Form({required this.state});

  final CoverageAreaReady state;

  Future<void> _pickAddress(BuildContext context, Address? current) async {
    final result = await Navigator.push<Address>(
      context,
      MaterialPageRoute(
        builder: (_) => AddressMapPage(
          initialAddress: current,
          saveAsWorkplace: true,
        ),
      ),
    );

    if (result != null && context.mounted) {
      context.read<ProfessionalProfileCubit>().loadProfile();
    }
  }

  Future<void> _pickDistricts(BuildContext context) async {
    final cubit = context.read<CoverageAreaCubit>();
    final selection = await Navigator.push<Set<String>>(
      context,
      MaterialPageRoute(
        builder: (_) => AreaPickerPage(
          areas: state.areas,
          initialSelection: state.selectedCodes,
        ),
      ),
    );

    if (selection != null) cubit.updateSelection(selection);
  }

  @override
  Widget build(BuildContext context) {
    final profileState = context.watch<ProfessionalProfileCubit>().state;
    final address = profileState is ProfessionalProfileLoaded
        ? profileState.profile.workplaceAddress
        : null;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const _SectionTitle('Base address'),
        const _Hint('Travel distance is measured from here.'),
        const SizedBox(height: 10),
        _AddressCard(
          address: address,
          onTap: () => _pickAddress(context, address),
        ),
        const SizedBox(height: 28),
        const _SectionTitle('Travel radius'),
        const _Hint(
          'How far you will travel from your base address. Affects how you '
          'rank for nearby patients.',
        ),
        _RadiusSlider(
          km: state.radiusKm,
          onChanged: context.read<CoverageAreaCubit>().updateRadius,
        ),
        const SizedBox(height: 20),
        const _SectionTitle('Districts'),
        const _Hint(
          'Districts you accept work in. Filters which requests reach you.',
        ),
        const SizedBox(height: 12),
        switch (state.availability) {
          CoverageAvailability.countryUnknown => const _DistrictsBlocked(
              message:
                  'Set your country in Personal details before choosing districts.',
              showLink: true,
            ),
          CoverageAvailability.noAreasForCountry => const _DistrictsBlocked(
              message: 'No districts are available for your country yet.',
            ),
          CoverageAvailability.ready => _DistrictSummary(
              selected: state.selectedAreas,
              onEdit: () => _pickDistricts(context),
            ),
        },
        const SizedBox(height: 40),
      ],
    );
  }
}

class _DistrictSummary extends StatelessWidget {
  const _DistrictSummary({required this.selected, required this.onEdit});

  final List<AreaOption> selected;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selected.isEmpty)
          Text(
            'No districts chosen yet.',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final area in selected)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Const.aqua.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    area.name,
                    style: const TextStyle(fontSize: 13, color: Const.tosca),
                  ),
                ),
            ],
          ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onEdit,
          icon: const Icon(Icons.search, size: 18),
          label: Text(selected.isEmpty ? 'Choose districts' : 'Edit districts'),
        ),
      ],
    );
  }
}

class _DistrictsBlocked extends StatelessWidget {
  const _DistrictsBlocked({required this.message, this.showLink = false});

  final String message;
  final bool showLink;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ),
            ],
          ),
          if (showLink)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  final state = context.read<ProfessionalProfileCubit>().state;
                  if (state is! ProfessionalProfileLoaded) return;
                  context.push(AppRoutes.editProfessionalProfile,
                      extra: state.profile);
                },
                child: const Text('Personal details'),
              ),
            ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.address, required this.onTap});

  final Address? address;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = address == null
        ? 'Not set — tap to choose'
        : [address!.name, address!.formattedAddress]
            .where((p) => p != null && p.isNotEmpty)
            .join(', ');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on_outlined, size: 20, color: Const.aqua),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  color: address == null
                      ? Colors.grey.shade500
                      : Colors.grey.shade800,
                ),
              ),
            ),
            Icon(Icons.edit_outlined, size: 16, color: Colors.grey.shade500),
          ],
        ),
      ),
    );
  }
}

class _RadiusSlider extends StatelessWidget {
  const _RadiusSlider({required this.km, required this.onChanged});

  final int km;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text('1 km', style: TextStyle(fontSize: 12)),
            Expanded(
              child: Slider(
                value: km.toDouble(),
                min: 1,
                max: 50,
                divisions: 49,
                activeColor: Const.aqua,
                label: '$km km',
                onChanged: (v) => onChanged(v.toInt()),
              ),
            ),
            const Text('50 km', style: TextStyle(fontSize: 12)),
          ],
        ),
        Text(
          '$km km',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Const.aqua,
          ),
        ),
      ],
    );
  }
}

class _Unavailable extends StatelessWidget {
  const _Unavailable({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, size: 40, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => _reload(context),
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }

  void _reload(BuildContext context) {
    final state = context.read<ProfessionalProfileCubit>().state;
    final profile = state is ProfessionalProfileLoaded ? state.profile : null;

    context.read<CoverageAreaCubit>().load(
          countryCode: profile?.countryCode,
          selected: profile?.serviceAreas ?? const [],
          radiusKm: profile?.serviceRadiusPreference,
        );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
    );
  }
}

class _SaveBar extends StatelessWidget {
  const _SaveBar({required this.state});

  final CoverageAreaReady state;

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
        onPressed: !state.isDirty || state.isSaving
            ? null
            : () => context.read<CoverageAreaCubit>().save(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Const.aqua,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: state.isSaving
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
