import 'package:flutter/widgets.dart';
import 'package:m2health/const.dart';
import 'package:pinput/pinput.dart';

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final int length;
  final bool showCursor;
  final void Function(String)? onCompleted;
  final void Function(String)? onChanged;

  const OtpInput({
    super.key,
    required this.controller,
    this.length = 6,
    this.showCursor = true,
    this.onCompleted,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(16),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Const.aqua),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    return Pinput(
      length: length,
      controller: controller,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: showCursor,
      onCompleted: onCompleted,
      onChanged: onChanged,
    );
  }
}
