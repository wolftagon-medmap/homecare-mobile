import 'package:m2health/features/_legacy/booking_appointment/second_opinion_imaging/domain/entities/second_opinion_imaging_feedback.dart';

class SecondOpinionImagingFeedbackModel extends SecondOpinionImagingFeedback {
  const SecondOpinionImagingFeedbackModel({
    super.diagnosticOpinion,
    super.recommendationOpinion,
  });

  factory SecondOpinionImagingFeedbackModel.fromJson(
      Map<String, dynamic> json) {
    return SecondOpinionImagingFeedbackModel(
      diagnosticOpinion: json['diagnostic_opinion'],
      recommendationOpinion: json['recommendation_opinion'],
    );
  }
}
