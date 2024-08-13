import 'package:flutter/material.dart';
class CustomDrawerButton extends StatelessWidget {
  const CustomDrawerButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 10,
        left: 10,
        child: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ));
  }
}
