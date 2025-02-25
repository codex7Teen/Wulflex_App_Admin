import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderID;
  final String senderEmail;
  final String recieverID;
  final String message;
  final Timestamp timestamp;

  MessageModel(
      {required this.senderID,
      required this.senderEmail,
      required this.recieverID,
      required this.message,
      required this.timestamp});

  // convert ot map
  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'recieverID': recieverID,
      'message': message,
      'timestamp': timestamp
    };
  }
}
