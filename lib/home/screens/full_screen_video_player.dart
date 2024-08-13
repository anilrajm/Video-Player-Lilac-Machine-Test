// Create a new file `full_screen_video_player.dart` and add this code
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoPlayer extends StatelessWidget {
  final VideoPlayerController controller;

  const FullScreenVideoPlayer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
            Positioned(
                right: 18,
                top: 0,
                child: IconButton(
                    onPressed: () {
                      controller.pause();
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close, color: Colors.white, size: 30))),
          ],
        ),
      ),
    );
  }
}
