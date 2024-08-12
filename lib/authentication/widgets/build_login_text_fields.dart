
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/color_theme.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.buttonAction,
    this.readOnly = false,
    this.maxLength,
    this.keyboardType,
    this.isEnabled = true,
    this.maxLines,
    this.validator,
    this.onChanged,
    this.isSmallTextField = false,
    this.isMedQtyField = false,
    this.autoValidate = AutovalidateMode.disabled,
    this.suffixIcon,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController? controller;
  final String? hintText;
  final IconData? prefixIcon;
  final Function()? buttonAction;
  final bool readOnly;
  final int? maxLength;
  final TextInputType? keyboardType;
  final bool isEnabled;
  final int? maxLines;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool isSmallTextField;
  final bool isMedQtyField;
  final AutovalidateMode autoValidate;
  final Icon? suffixIcon;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        textCapitalization: textCapitalization,
        autovalidateMode: autoValidate,
        onChanged: onChanged,
        keyboardType: keyboardType,
        onTap: buttonAction,
        readOnly: readOnly,
        enabled: isEnabled,
        maxLength: maxLength,
        maxLines: maxLines,
        textAlign: isSmallTextField ? TextAlign.center : TextAlign.start,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          hintStyle: TextStyle(
            fontSize: isMedQtyField ? 12.sp : null,
            color: Colors.grey.withOpacity(0.7),
          ),
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  size: 18.w,
                  color: ColorTheme.primaryBlue,
                )
              : null,
          hintText: hintText,
          filled: true,
          fillColor: ColorTheme.fieldFill,
          border: OutlineInputBorder(
              borderSide: BorderSide(color: ColorTheme.borderGrey),
              borderRadius: BorderRadius.circular(12.r)),
          contentPadding:
              EdgeInsets.symmetric(vertical: 16.h, horizontal: 14.w),
        ),
        cursorColor: ColorTheme.primaryBlue,
        controller: controller,
        validator: validator);
  }
}
