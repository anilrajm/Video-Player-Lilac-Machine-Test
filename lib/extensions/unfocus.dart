
import 'package:flutter/material.dart';

extension ScaffoldExtension on Scaffold {
  Widget withUnFocusGestureDetector(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: this,
    );
  }
}
