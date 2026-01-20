import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/presentation/widgets/otp_input.dart';
import 'package:m2health/core/presentation/widgets/buttons/primary_button.dart';
import 'package:m2health/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:m2health/features/settings/account/delete_account/bloc/delete_account_cubit.dart';
import 'package:m2health/features/settings/account/delete_account/bloc/delete_account_state.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/route/app_routes.dart';

class DeleteAccountOtpPage extends StatefulWidget {
  const DeleteAccountOtpPage({super.key});

  @override
  State<DeleteAccountOtpPage> createState() => _DeleteAccountOtpPageState();
}

class _DeleteAccountOtpPageState extends State<DeleteAccountOtpPage> {
  final TextEditingController _otpController = TextEditingController();
  Timer? _timer;
  int _start = 30;
  bool _isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    if (_timer?.isActive ?? false) _timer!.cancel();
    setState(() {
      _isResendEnabled = false;
      _start = 30;
    });
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _isResendEnabled = true;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
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
      body: MultiBlocListener(
        listeners: [
          // Listen for Confirm Delete events
          BlocListener<DeleteAccountCubit, DeleteAccountState>(
            listenWhen: (previous, current) =>
                previous.confirmDeleteState != current.confirmDeleteState,
            listener: (context, state) {
              if (state.confirmDeleteState.success) {
                context.read<AuthCubit>().loggedOut(); // Notify to log out
                context.goNamed(AppRoutes.deleteAccountSuccess);
              }
              if (state.confirmDeleteState.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(state.confirmDeleteState.error!),
                      backgroundColor: Colors.red),
                );
              }
            },
          ),
          // Listen for OTP Resend events
          BlocListener<DeleteAccountCubit, DeleteAccountState>(
            listenWhen: (previous, current) =>
                previous.resendOtpState != current.resendOtpState,
            listener: (context, state) {
              if (state.resendOtpState.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Code Resent!')),
                );
                startTimer();
              } else if (state.resendOtpState.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(state.resendOtpState.error!),
                      backgroundColor: Colors.red),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<DeleteAccountCubit, DeleteAccountState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Verify & Confirm',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Const.aqua,
                    ),
                  ),
                  const Text(
                    'Step 3 of 3',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Enter the 6-digit code sent to your email to confirm deletion.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: OtpInput(
                      controller: _otpController,
                      showCursor: true,
                      onChanged: (pin) =>
                          context.read<DeleteAccountCubit>().setOtpCode(pin),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: TextButton(
                      onPressed: _isResendEnabled &&
                              !state.resendOtpState.isLoading
                          ? () {
                              context.read<DeleteAccountCubit>().requestOtp();
                            }
                          : null,
                      child: Text(
                        _isResendEnabled
                            ? context.t.auth.otp_verification.button.resend_code
                            : context.t.auth.otp_verification
                                .resend_time_countdown(seconds: _start),
                        style: TextStyle(
                          color: _isResendEnabled ? Const.aqua : Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 36.0),
        child: BlocBuilder<DeleteAccountCubit, DeleteAccountState>(
          builder: (context, state) {
            final otp = state.otpCode?.trim() ?? '';
            final isOtpValid = otp.length == 6;

            return PrimaryButton(
              text: 'Permanently Delete Account',
              isLoading: state.confirmDeleteState.isLoading,
              backgroundColor: Colors.red,
              disabledBackgroundColor: Colors.red.shade200,
              disabledForegroundColor: Colors.white,
              onPressed: isOtpValid
                  ? () => context
                      .read<DeleteAccountCubit>()
                      .confirmDeleteAccount(otp)
                  : null,
            );
          },
        ),
      ),
    );
  }
}
