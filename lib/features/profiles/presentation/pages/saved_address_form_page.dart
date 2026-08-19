import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';
import 'package:m2health/features/profiles/domain/usecases/create_address.dart';
import 'package:m2health/features/profiles/domain/usecases/update_address.dart';
import 'package:m2health/features/profiles/presentation/bloc/saved_addresses_cubit.dart';
import 'package:m2health/features/profiles/presentation/bloc/saved_addresses_state.dart';
import 'package:m2health/features/profiles/presentation/pages/address_map_page.dart';

/// Adds a new saved address, or edits [existing] when provided.
class SavedAddressFormPage extends StatefulWidget {
  final Address? existing;

  const SavedAddressFormPage({super.key, this.existing});

  @override
  State<SavedAddressFormPage> createState() => _SavedAddressFormPageState();
}

class _SavedAddressFormPageState extends State<SavedAddressFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _labelController;

  /// The picked location — starts from [widget.existing] when editing, then
  /// replaced by whatever the map picker returns.
  Address? _picked;
  bool _setDefault = false;

  bool get _isCreate => widget.existing == null;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.existing?.label);
    _picked = widget.existing;
    // Already the default — there's nothing to toggle on for it.
    _setDefault = false;
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  Future<void> _pickLocation() async {
    final result = await Navigator.push<Address>(
      context,
      MaterialPageRoute(
        builder: (_) => AddressMapPage(
          initialAddress: _picked,
          pickOnly: true,
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() => _picked = result);
    }
  }

  void _submit() {
    final location = _picked;
    if (location == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.address_form_location_hint),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<SavedAddressesCubit>();

    if (_isCreate) {
      cubit.createAddress(CreateAddressParams(
        label: _labelController.text.trim(),
        latitude: location.latitude,
        longitude: location.longitude,
        googlePlaceId: location.googlePlaceId,
        name: location.name,
        formattedAddress: location.formattedAddress,
        shortFormattedAddress: location.shortFormattedAddress,
        isDefault: _setDefault,
      ));
    } else {
      cubit.updateAddress(UpdateAddressParams(
        id: widget.existing!.id,
        label: _labelController.text.trim(),
        latitude: location.latitude,
        longitude: location.longitude,
        googlePlaceId: location.googlePlaceId,
        name: location.name,
        formattedAddress: location.formattedAddress,
        shortFormattedAddress: location.shortFormattedAddress,
        isDefault: _setDefault ? true : null,
      ));
    }
  }

  Future<void> _confirmRemove() async {
    final existing = widget.existing;
    if (existing == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.address_remove),
        content: Text(context.l10n.address_remove_confirm(
            existing.label?.isNotEmpty == true
                ? existing.label!
                : existing.formattedAddress ?? '')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(context.l10n.common_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(context.l10n.common_delete,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      context.read<SavedAddressesCubit>().deleteAddress(existing.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SavedAddressesCubit, SavedAddressesState>(
      listener: (context, state) {
        if (state is SavedAddressesSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ));
          Navigator.pop(context, true);
        } else if (state is SavedAddressesError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ));
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            _isCreate
                ? context.l10n.address_form_add_title
                : context.l10n.address_form_edit_title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      children: [
                        TextFormField(
                          controller: _labelController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          // Matches the API column (varchar(32)) — caught here
                          // instead of as a 422 after the user finishes typing.
                          maxLength: 32,
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
                                  ? context.l10n.profile_form_field_required
                                  : null,
                          decoration: InputDecoration(
                            labelText: context.l10n.address_form_label,
                            hintText: context.l10n.address_form_label_hint,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          context.l10n.address_form_location,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: _pickLocation,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.map_outlined,
                                    color: Const.aqua),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _picked?.formattedAddress ??
                                        context.l10n.address_form_location_hint,
                                    style: TextStyle(
                                      color: _picked != null
                                          ? Colors.black87
                                          : Colors.grey.shade500,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.chevron_right,
                                    color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                        // Hidden once already the default: nothing to toggle
                        // on for it, and the backend always keeps one default.
                        if (widget.existing?.isDefault != true) ...[
                          const SizedBox(height: 12),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            value: _setDefault,
                            activeThumbColor: Const.aqua,
                            title: Text(
                              context.l10n.address_form_set_default,
                              style: const TextStyle(fontSize: 14),
                            ),
                            onChanged: (value) =>
                                setState(() => _setDefault = value),
                          ),
                        ],
                        if (!_isCreate) ...[
                          const SizedBox(height: 24),
                          OutlinedButton.icon(
                            onPressed: _confirmRemove,
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                            label: Text(
                              context.l10n.address_remove,
                              style: const TextStyle(color: Colors.red),
                            ),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              BlocBuilder<SavedAddressesCubit, SavedAddressesState>(
                builder: (context, state) {
                  final isSaving = state is SavedAddressesSaving;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: ElevatedButton(
                      onPressed: isSaving ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Const.aqua,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: isSaving
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : Text(
                              context.l10n.common_save,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
}
