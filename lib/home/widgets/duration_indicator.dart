import 'package:flutter/material.dart';
import 'package:lilac_machine_test/utils/format_duration_helper.dart';
import 'package:video_player/video_player.dart';
class DurationDisplay extends StatelessWidget {
  const DurationDisplay({
    super.key,
    required VideoPlayerController videoPlayerController,
  }) : _videoPlayerController = videoPlayerController;

  final VideoPlayerController _videoPlayerController;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 5,
      bottom: 59,
      child: ValueListenableBuilder(
        valueListenable: _videoPlayerController,
        builder: (context, VideoPlayerValue value, child) {
          final position = value.position;
          final duration = value.duration;
          final positionText = formatDuration(position);
          final durationText = formatDuration(duration);
          return Text(
            '$positionText / $durationText',
            style: const TextStyle(color: Colors.white, fontSize: 11),
          );
        },
      ),
    );
  }
}
