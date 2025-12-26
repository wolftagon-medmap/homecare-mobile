import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/features/subscription/domain/entities/subscription_plan_entity.dart';
import 'package:m2health/features/subscription/presentation/bloc/subscription_cubit.dart';
import 'package:m2health/features/subscription/presentation/bloc/subscription_state.dart';

class PaymentMethod {
  final String id;
  final String type;
  final String displayName;
  final String iconUrl;
  final String code;
  final String? accountNumber;
  final String? expiryDate;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.displayName,
    required this.iconUrl,
    required this.code,
    this.accountNumber,
    this.expiryDate,
  });
}

class SubscriptionPaymentPage extends StatefulWidget {
  final SubscriptionPlanEntity plan;

  const SubscriptionPaymentPage({super.key, required this.plan});

  @override
  State<SubscriptionPaymentPage> createState() =>
      _SubscriptionPaymentPageState();
}

class _SubscriptionPaymentPageState extends State<SubscriptionPaymentPage> {
  PaymentMethod? selectedPaymentMethod;

  List<PaymentMethod> paymentMethods = [
    PaymentMethod(
      id: '1',
      type: 'card',
      code: 'Visa',
      displayName: 'Visa',
      iconUrl: 'assets/icons/ic_visa.png',
      accountNumber: '**** **** **** 1234',
      expiryDate: '12/26',
    ),
    PaymentMethod(
      id: '2',
      type: 'card',
      code: 'MasterCard',
      displayName: 'MasterCard',
      iconUrl: 'assets/icons/mastercard.png',
      accountNumber: '**** **** **** 5678',
      expiryDate: '11/25',
    ),
    PaymentMethod(
      id: '3',
      type: 'alipay',
      code: 'Alipay',
      displayName: 'Alipay',
      iconUrl: 'assets/icons/ic_alipay.png',
    ),
    PaymentMethod(
      id: '4',
      type: 'paynow',
      code: 'PayNow',
      displayName: 'PayNow',
      iconUrl: 'assets/icons/ic_paynow.jpg',
    ),
    PaymentMethod(
      id: '5',
      type: 'cash',
      code: 'Cash',
      displayName: 'Cash',
      iconUrl: 'assets/icons/cash.png',
    ),
  ];

  void _onConfirmPayment() {
    if (selectedPaymentMethod == null) return;
    context.read<SubscriptionCubit>().purchase(widget.plan.id);
  }

  @override
  Widget build(BuildContext context) {
    final isButtonEnabled = selectedPaymentMethod != null;

    return BlocListener<SubscriptionCubit, SubscriptionState>(
      listenWhen: (previous, current) =>
          previous.purchaseStatus != current.purchaseStatus,
      listener: (context, state) {
        if (state.purchaseStatus == SubscriptionPurchaseStatus.success) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle,
                      color: Colors.green, size: 60),
                  const SizedBox(height: 16),
                  Text(context.l10n.payment_subscription_success_title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(context.l10n
                      .payment_subscription_success_content(widget.plan.name)),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Close dialog
                        Navigator.of(context).pop();
                        // Close payment page
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Const.tosca,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(context.l10n.common_ok),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state.purchaseStatus ==
            SubscriptionPurchaseStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n
                  .payment_purchase_failed(state.purchaseErrorMessage ?? '')),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.l10n.payment_title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.payment_order_summary,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.plan.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(context.l10n.admin_homecare_price),
                        Text(
                          '\$${widget.plan.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(context.l10n.admin_homecare_validity_days),
                        Text('${widget.plan.validityDays} Days'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                context.l10n.payment_select_method,
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
              )
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
            builder: (context, state) {
              final isLoading =
                  state.purchaseStatus == SubscriptionPurchaseStatus.submitting;
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
                        context.l10n.payment_pay_btn(
                            '\$${widget.plan.price.toStringAsFixed(2)}'),
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
