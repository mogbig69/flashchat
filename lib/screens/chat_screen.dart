//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/message_bubble.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String messageText;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    loggedInUser = user;
    print('getCurrentUser is $loggedInUser');
  }

  void getMessages() async {
    final querySnapshot = await _firestore.collection('messages').get();
    print(querySnapshot);
    print(querySnapshot.size);
    for (var message in querySnapshot.docs) {
      var data = message.data();
      print(data.toString());
    }
  }

  void messagesStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        var data = message.data();
        final mySender = data['sender'];
        final myText = data['text'];
        print('Sender = $mySender and Text = $myText');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  this.showSpinner = true;
                });
                _auth.signOut();
                print('B4 messagesStream');
                messagesStream();
                setState(() {
                  this.showSpinner = false;
                });
                Navigator.pushNamed(context, WelcomeScreen.id);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          progressIndicator: CircularProgressIndicator(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MessagesStream(),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageTextController,
                        onChanged: (value) {
                          messageText = value;
                          print(messageText);
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        messageTextController.clear();
                        try {
                          _firestore.collection('messages').add({
                            'text': messageText,
                            'sender': loggedInUser.email,
                          });
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text(
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
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isMe = false;
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data.docs;
            print(messages.length);
            List<MessageBubble> messageBubbles = [];
            for (var message in messages) {
              final String messageText = message['text'];
              final String messageSender = message['sender'];
              final currentUser = loggedInUser.email;
              if (currentUser == messageSender) {
                isMe = true;
              } else {
                isMe = false;
              }
              if (!isMe) {}
              print('Current User is $currentUser');
              final messageBubble = MessageBubble(inSender: messageSender, inText: messageText, isMe: isMe);
              messageBubbles.add(
                messageBubble,
              );
            }
            return Expanded(
              child: ListView(
                reverse: true,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                children: messageBubbles,
              ),
            );
          } else {
            print('No data found in snapshot');
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
              strokeWidth: 10,
            ));
          }
        });
  }
}
