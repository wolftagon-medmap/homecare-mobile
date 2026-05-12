import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/payment/domain/entities/payment.dart';

abstract class PaymentRepository {
  // v2: pay an existing order.
  Future<Either<Failure, Unit>> payOrder(int orderId, String method);

  @Deprecated('Use payOrder(orderId, method). TODO: delete.')
  Future<Either<Failure, Payment>> createPayment({
    required int appointmentId,
    required String method,
    required double amount,
  });
}
