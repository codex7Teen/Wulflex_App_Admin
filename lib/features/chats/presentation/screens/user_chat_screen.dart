import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/features/chats/bloc/bloc/chat_bloc.dart';
import 'package:wulflex_admin/features/chats/presentation/widgets/message_bubble_widget.dart';
import 'package:wulflex_admin/features/chats/presentation/widgets/user_chat_screen_widgets.dart';
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
  FocusNode myFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

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
                //! MESSAGES LIST
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
                            child: MessageBubbleWidget(
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
                //! MESSAGE INPUT
                UserChatScreenWidgets.buildMessageInputField(context,
                    myFocusNode, _messageController, widget.recieverID),
              ],
            );
          }
          return Center(child: Text('Network error'));
        },
      ),
    );
  }
}
