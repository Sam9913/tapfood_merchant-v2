import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:tapfood_v2/config/enum.dart';
import 'package:tapfood_v2/model/General.dart';
import 'package:tapfood_v2/model/Report.dart';

class AvailabilityProvider extends ChangeNotifier {
  Availability _availability = Availability.unavailable;
  Availability get availability => _availability;

  setAvailability(Availability availabilityChosen) {
    _availability = availabilityChosen;

    notifyListeners();
  }
}

class DateTimeProvider extends ChangeNotifier {
  DateTime _startDateTime = DateTime.now();
  DateTime _endDateTime = DateTime.now();
  DateTime _singleDate = DateTime.now();
  List<OpenCloseTime> _dateTimeList = [];
  DateTime get startDateTime => _startDateTime;
  DateTime get endDateTime => _endDateTime;
  DateTime get singleDate => _singleDate;
  List<OpenCloseTime> get dateTimeList => _dateTimeList;

  setStartDate(DateTime selectedStartDate) {
    _startDateTime = selectedStartDate;

    notifyListeners();
  }

  setEndDate(DateTime selectedEndDate) {
    _endDateTime = selectedEndDate;

    notifyListeners();
  }

  setDate(DateTime selectedDate, bool isNotify) {
    _singleDate = selectedDate;

    if (isNotify) {
      notifyListeners();
    }
  }

  addDateTimeList(String message, String message2) {
    bool isOver = false;
    DateTime startDate = _dateTimeList.isEmpty
        ? DateFormat("hh:mm a").parse("12:00 AM")
        : _dateTimeList[_dateTimeList.length - 1].closedAt.add(const Duration(hours: 1));
    DateTime endDate = _dateTimeList.isEmpty
        ? DateFormat("hh:mm a").parse("11:00 PM")
        : _dateTimeList[_dateTimeList.length - 1].closedAt.add(const Duration(hours: 2));

    int startApm = DateFormat("a").format(startDate) == "AM" ? 1 : 0;
    int startHour = int.parse(DateFormat("HH").format(startDate));
    int startMinutes = int.parse(DateFormat("mm").format(startDate));
    int endApm = DateFormat("a").format(endDate) == "AM" ? 1 : 0;
    int endHour = int.parse(DateFormat("HH").format(endDate));
    int endMinutes = int.parse(DateFormat("mm").format(endDate));

    if (_dateTimeList.isNotEmpty) {
      int totalDifferenceHours = 0;
      for (int i = 0; i < _dateTimeList.length; i++) {
        DateTime openTime = _dateTimeList[i].openAt;
        DateTime closeTime = _dateTimeList[i].closedAt;

        totalDifferenceHours += closeTime.difference(openTime).inHours;
      }

      if (totalDifferenceHours >= 22) {
        isOver = true;
      }
    }

    if (!isOver) {
      bool isLogic = true;
      for (int i = 0; i < _dateTimeList.length; i++) {
        int openApm = DateFormat("a").format(_dateTimeList[i].openAt) == "AM" ? 1 : 0;
        int openHour = int.parse(DateFormat("HH").format(_dateTimeList[i].openAt));
        int openMinutes = int.parse(DateFormat("mm").format(_dateTimeList[i].openAt));
        int closeApm = DateFormat("a").format(_dateTimeList[i].closedAt) == "AM" ? 1 : 0;
        int closeHour = int.parse(DateFormat("HH").format(_dateTimeList[i].closedAt));
        int closeMinutes = int.parse(DateFormat("mm").format(_dateTimeList[i].closedAt));

        if (!(((openApm > startApm) ||
            (openHour >= startHour) ||
            (openHour == startHour && openMinutes > startMinutes) && (closeApm < endApm) ||
            (closeHour <= endHour) ||
            (closeHour == endHour && closeMinutes < endMinutes)))) {
          isLogic = false;
        }
      }

      if(isLogic){
        _dateTimeList
            .add(OpenCloseTime(id: 0, openAt: startDate, closedAt: endDate, isDelete: false));
      }else{
        Fluttertoast.showToast(
            msg: message2,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white);
      }
    } else {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white);
    }

    notifyListeners();
  }

  setOpenCloseTime(int id, bool isOpen, DateTime dateTime, int index, String message) {
    bool isLogic = true;
    String apm = DateFormat("a").format(dateTime);
    int hour = int.parse(DateFormat("HH").format(dateTime));
    int minutes = int.parse(DateFormat("mm").format(dateTime));

    if (_dateTimeList.isNotEmpty) {
      int previousCloseHour =
          int.parse(DateFormat("HH").format(_dateTimeList[_dateTimeList.length - 1].closedAt));
      int previousCloseMinutes =
          int.parse(DateFormat("mm").format(_dateTimeList[_dateTimeList.length - 1].closedAt));

      if (!((apm != DateFormat("a").format(_dateTimeList[index].closedAt)) ||
          previousCloseHour >= hour ||
          (previousCloseHour == hour && previousCloseMinutes > minutes))) {
        isLogic = false;
      }
    }

    if (isLogic) {
      if (isOpen) {
        int closeHour = int.parse(DateFormat("HH").format(_dateTimeList[index].closedAt));
        int closeMinutes = int.parse(DateFormat("mm").format(_dateTimeList[index].closedAt));

        if (!((apm != DateFormat("a").format(_dateTimeList[index].closedAt)) ||
            closeHour >= hour ||
            (closeHour == hour && closeMinutes > minutes))) {
          isLogic = false;
        }
      } else {
        int openHour = int.parse(DateFormat("HH").format(_dateTimeList[index].openAt));
        int openMinutes = int.parse(DateFormat("mm").format(_dateTimeList[index].openAt));

        if (!((apm != DateFormat("a").format(_dateTimeList[index].openAt)) ||
            (openHour <= hour) ||
            (openHour == hour && openMinutes < minutes))) {
          isLogic = false;
        }
      }
    }

    if (isLogic) {
      _dateTimeList[index] = OpenCloseTime(
          id: id,
          openAt: isOpen ? dateTime : _dateTimeList[index].openAt,
          closedAt: isOpen ? _dateTimeList[index].closedAt : dateTime,
          isDelete: false);
    } else {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white);
    }

    notifyListeners();
  }

  setList(List<OpenCloseTime> openCloseTimeList) {
    _dateTimeList = openCloseTimeList;
  }

  removeDateTimeList(int index) {
    //_dateTimeList[index].isDelete = true;
    _dateTimeList.removeAt(index);

    notifyListeners();
  }

  resetDateTimeList(bool isNotify) {
    _dateTimeList = [];

    if (isNotify) {
      notifyListeners();
    }
  }
}

class ReportSummaryProvider extends ChangeNotifier {
  double _totalSettlement = 0.0;
  // double _totalCharges = 0.0;
  double _totalIncome = 0.0;
  double _totalCancel = 0.0;
  double get totalSettlement => _totalSettlement;
  // double get totalCharges => _totalCharges;
  double get totalIncome => _totalIncome;
  double get totalCancel => _totalCancel;

  setTotal(double totalIncome, double totalCancel, double totalSettlement) {
    //double totalCharges,
    _totalSettlement = totalSettlement;
    //_totalCharges = totalCharges;
    _totalCancel = totalCancel;
    _totalIncome = totalIncome;

    notifyListeners();
  }

  setTotalByList(List<Report> reportList) {
    double totalSettlement = 0;
    //double totalCharges = 0;
    double totalIncome = 0;
    double totalCancel = 0;

    for (var i = 0; i < reportList.length; i++) {
      totalSettlement += (double.parse(reportList[i].totalAmount.toString()) +
					double.parse(reportList[i].giveAmount.toString())) -
					double.parse(reportList[i].takeAmount.toString());
			/*totalCharges += double.parse(reportList[i].totalCharges.toString());*/
      totalIncome += (double.parse(reportList[i].totalAmount.toString()));
      totalCancel += (double.parse(reportList[i].totalCancelAmount.toString()));
    }

    _totalSettlement = totalSettlement;
    // _totalCharges = totalCharges;
    _totalIncome = totalIncome;
    _totalCancel = totalCancel;

    notifyListeners();
  }
}

class LoadingProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  bool _isClickLoading = false;
  bool get isClickLoading => _isClickLoading;

  setIsLoading(bool? loadingStatus) {
    _isLoading = loadingStatus ?? false;

    notifyListeners();
  }

  setIsClickLoading(bool? loadingStatus) {
    _isClickLoading = loadingStatus ?? false;

    notifyListeners();
  }
}

class MenuCategoryProvider extends ChangeNotifier {
  MenuCategory _menuCategory = MenuCategory.food;
  MenuCategory get menuCategory => _menuCategory;

  setMenuCategory(MenuCategory menuCategory) {
    _menuCategory = menuCategory;

    notifyListeners();
  }
}
