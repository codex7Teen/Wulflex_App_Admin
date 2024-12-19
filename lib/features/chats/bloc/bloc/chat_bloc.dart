import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:wulflex_admin/data/services/chat_services.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatServices _chatServices;
  static const String adminId = 'administratorIDofwulflex189';
  ChatBloc(this._chatServices) : super(ChatInitial()) {
      //! GET ALL USER CHATS
    on<GetAllUserChats>((event, emit) async {
      try {
        emit(ChatLoading());
        // Get the stream directly from services
        final usersStream = _chatServices.getUsersStream();
        emit(ChatLoaded(usersStream: usersStream));
      } catch (error) {
        emit(ChatError(errorMessage: error.toString()));
      }
    });
    
    //! SEND MESSAGE BLOC
    on<SendMessage>((event, emit) async {
      try {
        await _chatServices.sendMessage(event.receiverId, event.message);
        log('BLOC: MESSAGE SENT SUCCESS');
      } catch (error) {
        emit(ChatError(errorMessage: error.toString()));
      }
    });

    //! GET MESSAGE BLOC
    on<GetMessages>((event, emit) async {
      try {
        final messagesStream =
            _chatServices.getMessages(adminId, event.otherUserId);
        emit(MessagesLoaded(messages: messagesStream));
      } catch (error) {
        emit(ChatError(errorMessage: error.toString()));
      }
    });
  }
}
