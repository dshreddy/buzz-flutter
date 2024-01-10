import 'package:buzz/screens/chat.dart';
import 'package:buzz/screens/forgot_password.dart';
import 'package:buzz/screens/login.dart';
import 'package:buzz/screens/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'buzz',
      initialRoute: LoginScreen.id,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        SignUpScreen.id: (context) => SignUpScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        ForgotPasswordScreen.id: (context) => ForgotPasswordScreen(),
      },
    );
  }
}
