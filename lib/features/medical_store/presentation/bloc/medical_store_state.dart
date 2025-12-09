import 'package:equatable/equatable.dart';
import 'package:m2health/features/medical_store/domain/entity/medical_store.dart';

enum MedicalStoreStatus { initial, loading, success, failure }

class MedicalStoreState extends Equatable {
  final MedicalStoreStatus status;
  final List<MedicalStoreProduct> products;
  final bool hasReachedMax;
  final String errorMessage;
  final int page;

  const MedicalStoreState({
    this.status = MedicalStoreStatus.initial,
    this.products = const <MedicalStoreProduct>[],
    this.hasReachedMax = false,
    this.errorMessage = '',
    this.page = 1,
  });

  MedicalStoreState copyWith({
    MedicalStoreStatus? status,
    List<MedicalStoreProduct>? products,
    bool? hasReachedMax,
    String? errorMessage,
    int? page,
  }) {
    return MedicalStoreState(
      status: status ?? this.status,
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props =>
      [status, products, hasReachedMax, errorMessage, page];
}