
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lilac_machine_test/theme/color_theme.dart';

import '../../theme/text_theme.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    super.key,
    required this.buttonAction,
    required this.buttonLabel,
  });

  final void Function() buttonAction;
  final String buttonLabel;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: FilledButton.styleFrom(
            backgroundColor: Colors.white,
            minimumSize: Size(327.w, 56.h),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(30.r)),
            side: BorderSide(color: ColorTheme.lightBlueGrey, width: 0.5.w)),
        onPressed: buttonAction,
        child: Text(
          textAlign: TextAlign.center,
          buttonLabel,
          style: TT.f16w600DarkGrey,
        ));
  }
}
