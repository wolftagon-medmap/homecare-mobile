import 'package:equatable/equatable.dart';

class DiagnosticReportEntity extends Equatable {
  final int id;
  // screening | second_opinion_imaging | lab (auto-inferred from appointment type)
  final String type;
  // preliminary | final | amended
  final String status;
  final String? conclusion;
  final String? recommendation;
  final DiagnosticReportFile? file;

  const DiagnosticReportEntity({
    required this.id,
    required this.type,
    required this.status,
    this.conclusion,
    this.recommendation,
    this.file,
  });

  @override
  List<Object?> get props =>
      [id, type, status, conclusion, recommendation, file];
}

class DiagnosticReportFile extends Equatable {
  final int id;
  final String url;
  final String extname;

  const DiagnosticReportFile({
    required this.id,
    required this.url,
    required this.extname,
  });

  @override
  List<Object?> get props => [id, url, extname];
}
