// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lilac_machine_test/theme/color_theme.dart';

class FlowButton extends StatelessWidget {
  FlowButton(
      {super.key,
      required this.buttonLabel,
      required this.buttonAction,
      this.isWhite = false});

  bool isWhite;
  final Widget buttonLabel;
  final void Function() buttonAction;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
        style: FilledButton.styleFrom(
            minimumSize: Size(327.w, 56.h),
            maximumSize: Size(327.w, 56.h),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(30.r)),
            backgroundColor: isWhite ? Colors.white : ColorTheme.primaryBlue),
        onPressed: buttonAction, //Todo: Right to Left page transition animation
        child: buttonLabel);
  }
}
