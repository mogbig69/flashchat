import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinnner = false;
  String inEmail;
  String inPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinnner,
        progressIndicator: CircularProgressIndicator(),
        child: ListView(scrollDirection: Axis.vertical, shrinkWrap: true, children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                TextField(
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      inEmail = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email')),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      inPassword = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password')),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                    inTitle: 'Log in',
                    inColor: Colors.lightBlueAccent,
                    onPressed: () async {
                      print('email = $inEmail');
                      print('password = $inPassword');
                      setState(() {
                        showSpinnner = true;
                      });
                      try {
                        final credential = await _auth.signInWithEmailAndPassword(email: inEmail, password: inPassword);
                        if (credential != null) {
                          Navigator.pushNamed(context, ChatScreen.id);
                          setState(() {
                            showSpinnner = false;
                          });
                        }
                      } catch (e) {
                        if (e.code == 'user-not-found') {
                          print('Not a user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          print('Wrong password provided for that user.');
                        } else {
                          print('Unknown error = ${e.code}');
                        }
                        setState(() {
                          showSpinnner = false;
                        });
                      }
                    }),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
