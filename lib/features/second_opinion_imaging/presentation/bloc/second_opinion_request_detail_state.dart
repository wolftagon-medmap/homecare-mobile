part of 'second_opinion_request_detail_cubit.dart';

class SecondOpinionRequestDetailState extends Equatable {
  final ActionStatus submissionStatus;
  final String? errorMessage;

  const SecondOpinionRequestDetailState({
    this.submissionStatus = ActionStatus.initial,
    this.errorMessage,
  });

  SecondOpinionRequestDetailState copyWith({
    ActionStatus? submissionStatus,
    String? errorMessage,
  }) {
    return SecondOpinionRequestDetailState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [submissionStatus, errorMessage];
}
