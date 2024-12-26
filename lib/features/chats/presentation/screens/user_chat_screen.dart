import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/core/config/text_styles.dart';
import 'package:wulflex_admin/features/chats/bloc/bloc/chat_bloc.dart';
import 'package:wulflex_admin/shared/widgets/appbar_with_back_button_widget.dart';

class ScreenUserChat extends StatefulWidget {
  final String recieverID;
  final String recieverEmail;
  final String? userImageUrl;
  ScreenUserChat(
      {super.key,
      required this.recieverEmail,
      required this.recieverID,
      required this.userImageUrl});

  @override
  State<ScreenUserChat> createState() => _ScreenUserChatState();
}

class _ScreenUserChatState extends State<ScreenUserChat> {
  final TextEditingController _messageController = TextEditingController();

  // for textfield focus
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // add listener to focus node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        // cause a delay so the keyboard has time to show up
        // then the amount of remaining space will be calculated
        // then scroll down
        Future.delayed(Duration(milliseconds: 400), () => scrollDown());
      }
    });
  }

  // scroll controller
  final ScrollController _scrollController = ScrollController();

// function to scroll to maxextent
  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<ChatBloc>().add(GetMessages(otherUserId: widget.recieverID));
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppbarWithbackbuttonWidget(appBarTitle: widget.recieverEmail),
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
                      if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                        return Center(
                            child: Text('Start sending messages... 💬💬'));
                      }
                      // Scroll down when new data arrives
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Future.delayed(Duration(milliseconds: 400), () {
                          scrollDown();
                        });
                      });
                      return ListView(
                        controller: _scrollController,
                        children: snapshot.data!.docs.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return SlideInRight(
                            child: MessageBubble(
                              timeStamp: data['timestamp'],
                              userImage: widget.userImageUrl ?? '',
                              message: data['message'],
                              isMe: data['senderID'] ==
                                  'administratorIDofwulflex189',
                            ),
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
                      const EdgeInsets.only(left: 12, right: 12, bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
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
                            controller: _messageController,
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
                                    receiverId: widget.recieverID,
                                    message: message,
                                  ));
                              _messageController.clear();
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
                              if (_messageController.text.isNotEmpty) {
                                context.read<ChatBloc>().add(SendMessage(
                                    receiverId: widget.recieverID,
                                    message: _messageController.text));
                                _messageController.clear();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
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
      child: Padding(
        padding: EdgeInsets.only(
          left: isMe ? 60 : 16,
          right: isMe ? 16 : 60,
          bottom: 4,
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe
                    ? AppColors.blueThemeColor.withOpacity(0.95)
                    : AppColors.lightGreyThemeColor.withOpacity(0.95),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isMe ? 18 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (!isMe && userImage.isNotEmpty) ...[
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.lightGreyThemeColor,
                            width: 1.5,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 11,
                          backgroundImage: NetworkImage(userImage),
                        ),
                      ),
                    ],
                    Flexible(
                      child: Text(
                        message,
                        style: AppTextStyles.chatBubbleText(isMe),
                      ),
                    ),
                    if (isMe) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Image.asset(
                          'assets/wulflex_logo_nobg.png',
                          width: 20,
                          height: 20,
                          color: isMe
                              ? AppColors.whiteThemeColor
                              : AppColors.blackThemeColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 4,
                left: 4,
                right: 4,
                bottom: 2,
              ),
              child: Text(
                _formatDateTime(timeStamp),
                style: AppTextStyles.chatBubbleDateTimeText.copyWith(
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
