import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/extensions/string_extensions.dart';
import 'package:m2health/core/presentation/widgets/country_picker_field.dart';
import 'package:m2health/features/profiles/domain/entities/profile.dart';
import 'dart:io';
import 'package:m2health/features/profiles/domain/usecases/create_profile.dart';
import 'package:m2health/features/profiles/domain/usecases/update_profile.dart';
import 'package:m2health/features/profiles/presentation/bloc/patient_profile_cubit.dart';
import 'package:m2health/features/profiles/presentation/bloc/patient_profile_state.dart';
import 'package:m2health/features/profiles/presentation/widgets/profile_switcher_sheet.dart';

/// Edits the active profile, or adds a family member when [isCreate] is set.
class EditBasicInfoPage extends StatefulWidget {
  final bool isCreate;

  const EditBasicInfoPage({super.key, this.isCreate = false});

  @override
  State<EditBasicInfoPage> createState() => _EditBasicInfoPageState();
}

class _EditBasicInfoPageState extends State<EditBasicInfoPage> {
  final _formKey = GlobalKey<FormState>();
  late Profile? profile;
  File? _selectedImage;

  late TextEditingController _nameController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late TextEditingController _phoneController;
  String? _selectedGender;
  String? _selectedCountryCode;
  DateTime? _dateOfBirth;
  String? _selectedRelation;

  final List<String> genderItems = ['Male', 'Female'];

  /// 'self' belongs to the account holder's profile, which registration creates.
  static const List<String> _relationItems = [
    'spouse',
    'parent',
    'child',
    'sibling',
    'other',
  ];

  bool get _isCreate => widget.isCreate;

  /// The account holder's own profile: its relation is fixed at 'self' and it
  /// can't be removed.
  bool get _isAccountHolder => !_isCreate && (profile?.isPrimary ?? false);

  @override
  void initState() {
    super.initState();
    // Edits whichever profile is active, not necessarily the account holder's.
    profile = _isCreate ? null : context.read<PatientProfileCubit>().activeProfile;
    _nameController = TextEditingController(text: profile?.name);
    _weightController =
        TextEditingController(text: profile?.weight?.toString());
    _heightController =
        TextEditingController(text: profile?.height?.toString());
    _phoneController = TextEditingController(text: profile?.phoneNumber);
    _selectedGender = genderItems.contains(profile?.gender?.toTitleCase())
        ? profile?.gender?.toTitleCase()
        : null;
    _selectedCountryCode = profile?.countryCode;
    _dateOfBirth = profile?.dateOfBirth;
    _selectedRelation =
        _relationItems.contains(profile?.relation) ? profile?.relation : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      final int sizeInBytes = await image.length();
      const int limitInBytes = 10 * 1024 * 1024;

      if (sizeInBytes > limitInBytes) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Selected image is too large (limit is 10MB)'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        setState(() => _selectedImage = File(image.path));
      }
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  Future<void> _selectDateOfBirth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(DateTime.now().year - 30),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Const.aqua,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _dateOfBirth = picked);
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final cubit = context.read<PatientProfileCubit>();

    if (_isCreate) {
      cubit.createProfile(CreateProfileParams(
        name: _nameController.text,
        countryCode: _selectedCountryCode!,
        dateOfBirth: _dateOfBirth!,
        gender: _selectedGender!,
        relation: _selectedRelation!,
        weight: double.tryParse(_weightController.text),
        height: double.tryParse(_heightController.text),
        phoneNumber: _phoneController.text,
        avatar: _selectedImage,
      ));
      return;
    }

    final editedProfile = profile;
    if (editedProfile == null) return;

    cubit.updateProfile(UpdateProfileParams(
      profileId: editedProfile.id,
      name: _nameController.text,
      countryCode: _selectedCountryCode,
      dateOfBirth: _dateOfBirth,
      weight: double.tryParse(_weightController.text),
      height: double.tryParse(_heightController.text),
      phoneNumber: _phoneController.text,
      gender: _selectedGender,
      // The account holder stays 'self'; sending it back would be rejected for
      // anyone else, and the dropdown is hidden for them anyway.
      relation: _isAccountHolder ? null : _selectedRelation,
      avatar: _selectedImage,
    ));
  }

  Future<void> _confirmRemove() async {
    final removedProfile = profile;
    if (removedProfile == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.profile_form_remove),
        content: Text(
            context.l10n.profile_form_remove_confirm(removedProfile.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(context.l10n.common_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              context.l10n.common_delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      context.read<PatientProfileCubit>().deleteProfile(removedProfile.id);
    }
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.l10n.profile_form_field_required;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PatientProfileCubit, PatientProfileState>(
      listener: (context, state) {
        if (state is PatientProfileSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ));
          Navigator.pop(context);
        } else if (state is PatientProfileError) {
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
                ? context.l10n.profile_form_add_title
                : context.l10n.profile_info_title,
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
                    // Deliberately not set here: on the Form it revalidates
                    // every field as soon as any one of them is touched, so
                    // typing a name would flag the fields not filled in yet.
                    // Each field opts in for itself instead.
                    child: ListView(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      children: [
                        Text(
                          context.l10n.profile_info_profile_image,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildAvatarPicker(),
                        if (_selectedImage != null)
                          Center(
                            child: TextButton(
                              onPressed: _removeImage,
                              child: Text(
                                context.l10n.profile_info_remove_image,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: _nameController,
                          validator: _requiredValidator,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: context.l10n.name,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        FormField<String>(
                          initialValue: _selectedCountryCode,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (_) => _isCreate
                              ? _requiredValidator(_selectedCountryCode)
                              : null,
                          builder: (field) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CountryPickerField(
                                value: _selectedCountryCode,
                                onChanged: (v) {
                                  setState(() => _selectedCountryCode = v);
                                  field.didChange(v);
                                },
                              ),
                              if (field.hasError)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, left: 12),
                                  child: Text(
                                    field.errorText!,
                                    style: TextStyle(
                                        color: Theme.of(context).colorScheme.error,
                                        fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildDateOfBirthField(),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String?>(
                          decoration: InputDecoration(
                            labelText: context.l10n.gender,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          dropdownColor: Colors.white,
                          items: genderItems.map((String value) {
                            return DropdownMenuItem<String?>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal),
                              ),
                            );
                          }).toList(),
                          initialValue: _selectedGender,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              _isCreate ? _requiredValidator(value) : null,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedGender = newValue;
                            });
                          },
                        ),
                        // The account holder is always 'self', so offering the
                        // dropdown would only let them mislabel themselves.
                        if (!_isAccountHolder) ...[
                          const SizedBox(height: 20),
                          _buildRelationField(),
                        ],
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _weightController,
                          decoration: InputDecoration(
                            labelText: '${context.l10n.weight} (KG)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _heightController,
                          decoration: InputDecoration(
                            labelText: '${context.l10n.height} (CM)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: context.l10n.contact_number,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        if (!_isCreate && !_isAccountHolder) ...[
                          const SizedBox(height: 28),
                          _buildRemoveButton(),
                        ],
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
              // Save button — selalu di atas keyboard
              BlocBuilder<PatientProfileCubit, PatientProfileState>(
                builder: (context, state) {
                  final isUpdating = state is PatientProfileSaving;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: ElevatedButton(
                      onPressed: isUpdating ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Const.aqua,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: isUpdating
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

  Widget _buildAvatarPicker() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              border: Border.all(color: Colors.grey.shade300, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(58),
              child: _selectedImage != null
                  ? Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                    )
                  : profile != null && profile!.avatar != null
                      ? Image.network(
                          profile!.avatar!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _avatarPlaceholder();
                          },
                        )
                      : _avatarPlaceholder(),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF40E0D0),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarPlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: const Icon(
        Icons.person,
        size: 60,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildDateOfBirthField() {
    return FormField<DateTime>(
      initialValue: _dateOfBirth,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // Existing profiles predate this field, so only a new profile has to
      // supply one — otherwise renaming yourself would demand a birth date.
      validator: (_) => _isCreate && _dateOfBirth == null
          ? context.l10n.profile_form_field_required
          : null,
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async {
              await _selectDateOfBirth();
              field.didChange(_dateOfBirth);
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: TextEditingController(
                  text: _dateOfBirth != null
                      ? DateFormat('MMM dd, yyyy').format(_dateOfBirth!)
                      : '',
                ),
                decoration: InputDecoration(
                  labelText: context.l10n.profile_form_date_of_birth,
                  suffixIcon:
                      const Icon(Icons.calendar_today, color: Const.aqua),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          if (field.hasError)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 12),
              child: Text(
                field.errorText!,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.error, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRelationField() {
    return DropdownButtonFormField<String?>(
      decoration: InputDecoration(
        labelText: context.l10n.profile_form_relationship,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      dropdownColor: Colors.white,
      items: _relationItems.map((String value) {
        return DropdownMenuItem<String?>(
          value: value,
          child: Text(
            relationLabel(context, value),
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
        );
      }).toList(),
      initialValue: _selectedRelation,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => _isCreate ? _requiredValidator(value) : null,
      onChanged: (newValue) {
        setState(() {
          _selectedRelation = newValue;
        });
      },
    );
  }

  Widget _buildRemoveButton() {
    return BlocBuilder<PatientProfileCubit, PatientProfileState>(
      builder: (context, state) {
        final isBusy = state is PatientProfileSaving;
        return OutlinedButton.icon(
          onPressed: isBusy ? null : _confirmRemove,
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          label: Text(
            context.l10n.profile_form_remove,
            style: const TextStyle(color: Colors.red),
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            side: const BorderSide(color: Colors.red),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
    );
  }
}
