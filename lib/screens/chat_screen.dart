//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
//import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool showSpinner = false;
  User loggedInUser;
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
//                _auth.signOut();
                print('B4 messagesStream');
                messagesStream();
                setState(() {
                  this.showSpinner = false;
                });
//                Navigator.pushNamed(context, WelcomeScreen.id);
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
              StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('messages').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final messages = snapshot.data.docs;
                      print(messages.length);
                      List<Text> messageWidgets = [];
                      for (var message in messages) {
                        final messageText = message['text'];
                        final messageSender = message['sender'];
                        final messageWidget = Text('$messageText from $messageSender');
                        messageWidgets.add(messageWidget);
                      }
                      messageWidgets.add(Text('End of Message'));
                      print(messageWidgets.length);
                      return Column(
                        children: messageWidgets,
                      );
                    } else {
                      print('No data found in snapshot');
                      return Center(
                          child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                        strokeWidth: 10,
                      ));
                    }
                  }),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          messageText = value;
                          print(messageText);
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        print('onPressed');
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
