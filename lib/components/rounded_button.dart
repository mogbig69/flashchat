import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({this.inColor, this.inTitle, @required this.onPressed});
  final Color inColor;
  final String inTitle;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: inColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(inTitle, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
