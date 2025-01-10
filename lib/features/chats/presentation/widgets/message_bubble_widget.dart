//! Messages bubble widget
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/core/config/text_styles.dart';

class MessageBubbleWidget extends StatelessWidget {
  final String message;
  final bool isMe;
  final String userImage;
  final Timestamp timeStamp;

  const MessageBubbleWidget({
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
                    ? AppColors.blueThemeColor.withValues(alpha: 0.95)
                    : AppColors.lightGreyThemeColor.withValues(alpha: 0.95),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isMe ? 18 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
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
