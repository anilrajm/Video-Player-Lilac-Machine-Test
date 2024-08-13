// import 'dart:io';
//
//  import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lilac_machine_test/theme/color_theme.dart';
// import 'package:provider/provider.dart';
// import 'package:video_player/video_player.dart';
//
// import '../../utils/theme_provider.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({
//     super.key,
//   });
//
//   @override
//   State<StatefulWidget> createState() {
//     return _HomeScreenState();
//   }
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   User? _user;
//   TargetPlatform? _platform;
//   late VideoPlayerController _videoPlayerController1;
//   late VideoPlayerController _videoPlayerController2;
//   late VideoPlayerController _videoPlayerController3;
//   ChewieController? _chewieController;
//   int? bufferDelay;
//
//   @override
//   void initState() {
//     super.initState();
//     initializePlayer();
//     _user = FirebaseAuth.instance.currentUser!;
//   }
//
//   @override
//   void dispose() {
//     _videoPlayerController1.dispose();
//     _videoPlayerController2.dispose();
//     _videoPlayerController3.dispose();
//     _chewieController?.dispose();
//     super.dispose();
//   }
//
//   List<String> srcs = [
//     "https://lilactaskbucket.s3.ap-south-1.amazonaws.com/1649831-uhd_3840_2160_30fps.mp4?response-content-disposition=inline&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEK%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCmFwLXNvdXRoLTEiRzBFAiB92AQ7WBV20v8IdgDZ8xU5DHm7PXPcsGUouzd7B4s6TwIhAKQ8qoY4OCnsQeLioQcFSULpRiOIZswdss46o15%2Fe9t1Ku0CCKj%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEQABoMMzA3OTQ2NjgwNDI3IgzLM22uRNoT1qjS7uEqwQLM84Bndf5CwfbRzx5MZIwlhfJKQKPcajOdP0t%2FYkgLt%2F6qjmbFmCL2w1sdUyHhjdjj9Jt89oK%2FxCpxbrFyFhi1FSiN7Mw0KPMgCKxrm6Wk0uABOTwUrzNlrgvdvmoHa%2F20ay%2BbMaF6IZbmrtH%2FmZAnIv2YN3ppEbsuTur9ZWd9ra4WXihZXATzFdhDawnsSPP5hZTNfzzxW2jxGruqfNUlN2aHLO%2FQTErbeoRUGNamOo%2BBKK9Ic%2BXp3fbOZGIDbsLTzcIr7LUhY5XHe0iIJBvUEDThFznH15sEt0HB56zDSBvn2BSBlhCbMGnQUj1f7C9l2H6%2B5fQZ4qPGyWwKRWa6xjSyMxVUZhln6CdLd3rgwCkK0xoNjremziYvozD9tllN3BP%2FHdq3NXHpAHkNUrIOE96odEUVh1mLdI28JYLwK%2BMw2OnttQY6swLOI3JharQcZDjuXvDXH8Z%2BWxSGC%2FuQd5XlBM%2BFa1ez0%2BEZw1eLgvZ%2B05i349PcXPcv5KJp%2FVCrOnD0dwyvotA5%2Fk0HLIepkcrF6oc8YFgW0c9WCJ2NrC8I72DSflSakVLjOyFK2W59l2NtLszR%2FK8wadALrqbbW92LHE3rYIkAikxpgtY1NcWoK3SCaQPm9BwN9SDvSa836oVybf8HVWdf9DcvSwDP2HGpW94R6kiLcTysImNjXPhMA%2B0sIHfoqa1DicnJ1RKPELxKNPNNt1TR6C5pC4ezflLmYlqKtO%2FsqJpBPVbIe3Ba9zbcdrj6szks2gLP%2BXeP2fMJ75FS%2Fs8X%2BVIroG8Mfs9mqwnQnncxgArKbdLga5x6%2FQAK5HjECh%2BlAyuHIZvQZI6fshrQtrucXwaD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240813T150450Z&X-Amz-SignedHeaders=host&X-Amz-Expires=300&X-Amz-Credential=ASIAUPMYNOBV5ACDHSDZ%2F20240813%2Fap-south-1%2Fs3%2Faws4_request&X-Amz-Signature=2afd3bae11b9a902d10f64b70247ffc89bc9a3fe8683ef8db926201395209068",
//     "https://lilactaskbucket.s3.ap-south-1.amazonaws.com/2146396-uhd_3840_2160_30fps.mp4?response-content-disposition=inline&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEK%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCmFwLXNvdXRoLTEiRzBFAiB92AQ7WBV20v8IdgDZ8xU5DHm7PXPcsGUouzd7B4s6TwIhAKQ8qoY4OCnsQeLioQcFSULpRiOIZswdss46o15%2Fe9t1Ku0CCKj%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEQABoMMzA3OTQ2NjgwNDI3IgzLM22uRNoT1qjS7uEqwQLM84Bndf5CwfbRzx5MZIwlhfJKQKPcajOdP0t%2FYkgLt%2F6qjmbFmCL2w1sdUyHhjdjj9Jt89oK%2FxCpxbrFyFhi1FSiN7Mw0KPMgCKxrm6Wk0uABOTwUrzNlrgvdvmoHa%2F20ay%2BbMaF6IZbmrtH%2FmZAnIv2YN3ppEbsuTur9ZWd9ra4WXihZXATzFdhDawnsSPP5hZTNfzzxW2jxGruqfNUlN2aHLO%2FQTErbeoRUGNamOo%2BBKK9Ic%2BXp3fbOZGIDbsLTzcIr7LUhY5XHe0iIJBvUEDThFznH15sEt0HB56zDSBvn2BSBlhCbMGnQUj1f7C9l2H6%2B5fQZ4qPGyWwKRWa6xjSyMxVUZhln6CdLd3rgwCkK0xoNjremziYvozD9tllN3BP%2FHdq3NXHpAHkNUrIOE96odEUVh1mLdI28JYLwK%2BMw2OnttQY6swLOI3JharQcZDjuXvDXH8Z%2BWxSGC%2FuQd5XlBM%2BFa1ez0%2BEZw1eLgvZ%2B05i349PcXPcv5KJp%2FVCrOnD0dwyvotA5%2Fk0HLIepkcrF6oc8YFgW0c9WCJ2NrC8I72DSflSakVLjOyFK2W59l2NtLszR%2FK8wadALrqbbW92LHE3rYIkAikxpgtY1NcWoK3SCaQPm9BwN9SDvSa836oVybf8HVWdf9DcvSwDP2HGpW94R6kiLcTysImNjXPhMA%2B0sIHfoqa1DicnJ1RKPELxKNPNNt1TR6C5pC4ezflLmYlqKtO%2FsqJpBPVbIe3Ba9zbcdrj6szks2gLP%2BXeP2fMJ75FS%2Fs8X%2BVIroG8Mfs9mqwnQnncxgArKbdLga5x6%2FQAK5HjECh%2BlAyuHIZvQZI6fshrQtrucXwaD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240813T150538Z&X-Amz-SignedHeaders=host&X-Amz-Expires=300&X-Amz-Credential=ASIAUPMYNOBV5ACDHSDZ%2F20240813%2Fap-south-1%2Fs3%2Faws4_request&X-Amz-Signature=02a581b59da3e43273f2e857da1340fd52665a2e205fdebece861137299a6b76",
//     "https://lilactaskbucket.s3.ap-south-1.amazonaws.com/3015514-hd_1920_1080_24fps.mp4?response-content-disposition=inline&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEK%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCmFwLXNvdXRoLTEiRzBFAiB92AQ7WBV20v8IdgDZ8xU5DHm7PXPcsGUouzd7B4s6TwIhAKQ8qoY4OCnsQeLioQcFSULpRiOIZswdss46o15%2Fe9t1Ku0CCKj%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEQABoMMzA3OTQ2NjgwNDI3IgzLM22uRNoT1qjS7uEqwQLM84Bndf5CwfbRzx5MZIwlhfJKQKPcajOdP0t%2FYkgLt%2F6qjmbFmCL2w1sdUyHhjdjj9Jt89oK%2FxCpxbrFyFhi1FSiN7Mw0KPMgCKxrm6Wk0uABOTwUrzNlrgvdvmoHa%2F20ay%2BbMaF6IZbmrtH%2FmZAnIv2YN3ppEbsuTur9ZWd9ra4WXihZXATzFdhDawnsSPP5hZTNfzzxW2jxGruqfNUlN2aHLO%2FQTErbeoRUGNamOo%2BBKK9Ic%2BXp3fbOZGIDbsLTzcIr7LUhY5XHe0iIJBvUEDThFznH15sEt0HB56zDSBvn2BSBlhCbMGnQUj1f7C9l2H6%2B5fQZ4qPGyWwKRWa6xjSyMxVUZhln6CdLd3rgwCkK0xoNjremziYvozD9tllN3BP%2FHdq3NXHpAHkNUrIOE96odEUVh1mLdI28JYLwK%2BMw2OnttQY6swLOI3JharQcZDjuXvDXH8Z%2BWxSGC%2FuQd5XlBM%2BFa1ez0%2BEZw1eLgvZ%2B05i349PcXPcv5KJp%2FVCrOnD0dwyvotA5%2Fk0HLIepkcrF6oc8YFgW0c9WCJ2NrC8I72DSflSakVLjOyFK2W59l2NtLszR%2FK8wadALrqbbW92LHE3rYIkAikxpgtY1NcWoK3SCaQPm9BwN9SDvSa836oVybf8HVWdf9DcvSwDP2HGpW94R6kiLcTysImNjXPhMA%2B0sIHfoqa1DicnJ1RKPELxKNPNNt1TR6C5pC4ezflLmYlqKtO%2FsqJpBPVbIe3Ba9zbcdrj6szks2gLP%2BXeP2fMJ75FS%2Fs8X%2BVIroG8Mfs9mqwnQnncxgArKbdLga5x6%2FQAK5HjECh%2BlAyuHIZvQZI6fshrQtrucXwaD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240813T150625Z&X-Amz-SignedHeaders=host&X-Amz-Expires=300&X-Amz-Credential=ASIAUPMYNOBV5ACDHSDZ%2F20240813%2Fap-south-1%2Fs3%2Faws4_request&X-Amz-Signature=8a0a2b7621a92241a5692e6515eb66b156ba4962284db8b1bf18037230826c2d"
//   ];
//
//   Future<void> initializePlayer() async {
//     _videoPlayerController1 =
//         VideoPlayerController.networkUrl(Uri.parse(srcs[currPlayIndex]));
//     _videoPlayerController2 =
//         VideoPlayerController.networkUrl(Uri.parse(srcs[currPlayIndex]));
//     _videoPlayerController3 =
//         VideoPlayerController.networkUrl(Uri.parse(srcs[currPlayIndex]));
//
//     await Future.wait([
//       _videoPlayerController1.initialize(),
//       _videoPlayerController2.initialize(),
//       _videoPlayerController3.initialize(),
//     ]);
//     _createChewieController();
//     setState(() {});
//   }
//
//   void _createChewieController() {
//     _chewieController = ChewieController(
//       videoPlayerController: _videoPlayerController1,
//       autoPlay: true,
//       looping: true,
//       progressIndicatorDelay:
//           bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
//
//       additionalOptions: (context) {
//         return <OptionItem>[
//           OptionItem(
//             onTap: toggleVideo,
//             iconData: Icons.live_tv_sharp,
//             title: 'Toggle Video Src',
//           ),
//         ];
//       },
//       subtitleBuilder: (context, dynamic subtitle) => Container(
//         padding: const EdgeInsets.all(10.0),
//         child: subtitle is InlineSpan
//             ? RichText(
//                 text: subtitle,
//               )
//             : Text(
//                 subtitle.toString(),
//                 style: const TextStyle(color: Colors.black),
//               ),
//       ),
//
//       hideControlsTimer: const Duration(seconds: 1),
//
//     );
//   }
//
//   int currPlayIndex = 0;
//
//   Future<void> toggleVideo() async {
//     await _videoPlayerController1.pause();
//     currPlayIndex += 1;
//     if (currPlayIndex >= srcs.length) {
//       currPlayIndex = 0;
//     }
//
//     await initializePlayer();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//
//     print('---------email---------');
//
//     return Scaffold(
//       drawer: Drawer(
//         child: ListView(
//           children: [
//             Container(
//               padding: EdgeInsets.only(top: 20, bottom: 20),
//               color: ThemeData.dark().primaryColor,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   CircleAvatar(
//                       radius: 70,
//                       foregroundImage: NetworkImage(_user?.photoURL ??
//                           'https://images.pexels.com/photos/460031/pexels-photo-460031.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1')
//                       // AssetImage('assets/profile_vector.jpg')
//                       ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     _user?.displayName?.isEmpty ?? true
//                         ? 'Rahul'
//                         : _user?.displayName ?? '',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w400,
//                         fontSize: 24),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(_user?.phoneNumber ?? _user?.displayName ?? '',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w400,
//                           fontSize: 16)),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                       'Email: ${_user?.email?.isEmpty ?? true ? 'test@gmail.com' : _user?.email}',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w400,
//                           fontSize: 16)),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text('DOB: 19/11/2001',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w400,
//                           fontSize: 16)),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 0.4.sh,
//             ),
//             Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 10.w),
//                 child: ListTile(
//                   leading: Icon(
//                     Icons.logout_rounded,
//                     size: 29.r,
//                   ),
//                   title: Text(
//                     'Log Out',
//                     style: TextStyle(fontSize: 18.sp),
//                   ),
//                   onTap: () async {
//                     try {
//                       final currentUser = FirebaseAuth.instance.currentUser;
//                       if (currentUser != null) {
//                         await FirebaseAuth.instance.signOut();
//                         Navigator.pushNamedAndRemoveUntil(
//                             context, '/phoneInput', (route) => false);
//                       }
//                     } catch (e) {
//                       ScaffoldMessenger.of(context)
//                           .showSnackBar(SnackBar(content: Text(e.toString())));
//                     }
//                   },
//                 )),
//           ],
//         ),
//       ),
//       appBar: AppBar(
//         actions: [
//           Row(
//             children: [
//               Text('Light'),
//               SizedBox(
//                 width: 2,
//               ),
//               CupertinoSwitch(
//                 activeColor: Colors.blueGrey,
//                 value: themeProvider.isDarkTheme,
//                 onChanged: (value) {
//                   themeProvider.toggleTheme();
//                 },
//               ),
//               SizedBox(
//                 width: 2,
//               ),
//               Text('Dark'),
//               SizedBox(
//                 width: 10,
//               )
//             ],
//           ),
//         ],
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: Center(
//               child: _chewieController != null &&
//                       _chewieController!
//                           .videoPlayerController.value.isInitialized
//                   ? Chewie(
//                       controller: _chewieController!,
//                     )
//                   : const Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         CircularProgressIndicator(),
//                         SizedBox(height: 20),
//                         Text('Loading'),
//                       ],
//                     ),
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               _chewieController?.enterFullScreen();
//             },
//             child: const Text('Fullscreen'),
//           ),
//           Row(
//             children: <Widget>[
//               Expanded(
//                 child: TextButton(
//                   onPressed: () {
//                     setState(() {
//                       _videoPlayerController1.pause();
//                       _videoPlayerController1.seekTo(Duration.zero);
//                       _createChewieController();
//                     });
//                   },
//                   child: const Padding(
//                     padding: EdgeInsets.symmetric(vertical: 16.0),
//                     child: Text("Landscape Video"),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: TextButton(
//                   onPressed: () {
//                     setState(() {
//                       _videoPlayerController2.pause();
//                       _videoPlayerController2.seekTo(Duration.zero);
//                       _chewieController = _chewieController!.copyWith(
//                         videoPlayerController: _videoPlayerController2,
//                         autoPlay: true,
//                         looping: true,
//                         /* subtitle: Subtitles([
//                             Subtitle(
//                               index: 0,
//                               start: Duration.zero,
//                               end: const Duration(seconds: 10),
//                               text: 'Hello from subtitles',
//                             ),
//                             Subtitle(
//                               index: 0,
//                               start: const Duration(seconds: 10),
//                               end: const Duration(seconds: 20),
//                               text: 'Whats up? :)',
//                             ),
//                           ]),
//                           subtitleBuilder: (context, subtitle) => Container(
//                             padding: const EdgeInsets.all(10.0),
//                             child: Text(
//                               subtitle,
//                               style: const TextStyle(color: Colors.white),
//                             ),
//                           ), */
//                       );
//                     });
//                   },
//                   child: const Padding(
//                     padding: EdgeInsets.symmetric(vertical: 16.0),
//                     child: Text("Portrait Video"),
//                   ),
//                 ),
//               )
//             ],
//           ),
//           Row(
//             children: <Widget>[
//               Expanded(
//                 child: TextButton(
//                   onPressed: () {
//                     setState(() {
//                       _platform = TargetPlatform.android;
//                     });
//                   },
//                   child: const Padding(
//                     padding: EdgeInsets.symmetric(vertical: 16.0),
//                     child: Text("Android controls"),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: TextButton(
//                   onPressed: () {
//                     setState(() {
//                       _platform = TargetPlatform.iOS;
//                     });
//                   },
//                   child: const Padding(
//                     padding: EdgeInsets.symmetric(vertical: 16.0),
//                     child: Text("iOS controls"),
//                   ),
//                 ),
//               )
//             ],
//           ),
//           Row(
//             children: <Widget>[
//               Expanded(
//                 child: TextButton(
//                   onPressed: () {
//                     setState(() {
//                       _platform = TargetPlatform.windows;
//                     });
//                   },
//                   child: const Padding(
//                     padding: EdgeInsets.symmetric(vertical: 16.0),
//                     child: Text("Desktop controls"),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           if (Platform.isAndroid)
//             ListTile(
//               title: const Text("Delay"),
//               subtitle: DelaySlider(
//                 delay:
//                     _chewieController?.progressIndicatorDelay?.inMilliseconds,
//                 onSave: (delay) async {
//                   if (delay != null) {
//                     bufferDelay = delay == 0 ? null : delay;
//                     await initializePlayer();
//                   }
//                 },
//               ),
//             )
//         ],
//       ),
//     );
//   }
// }
//
// class DelaySlider extends StatefulWidget {
//   const DelaySlider({super.key, required this.delay, required this.onSave});
//
//   final int? delay;
//   final void Function(int?) onSave;
//
//   @override
//   State<DelaySlider> createState() => _DelaySliderState();
// }
//
// class _DelaySliderState extends State<DelaySlider> {
//   int? delay;
//   bool saved = false;
//
//   @override
//   void initState() {
//     super.initState();
//     delay = widget.delay;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     const int max = 1000;
//     return ListTile(
//       title: Text(
//         "Progress indicator delay ${delay != null ? "${delay.toString()} MS" : ""}",
//       ),
//       subtitle: Slider(
//         value: delay != null ? (delay! / max) : 0,
//         onChanged: (value) async {
//           delay = (value * max).toInt();
//           setState(() {
//             saved = false;
//           });
//         },
//       ),
//       trailing: IconButton(
//         icon: const Icon(Icons.save),
//         onPressed: saved
//             ? null
//             : () {
//                 widget.onSave(delay);
//                 setState(() {
//                   saved = true;
//                 });
//               },
//       ),
//     );
//   }
// }
