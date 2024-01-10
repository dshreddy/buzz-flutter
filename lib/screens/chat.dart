import 'package:buzz/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/message_box.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  static String id = "chat_screen";

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textController = TextEditingController();
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  User? loggedInUser = FirebaseAuth.instance.currentUser;
  String? typedMessage;

  @override
  void initState() {
    super.initState();
    if (loggedInUser == null) {
      Navigator.pushNamed(context, LoginScreen.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const Image(image: AssetImage("assets/images/favicon.png")),
        actions: [
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pushNamed(context, LoginScreen.id);
              }),
        ],
        backgroundColor: Colors.orangeAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Widget> messages = [];
                  for (var message in snapshot.data!.docs) {
                    messages.add(MessageBox(
                      sender: message.data()["sender"],
                      text: message.data()["text"],
                      isMe: (loggedInUser?.email == message.data()["sender"]),
                    ));
                  }
                  return Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      children: messages,
                    ),
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textController,
                      onChanged: (value) {
                        typedMessage = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //Implement send functionality.
                      textController.clear();
                      FirebaseFirestore.instance.collection("messages").add({
                        'text': typedMessage,
                        'sender': loggedInUser?.email,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
