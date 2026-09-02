import 'dart:io';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:m2health/features/medical_record/domain/entities/medical_record.dart';
import 'package:m2health/features/medical_record/domain/usecases/create_medical_record.dart';
import 'package:m2health/features/medical_record/domain/usecases/update_medical_record.dart';
import 'package:m2health/features/file_upload/data/datasources/file_upload_remote_data_source.dart';
import 'medical_record_form_state.dart';

class MedicalRecordFormCubit extends Cubit<MedicalRecordFormState> {
  final CreateMedicalRecord createMedicalRecord;
  final UpdateMedicalRecord updateMedicalRecord;
  final FileUploadRemoteDataSource fileUploadRemoteDataSource;

  MedicalRecordFormCubit({
    required this.createMedicalRecord,
    required this.updateMedicalRecord,
    required this.fileUploadRemoteDataSource,
  }) : super(const MedicalRecordFormState());

  static const List<String> predefinedSpecialConsiderations = [
    'Liver Disease',
    'Kidney Disease',
    'Lung Disease',
    'Aging Adult',
    'Children',
    'Pregnant',
  ];

  void initializeForm(MedicalRecord record) {
    final considerations = record.specialConsideration
            ?.split(', ')
            .where((s) => s.isNotEmpty)
            .toList() ??
        [];

    emit(state.copyWith(
      initialRecord: record,
      title: record.title,
      diseaseName: record.diseaseName,
      diseaseHistory: record.diseaseHistory ?? '',
      specialConsiderations: considerations,
      treatmentInfo: record.treatmentInfo ?? '',
  existingUploadedFileIds: record.files.map((f) => f.id).toList(),
  // uploadedFileIds is the final list that will be submitted.
  uploadedFileIds: record.files.map((f) => f.id).toList(),
    ));
  }

  void titleChanged(String value) {
    emit(state.copyWith(title: value, status: FormSubmissionStatus.initial));
  }

  void diseaseNameChanged(String value) {
    emit(state.copyWith(
        diseaseName: value, status: FormSubmissionStatus.initial));
  }

  void diseaseHistoryChanged(String value) {
    emit(state.copyWith(
        diseaseHistory: value, status: FormSubmissionStatus.initial));
  }

  void toggleSpecialConsideration(String option) {
    final currentList = List<String>.from(state.specialConsiderations);
    if (currentList.contains(option)) {
      currentList.remove(option);
    } else {
      currentList.add(option);
    }
    emit(state.copyWith(
        specialConsiderations: currentList,
        status: FormSubmissionStatus.initial));
  }

  void treatmentInfoChanged(String value) {
    emit(state.copyWith(
        treatmentInfo: value, status: FormSubmissionStatus.initial));
  }

  Future<void> addPickedFiles(List<File> files) async {
    if (files.isEmpty) return;

    emit(state.copyWith(
      fileUploadStatus: FileUploadStatus.uploading,
      fileUploadErrorMessage: null,
      status: FormSubmissionStatus.initial,
    ));

    final nextPicked = List<File>.from(state.pickedFiles);
    final nextIds = List<int>.from(state.uploadedFileIds);

    try {
      for (final f in files) {
        // Avoid duplicates by exact path match.
        if (nextPicked.any((p) => p.path == f.path)) continue;

        nextPicked.add(f);
        final id = await fileUploadRemoteDataSource.uploadFile(f.path);
        nextIds.add(id);
      }

      emit(state.copyWith(
        pickedFiles: nextPicked,
        uploadedFileIds: nextIds,
        fileUploadStatus: FileUploadStatus.idle,
      ));
    } catch (e) {
      // Surface useful HTTP error details when Dio throws.
      String message = e.toString();
      if (e is DioException) {
        final status = e.response?.statusCode;
        final body = e.response?.data;
        message = 'DioException(status: $status, body: $body)';
        log(message, name: 'MedicalRecordFormCubit');
      } else {
        log(message, name: 'MedicalRecordFormCubit');
      }
      emit(state.copyWith(
        fileUploadStatus: FileUploadStatus.failure,
        fileUploadErrorMessage: message,
      ));
    }
  }

  void removePickedFileAt(int index) {
    final nextPicked = List<File>.from(state.pickedFiles);
    final nextIds = List<int>.from(state.uploadedFileIds);

    if (index < 0 || index >= nextPicked.length) return;
    nextPicked.removeAt(index);
    if (index < nextIds.length) {
      nextIds.removeAt(index);
    }

    emit(state.copyWith(
      pickedFiles: nextPicked,
      uploadedFileIds: nextIds,
      status: FormSubmissionStatus.initial,
    ));
  }

  void removeExistingUploadedFileId(int fileId) {
    if (!state.isEditMode || state.initialRecord == null) return;

    final nextExisting = List<int>.from(state.existingUploadedFileIds)
      ..remove(fileId);
    final nextIds = List<int>.from(state.uploadedFileIds)..remove(fileId);

    emit(state.copyWith(
      existingUploadedFileIds: nextExisting,
      uploadedFileIds: nextIds,
      status: FormSubmissionStatus.initial,
    ));
  }

  Future<void> submitForm() async {
    if (!state.isFormValid) return;

  if (state.fileUploadStatus == FileUploadStatus.uploading) return;

    emit(state.copyWith(status: FormSubmissionStatus.loading));

    final considerationsString = state.specialConsiderations.join(', ');

    try {
      if (state.isEditMode) {
        final params = UpdateRecordParams(
          id: state.initialRecord!.id,
          title: state.title,
          diseaseName: state.diseaseName,
          diseaseHistory: state.diseaseHistory,
          specialConsideration: considerationsString,
          treatmentInfo: state.treatmentInfo,
          fileIds: state.uploadedFileIds,
        );
        final result = await updateMedicalRecord(params);
        result.fold(
          (failure) => emit(state.copyWith(
              status: FormSubmissionStatus.failure,
              errorMessage: failure.message)),
          (record) =>
              emit(state.copyWith(status: FormSubmissionStatus.success)),
        );
      } else {
        final params = CreateRecordParams(
          title: state.title,
          diseaseName: state.diseaseName,
          diseaseHistory: state.diseaseHistory,
          specialConsideration: considerationsString,
          treatmentInfo: state.treatmentInfo,
          fileIds: state.uploadedFileIds,
        );
        final result = await createMedicalRecord(params);
        result.fold(
          (failure) => emit(state.copyWith(
              status: FormSubmissionStatus.failure,
              errorMessage: failure.message)),
          (record) =>
              emit(state.copyWith(status: FormSubmissionStatus.success)),
        );
      }
    } catch (e) {
      emit(state.copyWith(
          status: FormSubmissionStatus.failure, errorMessage: e.toString()));
    }
  }
}
