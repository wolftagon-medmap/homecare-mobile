import 'package:equatable/equatable.dart';

class FileUpload extends Equatable {
  final int id;
  final String? originalName;
  final String? path;
  final String? url;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FileUpload({
    required this.id,
  this.originalName,
    this.path,
    this.url,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, originalName, path, url, createdAt, updatedAt];
}

class MedicalRecord extends Equatable {
  final int id;
  final int userId;
  final String title;
  final String diseaseName;
  final String? diseaseHistory;
  final String? symptoms;
  final String? specialConsideration;
  final String? treatmentInfo;
  // Legacy single-file field (kept for backward compatibility with older API responses)
  final String? fileUrl;
  // New multi-file attachments
  final List<FileUpload> files;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MedicalRecord({
    required this.id,
    required this.userId,
    required this.title,
    required this.diseaseName,
    this.diseaseHistory,
    this.symptoms,
    this.specialConsideration,
    this.treatmentInfo,
    this.fileUrl,
  this.files = const <FileUpload>[],
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        diseaseName,
        diseaseHistory,
        symptoms,
        specialConsideration,
        treatmentInfo,
        fileUrl,
  files,
        createdAt,
        updatedAt,
      ];
}
