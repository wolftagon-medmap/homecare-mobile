import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/user_profiles/domain/entities/address.dart';
import 'package:m2health/features/user_profiles/domain/repositories/address_repository.dart';
import 'package:m2health/features/user_profiles/domain/usecases/save_address.dart';

class SaveWorkplaceAddress {
  final AddressRepository repository;

  SaveWorkplaceAddress(this.repository);

  Future<Either<Failure, Address>> call(SaveAddressParams params) async {
    return await repository.saveWorkplaceAddress(params);
  }
}
