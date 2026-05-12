import 'package:dartz/dartz.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/booking_appointment/services_selection/data/datasources/services_remote_datasource.dart';
import 'package:m2health/features/booking_appointment/services_selection/domain/repositories/services_repository.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  final ServicesRemoteDatasource remoteDataSource;

  ServicesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ServiceEntity>>> getServices(
      String serviceType) async {
    try {
      final services = await remoteDataSource.getServices(serviceType);
      return Right(services);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
