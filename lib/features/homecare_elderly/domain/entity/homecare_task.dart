import 'package:equatable/equatable.dart';

class HomecareTask extends Equatable {
  final int id;
  final String name;

  const HomecareTask({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
