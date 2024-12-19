import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wulflex_admin/data/models/message_model.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //! GET USER STREAM
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // go through each individual user
        final user = doc.data();

        // return user
        return user;
      }).toList();
    });
  }

  //! SEND A MESSAGE
  Future<void> sendMessage(String recieverID, message) async {
    // get admin info
    const String adminID = 'administratorIDofwulflex189';
    const String adminEmail = 'administrator189@gmail.com';
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    MessageModel newMessage = MessageModel(
        senderID: adminID,
        senderEmail: adminEmail,
        recieverID: recieverID,
        message: message,
        timestamp: timestamp);

    // construct chat room ID for storing messages
    List<String> ids = [adminID, recieverID];
    ids.sort(); // sort the ids (this ensure the chatroomID is the same for any 2 people)
    String chatRoomID = ids.join('_');

    // add new message to database
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .add(newMessage.toMap());
    log('SERVICES: MESSAGE SENT SUCCESS');
  }

  //! GET MESSAGES

  Stream<QuerySnapshot> getMessages(String adminID, String otherUserID) {
    // construct a chatroom id for two users
    List<String> ids = [adminID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
