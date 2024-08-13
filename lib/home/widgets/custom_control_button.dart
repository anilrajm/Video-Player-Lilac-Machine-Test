import 'package:flutter/material.dart';
import 'package:lilac_machine_test/utils/theme_provider.dart';
class CustomControlButton extends StatelessWidget {
  const CustomControlButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.themeProvider,
  });

  final Function() onPressed;
  final IconData icon;
  final ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: themeProvider.isDarkTheme ? Colors.white12 : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(15),
        child: Icon(
          icon,
        ),
      ),
    );
  }
}
