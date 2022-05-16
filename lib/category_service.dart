import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/message_format.dart';

class MessageService {
  FirebaseFirestore _instance;

  List<MyMessageFormat> _MyMessages = [];

  List<MyMessageFormat> getMyMessages() {
    return _MyMessages;
  }

  Future<void> getMyMessagesCollectionFromFirebase() async {
    _instance = FirebaseFirestore.instance;
    final querySnapshot = await _instance.collection('messages').get();
    var data = querySnapshot.docs as List<dynamic>;
  }
}
