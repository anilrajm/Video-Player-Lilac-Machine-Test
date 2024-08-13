import 'package:flutter/material.dart';
import 'package:lilac_machine_test/utils/theme_provider.dart';
class CustomDownloadButton extends StatelessWidget {
  const CustomDownloadButton({
    super.key,
    required this.onPressed,
    required this.themeProvider,
  });

  final Function() onPressed;
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
          padding: const EdgeInsets.only(left: 5, right: 16, top: 5, bottom: 6),
          child: const Row(
            children: [
              Icon(
                size: 40,
                Icons.arrow_drop_down_sharp,
                color: Color(0xff57EE9D),
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                'Download',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              )
            ],
          )),
    );
  }
}
