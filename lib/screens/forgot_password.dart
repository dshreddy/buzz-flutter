import 'dart:io';

import 'package:buzz/screens/login.dart';
import 'package:buzz/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../constants.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  static String id = "forgot_password";

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String? emailAddress;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: <Widget>[
                const Expanded(child: SizedBox()),
                // Email
                Flexible(
                  child: SizedBox(
                    width: fieldSize,
                    child: Material(
                      borderRadius: BorderRadius.circular(30),
                      elevation: 5,
                      color: Colors.white,
                      child: TextField(
                        decoration:
                            kTextFieldDecoration.copyWith(hintText: "Email"),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          emailAddress = value;
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: gap),
                CustomButton(
                  buttonText: "Send mail",
                  onPressed: () async {
                    if (emailAddress == null) {
                      alert("Email Address is null", context);
                      return;
                    }
                    setState(() {
                      showSpinner = true;
                    });
                    bool success = true;
                    try {
                      var _ = await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: emailAddress!);
                    } catch (e) {
                      success = false;
                      alert(e.toString(), context);
                    }
                    setState(() {
                      showSpinner = false;
                    });
                    if (success) {
                      alert("Reset link is sent to your mail", context);
                    }
                  },
                ),
                const SizedBox(height: gap),
                CustomButton(
                  buttonText: "Go back",
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void alert(String desc, context) {
    Alert(
      style: const AlertStyle(
        backgroundColor: Colors.orangeAccent,
        descStyle: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontFamily: 'Overpass',
          fontWeight: FontWeight.w700,
        ),
      ),
      context: context,
      desc: desc,
      buttons: [
        DialogButton(
            color: Colors.white,
            child: const Text(
              "OK",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    ).show();
  }
}
