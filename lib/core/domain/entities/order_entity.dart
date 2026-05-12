import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final int id;
  final String status; // awaiting_payment | paid | voided
  final double subtotal;
  final double subscriptionCredit;
  final double total; // net cash due
  final List<OrderLineItem> lineItems;

  const OrderEntity({
    required this.id,
    required this.status,
    required this.subtotal,
    required this.subscriptionCredit,
    required this.total,
    required this.lineItems,
  });

  bool get isPaid => status == 'paid';
  bool get isFullyCovered => total == 0;

  @override
  List<Object?> get props =>
      [id, status, subtotal, subscriptionCredit, total, lineItems];
}

class OrderLineItem extends Equatable {
  final String type;
  final String description;
  final double amount;

  const OrderLineItem({
    required this.type,
    required this.description,
    required this.amount,
  });

  @override
  List<Object?> get props => [type, description, amount];
}
