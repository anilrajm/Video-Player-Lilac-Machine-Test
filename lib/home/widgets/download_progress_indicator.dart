import 'package:flutter/material.dart';
class DownloadProgressIndicator extends StatelessWidget {
  const DownloadProgressIndicator({
    super.key,
    required this.isDownloading,
  });

  final bool isDownloading;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isDownloading,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: LinearProgressIndicator(
          value: isDownloading ? null : 0,
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff57EE9D)),
          backgroundColor: Colors.grey.withOpacity(0.5),
        ),
      ),
    );
  }
}