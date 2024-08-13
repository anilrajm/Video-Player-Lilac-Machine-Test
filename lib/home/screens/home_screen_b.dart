import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../authentication/services/video_services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/format_duration_helper.dart';
import '../../utils/theme_provider.dart';
import 'full_screen_video_player.dart';

class HomeScreenB extends StatefulWidget {
  const HomeScreenB({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenBState();
  }
}

class _HomeScreenBState extends State<HomeScreenB> {
  User? _user;
  late VideoPlayerController _videoPlayerController;
  bool isLoading = true;
  final videoService = VideoService();
  final encryptionKey = 'my32lengthsupersecretnooneknows1';
  bool isMuted = false;

  final List<String> videoUrls = [
    "https://lilactaskbucket.s3.ap-south-1.amazonaws.com/istockphoto-1158647615-640_adpp_is.mp4",
    "https://lilactaskbucket.s3.ap-south-1.amazonaws.com/istockphoto-1140675444-640_adpp_is.mp4",
    "https://lilactaskbucket.s3.ap-south-1.amazonaws.com/istockphoto-1409042809-640_adpp_is.mp4",
    "https://lilactaskbucket.s3.ap-south-1.amazonaws.com/istockphoto-540464346-640_adpp_is.mp4"
        "https://lilactaskbucket.s3.ap-south-1.amazonaws.com/istockphoto-1488785315-640_adpp_is.mp4"
  ];
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
        videoUrls[currentVideoIndex]
            .substring(videoUrls[currentVideoIndex].lastIndexOf('/') + 1));
    if (localFile != null && await localFile.exists()) {
      _videoPlayerController = VideoPlayerController.file(localFile);
    } else {
      final videoUrl = videoUrls[currentVideoIndex];
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
    final videoUrl = videoUrls[currentVideoIndex];
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
    if (currentVideoIndex < videoUrls.length - 1) {
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
                      const DrawerButton(),
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
                              icon:
                                  const Icon(Icons.fast_rewind, color: Colors.white),
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
                              icon:
                                  const Icon(Icons.fast_forward, color: Colors.white),
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

class DisplayPicture extends StatelessWidget {
  const DisplayPicture({
    super.key,
    required User? user,
  }) : _user = user;

  final User? _user;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 10,
        right: 10,
        child: CircleAvatar(
            radius: 25,
            foregroundImage: NetworkImage(_user?.photoURL ??
                'https://images.pexels.com/photos/460031/pexels-photo-460031.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1')
            // AssetImage('assets/profile_vector.jpg')
            ));
  }
}

class DrawerButton extends StatelessWidget {
  const DrawerButton({
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

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            color: ThemeData.dark().primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                    radius: 70,
                    foregroundImage: NetworkImage(user?.photoURL ??
                        'https://images.pexels.com/photos/460031/pexels-photo-460031.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1')
                    // AssetImage('assets/profile_vector.jpg')
                    ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  user?.displayName?.isEmpty ?? true
                      ? 'Rahul'
                      : user?.displayName ?? '',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 24),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(user?.phoneNumber ?? user?.displayName ?? '',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16)),
                const SizedBox(
                  height: 10,
                ),
                Text(
                    'Email: ${user?.email?.isEmpty ?? true ? 'test@gmail.com' : user?.email}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16)),
                const SizedBox(
                  height: 10,
                ),
                const Text('DOB: 19/11/2001',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16)),
              ],
            ),
          ),
          SizedBox(
            height: 0.4.sh,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: ListTile(
                leading: Icon(
                  Icons.logout_rounded,
                  size: 29.r,
                ),
                title: Text(
                  'Log Out',
                  style: TextStyle(fontSize: 18.sp),
                ),
                onTap: () async {
                  try {
                    final currentUser = FirebaseAuth.instance.currentUser;
                    if (currentUser != null) {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/phoneInput', (route) => false);
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                },
              )),
        ],
      ),
    );
  }
}

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
