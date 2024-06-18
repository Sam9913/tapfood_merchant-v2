import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:tapfood_v2/model/Order.dart';
import 'package:tapfood_v2/model/OrderDetail.dart';
import 'package:tapfood_v2/services/OrderServices.dart';

class OrderProvider extends ChangeNotifier {
  List<Order> _normalOrderList = [];
  List<Order> _scheduledOrderList = [];
  List<Order> _completedOrderList = [];
  int _preparingOrderCount = 0;
  int _upcomingOrderCount = 0;
  late OrderDetail _orderDetail;
  late Order _orderItem;
  final List<bool> _isLoading = [false, false, false];
  Courier _courier = Courier();
  Courier get courier => _courier;
  OrderDetail get orderDetail => _orderDetail;
  List<Order> get normalOrderList => _normalOrderList;
  List<Order> get scheduledOrderList => _scheduledOrderList;
  List<Order> get completedOrderList => _completedOrderList;
  Order get orderItem => _orderItem;
  int get preparingOrderCount => _preparingOrderCount;
  int get upcomingOrderCount => _upcomingOrderCount;
  List<bool> get isLoading => _isLoading;
  OrderServices orderServices = OrderServices();

  setIsLoading(int index, bool isLoading) async {
    _isLoading[index] = isLoading;
    notifyListeners();
  }

  Future<bool> getNormalOrder() async {
    try {
      final normalOrderList = await orderServices.getAll(0);

      _normalOrderList = normalOrderList.reversed.toList();
      _preparingOrderCount = _normalOrderList.length;
      _isLoading[0] = false;

      notifyListeners();
      return true;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> getScheduledOrder() async {
    try {
      final scheduledOrderList = await orderServices.getAll(2);

      if (_scheduledOrderList != scheduledOrderList) {
        _scheduledOrderList = scheduledOrderList.reversed.toList();
        _upcomingOrderCount = _scheduledOrderList.length;
      }
      _isLoading[2] = false;

      notifyListeners();
      return true;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> getCompletedOrder() async {
    try {
      final completedOrderList = await orderServices.getCompletedOrder();

      if (completedOrderList != _completedOrderList) {
        _completedOrderList = completedOrderList.reversed.toList();
      }
      _isLoading[1] = false;

      notifyListeners();
      return true;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> getOrderDetail(int orderId) async {
    try {
      _orderDetail = await orderServices.getDetailById(orderId);
      _orderItem = await orderServices.getById(orderId);

      if (_orderItem.orderPreference == 2) {
        _courier = await orderServices.getCourierById(orderId);
      }

      notifyListeners();
      return true;
    } catch (error) {
      rethrow;
    }
  }

  Future<OrderDetail> returnOrderDetail(int orderId) async {
    try {
      OrderDetail orderDetail = await orderServices.getDetailById(orderId);

      notifyListeners();
      return orderDetail;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> updateOrderStatus(int orderId) async {
    bool isSuccess = false;

    try {
      isSuccess = await orderServices.updateOrderStatus(1, orderId);

      notifyListeners();
      return isSuccess;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> updatePaymentStatus(int orderId) async {
    bool isSuccess = false;

    try {
      isSuccess = await orderServices.updateOrderPaymentStatus(1, orderId);

      notifyListeners();
      return isSuccess;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> cancelOrder(int orderId) async {
    bool isSuccess = false;

    try {
      isSuccess = await orderServices.cancelOrder(orderId);
      final normalOrderList = await orderServices.getAll(0);
      _normalOrderList = normalOrderList.reversed.toList();

      notifyListeners();
      return isSuccess;
    } catch (error) {
      rethrow;
    }
  }
}
