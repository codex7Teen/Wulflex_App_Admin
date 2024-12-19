import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/features/chats/bloc/bloc/chat_bloc.dart';
import 'package:wulflex_admin/shared/widgets/appbar_with_back_button_widget.dart';

class ScreenUserChat extends StatelessWidget {
  final String recieverID;
  final String recieverEmail;
  final String? userImageUrl;
  ScreenUserChat(
      {super.key,
      required this.recieverEmail,
      required this.recieverID,
      required this.userImageUrl});

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.read<ChatBloc>().add(GetMessages(otherUserId: recieverID));
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppbarWithbackbuttonWidget(appBarTitle: recieverEmail),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ChatError) {
            return Center(child: Text('Chat fetch error'));
          } else if (state is MessagesLoaded) {
            return Column(
              children: [
                // Messages List
                Expanded(
                  child: StreamBuilder(
                    stream: state.messages,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ListView(
                        children: snapshot.data!.docs.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return MessageBubble(
                            timeStamp: data['timestamp'],
                            userImage: userImageUrl ?? '',
                            message: data['message'],
                            isMe: data['senderID'] ==
                                'administratorIDofwulflex189',
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
                Divider(thickness: 1, color: AppColors.lightGreyThemeColor),
                //! Message input
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            focusedBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            disabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: 'Type a message...',
                          ),
                          onSubmitted: (message) {
                            context.read<ChatBloc>().add(
                                  SendMessage(
                                    receiverId: recieverID,
                                    message: message,
                                  ),
                                );
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          // Handle send button press
                          if (_messageController.text.isNotEmpty) {
                            // send the message
                            context.read<ChatBloc>().add(SendMessage(
                                receiverId: recieverID,
                                message: _messageController.text));
                            // clear the textfiels
                            _messageController.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Center(child: Text('Network error'));
        },
      ),
    );
  }
}

//! Messages bubble widget
class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String userImage;
  final Timestamp timeStamp;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.userImage,
    required this.timeStamp,
  });

  String _formatDateTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String period = dateTime.hour >= 12 ? 'PM' : 'AM';
    int hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    hour = hour == 0 ? 12 : hour;
    String minute = dateTime.minute.toString().padLeft(2, '0');

    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    String month = months[dateTime.month - 1];

    return "$month ${dateTime.day}, $hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue : Colors.grey[300],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: isMe ? Radius.circular(15) : Radius.circular(0),
                bottomRight: isMe ? Radius.circular(0) : Radius.circular(15),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isMe && userImage.isNotEmpty)
                  CircleAvatar(
                    radius: 11,
                    backgroundImage: NetworkImage(userImage),
                  ),
                if (!isMe) const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                isMe
                    ? Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Image.asset(
                          'assets/wulflex_logo_nobg.png',
                          width: 20,
                          height: 20,
                        ),
                      )
                    : SizedBox(width: 8)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              _formatDateTime(timeStamp),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(height: 8)
        ],
      ),
    );
  }
}
