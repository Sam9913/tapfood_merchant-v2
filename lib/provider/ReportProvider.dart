import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:tapfood_v2/model/Order.dart';
import 'package:tapfood_v2/model/Report.dart';
import 'package:tapfood_v2/services/ReportServices.dart';

class ReportProvider extends ChangeNotifier {
	List<Report> _reportList = [];
	List<Order> _selectedOrderList = [];
	List<Report> get reportList => _reportList;
	List<Order> get selectedOrderList => _selectedOrderList;
	ReportServices reportServices = ReportServices();

	Future<bool> getByDateRange(String _startDate, String _endDate) async {
		try {
			_reportList = await reportServices.getByDateRange(_startDate, _endDate);

			notifyListeners();
			return true;
		} catch (error) {
			return false;
		}
	}

	Future<bool> getOrderList(String selectedDate) async{
		try {
			_selectedOrderList = await reportServices.getOrderList(selectedDate);
			_selectedOrderList.sort((a,b) => (int.parse(a.orderId.toString())).compareTo(int.parse(b.orderId.toString())));
			_selectedOrderList = _selectedOrderList.reversed.toList();

			notifyListeners();
			return true;
		} catch (error) {
			return false;
		}
	}
}
