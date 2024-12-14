import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wulflex_admin/data/models/order_model.dart';

class OrderServices {
  final _firestore = FirebaseFirestore.instance;

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
