import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:lilac_machine_test/authentication/providers/auth_provider.dart';
import 'package:lilac_machine_test/authentication/providers/otp_timer_provider.dart';
import 'package:lilac_machine_test/firebase_options.dart';
import 'package:lilac_machine_test/utils/routes.dart';
import 'package:lilac_machine_test/utils/theme_provider.dart';
import 'package:provider/provider.dart';


import 'authentication/providers/save_user_data.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);

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
        ChangeNotifierProvider<ThemeProvider>(create: (context) => ThemeProvider()),

      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return ScreenUtilInit(
            child: MaterialApp(

              debugShowCheckedModeBanner: false,
              title: 'Video Player Machine Test',
              theme: themeProvider.themeData,
              initialRoute: FirebaseAuth.instance.currentUser == null
                  ? '/phoneInput'
                  : '/home',
              routes: customRoutes,
            ),
          );
        })
    );
  }
}