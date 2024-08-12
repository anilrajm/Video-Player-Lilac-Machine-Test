import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lilac_machine_test/authentication/models/user_data.dart';
import 'package:lilac_machine_test/authentication/providers/auth_provider.dart';
import 'package:lilac_machine_test/authentication/providers/save_user_data.dart';
import 'package:lilac_machine_test/authentication/widgets/build_back_button.dart';
import 'package:lilac_machine_test/authentication/widgets/build_login_text_fields.dart';
import 'package:lilac_machine_test/extensions/unfocus.dart';
import 'package:lilac_machine_test/global_widgets/custom_snackbar.dart';
import 'package:lilac_machine_test/theme/text_theme.dart';
import 'package:lilac_machine_test/utils/validators.dart';
import 'package:provider/provider.dart';

import '../widgets/build_get_otp_button.dart';


class PhoneNumInput extends StatefulWidget {
  const PhoneNumInput({super.key});

  @override
  State<PhoneNumInput> createState() => _PhoneNumInputState();
}

class _PhoneNumInputState extends State<PhoneNumInput> {
  bool _isOtpRequest = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  var receivedID = '';

  Future<void> verifyUserPhoneNumber() async {
    auth.verifyPhoneNumber(
      phoneNumber: "+91${_phoneNumController.text}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        // await auth.signInWithCredential(credential).then(
        //       (value) => print('Logged In Successfully'),
        //     );
      },
      verificationFailed: (FirebaseAuthException e) {
        if(context.mounted){
          setState(() {
            _isOtpRequest = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message.toString()),
            ),
          );

        }



        throw Exception(e.message);
      },
      codeSent: (String verificationId, int? resendToken) async {
        log('Code Sent');

        final provider =
            Provider.of<AuthenticationProvider>(context, listen: false);
        provider.setReceivedID(verificationId);
        await Navigator.pushNamed(context, '/otpInput');

        receivedID = verificationId;
        setState(() {
          _isOtpRequest = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        if(
        context.mounted
        ){
          setState(() {
            _isOtpRequest = false;
          });
        }

        print('TimeOut');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var terms = Provider.of<AuthenticationProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(top: 120.h, left: 33.w, right: 33.w, bottom: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter your phone number",
                  style: TT.f24w700Primary,
                ),
                SizedBox(
                  height: 7.h,
                ),
                Text("We will send an OTP to your number",
                    style: TT.f16w400bluishGrey),
                SizedBox(height: 39.h),
                Text("Phone Number", style: TT.f14w400navyBlueB),
                SizedBox(height: 13.h),
                AuthTextField(
                  validator: Validators.validatePhoneNumber,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  controller: _phoneNumController,
                  hintText: "Phone Number",
                ),
                SizedBox(
                  height: 0.3.sh,
                ),


                SizedBox(
                  height: 10.h,
                ),
                GetOtpButton(
                  buttonLabel:"Get OTP",
                  buttonAction: () async {
                    final phoneNumber = _phoneNumController.text;
                    Provider.of<SaveUserProvider>(context, listen: false)
                        .updateUserData(UserData(phoneNo: phoneNumber));

                    if (_formKey.currentState!.validate()) {
                      try {
                        setState(() {
                          _isOtpRequest = true;
                        });

                        await verifyUserPhoneNumber();

                        // await AuthService.getOtp(
                        //     phoneNum: _phoneNumController.text);
                        // setState(() {
                        //   _isOtpRequest = false;
                        // });
                        //
                        // if (context.mounted) {
                        //   Navigator.pushNamed(context, '/otpInput');
                        // }
                      } catch (e) {
                        CustomSnackBar.showSnackBar(
                            context,"OTP request failed",);
                      } finally {}
                    }
                  },
                  enabled:true,
                  isLoading: _isOtpRequest,
                ),
                SizedBox(height: 15.h),
                CustomBackButton(
                  buttonAction: () {
                    Navigator.pop(context);
                  },
                  buttonLabel: "Back",
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    ).withUnFocusGestureDetector(context);
  }

  @override
  void dispose() {
    _phoneNumController.dispose();
    super.dispose();
  }
}
