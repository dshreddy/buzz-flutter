import 'package:buzz/screens/forgot_password.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:buzz/constants.dart';
import 'package:buzz/screens/chat.dart';
import 'package:buzz/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = "login_screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? emailAddress;
  String? password;
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

                // Logo
                const Flexible(
                  child: Image(
                    height: logoHeight,
                    image: AssetImage("assets/images/favicon.png"),
                  ),
                ),
                const SizedBox(height: gap),

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

                //Password
                Flexible(
                  child: SizedBox(
                    width: fieldSize,
                    child: Material(
                      borderRadius: BorderRadius.circular(30),
                      elevation: 5,
                      color: Colors.white,
                      child: TextField(
                        obscureText: true,
                        decoration:
                            kTextFieldDecoration.copyWith(hintText: "Password"),
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                    ),
                  ),
                ),

                // Login button
                CustomButton(
                  buttonText: 'Login',
                  onPressed: () async {
                    if (emailAddress == null) {
                      alert("USERNAME IS NULL");
                      return;
                    }
                    if (password == null) {
                      alert("PASSWORD IS NULL");
                      return;
                    }
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: emailAddress!, password: password!);
                      Navigator.pushNamed(context, ChatScreen.id);
                    } catch (e) {
                      alert(e.toString());
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  },
                ),

                //Don't have an account text
                Flexible(
                  child: Row(
                    children: <Widget>[
                      const Expanded(child: SizedBox()),
                      const Text(
                        "Don't have an account ?",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, SignUpScreen.id);
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                            decorationThickness: 0.5,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue,
                          ),
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ),

                // Forgot password text
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, ForgotPasswordScreen.id);
                  },
                  child: const Text(
                    "Forgot my password",
                    style: TextStyle(
                      color: Colors.grey,
                      decorationThickness: 0.8,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.grey,
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void alert(String desc) {
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
