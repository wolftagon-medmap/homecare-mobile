import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/domain/entities/order_entity.dart';
import 'package:m2health/core/extensions/string_extensions.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';
import 'package:m2health/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:m2health/features/payment/presentation/widgets/offline_payment_success_dialog.dart';
import 'package:m2health/features/payment/presentation/widgets/payment_success_dialog.dart';
import 'package:m2health/i18n/translations.g.dart';

class PaymentMethod extends Equatable {
  final String id;
  final String type;
  final String displayName;
  final String iconUrl;
  final String code;

  final String? accountNumber;
  final String? expiryDate;

  const PaymentMethod({
    required this.id,
    required this.type,
    required this.displayName,
    required this.iconUrl,
    required this.code,
    this.accountNumber,
    this.expiryDate,
  });

  @override
  List<Object?> get props => [
        id,
        code,
      ];
}

class PaymentPage extends StatefulWidget {
  final AppointmentEntity appointment;

  const PaymentPage({
    super.key,
    required this.appointment,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  PaymentMethod? selectedPaymentMethod;

  ProfessionalEntity get profile => widget.appointment.provider!;
  OrderEntity? get _order => widget.appointment.order;
  bool get _isFullyCovered => _order != null && _order!.total == 0.0;

  List<OrderLineItem> get _lineItems => _order?.lineItems ?? [];

  // ignore: deprecated_member_use_from_same_package
  double get totalCost => _order?.total ?? widget.appointment.payTotal;

  List<PaymentMethod> get paymentMethods => [
        // PaymentMethod(
        //   id: '1',
        //   type: 'card',
        //   code: 'Visa',
        //   displayName: 'Visa',
        //   iconUrl: 'assets/icons/ic_visa.png',
        //   accountNumber: '**** **** **** 1234',
        //   expiryDate: '12/26',
        // ),
        // PaymentMethod(
        //   id: '2',
        //   type: 'card',
        //   code: 'MasterCard',
        //   displayName: 'MasterCard',
        //   iconUrl: 'assets/icons/mastercard.png',
        //   accountNumber: '**** **** **** 5678',
        //   expiryDate: '11/25',
        // ),
        // PaymentMethod(
        //   id: '3',
        //   type: 'alipay',
        //   code: 'Alipay',
        //   displayName: 'Alipay',
        //   iconUrl: 'assets/icons/ic_alipay.png',
        // ),
        // PaymentMethod(
        //   id: '4',
        //   type: 'paynow',
        //   code: 'PayNow',
        //   displayName: 'PayNow',
        //   iconUrl: 'assets/icons/ic_paynow.jpg',
        // ),
        PaymentMethod(
          id: '5',
          type: 'cash',
          code: 'CASH_OFFLINE',
          displayName: context.t.payment.methods.cash_offline,
          iconUrl: 'assets/icons/cash.png',
        ),
      ];

  void _onConfirmPayment() {
    if (widget.appointment.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t.payment.error.appointment_id_missing)),
      );
      return;
    }

    if (_isFullyCovered) {
      // Subscription covers full cost — nothing to pay.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Appointment is fully covered by your subscription.')),
      );
      return;
    }

    if (selectedPaymentMethod == null) return;

    final order = _order;
    if (order != null) {
      context.read<PaymentCubit>().payOrder(
            orderId: order.id,
            method: selectedPaymentMethod!.code,
            amount: totalCost,
          );
    } else {
      // ignore: deprecated_member_use
      context.read<PaymentCubit>().createPayment(
            appointmentId: widget.appointment.id!,
            method: selectedPaymentMethod!.code,
            amount: totalCost,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isButtonEnabled = _isFullyCovered || selectedPaymentMethod != null;

    return BlocListener<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is PaymentSuccess) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => PaymentSuccessDialog(
              appointment: widget.appointment,
              payment: state.payment,
            ),
          );
        } else if (state is OfflinePaymentSuccess) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => OfflinePaymentSuccessDialog(
              appointment: widget.appointment,
              payment: state.payment,
            ),
          );
        } else if (state is PaymentFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(context.t.payment.messages.failed(error: state.message)),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.t.payment.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withValues(alpha: 0.08),
                      spreadRadius: 0,
                      blurRadius: 16,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: (profile.avatar != null)
                          ? NetworkImage(profile.avatar!)
                          : null,
                      child: (profile.avatar == null)
                          ? const Icon(Icons.person,
                              size: 40, color: Colors.grey)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(profile.jobTitle?.toTitleCase() ??
                            profile.role.toTitleCase()),
                        Row(
                          children: [
                            const Icon(Icons.star_half_rounded,
                                color: Color(0xFF9DEAC0)),
                            const SizedBox(width: 4),
                            Text('${profile.rating} (${100} reviews)'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                context.t.payment.service_charge,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Column(
                spacing: 4,
                children: _lineItems.map((item) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(item.description)),
                      Text('\$${item.amount.toStringAsFixed(2)}'),
                    ],
                  );
                }).toList(),
              ),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.t.payment.total_label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '\$${totalCost.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              if (_isFullyCovered) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade300),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Fully covered by your subscription — no payment required.',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                const SizedBox(height: 24),
                Text(
                  context.t.payment.select_method,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  spacing: 8,
                  children: paymentMethods
                      .map((method) => _buildPaymentMethodCard(method))
                      .toList(),
                ),
              ]
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<PaymentCubit, PaymentState>(
            builder: (context, state) {
              final isLoading = state is PaymentLoading;
              return ElevatedButton(
                onPressed:
                    isButtonEnabled && !isLoading ? _onConfirmPayment : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF35C5CF),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFB2B9C4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Text(
                        context.t.global.confirm,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(PaymentMethod paymentMethod) {
    void toggleSelection(PaymentMethod newPaymentMethod) {
      setState(() {
        if (selectedPaymentMethod == newPaymentMethod) {
          selectedPaymentMethod = null;
        } else {
          selectedPaymentMethod = newPaymentMethod;
        }
      });
    }

    return GestureDetector(
      onTap: () {
        toggleSelection(paymentMethod);
      },
      child: Container(
        decoration: BoxDecoration(
          color: selectedPaymentMethod == paymentMethod
              ? (Colors.green.withValues(alpha: 0.08))
              : Colors.white,
          border: Border.all(
            color: selectedPaymentMethod == paymentMethod
                ? (Colors.green)
                : Colors.grey.withValues(alpha: 0.3),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Image.asset(paymentMethod.iconUrl, width: 40, height: 40),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    paymentMethod.displayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (paymentMethod.accountNumber != null) ...[
                    Text(paymentMethod.accountNumber!),
                    Text('Expired: ${paymentMethod.expiryDate}'),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
