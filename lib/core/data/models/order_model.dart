import 'package:m2health/core/domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.status,
    required super.subtotal,
    required super.subscriptionCredit,
    required super.total,
    required super.lineItems,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final items = (json['line_items'] as List? ?? [])
        .map((e) => OrderLineItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return OrderModel(
      id: json['id'] as int,
      status: json['status'] as String? ?? 'awaiting_payment',
      subtotal: double.parse((json['subtotal'] ?? 0).toString()),
      subscriptionCredit:
          double.parse((json['subscription_credit'] ?? 0).toString()),
      total: double.parse((json['total'] ?? 0).toString()),
      lineItems: items,
    );
  }
}

class OrderLineItemModel extends OrderLineItem {
  const OrderLineItemModel({
    required super.type,
    required super.description,
    required super.amount,
  });

  factory OrderLineItemModel.fromJson(Map<String, dynamic> json) {
    return OrderLineItemModel(
      type: json['type'] as String? ?? '',
      description: json['description'] as String? ?? '',
      amount: double.parse((json['amount'] ?? 0).toString()),
    );
  }
}
