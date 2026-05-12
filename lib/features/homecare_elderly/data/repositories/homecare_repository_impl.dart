import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/homecare_elderly/data/datasources/homecare_remote_data_source.dart';
import 'package:m2health/features/homecare_elderly/domain/repositories/homecare_repository.dart';

class HomecareRepositoryImpl implements HomecareRepository {
  final HomecareRemoteDataSource remoteDataSource;

  HomecareRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ServiceEntity>>> getHomecareRates() async {
    try {
      final result = await remoteDataSource.getHomecareRates();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ServiceEntity>> updateHomecareRate(int id, double price) async {
    try {
      final result = await remoteDataSource.updateHomecareRate(id, price);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
