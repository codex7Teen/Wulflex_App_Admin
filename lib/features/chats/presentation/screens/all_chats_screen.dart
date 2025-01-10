import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/features/chats/bloc/bloc/chat_bloc.dart';
import 'package:wulflex_admin/features/chats/presentation/widgets/all_chats_screen_widgets.dart';

class ScreenAllChats extends StatelessWidget {
  const ScreenAllChats({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ChatBloc>().add(GetAllUserChats());
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: BlocBuilder<ChatBloc, ChatState>(
        buildWhen: (previous, current) {
          // Build when the state is either ChatLoaded or in loading/error states
          // Ignore MessagesLoaded state by listening to only these states
          return current is ChatLoading ||
              current is ChatLoaded ||
              current is ChatError;
        },
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatError) {
            return Center(child: Text(state.errorMessage));
          } else if (state is ChatLoaded) {
            return StreamBuilder<List<Map<String, dynamic>>>(
              stream: state.usersStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No users found'));
                }

                // Filter out admin from the chat list
                final userChats = snapshot.data!
                    .where(
                        (user) => user['email'] != 'administrator189@gmail.com')
                    .toList();

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 18),
                    child: Column(
                      children: [
                        AllChatsScreenWidgets.buildUserChatsList(userChats),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Network error. Please retry'));
        },
      ),
    );
  }
}
