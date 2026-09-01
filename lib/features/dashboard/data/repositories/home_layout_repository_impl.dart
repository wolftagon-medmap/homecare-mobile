import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/dashboard/data/datasources/home_layout_local_datasource.dart';
import 'package:m2health/features/dashboard/domain/entities/home_service.dart';
import 'package:m2health/features/dashboard/domain/repositories/home_layout_repository.dart';

class HomeLayoutRepositoryImpl implements HomeLayoutRepository {
  final HomeLayoutLocalDatasource localDatasource;

  HomeLayoutRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Failure, HomeServicesLayout>> getLayout() async {
    try {
      final saved = await localDatasource.read();
      return Right(saved ?? HomeServicesLayout.grid);
    } catch (e, stackTrace) {
      log('Failed to read the home layout',
          name: 'dashboard.layout', error: e, stackTrace: stackTrace);
      return const Left(ServerFailure('Could not read the saved layout'));
    }
  }

  @override
  Future<Either<Failure, Unit>> setLayout(HomeServicesLayout layout) async {
    try {
      await localDatasource.write(layout);
      return const Right(unit);
    } catch (e, stackTrace) {
      log('Failed to save the home layout',
          name: 'dashboard.layout', error: e, stackTrace: stackTrace);
      return const Left(ServerFailure('Could not save the layout'));
    }
  }
}
