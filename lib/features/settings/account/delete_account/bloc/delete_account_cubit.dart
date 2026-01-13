import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/settings/account/delete_account/data/repositories/delete_account_repository.dart';
import 'delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  final DeleteAccountRepository deleteAccountRepository;

  DeleteAccountCubit({required this.deleteAccountRepository})
      : super(const DeleteAccountState());

  void selectReason(String reason) {
    emit(state.copyWith(selectedReason: reason));
  }

  void setReasonDetails(String details) {
    emit(state.copyWith(reasonDetails: details));
  }

  void setOtpCode(String otp) {
    emit(state.copyWith(otpCode: otp));
  }

  Future<void> requestOtp() async {
    emit(state.copyWith(requestOtpState: DeleteAccountActionState.loading()));
    final result = await deleteAccountRepository.requestDeleteAccountOtp();
    if (result.status == DeleteAccountResultStatus.success) {
      emit(state.copyWith(requestOtpState: DeleteAccountActionState.success()));
    } else {
      emit(state.copyWith(
          requestOtpState: DeleteAccountActionState.error(result.message)));
    }
  }

  Future<void> confirmDeleteAccount(String otp) async {
    emit(state.copyWith(confirmDeleteState: DeleteAccountActionState.loading()));
    final result = await deleteAccountRepository.confirmDeleteAccount(
      otp: otp,
      reason: state.selectedReason!,
      details: state.reasonDetails,
    );

    if (result.status == DeleteAccountResultStatus.success) {
      emit(state.copyWith(confirmDeleteState: DeleteAccountActionState.success()));
    } else {
      emit(state.copyWith(
          confirmDeleteState: DeleteAccountActionState.error(result.message)));
    }
  }
}
