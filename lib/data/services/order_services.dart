import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wulflex_admin/data/models/order_model.dart';
import 'package:wulflex_admin/data/services/notification_services.dart';

class OrderServices {
  final _firestore = FirebaseFirestore.instance;
  final _notificationServices = NotificationServices();

  //! FETCH ALL ORDERS
  Future<List<OrderModel>> fetchAllOrders() async {
    try {
      final orderSnapshot = await _firestore
          .collection('orders')
          .orderBy('orderDate', descending: true)
          .get();

      final allOrders = orderSnapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data(), documentId: doc.id))
          .toList();

      log('ADMIN SERVICES: FETCHED ${allOrders.length} ORDERS');
      return allOrders;
    } catch (error) {
      log('ADMIN SERVICES: Error fetching orders - $error');
      rethrow;
    }
  }

  //! UPDATE ORDER STATUS
  Future<void> updateOrderStatus(
      {required String orderId, required OrderStatus newStatus}) async {
    try {
      await _firestore.collection('orders').doc(orderId).update(
          {'status': newStatus.toString(), 'updatedAt': DateTime.now()});
      // SENDING NOTIFICATION USING FCM
      // Get user ID from order
      final orderDoc = await _firestore.collection('orders').doc(orderId).get();
      final userId = orderDoc.data()?['userId'];

      if (userId != null) {
        // Get users FCM token
        final userDoc = await _firestore.collection('users').doc(userId).get();
        final fcmToken = userDoc.data()?['notification_token'];
        final userName = userDoc.data()?['name'] ?? 'Customer';

        if (fcmToken != null) {
          // Send push notification
          const title = '🛍️ Order Update Alert!';
          final body = '''

Hi $userName,
Your order #$orderId has been ${newStatus.name} ...${newStatus == OrderStatus.cancelled ? '' : ' 🎉🎉🎉'}

Thank you for shopping with us! 💖
Wulflex Team
        ''';

          // Send push notification
          await _notificationServices.pushNotifications(
              title: title, body: body, token: fcmToken);
          log('ADMIN SERVICES: Notification sent for order $orderId');
        }
      }

      log('ADMIN SERVICES: Updated order $orderId status to $newStatus');
    } catch (error) {
      log('ADMIN SERVICES: Error updating order status - $error');
      rethrow;
    }
  }

  //! FILTER ORDERS BY STATUS
  Future<List<OrderModel>> filterOrdersByStatus(OrderStatus status) async {
    try {
      final orderSnapshot = await _firestore
          .collection('orders')
          .where('status', isEqualTo: status.toString())
          .orderBy('orderDate', descending: true)
          .get();

      final filteredOrders = orderSnapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data(), documentId: doc.id))
          .toList();

      log('ADMIN SERVICES: Fetched ${filteredOrders.length} orders with status $status');
      return filteredOrders;
    } catch (e) {
      log('ADMIN SERVICES: Error filtering orders - $e');
      rethrow;
    }
  }
}
