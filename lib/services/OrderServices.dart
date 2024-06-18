import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:tapfood_v2/config/appConfig.dart';
import 'package:tapfood_v2/model/Order.dart';
import 'package:tapfood_v2/model/OrderDetail.dart';
import 'package:tapfood_v2/utils/apiHelper.dart';

class OrderServices {
	late Response response;
	Config config = Config();
	ApiHelper apiHelper = ApiHelper(Config().baseUrl);

	Future<List<Order>> getAll(int orderStatus) async {
		List<Order> orderList = [];

		try {
			response = await apiHelper.get('order/getByStatus/$orderStatus');

			if (response.data != null) {
				response.data.forEach(
								(e) => {orderList.add(Order.fromJson(e))});
			}
		} catch (e) {
			rethrow;
		}
		return orderList;
	}

	Future<Order> getById(int orderId) async {
		late Order order;

		try {
			response = await apiHelper.get('order/getById/$orderId');

			if (response.data != null) {
				order = Order.fromJson(response.data);
			}
		} catch (e) {
			rethrow;
		}
		return order;
	}

	Future<bool> updateOrderStatus(int status, int id) async{
		bool isSuccess = false;
		try {
			response = await apiHelper.post('order/updateStatus', data: {
				"status": status,
				"id": id
			});

			if (response.statusCode == 200) {
				isSuccess = true;
			}
		} catch (e) {
			isSuccess = false;
		}

		return isSuccess;
	}

	Future<bool> updateOrderPaymentStatus(int status, int id) async{
		bool isSuccess = false;
		try {
			response = await apiHelper.post('order/updatePaymentStatus', data: {
				"status": status,
				"id": id
			});

			if (response.statusCode == 200) {
				isSuccess = true;
			}
		} catch (e) {
			isSuccess = false;
		}

		return isSuccess;
	}

	Future<OrderDetail> getDetailById(int orderId) async {
		late OrderDetail orderDetail;

		try {
			response = await apiHelper.get('order/detail/getById/$orderId');

			if (response.data != null) {
				orderDetail = OrderDetail.fromJson(response.data);
			}
		} catch (e) {
			rethrow;
		}
		return orderDetail;
	}

	Future<Courier> getCourierById(int orderId) async {
		late Courier courier;

		try {
			response = await apiHelper.get('order/courier/getByOrder/$orderId');

			if (response.data != null) {
				courier = Courier.fromJson(response.data);
			}
		} catch (e) {
			rethrow;
		}
		return courier;
	}

	Future<List<Order>> getCompletedOrder() async {
		List<Order> orderList = [];
		String selectedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
		//String startDate = DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(const Duration(days: 7)));

		try {
			response = await apiHelper.get('order/getCompletedOrder?date=$selectedDate');

			if (response.data != null) {
				response.data.forEach(
								(e) => {orderList.add(Order.fromJson(e))});
			}
		} catch (e) {
			rethrow;
		}
		return orderList;
	}

	Future<bool> cancelOrder(int orderId) async {
		bool isSuccess = false;
		try {
			response = await apiHelper.post('order/cancel', data: {"orderId": orderId});

			if (response.statusCode == 200) {
				isSuccess = true;
			}
		} catch (e) {
			isSuccess = false;
		}

		return isSuccess;
	}
}
