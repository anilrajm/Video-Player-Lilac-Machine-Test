import 'package:flutter/material.dart';
import '../authentication/screens/otp_input_screen.dart';
import '../authentication/screens/phone_input_screen.dart';
import '../home/screens/home_screen_b.dart';

final Map<String, WidgetBuilder> customRoutes = {
  '/phoneInput': (BuildContext ctx) => const PhoneNumInput(),
  '/otpInput': (BuildContext ctx) => const OtpScreen(),
  '/home': (BuildContext ctx) => const HomeScreenB(),
};
