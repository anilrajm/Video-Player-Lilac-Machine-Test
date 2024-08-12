import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lilac_machine_test/authentication/providers/auth_provider.dart';
import 'package:lilac_machine_test/authentication/providers/otp_timer_provider.dart';
import 'package:lilac_machine_test/firebase_options.dart';
import 'package:lilac_machine_test/utils/routes.dart';
import 'package:provider/provider.dart';

import 'authentication/providers/save_user_data.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SaveUserProvider>(
            create: (context) => SaveUserProvider()),
        ChangeNotifierProvider<OtpTimer>(create: (context) => OtpTimer()),
        ChangeNotifierProvider<AuthenticationProvider>(
            create: (context) => AuthenticationProvider()),
      ],
      child: ScreenUtilInit(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Video Player Machine Test',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: false,
          ),
          initialRoute: FirebaseAuth.instance.currentUser == null ? '/phoneInput' : '/home',
          routes: customRoutes,
        ),
      ),
    );
  }
}