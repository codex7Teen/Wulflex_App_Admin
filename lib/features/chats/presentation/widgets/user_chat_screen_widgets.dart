import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wulflex_admin/core/config/text_styles.dart';
import 'package:wulflex_admin/features/chats/bloc/bloc/chat_bloc.dart';

class UserChatScreenWidgets {
  static Widget buildMessageInputField(
      BuildContext context,
      FocusNode myFocusNode,
      TextEditingController messageController,
      String recieverID) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                focusNode: myFocusNode,
                style: AppTextStyles.chatTextfieldstyle,
                controller: messageController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type a message...',
                  hintStyle: AppTextStyles.chatHintText,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                ),
                onSubmitted: (message) {
                  context.read<ChatBloc>().add(SendMessage(
                        receiverId: recieverID,
                        message: message,
                      ));
                  messageController.clear();
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  if (messageController.text.isNotEmpty) {
                    context.read<ChatBloc>().add(SendMessage(
                        receiverId: recieverID,
                        message: messageController.text));
                    messageController.clear();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
