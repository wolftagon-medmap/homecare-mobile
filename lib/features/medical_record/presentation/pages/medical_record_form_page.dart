import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/medical_record/domain/entities/medical_record.dart';
import 'package:m2health/features/medical_record/presentation/bloc/form/medical_record_form_cubit.dart';
import 'package:m2health/features/medical_record/presentation/bloc/form/medical_record_form_state.dart';
import 'package:m2health/features/medical_record/presentation/bloc/medical_record_bloc.dart';
import 'package:m2health/features/medical_record/presentation/bloc/medical_record_event.dart';
import 'package:m2health/service_locator.dart';

class MedicalRecordFormPage extends StatelessWidget {
  final MedicalRecord? recordToEdit;

  const MedicalRecordFormPage({super.key, this.recordToEdit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = MedicalRecordFormCubit(
          createMedicalRecord: sl(),
          updateMedicalRecord: sl(),
          fileUploadRemoteDataSource: sl(),
        );
        if (recordToEdit != null) {
          cubit.initializeForm(recordToEdit!);
        }
        return cubit;
      },
      child: MedicalRecordFormView(
        isEditMode: recordToEdit != null,
      ),
    );
  }
}

class MedicalRecordFormView extends StatelessWidget {
  final bool isEditMode;
  const MedicalRecordFormView({super.key, required this.isEditMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          isEditMode ? 'Edit Medical Record' : 'Add New Medical Record',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: BlocConsumer<MedicalRecordFormCubit, MedicalRecordFormState>(
        listener: (context, state) {
          if (state.status == FormSubmissionStatus.success) {
            context.read<MedicalRecordBloc>().add(FetchMedicalRecords());
            Navigator.of(context).pop();
          } else if (state.status == FormSubmissionStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(state.errorMessage ?? 'Submission Failed'),
                ),
              );
          }
        },
        builder: (context, state) {
          if (state.status == FormSubmissionStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return _FormBody(isEditMode: isEditMode);
        },
      ),
      bottomNavigationBar: _KeyboardAwareBottomBar(
        child: _SubmitButton(isEditMode: isEditMode),
      ),
    );
  }
}

/// Keeps the bottom bar (e.g., Submit button) visible by moving it above the keyboard.
/// This mirrors the behavior users expect from the Profile Information page.
class _KeyboardAwareBottomBar extends StatelessWidget {
  final Widget child;
  const _KeyboardAwareBottomBar({required this.child});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: child,
      ),
    );
  }
}

class _FormBody extends StatelessWidget {
  final bool isEditMode;
  const _FormBody({required this.isEditMode});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Patient Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _TitleInput(
              initialValue: isEditMode
                  ? context.read<MedicalRecordFormCubit>().state.title
                  : null),
          const SizedBox(height: 16),
          _DiseaseNameInput(
              initialValue: isEditMode
                  ? context.read<MedicalRecordFormCubit>().state.diseaseName
                  : null),
          const SizedBox(height: 16),
          _DiseaseHistoryInput(
              initialValue: isEditMode
                  ? context.read<MedicalRecordFormCubit>().state.diseaseHistory
                  : null),
          const SizedBox(height: 24),
          const _FieldLabel('Patient with Special Consideration'),
          _SpecialConsiderationCheckboxes(),
          const SizedBox(height: 24),
          // NOTE: Treatment Info disabled, need to confirm with PM
          // const Text(
          //   'Treatment Information',
          //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          // ),
          // const SizedBox(height: 16),
          // _TreatmentInfoInput(
          //     initialValue: isEditMode
          //         ? context.read<MedicalRecordFormCubit>().state.treatmentInfo
          //         : null),
          // const SizedBox(height: 24),
          _FilePicker(),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _TitleInput extends StatelessWidget {
  final String? initialValue;
  const _TitleInput({this.initialValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('Title *'),
        TextFormField(
          initialValue: initialValue,
          decoration: const InputDecoration(
            hintText: 'e.g. Annual Checkup',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) =>
              context.read<MedicalRecordFormCubit>().titleChanged(value),
        ),
      ],
    );
  }
}

class _DiseaseNameInput extends StatelessWidget {
  final String? initialValue;
  const _DiseaseNameInput({this.initialValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('Disease Name *'),
        TextFormField(
          initialValue: initialValue,
          decoration: const InputDecoration(
            hintText: 'e.g. Diphtheria, Pneumonia, etc.',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) =>
              context.read<MedicalRecordFormCubit>().diseaseNameChanged(value),
        ),
      ],
    );
  }
}

class _DiseaseHistoryInput extends StatelessWidget {
  final String? initialValue;
  const _DiseaseHistoryInput({this.initialValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('Disease History Description *'),
        TextFormField(
          initialValue: initialValue,
          decoration: const InputDecoration(
            hintText: 'Write your disease history here...',
            border: OutlineInputBorder(),
          ),
          minLines: 3,
          maxLines: 10,
          onChanged: (value) => context
              .read<MedicalRecordFormCubit>()
              .diseaseHistoryChanged(value),
        ),
      ],
    );
  }
}

class _SpecialConsiderationCheckboxes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicalRecordFormCubit, MedicalRecordFormState>(
      builder: (context, state) {
        return Wrap(
          spacing: 8.0,
          runSpacing: 0.0,
          children: MedicalRecordFormCubit.predefinedSpecialConsiderations
              .map((option) {
            return SizedBox(
              width: (MediaQuery.of(context).size.width / 2) - 24,
              child: CheckboxListTile(
                title: Text(option),
                value: state.specialConsiderations.contains(option),
                onChanged: (bool? value) {
                  context
                      .read<MedicalRecordFormCubit>()
                      .toggleSpecialConsideration(option);
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                activeColor: Const.aqua,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _TreatmentInfoInput extends StatelessWidget {
  final String? initialValue;
  const _TreatmentInfoInput({this.initialValue});

  @override
  Widget build(BuildContext context) {
    // --- CHANGED ---
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('Treatment Info'),
        TextFormField(
          initialValue: initialValue,
          decoration: const InputDecoration(
            hintText: 'Describe treatment plan...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          onChanged: (value) => context
              .read<MedicalRecordFormCubit>()
              .treatmentInfoChanged(value),
        ),
      ],
    );
  }
}

class _FilePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('Medical Report Files'),
        BlocBuilder<MedicalRecordFormCubit, MedicalRecordFormState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.isEditMode && state.initialRecord != null)
                  _ExistingFilesList(
                    record: state.initialRecord!,
                    visibleIds: state.existingUploadedFileIds,
                  ),

                OutlinedButton.icon(
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Pick Files'),
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf', 'jpg', 'png'],
                      allowMultiple: true,
                    );
                    if (!context.mounted) {
                      log('Context not mounted after file picker',
                          name: 'MedicalRecordFormPage');
                      return;
                    }
                    final paths = result?.paths.whereType<String>().toList() ??
                        const <String>[];
                    if (paths.isEmpty) return;

                    await context.read<MedicalRecordFormCubit>().addPickedFiles(
                          paths.map((p) => File(p)).toList(),
                        );
                  },
                ),

                if (state.fileUploadStatus == FileUploadStatus.uploading)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 8),
                        Text('Uploading...'),
                      ],
                    ),
                  ),
                if (state.fileUploadStatus == FileUploadStatus.failure)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      state.fileUploadErrorMessage ?? 'Upload failed',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                if (state.pickedFiles.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'New files (will be added)',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        ...List.generate(state.pickedFiles.length, (index) {
                          final file = state.pickedFiles[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    p.basename(file.path),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => context
                                      .read<MedicalRecordFormCubit>()
                                      .removePickedFileAt(index),
                                  icon: const Icon(Icons.close),
                                ),
                              ],
                            ),
                          );
                        }),
                        Text('Total: ${state.pickedFiles.length} file(s)'),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ExistingFilesList extends StatelessWidget {
  final MedicalRecord record;
  final List<int> visibleIds;
  const _ExistingFilesList({required this.record, required this.visibleIds});

  @override
  Widget build(BuildContext context) {
  final files = record.files.where((f) => visibleIds.contains(f.id)).toList();
    if (files.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Existing files',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          ...files.map((f) {
            final displayName = _displayNameForExistingFile(f);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Remove this file',
                    onPressed: () => context
                        .read<MedicalRecordFormCubit>()
                        .removeExistingUploadedFileId(f.id),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String _displayNameForExistingFile(dynamic f) {
    // `f` is a domain `FileUpload` (from entity). It has `path` and `url`.
  final originalName = (f as FileUpload).originalName;
  if (originalName != null && originalName.trim().isNotEmpty) return originalName;

  final url = (f as FileUpload).url;
  final path = (f as FileUpload).path;
    final value = (url is String && url.isNotEmpty)
        ? url
        : (path is String && path.isNotEmpty)
            ? path
      : 'File #${(f as FileUpload).id}';

    final cleaned = value.split('?').first;
    return p.basename(cleaned);
  }
}

class _SubmitButton extends StatelessWidget {
  final bool isEditMode;
  const _SubmitButton({required this.isEditMode});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicalRecordFormCubit, MedicalRecordFormState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Const.aqua,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: state.isFormValid
                ? () => context.read<MedicalRecordFormCubit>().submitForm()
                : null,
            child: Text(
              state.status == FormSubmissionStatus.loading
                  ? 'Submitting...'
                  : (isEditMode ? 'Update' : 'Submit'),
            ),
          ),
        );
      },
    );
  }
}
