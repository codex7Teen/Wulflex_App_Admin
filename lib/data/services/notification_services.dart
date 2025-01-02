import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:wulflex_admin/data/services/get_server_key.dart';

class NotificationServices {
  Future<bool> pushNotifications({required String title, body, token}) async {
    try {
      final serverKeyToken = await GetServerKey().getServerKeyToken();

      // Using the FCM v1 API endpoint
      final url = Uri.parse(
          'https://fcm.googleapis.com/v1/projects/wulflex/messages:send');

      Map<String, dynamic> payload = {
        'message': {
          'token': token,
          'notification': {'title': title, 'body': body},
          'android': {
            'priority': 'high',
            'notification': {'sound': 'default'}
          }
        }
      };

      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $serverKeyToken'
          },
          body: jsonEncode(payload));

      if (response.statusCode == 200) {
        debugPrint('Notification sent successfully');
        return true;
      } else {
        debugPrint('Failed to send notification: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Error sending notification: $e');
      return false;
    }
  }
}
