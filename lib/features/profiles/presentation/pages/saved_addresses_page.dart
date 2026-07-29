import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';
import 'package:m2health/features/profiles/presentation/bloc/saved_addresses_cubit.dart';
import 'package:m2health/features/profiles/presentation/bloc/saved_addresses_state.dart';
import 'package:m2health/route/app_routes.dart';

class SavedAddressesPage extends StatefulWidget {
  const SavedAddressesPage({super.key});

  @override
  State<SavedAddressesPage> createState() => _SavedAddressesPageState();
}

class _SavedAddressesPageState extends State<SavedAddressesPage> {
  @override
  void initState() {
    super.initState();
    context.read<SavedAddressesCubit>().loadAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.settings_saved_addresses,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<SavedAddressesCubit, SavedAddressesState>(
        listener: (context, state) {
          if (state is SavedAddressesError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ));
          }
        },
        builder: (context, state) {
          if (state is SavedAddressesLoading ||
              state is SavedAddressesInitial ||
              state is SavedAddressesSaving) {
            return const Center(child: CircularProgressIndicator());
          }

          final addresses = state is SavedAddressesLoaded
              ? state.addresses
              : const <Address>[];

          return RefreshIndicator(
            onRefresh: () async {
              context.read<SavedAddressesCubit>().loadAddresses();
            },
            child: addresses.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(32),
                    children: [
                      const SizedBox(height: 80),
                      Icon(Icons.location_off_outlined,
                          size: 56, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        context.l10n.address_empty_state,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  )
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: addresses.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) =>
                        _AddressCard(address: addresses[index]),
                  ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Const.aqua,
        onPressed: () async {
          await context.push<bool>(AppRoutes.savedAddressForm);
          if (context.mounted) {
            context.read<SavedAddressesCubit>().loadAddresses();
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final Address address;

  const _AddressCard({required this.address});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.grey.withValues(alpha: 0.2),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        // Without this, a 1-line vs 2-line subtitle centers the leading/trailing
        // icons at different heights row to row, so they stop lining up down the list.
        titleAlignment: ListTileTitleAlignment.top,
        leading: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(
            address.isDefault ? Icons.star : Icons.location_on_outlined,
            color: address.isDefault ? Colors.amber.shade700 : Const.aqua,
          ),
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(
                address.label?.isNotEmpty == true
                    ? address.label!
                    : context.l10n.address_form_label,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (address.isDefault) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Const.aqua.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  context.l10n.address_default_badge,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Const.aqua,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            address.formattedAddress ?? '${address.latitude}, ${address.longitude}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
        ),
        // Matches the leading icon's top offset — IconButton's own padding
        // would otherwise sit lower than the plain Icon used for "is default".
        trailing: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: !address.isDefault
              ? IconButton(
                  icon: const Icon(Icons.radio_button_unchecked, size: 20),
                  tooltip: context.l10n.address_form_set_default,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    context.read<SavedAddressesCubit>().setDefaultAddress(address.id);
                  },
                )
              : const Icon(Icons.check_circle, color: Const.aqua, size: 20),
        ),
        onTap: () async {
          await context.push<bool>(AppRoutes.savedAddressForm, extra: address);
          if (context.mounted) {
            context.read<SavedAddressesCubit>().loadAddresses();
          }
        },
      ),
    );
  }
}
