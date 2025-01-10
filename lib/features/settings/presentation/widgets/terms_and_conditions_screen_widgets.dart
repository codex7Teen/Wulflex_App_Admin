import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminTermsAndConditionsScreenWidgets {
  static PreferredSizeWidget buildAppbar() {
    return AppBar(
      title: const Text('Terms and Conditions - Admin'),
      centerTitle: true,
      backgroundColor: Colors.transparent,
    );
  }

  static Widget buildTermsAndConditionsContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Terms and Conditions for Wulflex Admin',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          'Effective Date: January 2, 2025',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 20),
        _buildSectionTitle('1. Admin Login Credentials'),
        const Text(
          'The administrator can log in to the app using the unique administrator ID and password provided by the developer. These credentials should be kept secure and confidential.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 20),
        _buildSectionTitle('2. Managing Products'),
        const Text(
          'The admin can perform the following actions:'
          '- Add new products.'
          '- Edit existing product details.'
          '- Update product inventory or status.'
          '- Delete products when required.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 20),
        _buildSectionTitle('3. Managing Categories'),
        const Text(
          'Admins can manage categories as follows:'
          '- Add custom categories.'
          '- Edit custom category details.'
          '- Delete custom categories. Note: Deleting a custom category will also delete all the products within that category.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 20),
        _buildSectionTitle('4. Managing Orders'),
        const Text(
          'The admin can update the order status, including marking orders as Delivered, Canceled, or Processing. Notifications will be sent to the respective users via Firebase Cloud Messaging (FCM) when an order status is updated.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 20),
        _buildSectionTitle('5. Communication with Users'),
        const Text(
          'Admins can communicate with individual users via chat. This feature allows for addressing user queries or resolving issues effectively.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 20),
        _buildSectionTitle('6. Viewing User Reviews'),
        const Text(
          'Admins can view user reviews for products. This helps in understanding user feedback and improving the overall service quality.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 20),
        _buildSectionTitle('7. Admin Settings'),
        const Text(
          'Admins have access to the settings section, which includes the option to log out securely from the application.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 20),
        _buildSectionTitle('8. General Conditions'),
        const Text(
          '- Admin actions must comply with the app’s policies and guidelines.'
          '- Unauthorized sharing or misuse of data is strictly prohibited.'
          '- Ensure regular communication with the app developer for any technical support.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 20),
        _buildSectionTitle('9. Changes to Terms and Conditions'),
        const Text(
          'These terms and conditions may be updated from time to time. Admins are encouraged to review them periodically to stay informed of any changes.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 20),
        _buildSectionTitle('Contact Us'),
        const Text(
          'For any queries regarding these terms and conditions, please contact the developer at:',
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
