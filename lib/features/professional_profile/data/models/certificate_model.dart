import 'package:m2health/features/professional_profile/domain/entities/certificate.dart';

class CertificateModel extends Certificate {
  const CertificateModel({
    required super.id,
    required super.title,
    required super.registrationNumber,
    required super.issuedOn,
    required super.fileURL,
    super.createdAt,
    super.updatedAt,
  });

  static dynamic _pick(Map<String, dynamic> json, String snake, String camel) =>
      json[snake] ?? json[camel];

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    final createdAt = _pick(json, 'created_at', 'createdAt') as String?;
    final updatedAt = _pick(json, 'updated_at', 'updatedAt') as String?;

    return CertificateModel(
      id: json['id'] ?? 0,
      title: _pick(json, 'certificate_title', 'certificateTitle') ?? '',
      registrationNumber:
          _pick(json, 'registration_number', 'registrationNumber') ?? '',
      issuedOn: _pick(json, 'issued_on', 'issuedOn') ?? '',
      fileURL: _pick(json, 'file_path', 'filePath') ?? '',
      createdAt: createdAt == null ? null : DateTime.tryParse(createdAt),
      updatedAt: updatedAt == null ? null : DateTime.tryParse(updatedAt),
    );
  }
}
