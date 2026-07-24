import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';
import 'package:m2health/features/profiles/domain/repositories/address_repository.dart';

class GetAddresses {
  final AddressRepository repository;

  GetAddresses(this.repository);

  Future<Either<Failure, List<Address>>> call() async {
    return await repository.getAddresses();
  }
}
