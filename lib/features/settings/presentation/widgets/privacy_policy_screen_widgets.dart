import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminPrivacyPolicyScreenWidgets {
  static PreferredSizeWidget buildAppbar() {
    return AppBar(
      title: const Text('Privacy Policy - Admin'),
      centerTitle: true,
      backgroundColor: Colors.transparent,
    );
  }

  static Widget buildPrivacyPolicyContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Privacy Policy for Wulflex Admin',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          'Effective Date: January 2, 2025',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 20),
        _buildSectionTitle('1. Information We Collect'),
        const Text(
          'As an admin, the following information is collected and managed:'
          '- Product Information: Details of products added, edited, or deleted.'
          '- Category Information: Categories added, edited, or removed.'
          '- User Reviews: Reviews managed and responded to.'
          '- User Details: Emails of registered users for communication.'
          '- Chat Communication: Messages exchanged with users.'
          '- Order Information: Status updates managed and notifications sent.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 20),
        _buildSectionTitle('2. How We Use This Information'),
        const Text(
          '- To manage products and categories in the app.'
          '- To respond to and moderate user reviews.'
          '- To communicate with users via chat.'
          '- To mark and update order statuses and notify users.'
          '- To improve the functionality of the Wulflex platform.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 20),
        _buildSectionTitle('3. Data Security'),
        const Text(
          'We prioritize securing the information you manage. Sensitive user data such as payment information is handled by Razorpay, ensuring maximum security. Notifications are sent using Firebase Cloud Messaging (FCM) and Flutter Local Notifications.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 20),
        _buildSectionTitle('4. Third-Party Services'),
        const Text(
          'The app integrates third-party services like Razorpay for payments, Firebase Cloud Messaging for notifications, and Firebase for chat functionality. These services have independent privacy policies.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 20),
        _buildSectionTitle('5. Admin Responsibilities'),
        const Text(
          '- Ensure all actions performed in the app comply with the Privacy Policy.'
          '- Protect user data and maintain confidentiality.'
          '- Avoid unauthorized sharing or misuse of user information.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 20),
        _buildSectionTitle('6. Changes to this Privacy Policy'),
        const Text(
          'We reserve the right to update this Privacy Policy at any time. Please review it periodically for any changes.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 20),
        _buildSectionTitle('Contact Us'),
        const Text(
          'If you have any questions or concerns about this Privacy Policy, please contact us at:',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () async {
            final Uri emailLaunchUri = Uri(
              scheme: 'mailto',
              path: 'djconnect189@gmail.com',
            );
            if (await canLaunchUrl(emailLaunchUri)) {
              await launchUrl(emailLaunchUri);
            } else {
              throw Exception('Could not launch $emailLaunchUri');
            }
          },
          child: const Text(
            'djconnect189@gmail.com',
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}
