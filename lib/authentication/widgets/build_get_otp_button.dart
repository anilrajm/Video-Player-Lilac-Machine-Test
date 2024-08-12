import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lilac_machine_test/theme/text_theme.dart';

import '../../theme/color_theme.dart';

class GetOtpButton extends StatelessWidget {
  const GetOtpButton(
      {super.key,
      required this.buttonLabel,
      required this.buttonAction,
      required this.enabled,
      required this.isLoading});

  final String buttonLabel;
  final void Function()? buttonAction;
  final bool enabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
          disabledBackgroundColor: ColorTheme.btnDisabledGrey,
          minimumSize: Size(327.w, 56.h),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(30.r)),
          backgroundColor: ColorTheme.primaryBlue),
      onPressed: enabled ? buttonAction : null,
      child: isLoading
          ? CupertinoActivityIndicator(
              color: Colors.white,
              radius: 15.r,
            )
          : Text(
              buttonLabel,
              style: TT.f16w700White,
            ),
    );
  }
}
