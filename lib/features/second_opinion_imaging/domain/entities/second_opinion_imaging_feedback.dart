import 'package:equatable/equatable.dart';

class SecondOpinionImagingFeedback extends Equatable {
  final String? diagnosticOpinion;
  final String? recommendationOpinion;

  const SecondOpinionImagingFeedback({
    this.diagnosticOpinion,
    this.recommendationOpinion,
  });

  @override
  List<Object?> get props => [diagnosticOpinion, recommendationOpinion];
}
