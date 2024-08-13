import 'package:flutter/material.dart';
import 'package:lilac_machine_test/home/screens/full_screen_video_player.dart';
import 'package:video_player/video_player.dart';
class SettingsButton extends StatelessWidget {
  const SettingsButton({
    super.key,
    required VideoPlayerController videoPlayerController,
  }) : _videoPlayerController = videoPlayerController;

  final VideoPlayerController _videoPlayerController;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      right: 10,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Add settings action here
            },
          ),
          IconButton(
            icon: const Icon(Icons.fullscreen, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FullScreenVideoPlayer(controller: _videoPlayerController),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
