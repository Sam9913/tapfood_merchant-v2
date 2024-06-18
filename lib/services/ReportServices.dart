import 'package:dio/dio.dart';
import 'package:tapfood_v2/config/appConfig.dart';
import 'package:tapfood_v2/model/Order.dart';
import 'package:tapfood_v2/model/Report.dart';
import 'package:tapfood_v2/utils/apiHelper.dart';

class ReportServices {
	late Response response;
	Config config = Config();
	ApiHelper apiHelper = ApiHelper(Config().baseUrl);

	Future<List<Report>> getByDateRange(String? startDate, String? endDate) async {
		List<Report> orderList = [];

		try {
			response = await apiHelper.get('report/getByDateRange', queryParameters: {
				"startDate": startDate,
				"endDate": endDate
			});

			if (response.data != null) {
				response.data.forEach(
								(e) => {orderList.add(Report.fromJson(e))});
			}
		} catch (e) {
			rethrow;
		}
		return orderList;
	}

	Future<List<Order>> getOrderList(String date) async {
		List<Order> orderList = [];

		try {
			response = await apiHelper.get('order/getByDateRange', queryParameters: {
				"date": date
			});

			if (response.data != null) {
				response.data.forEach(
								(e) => {orderList.add(Order.fromJson(e))});
			}
		} catch (e) {
			rethrow;
		}
		return orderList;
	}
}
