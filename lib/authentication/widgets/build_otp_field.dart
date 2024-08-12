  import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lilac_machine_test/theme/color_theme.dart';
import 'package:pinput/pinput.dart';

class OtpField extends StatelessWidget {
  final void Function(String)? onSubmit;
  final int length;

  OtpField({
    super.key,
    this.onSubmit,
    required this.length,
  });

  final defaultPinTheme = PinTheme(
    width: 60.w,
    height: 60.h,
    textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: ColorTheme.blueGrey),
      borderRadius: BorderRadius.circular(10),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );
    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return SizedBox(
      height: 70.h,
      child: Center(
        child: Pinput(
          keyboardType: TextInputType.number,
          closeKeyboardWhenCompleted: true,

          onCompleted: onSubmit,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          defaultPinTheme: defaultPinTheme,
          length: length,
          focusedPinTheme: focusedPinTheme,
          submittedPinTheme: submittedPinTheme,
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          showCursor: true,
          autofocus: true,
          // androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
        ),
      ),
    );
  }
}
