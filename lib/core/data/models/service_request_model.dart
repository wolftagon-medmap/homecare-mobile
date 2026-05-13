import 'package:m2health/core/domain/entities/service_request_detail.dart';
import 'package:m2health/core/domain/entities/service_request_entity.dart';

class ServiceRequestModel extends ServiceRequestEntity {
  const ServiceRequestModel({super.id, super.status, super.detail});

  factory ServiceRequestModel.fromJson(
      Map<String, dynamic> json, String appointmentType) {
    final detail = json['detail'] as Map<String, dynamic>?;
    final status = json['status'] as String?;
    final id = json['id'] as int?;

    return ServiceRequestModel(
      id: id,
      status: status,
      detail: detail != null ? _parseDetail(detail, appointmentType) : null,
    );
  }

  static ServiceRequestDetail _parseDetail(
      Map<String, dynamic> detail, String appointmentType) {
    switch (appointmentType) {
      case 'nursing':
        return NursingDetail.fromJson(detail);
      case 'pharmacy':
        final serviceType =
            (detail['service_type'] ?? detail['serviceType']) as String?;
        if (serviceType == 'smoking_cessation') {
          return PharmacySmokingCessationDetail.fromJson(detail);
        }
        return PharmacyGeneralDetail.fromJson(detail);
      case 'screening':
        return ScreeningDetail.fromJson(detail);
      case 'homecare':
        return HomecareDetail.fromJson(detail);
      case 'physiotherapy':
        return PhysiotherapyDetail.fromJson(detail);
      case 'second_opinion_imaging':
        return SecondOpinionDetail.fromJson(detail);
      case 'nutrition':
        return NutritionDetail();
      default:
        return NutritionDetail(); // unknown type — safe no-op subtype
    }
  }
}
