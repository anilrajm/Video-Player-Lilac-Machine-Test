import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lilac_machine_test/theme/color_theme.dart';
import 'package:lilac_machine_test/theme/text_theme.dart';

class OtpCountdown extends StatelessWidget {
  final int durationInSeconds;
  final String formatDuration;

  const OtpCountdown({
    Key? key,
    required this.durationInSeconds,
    required this.formatDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15.w, top: 15.h, bottom: 15.h),
      width: 90.w,
      height: 50.h,
      decoration: BoxDecoration(
        color: ColorTheme.fieldFill,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          Icon(
            Icons.timer_outlined,
            size: 20.w,
            color: ColorTheme.navyBlue,
          ),
          SizedBox(width: 8.w),
          Text(
            formatDuration,
            style: TT.f12w500navyBlueMontserrat,
          ),
        ],
      ),
    );
  }
}
