import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lilac_machine_test/utils/theme_provider.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.browseVideos});

  final Function() browseVideos;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return AppBar(
      leading: const SizedBox(),
      actions: [
        Row(
          children: [
            const Text('Light'),
            const SizedBox(
              width: 2,
            ),
            CupertinoSwitch(
              activeColor: Colors.blueGrey,
              value: themeProvider.isDarkTheme,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
            ),
            const SizedBox(
              width: 2,
            ),
            const Text('Dark'),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        IconButton(
          icon: const Icon(Icons.folder_open),
          onPressed: browseVideos,
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(56);
}
