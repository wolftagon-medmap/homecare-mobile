import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/subscription/data/datasources/subscription_remote_data_source.dart';
import 'package:m2health/features/subscription/domain/entities/subscription_plan_entity.dart';
import 'package:m2health/features/subscription/domain/entities/user_subscription_entity.dart';
import 'package:m2health/features/subscription/domain/repositories/subscription_repository.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDataSource remoteDataSource;

  SubscriptionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<SubscriptionPlanEntity>>>
      getSubscriptionPlans() async {
    try {
      final result = await remoteDataSource.getSubscriptionPlans();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserSubscriptionEntity>>>
      getUserSubscriptions() async {
    try {
      final result = await remoteDataSource.getUserSubscriptions();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserSubscriptionEntity>> purchaseSubscription(
      int planId) async {
    try {
      final result = await remoteDataSource.purchaseSubscription(planId);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SubscriptionPlanEntity>> createSubscriptionPlan(Map<String, dynamic> body) async {
    try {
      final result = await remoteDataSource.createSubscriptionPlan(body);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SubscriptionPlanEntity>> updateSubscriptionPlan(int id, Map<String, dynamic> body) async {
    try {
      final result = await remoteDataSource.updateSubscriptionPlan(id, body);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SubscriptionPlanEntity>> toggleSubscriptionPlanActive(int id) async {
    try {
      final result = await remoteDataSource.toggleSubscriptionPlanActive(id);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
