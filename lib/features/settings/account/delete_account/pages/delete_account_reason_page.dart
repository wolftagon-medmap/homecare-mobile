import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/presentation/widgets/primary_button.dart';
import 'package:m2health/features/diabetes/widgets/diabetes_form_widget.dart';
import 'package:m2health/features/settings/account/delete_account/bloc/delete_account_cubit.dart';
import 'package:m2health/features/settings/account/delete_account/bloc/delete_account_state.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/utils.dart';

class DeleteAccountReasonPage extends StatefulWidget {
  const DeleteAccountReasonPage({super.key});

  @override
  State<DeleteAccountReasonPage> createState() =>
      _DeleteAccountReasonPageState();
}

class _DeleteAccountReasonPageState extends State<DeleteAccountReasonPage> {
  final List<String> reasons = [
    'No longer need service',
    'Found a better alternative',
    'Privacy concerns',
    'Technical issues',
    'Other'
  ];

  final TextEditingController _detailsController = TextEditingController();

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  Future<String?> get getEmail async {
    return await Utils.getSpString(Const.EMAIL);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delete Account',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<DeleteAccountCubit, DeleteAccountState>(
        listenWhen: (previous, current) =>
            previous.requestOtpState != current.requestOtpState,
        listener: (context, state) {
          if (state.requestOtpState.success) {
            context.pushNamed(AppRoutes.deleteAccountOtp);
          }
          if (state.requestOtpState.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.requestOtpState.error!),
                  backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tell Us Why',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Const.aqua,
                  ),
                ),
                const Text(
                  'Step 2 of 3',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Why are you leaving?',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                DropdownButtonFormField<String?>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: 'Select a reason',
                  ),
                  initialValue: state.selectedReason,
                  dropdownColor: Colors.white,
                  items:
                      reasons.map<DropdownMenuItem<String?>>((String? value) {
                    return DropdownMenuItem<String?>(
                      value: value,
                      child: Text(
                        value ?? 'Select a reason',
                        style: const TextStyle(fontWeight: FontWeight.w400),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      context.read<DeleteAccountCubit>().selectReason(newValue);
                    }
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Additional Details (Optional)',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: _detailsController,
                  onChanged: (value) {
                    context.read<DeleteAccountCubit>().setReasonDetails(value);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Tell us more...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your feedback helps us improve our services.',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 32),
                FutureBuilder(
                  future: getEmail,
                  builder: (context, asyncSnapshot) {
                    return Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: const Color.fromRGBO(154, 225, 255, 0.2),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.email_outlined,
                            color: Const.aqua,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Colors.black87,
                                ),
                                children: [
                                  const TextSpan(
                                    text:
                                        "A 6-digit verification code will be sent to your registered email",
                                  ),
                                  if (asyncSnapshot.hasData) ...[
                                    const TextSpan(text: ": "),
                                    TextSpan(
                                      text: asyncSnapshot.data!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Const.aqua,
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 36.0),
        child: BlocBuilder<DeleteAccountCubit, DeleteAccountState>(
          builder: (context, state) {
            return PrimaryButton(
              isLoading: state.requestOtpState.isLoading,
              text: 'Send Verification Code',
              onPressed: state.selectedReason != null
                  ? () => context.read<DeleteAccountCubit>().requestOtp()
                  : null,
            );
          },
        ),
      ),
    );
  }
}
