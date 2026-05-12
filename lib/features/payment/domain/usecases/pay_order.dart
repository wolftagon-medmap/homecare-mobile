import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/payment/domain/repositories/payment_repository.dart';

class PayOrder {
  final PaymentRepository repository;

  PayOrder(this.repository);

  Future<Either<Failure, Unit>> call(int orderId, String method) async {
    return await repository.payOrder(orderId, method);
  }
}
