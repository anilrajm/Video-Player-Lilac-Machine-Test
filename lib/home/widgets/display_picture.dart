import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
