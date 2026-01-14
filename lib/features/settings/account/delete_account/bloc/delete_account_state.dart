import 'package:equatable/equatable.dart';

// enum DeleteAccountStep { info, reason, otp, success }

class DeleteAccountActionState extends Equatable {
  final bool isLoading;
  final String? error;
  final bool success;

  const DeleteAccountActionState({
    this.isLoading = false,
    this.error,
    this.success = false,
  });

  factory DeleteAccountActionState.initial() {
    return const DeleteAccountActionState();
  }

  factory DeleteAccountActionState.loading() {
    return const DeleteAccountActionState(isLoading: true);
  }

  factory DeleteAccountActionState.error(String? error) {
    return DeleteAccountActionState(error: error);
  }

  factory DeleteAccountActionState.success() {
    return const DeleteAccountActionState(success: true);
  }

  @override
  List<Object?> get props => [isLoading, error, success];
}

class DeleteAccountState extends Equatable {
  final DeleteAccountActionState requestOtpState;
  final DeleteAccountActionState resendOtpState;
  final DeleteAccountActionState confirmDeleteState;

  final String? selectedReason;
  final String? reasonDetails;
  final String? otpCode;

  const DeleteAccountState({
    this.requestOtpState = const DeleteAccountActionState(),
    this.resendOtpState = const DeleteAccountActionState(),
    this.confirmDeleteState = const DeleteAccountActionState(),
    this.selectedReason,
    this.reasonDetails,
    this.otpCode,
  });

  DeleteAccountState copyWith({
    DeleteAccountActionState? requestOtpState,
    DeleteAccountActionState? resendOtpState,
    DeleteAccountActionState? confirmDeleteState,
    String? selectedReason,
    String? reasonDetails,
    String? otpCode,
  }) {
    return DeleteAccountState(
      requestOtpState: requestOtpState ?? this.requestOtpState,
      resendOtpState: resendOtpState ?? this.resendOtpState,
      confirmDeleteState: confirmDeleteState ?? this.confirmDeleteState,
      selectedReason: selectedReason ?? this.selectedReason,
      reasonDetails: reasonDetails ?? this.reasonDetails,
      otpCode: otpCode ?? this.otpCode,
    );
  }

  @override
  List<Object?> get props => [
        requestOtpState,
        resendOtpState,
        confirmDeleteState,
        selectedReason,
        reasonDetails,
        otpCode,
      ];
}
