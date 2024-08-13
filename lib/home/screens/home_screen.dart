import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:lilac_machine_test/constants/video_urls.dart';
import 'package:lilac_machine_test/home/widgets/custom_appbar.dart';
import 'package:lilac_machine_test/home/widgets/custom_control_button.dart';
import 'package:lilac_machine_test/home/widgets/custom_download_button.dart';
import 'package:lilac_machine_test/home/widgets/custom_drawer.dart';
import 'package:lilac_machine_test/home/widgets/display_picture.dart';
import 'package:lilac_machine_test/home/widgets/download_progress_indicator.dart';
import 'package:lilac_machine_test/home/widgets/drawer_button.dart';
import 'package:lilac_machine_test/home/widgets/duration_indicator.dart';
import 'package:lilac_machine_test/home/widgets/settings_button.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../services/video_services.dart';

import '../../utils/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  User? _user;
  late VideoPlayerController _videoPlayerController;
  bool isLoading = true;
  final videoService = VideoService();
  final encryptionKey = 'my32lengthsupersecretnooneknows1';
  bool isMuted = false;

  int currentVideoIndex = 0;
  bool isDownloading = false;

  @override
  void initState() {
    super.initState();

    fetchAndInitializeVideo().catchError((error, stackTrace) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    });
    _user = FirebaseAuth.instance.currentUser!;
  }

  Future<void> fetchAndInitializeVideo() async {
    final localFile = await videoService.getLocalVideoFile(
        VideoUrls.videoUrls[currentVideoIndex].substring(
            VideoUrls.videoUrls[currentVideoIndex].lastIndexOf('/') + 1));
    if (localFile != null && await localFile.exists()) {
      _videoPlayerController = VideoPlayerController.file(localFile);
    } else {
      final videoUrl = VideoUrls.videoUrls[currentVideoIndex];
      _videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    }
    await _videoPlayerController.initialize();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> downloadVideo() async {
    setState(() {
      isDownloading = true;
    });
    final videoUrl = VideoUrls.videoUrls[currentVideoIndex];
    final videoFile = await videoService.downloadVideo(
        videoUrl, videoUrl.substring(videoUrl.lastIndexOf('/') + 1));
    final encryptedFile =
        await videoService.encryptFile(videoFile, encryptionKey);
    final decryptedFile =
        await videoService.decryptFile(encryptedFile, encryptionKey);
    _videoPlayerController = VideoPlayerController.file(decryptedFile);
    await _videoPlayerController.initialize();
    setState(() {
      isDownloading = false;
      isLoading = false;
    });
  }

  void playNextVideo() {
    if (currentVideoIndex < VideoUrls.videoUrls.length - 1) {
      currentVideoIndex++;

      fetchAndInitializeVideo();
    }
  }

  void playPreviousVideo() {
    if (currentVideoIndex > 0) {
      currentVideoIndex--;

      fetchAndInitializeVideo();
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future<void> browseVideos() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null) {
      final file = File(result.files.single.path!);
      _videoPlayerController = VideoPlayerController.file(file);
      await _videoPlayerController.initialize();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      drawer: CustomDrawer(
        user: _user,
      ),
      appBar: CustomAppBar(
        browseVideos: browseVideos,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      AspectRatio(
                        aspectRatio: _videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(_videoPlayerController),
                      ),
                      VideoProgressIndicator(
                        _videoPlayerController,
                        colors: VideoProgressColors(
                            playedColor: const Color(0xff57EE9D),
                            bufferedColor: Colors.blue.withOpacity(0.5),
                            backgroundColor: const Color(0xff525252)),
                        allowScrubbing: true,
                        padding: const EdgeInsets.only(
                            bottom: 65, left: 60, right: 80),
                      ),
                      DurationDisplay(
                          videoPlayerController: _videoPlayerController),
                      const CustomDrawerButton(),
                      DisplayPicture(user: _user),
                      Positioned(
                        bottom: 35,
                        left: 0,
                        child: IconButton(
                          icon: Icon(
                            size: 50,
                            _videoPlayerController.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _videoPlayerController.value.isPlaying
                                  ? _videoPlayerController.pause()
                                  : _videoPlayerController.play();
                            });
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 50,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.fast_rewind,
                                  color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _videoPlayerController.seekTo(
                                    _videoPlayerController.value.position -
                                        const Duration(seconds: 3),
                                  );
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.fast_forward,
                                  color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _videoPlayerController.seekTo(
                                    _videoPlayerController.value.position +
                                        const Duration(seconds: 3),
                                  );
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                isMuted ? Icons.volume_off : Icons.volume_up,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  isMuted = !isMuted;
                                  _videoPlayerController
                                      .setVolume(isMuted ? 0 : 1);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SettingsButton(
                          videoPlayerController: _videoPlayerController),
                    ],
                  ),
                  const SizedBox(height: 20),
                  DownloadProgressIndicator(isDownloading: isDownloading),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomControlButton(
                        themeProvider: themeProvider,
                        onPressed: () {
                          playPreviousVideo();
                        },
                        icon: Icons.arrow_back_ios_new,
                      ),
                      CustomDownloadButton(
                        themeProvider: themeProvider,
                        onPressed: () async {
                          await downloadVideo();
                        },
                      ),
                      CustomControlButton(
                        themeProvider: themeProvider,
                        onPressed: () {
                          playNextVideo();
                        },
                        icon: Icons.arrow_forward_ios,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
    );
  }
}
