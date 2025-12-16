import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/subscription/domain/entities/user_subscription_entity.dart';
import 'package:m2health/features/subscription/domain/repositories/subscription_repository.dart';

class GetUserSubscriptions {
  final SubscriptionRepository repository;

  GetUserSubscriptions(this.repository);

  Future<Either<Failure, List<UserSubscriptionEntity>>> call() async {
    return await repository.getUserSubscriptions();
  }
}
