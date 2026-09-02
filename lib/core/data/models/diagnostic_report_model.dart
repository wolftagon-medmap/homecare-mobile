import 'package:m2health/core/domain/entities/diagnostic_report_entity.dart';

class DiagnosticReportModel extends DiagnosticReportEntity {
  const DiagnosticReportModel({
    required super.id,
    required super.type,
    required super.status,
    super.conclusion,
    super.recommendation,
    super.file,
  });

  factory DiagnosticReportModel.fromJson(Map<String, dynamic> json) {
    final fileJson = json['file'] as Map<String, dynamic>?;
    return DiagnosticReportModel(
      id: json['id'] as int,
      type: json['type'] as String? ?? '',
      status: json['status'] as String? ?? 'preliminary',
      conclusion: json['conclusion'] as String?,
      recommendation: json['recommendation'] as String?,
      file: fileJson != null
          ? DiagnosticReportFileModel.fromJson(fileJson)
          : null,
    );
  }
}

class DiagnosticReportFileModel extends DiagnosticReportFile {
  const DiagnosticReportFileModel({
    required super.id,
    required super.url,
    required super.extname,
  });

  factory DiagnosticReportFileModel.fromJson(Map<String, dynamic> json) {
    return DiagnosticReportFileModel(
      id: json['id'] as int? ?? 0,
      url: json['url'] as String? ?? '',
      extname: json['extname'] as String? ?? '',
    );
  }
}
