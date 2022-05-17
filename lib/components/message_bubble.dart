import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble({this.inSender, this.inText, this.isMe});
  final String inSender;
  final String inText;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: <Widget>[
        Text(
          inSender,
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.black54,
          ),
        ),
        Material(
          borderRadius: isMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                )
              : BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
          elevation: 5.0,
          color: isMe ? Colors.white : Colors.lightBlueAccent,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Text(inText,
                style: TextStyle(
                  fontSize: 12.0,
                  color: isMe ? Colors.black54 : Colors.white,
                )),
          ),
        ),
      ]),
    );
  }
}
