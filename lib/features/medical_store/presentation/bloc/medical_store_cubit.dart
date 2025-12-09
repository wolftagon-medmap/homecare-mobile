import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/medical_store/presentation/bloc/medical_store_state.dart';
import 'package:m2health/features/medical_store/domain/entity/medical_store.dart';

class MedicalStoreCubit extends Cubit<MedicalStoreState> {
  final Dio dio;
  static const int _limit = 20;

  MedicalStoreCubit({required this.dio}) : super(const MedicalStoreState());

  Future<void> getProductByCategory(MedicalStoreProductCategory category,
      {bool isRefresh = false}) async {
    if (state.hasReachedMax && !isRefresh) return;

    log('Is refresh: $isRefresh', name: 'MedicalStoreCubit');

    try {
      if (state.products.isEmpty || isRefresh) {
        emit(state.copyWith(
          status: MedicalStoreStatus.loading,
          page: 1,
          hasReachedMax: false,
          errorMessage: '',
          products: isRefresh ? [] : state.products,
        ));
      }

      final page = isRefresh ? 1 : state.page + 1;
      final params = {
        'category': category == MedicalStoreProductCategory.consumables
            ? 'medical-consumeables'
            : 'poct',
        'page': page,
        'limit': _limit,
      };

      final response =
          await dio.get(Const.API_MEDICAL_STORE, queryParameters: params);

      final newProducts = (response.data['data'] as List)
          .map((e) => MedicalStoreProduct.fromJson(e))
          .toList();

      log('Loaded ${newProducts.length} products for category $category on page $page',
          name: 'MedicalStoreCubit');

      final hasReachedMax = newProducts.length < _limit;
      final allProducts = isRefresh
          ? newProducts
          : (List.of(state.products)..addAll(newProducts));

      emit(state.copyWith(
        status: MedicalStoreStatus.success,
        products: allProducts,
        hasReachedMax: hasReachedMax,
        page: page,
      ));
    } on DioException catch (e) {
      log('Dio error loading products: ${e.message}', error: e);
      emit(state.copyWith(
        status: MedicalStoreStatus.failure,
        errorMessage: 'Failed to load products: ${e.message}',
      ));
    } catch (e) {
      log('Error loading products', error: e);
      emit(state.copyWith(
        status: MedicalStoreStatus.failure,
        errorMessage: 'Failed to load products',
      ));
    }
  }

  Future<void> getDummyProductsByCategory(MedicalStoreProductCategory category,
      {bool isRefresh = false}) async {
    if (state.hasReachedMax && !isRefresh) return;

    if (state.products.isEmpty || isRefresh) {
      emit(state.copyWith(
          status: MedicalStoreStatus.loading,
          products: isRefresh ? [] : state.products));
    }

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final List<MedicalStoreProduct> homecareConsumeables = [
      MedicalStoreProduct(
        id: 1,
        name: 'Disposable 3 pty class 1',
        imageUrl: 'assets/images/store_mask.png',
        isLocalImage: true,
        description: 'Disposable 3 pty class 1',
        price: 35.0,
      ),
      MedicalStoreProduct(
        id: 2,
        name: 'Syringe',
        imageUrl: 'assets/images/store_syringe.png',
        isLocalImage: true,
        description: 'Syringe',
        price: 10.0,
      ),
      MedicalStoreProduct(
        id: 3,
        name: 'SwiftGrip Disposable',
        imageUrl: 'assets/images/store_glove.png',
        isLocalImage: true,
        description: 'SwiftGrip Disposable',
        price: 15.0,
      ),
      MedicalStoreProduct(
        id: 4,
        name: 'B-Type (10 L) Oxygen',
        imageUrl: 'assets/images/store_oxygen.png',
        isLocalImage: true,
        description: 'B-Type (10 L) Oxygen',
        price: 50.0,
      ),
      MedicalStoreProduct(
        id: 5,
        name: 'Blood Glucose Meter',
        imageUrl: 'assets/images/store_blood.png',
        isLocalImage: true,
        description: 'Blood Glucose Meter',
        price: 20.0,
      ),
      MedicalStoreProduct(
        id: 6,
        name: '5ml PP Tube Disposable',
        imageUrl: 'assets/images/store_tube.png',
        isLocalImage: true,
        description: '5ml PP Tube Disposable',
        price: 5.0,
      ),
    ];

    final List<MedicalStoreProduct> poctProducts = [
      MedicalStoreProduct(
        id: 7,
        name: 'COVID-19 Rapid Test Kit',
        imageUrl: 'assets/images/store_biochemist.png',
        isLocalImage: true,
        description: 'COVID-19 Rapid Test Kit',
        price: 25.0,
      ),
      MedicalStoreProduct(
        id: 8,
        name: 'Blood Glucose Monitoring System',
        imageUrl: 'assets/images/store_seamaty.png',
        isLocalImage: true,
        description: 'Blood Glucose Monitoring System',
        price: 30.0,
      ),
      MedicalStoreProduct(
        id: 9,
        name: 'Digital Thermometer',
        imageUrl: 'assets/images/store_hematology.png',
        isLocalImage: true,
        description: 'Digital Thermometer',
        price: 10.0,
      ),
      MedicalStoreProduct(
        id: 10,
        name: 'Finger Pulse Oximeter',
        imageUrl: 'assets/images/store_flurolit.png',
        isLocalImage: true,
        description: 'Finger Pulse Oximeter',
        price: 20.0,
      ),
      MedicalStoreProduct(
        id: 11,
        name: 'Portable ECG Monitor',
        imageUrl: 'assets/images/store_urinalysis.png',
        isLocalImage: true,
        description: 'Portable ECG Monitor',
        price: 100.0,
      ),
      MedicalStoreProduct(
        id: 12,
        name: 'Urine Test Strips',
        imageUrl: 'assets/images/store_poct.png',
        isLocalImage: true,
        description: 'Urine Test Strips',
        price: 15.0,
      ),
    ];

    final productsToReturn = category == MedicalStoreProductCategory.consumables
        ? homecareConsumeables
        : poctProducts;

    emit(state.copyWith(
      status: MedicalStoreStatus.success,
      products: productsToReturn,
      hasReachedMax: true,
      page: 1,
    ));
  }
}
