import 'package:equatable/equatable.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';

// TODO: Remove in next refactor cycle — use ServiceEntity with category='screening'.
@Deprecated(
    'Use ServiceEntity with category="screening" from unified catalog. TODO: delete.')
class ScreeningCategory extends Equatable {
  final int id;
  final String name;
  final List<ScreeningItem> items;

  const ScreeningCategory({
    required this.id,
    required this.name,
    required this.items,
  });

  @override
  List<Object?> get props => [id, name, items];
}

// TODO: Remove in next refactor cycle — use ServiceEntity with category='screening'.
@Deprecated(
    'Use ServiceEntity with category="screening" from unified catalog. TODO: delete.')
class ScreeningItem extends ServiceEntity {
  final String? description;

  const ScreeningItem({
    required super.id,
    required super.name,
    required super.price,
    this.description,
  });

  @override
  List<Object?> get props => [id, name, price, description];
}
