import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
