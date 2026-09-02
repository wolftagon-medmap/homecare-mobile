import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';
import 'package:m2health/features/profiles/domain/repositories/address_repository.dart';

class SetDefaultAddress {
  final AddressRepository repository;

  SetDefaultAddress(this.repository);

  Future<Either<Failure, Address>> call(int id) async {
    return await repository.setDefaultAddress(id);
  }
}
