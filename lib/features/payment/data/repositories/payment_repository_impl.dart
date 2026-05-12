import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/payment/data/datasources/payment_remote_data_source.dart';
import 'package:m2health/features/payment/domain/entities/payment.dart';
import 'package:m2health/features/payment/domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Unit>> payOrder(int orderId, String method) async {
    try {
      await remoteDataSource.payOrder(orderId, method);
      return const Right(unit);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  @Deprecated('Use payOrder(orderId, method). TODO: delete.')
  Future<Either<Failure, Payment>> createPayment({
    required int appointmentId,
    required String method,
    required double amount,
  }) async {
    try {
      // ignore: deprecated_member_use
      final payment = await remoteDataSource.createPayment(
        appointmentId: appointmentId,
        method: method,
        amount: amount,
      );
      return Right(payment);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
