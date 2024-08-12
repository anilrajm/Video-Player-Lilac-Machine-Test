// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as fire;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lilac_machine_test/authentication/providers/auth_provider.dart';
import 'package:lilac_machine_test/authentication/widgets/build_back_button.dart';
import 'package:lilac_machine_test/authentication/widgets/build_flow_button.dart';
import 'package:lilac_machine_test/extensions/unfocus.dart';
import 'package:lilac_machine_test/theme/text_theme.dart';
import 'package:provider/provider.dart';

import '../../global_widgets/custom_snackbar.dart';
import '../providers/otp_timer_provider.dart';
import '../providers/save_user_data.dart';
import '../widgets/build_countdown.dart';
import '../widgets/build_otp_field.dart';


class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
   final fire.FirebaseAuth auth = fire.FirebaseAuth.instance;
  String _token = '';
  bool _isLoading = false;
  String otpCode = '';

  Future<String?> verifyOTPCode(String otpCode) async {
    final provider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    fire.PhoneAuthCredential credential = fire.PhoneAuthProvider.credential(
      verificationId: provider.receivedID,
      smsCode: otpCode,
    );

    try {
      fire.UserCredential userCredential =
          await auth.signInWithCredential(credential);
      fire.User? user = userCredential.user;

      if (user != null) {
         print('Logged In Successfully');
        print('User UID: ${user.uid}');

         String? idToken = await user.getIdToken();

        print('ID Token: $idToken');
        return idToken;

       } else {
        print('User is null');
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
     var timer = Provider.of<OtpTimer>(context, listen: false);
    timer.start();
  }



  @override
  Widget build(BuildContext context) {
    var userData =
        Provider.of<SaveUserProvider>(context, listen: false).userData;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 31.w, right: 31.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100.h,
              ),
              Text(
                "Verify Phone Number",
                style: TT.f24w700Primary,
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Text(
                      "We will send an OTP to your number ${userData.phoneNo}\n Please verify",
                      style: TT.f16w400bluishGrey),
                  SizedBox(
                    width: 5.w,
                  ),

                ],
              ),
              SizedBox(height: 36.h),
              Center(
                child: OtpField(
                  length: 6,
                  onSubmit: (String verificationCode) {
                    log('otp : $verificationCode');
                    otpCode = verificationCode;
                  },
                ),
              ),
              SizedBox(
                height: 24.h,
              ),
              Center(
                child: Consumer<OtpTimer>(
                  builder: (_, otpTimer, __) {
                    return OtpCountdown(
                      durationInSeconds: otpTimer.durationInSeconds,
                      formatDuration: otpTimer.formatDuration(),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Didn't receive the OTP",
                      style: TT.f12w400bluishGreyB),
                  SizedBox(width: 5.w),
                  Consumer<OtpTimer>(
                    builder: (_, otpTimer, __) => TextButton(
                      onPressed: otpTimer.durationInSeconds == 0
                          ? () {
                              try {
                                auth.verifyPhoneNumber(
                                  phoneNumber: "+91${userData.phoneNo}",
                                  verificationCompleted:
                                      (PhoneAuthCredential credential) async {
                                    await auth
                                        .signInWithCredential(credential)
                                        .then(
                                          (value) =>
                                              print('Logged In Successfully'),
                                        );
                                  },
                                  verificationFailed:
                                      (FirebaseAuthException e) {
                                    throw Exception(e.message);
                                  },
                                  codeSent: (String verificationId,
                                      int? resendToken) async {
                                    log('Code Sent');

                                    final provider =
                                        Provider.of<AuthenticationProvider>(
                                            context,
                                            listen: false);
                                    provider.setReceivedID(verificationId);
                                    await Navigator.pushNamed(
                                        context, '/otpInput');
                                  },
                                  codeAutoRetrievalTimeout:
                                      (String verificationId) {
                                    print('TimeOut');
                                  },
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())));
                              } finally {}

                              otpTimer.restart();
                            }
                          : null,
                      child: Text("Resend OTP",
                          style: otpTimer.durationInSeconds == 0
                              ? TT.f12w700primary
                              : TT.f12w500Teal),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 229.h,
              ),
              FlowButton(
                buttonLabel: _isLoading
                    ? CupertinoActivityIndicator(
                        color: Colors.white,
                        radius: 15.r,
                      )
                    : Text(
                "Verify",
                        style: TT.f16w700White,
                      ),
                buttonAction: () async {
                  if (otpCode.isNotEmpty) {
                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      await login(
                          phoneNo: userData.phoneNo,
                          otp: otpCode,
                          );
                    } catch (e) {
                      CustomSnackBar.showSnackBar(context, e.toString());
                    } finally {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  } else {
                    return;
                  }
                },
              ),
              SizedBox(height: 15.h),
              CustomBackButton(
                buttonAction: () {
                  Navigator.pop(context);
                },
                buttonLabel: "Back",
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    ).withUnFocusGestureDetector(context);
  }

  Future<void> login(
      {required String phoneNo,
      required String otp,
      }) async {
    try {
      String? idToken = await verifyOTPCode(otp);
      if (idToken == null) {
        throw 'Invalid OTP';
      }else{
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/home', (route) => false);
        }
      }

    } on HttpException catch (e) {
       log('HTTP error: ${e.message}');
      rethrow;
    } catch (e) {
       log('Error: $e');
      rethrow;
    }
  }
}
