import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
                    height: 220.0,
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
                    decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Password')),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                    inTitle: 'Register',
                    inColor: Colors.blueAccent,
                    onPressed: () async {
                      print('email = $inEmail');
                      print('password = $inPassword');
                      try {
                        setState(() {
                          showSpinnner = true;
                        });
                        final newUser = await _auth.createUserWithEmailAndPassword(email: inEmail, password: inPassword);
                        if (newUser != null) {
                          Navigator.pushNamed(context, ChatScreen.id);
                        }
                      } catch (e) {
                        print(e);
                      }
                      setState(() {
                        showSpinnner = false;
                      });
                    }),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
