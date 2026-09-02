import 'package:m2health/features/medical_record/domain/entities/medical_record.dart';

class FileUploadModel extends FileUpload {
  const FileUploadModel({
    required super.id,
  super.originalName,
    super.path,
    super.url,
    super.createdAt,
    super.updatedAt,
  });

  factory FileUploadModel.fromJson(Map<String, dynamic> json) {
    DateTime? tryParseDate(dynamic v) {
      if (v == null) return null;
      if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
      return null;
    }

    return FileUploadModel(
      id: json['id'] ?? 0,
  originalName: (json['originalName'] ?? json['original_name']) as String?,
      path: json['path'],
      url: json['url'],
      createdAt: tryParseDate(json['created_at']),
      updatedAt: tryParseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
  'original_name': originalName,
      'path': path,
      'url': url,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class MedicalRecordModel extends MedicalRecord {
  const MedicalRecordModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.diseaseName,
    super.diseaseHistory,
    super.symptoms,
    super.specialConsideration,
    super.treatmentInfo,
    super.fileUrl,
  super.files,
    required super.createdAt,
    required super.updatedAt,
  });

  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) {
  final filesJson = json['files'];
  final files = (filesJson is List)
    ? filesJson
      .whereType<Map<String, dynamic>>()
      .map((f) => FileUploadModel.fromJson(f))
      .toList()
    : <FileUploadModel>[];

    return MedicalRecordModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      title: json['title'] ?? '',
      diseaseName: json['disease_name'] ?? '',
      diseaseHistory: json['disease_history'],
      symptoms: json['symptoms'],
      specialConsideration: json['special_consideration'],
      treatmentInfo: json['treatment_info'],
      fileUrl: json['file_url'],
  files: files,
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'disease_name': diseaseName,
      'disease_history': diseaseHistory,
      'symptoms': symptoms,
      'special_consideration': specialConsideration,
      'treatment_info': treatmentInfo,
      'file_url': fileUrl,
      'files': files.map((f) {
        if (f is FileUploadModel) return f.toJson();
        return {
          'id': f.id,
          'path': f.path,
          'url': f.url,
          'created_at': f.createdAt?.toIso8601String(),
          'updated_at': f.updatedAt?.toIso8601String(),
        };
      }).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
