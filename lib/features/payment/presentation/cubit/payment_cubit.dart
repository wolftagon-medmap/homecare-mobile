import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/features/payment/domain/entities/payment.dart';
import 'package:m2health/features/payment/domain/usecases/create_payment.dart';
import 'package:m2health/features/payment/domain/usecases/pay_order.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final CreatePayment createPaymentUseCase;
  final PayOrder payOrderUseCase;

  PaymentCubit({
    required this.createPaymentUseCase,
    required this.payOrderUseCase,
  }) : super(PaymentInitial());

  // v2: pay an existing order. amount is displayed in the success dialog.
  Future<void> payOrder({
    required int orderId,
    required String method,
    required double amount,
  }) async {
    emit(PaymentLoading());
    final result = await payOrderUseCase(orderId, method);
    result.fold(
      (failure) => emit(PaymentFailure(failure.message)),
      (_) {
        final synthetic = Payment(
          id: orderId,
          userId: 0,
          appointmentId: 0,
          method: method,
          amount: amount,
          status: 'paid',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        if (method == 'CASH_OFFLINE') {
          emit(OfflinePaymentSuccess(synthetic));
        } else {
          emit(PaymentSuccess(synthetic));
        }
      },
    );
  }

  @Deprecated('Use payOrder(orderId, method, amount). TODO: delete.')
  Future<void> createPayment({
    required int appointmentId,
    required String method,
    required double amount,
  }) async {
    emit(PaymentLoading());
    final params = PaymentParams(
      appointmentId: appointmentId,
      method: method,
      amount: amount,
    );
    // ignore: deprecated_member_use
    final failureOrPayment = await createPaymentUseCase(params);

    failureOrPayment.fold(
      (failure) => emit(PaymentFailure(failure.message)),
      (payment) {
        if (payment.method == 'CASH_OFFLINE') {
          emit(OfflinePaymentSuccess(payment));
        } else {
          emit(PaymentSuccess(payment));
        }
      },
    );
  }
}
