import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/professional_profile/data/care_dna_catalog.dart';
import 'package:m2health/features/professional_profile/data/care_dna_store.dart';
import 'package:m2health/features/professional_profile/domain/care_dna.dart';
import 'package:m2health/features/professional_profile/presentation/widgets/select_then_rate.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';
import 'package:m2health/features/professional_profile/domain/usecases/update_professional_profile.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/professional_profile_cubit.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/professional_profile_state.dart';
import 'package:m2health/features/profiles/presentation/pages/address_map_page.dart';

/// The three location settings in one place, because splitting them across two
/// screens is what made them look like duplicates of each other.
///
/// They do different jobs and all three stay: the base address is the origin,
/// the radius scores how far a patient is from it, and the districts filter
/// which work is offered at all.
class WhereIWorkPage extends StatefulWidget {
  const WhereIWorkPage({super.key});

  @override
  State<WhereIWorkPage> createState() => _WhereIWorkPageState();
}

class _WhereIWorkPageState extends State<WhereIWorkPage> {
  int? _radiusKm;
  bool _radiusDirty = false;

  Future<void> _pickAddress(Address? current) async {
    final result = await Navigator.push<Address>(
      context,
      MaterialPageRoute(
        builder: (_) => AddressMapPage(
          initialAddress: current,
          saveAsWorkplace: true,
        ),
      ),
    );

    if (result != null && mounted) {
      context.read<ProfessionalProfileCubit>().loadProfile();
    }
  }

  void _saveRadius() {
    final cubit = context.read<ProfessionalProfileCubit>();
    if (cubit.state is! ProfessionalProfileLoaded || _radiusKm == null) return;

    // The cubit supplies the real role; this field is ignored, matching how the
    // edit-profile screen calls it.
    cubit.updateProfessionalProfile(
      UpdateProfessionalProfileParams(
        role: '',
        serviceRadiusPreference: _radiusKm,
      ),
    );
    setState(() => _radiusDirty = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Coverage area',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<ProfessionalProfileCubit, ProfessionalProfileState>(
        listener: (context, state) {
          if (state is ProfessionalProfileLoaded) {
            _radiusKm ??= state.profile.serviceRadiusPreference ?? 30;
          }
        },
        builder: (context, state) {
          if (state is ProfessionalProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile =
              state is ProfessionalProfileLoaded ? state.profile : null;
          final address = profile?.workplaceAddress;
          _radiusKm ??= profile?.serviceRadiusPreference ?? 30;

          return ValueListenableBuilder<CareDnaProfile>(
            valueListenable: CareDnaStore.instance,
            builder: (context, dna, _) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const _SectionTitle('Base address'),
                  const _Hint('Travel distance is measured from here.'),
                  const SizedBox(height: 10),
                  _AddressCard(
                    address: address,
                    onTap: () => _pickAddress(address),
                  ),
                  const SizedBox(height: 28),
                  const _SectionTitle('Travel radius'),
                  const _Hint(
                    'How far you will travel from your base address. Affects how '
                    'you rank for nearby patients.',
                  ),
                  _RadiusSlider(
                    km: _radiusKm!,
                    onChanged: (v) => setState(() {
                      _radiusKm = v;
                      _radiusDirty = true;
                    }),
                  ),
                  if (_radiusDirty)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: state is ProfessionalProfileSaving
                            ? null
                            : _saveRadius,
                        child: const Text('Save radius'),
                      ),
                    ),
                  const SizedBox(height: 20),
                  const _SectionTitle('Districts'),
                  const _Hint(
                    'Districts you accept work in. Filters which requests reach you.',
                  ),
                  const SizedBox(height: 12),
                  TagMultiSelect(
                    options: _districtOptions(),
                    selectedCodes: dna.serviceAreas.toSet(),
                    onChanged: (codes) =>
                        CareDnaStore.instance.setServiceAreas(codes.toList()),
                  ),
                  const SizedBox(height: 40),
                ],
              );
            },
          );
        },
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

// Temporary. Districts are still hardcoded labels held in CareDnaStore; F6
// replaces this screen with the searchable picker over the real areas.
List<TagOption> _districtOptions() => [
      for (final name in CareDnaCatalog.serviceAreas)
        TagOption(code: name, label: name),
    ];
