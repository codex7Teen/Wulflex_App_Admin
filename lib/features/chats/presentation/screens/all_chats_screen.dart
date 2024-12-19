import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/core/config/text_styles.dart';
import 'package:wulflex_admin/features/chats/bloc/bloc/chat_bloc.dart';
import 'package:wulflex_admin/features/chats/presentation/screens/user_chat_screen.dart';
import 'package:wulflex_admin/shared/widgets/navigation_helper_widget.dart';

class ScreenAllChats extends StatelessWidget {
  const ScreenAllChats({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger loading of chats
    context.read<ChatBloc>().add(GetAllUserChats());

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: BlocBuilder<ChatBloc, ChatState>(
        buildWhen: (previous, current) {
          // Build when the state is either ChatLoaded or in loading/error states
          // Ignore MessagesLoaded state
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
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: userChats.length,
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 10);
                          },
                          itemBuilder: (context, index) {
                            final user = userChats[index];
                            return UserChatTile(user: user);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Network error. Turn on network'));
        },
      ),
    );
  }
}

class UserChatTile extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserChatTile({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => NavigationHelper.navigateToWithoutReplacement(
        context,
        ScreenUserChat(
          recieverEmail: user['email'],
          recieverID: user['uid'],
          userImageUrl: user['userImage'],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.lightGreyThemeColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            UserAvatar(imageUrl: user['userImage']),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                user['email'].toString().toUpperCase(),
                style: AppTextStyles.contentTitleTexts,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.message,
              color: AppColors.greyThemeColor,
              size: 18,
            )
          ],
        ),
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  final String? imageUrl;

  const UserAvatar({
    super.key,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: SizedBox(
        width: 30,
        height: 30,
        child: imageUrl != null
            ? CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: imageUrl!,
                placeholder: (context, url) => _buildPlaceholderImage(),
                errorWidget: (context, url, error) => _buildPlaceholderImage(),
              )
            : _buildPlaceholderImage(),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Image.asset(
      'assets/wulflex_logo_nobg.png',
      width: 28,
      height: 28,
    );
  }
}
