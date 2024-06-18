import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:tapfood_v2/function/DateTimeCheck.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/model/DeliverySetting.dart';
import 'package:tapfood_v2/model/General.dart';
import 'package:tapfood_v2/model/OperationHour.dart';
import 'package:tapfood_v2/model/OperationHourException.dart';
import 'package:tapfood_v2/services/MerchantServices.dart';

class MerchantProvider extends ChangeNotifier {
  late DeliverySetting _deliverySetting;
  List<OperationHourException> _operationHourException = [];
  List<SpecialHourGrouped> _specialHourGrouped = [];
  List<OperationHourGrouped> _operationHourGrouped = [];
  List<OperationHourGroup> _operationHourGroup = [];
  DeliverySetting get deliverySetting => _deliverySetting;
  List<SpecialHourGrouped> get specialHourGrouped => _specialHourGrouped;
  List<OperationHourException> get operationHourException => _operationHourException;
  List<OperationHourGrouped> get operationHourGrouped => _operationHourGrouped;
  List<OperationHourGroup> get operationHourGroup => _operationHourGroup;
  MerchantServices merchantServices = MerchantServices();

  Future<bool> getMerchantStoreSetting(AppLocalizations appLocalizations) async {
    bool isSuccess = false;

    try {
      _deliverySetting = await merchantServices.getDeliverySetting();
      _operationHourGrouped = await merchantServices.getOperationHour(appLocalizations);
      _operationHourException = await merchantServices.getOperationHourException();
      _specialHourGrouped = await merchantServices.getOperationHourExceptionGrouped();

      notifyListeners();
      return isSuccess;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> getOperationHourGroup() async {
    try {
      _operationHourGroup = await merchantServices.getOperationHourGroup();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> getOperationHour(AppLocalizations appLocalizations) async {
    try {
      _operationHourGrouped = await merchantServices.getOperationHour(appLocalizations);

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> getSpecialHourOperation() async {
    bool isSuccess = false;

    try {
      _operationHourException = await merchantServices.getOperationHourException();

      notifyListeners();
    } catch (e) {
      rethrow;
    }

    return isSuccess;
  }

  Future<bool> getSpecialHourOperationGrouped() async {
    bool isSuccess = false;

    try {
      _specialHourGrouped = await merchantServices.getOperationHourExceptionGrouped();

      notifyListeners();
    } catch (e) {
      rethrow;
    }

    return isSuccess;
  }

  Future<String> updateDeliverySetting(int vehicleID, int preparationTime) async {
    try {
      final response = await merchantServices.updateDeliverySetting(vehicleID, preparationTime);

      notifyListeners();
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> updateStatus() async {
    try {
      final response = await merchantServices.updateStatus();

      notifyListeners();
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> deleteOperationHourException(String date) async {
    try {
      final response = await merchantServices.deleteOperationHourException(date);

      notifyListeners();
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> insertUpdateOperationHourException(List<Map<String, dynamic>> jsonBody) async {
    try {
      final response = await merchantServices.insertOperationHourException(jsonBody);

      notifyListeners();
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> updateOperationHour(List<Map<String, dynamic>> jsonBody) async {
    try {
      final response = await merchantServices.updateOperationHour(jsonBody);

      notifyListeners();
      return response;
    } catch (error) {
      rethrow;
    }
  }

  setOpenCloseTime(int id, bool isOpen, DateTime dateTime, DateTime anotherDateTime, int index,
      int secondaryIndex, String message) {
    bool isLogic = true;
    /*String apm = DateFormat("a").format(dateTime);
    int hour = int.parse(DateFormat("HH").format(dateTime));
    int minutes = int.parse(DateFormat("mm").format(dateTime));*/

    // If operation is not empty, check date time not between the previous date
    // need compare with own also
    // If 24 hours, means cannot add already

    //debugPrint('selectedDate: $dateTime, openTime: ${operationHourGroup[index].openCloseTime[0].openAt}, closeTime: ${operationHourGroup[index].openCloseTime[0].closedAt} index: $index');
    if (isOpen) {
      if (!anotherDateTime.isAfter(dateTime)) {
        anotherDateTime = dateTime.add(const Duration(hours: 1));
      }
    } else {
      if (!anotherDateTime.isBefore(dateTime)) {
        anotherDateTime = dateTime.subtract(const Duration(hours: 1));
      }
    }

    if (operationHourGroup[index].openCloseTime.isNotEmpty) {
      if (isOpen) {
        for (var openCloseTime in operationHourGroup[index].openCloseTime) {
          //debugPrint('after: ${DateTimeCheck().isAfterOrSame(dateTime, openCloseTime.openAt)} before: ${DateTimeCheck().isBeforeOrSame(openCloseTime.closedAt, anotherDateTime)}');
          if (!(DateTimeCheck().isAfterOrSame(dateTime, openCloseTime.openAt) &&
              DateTimeCheck().isBeforeOrSame(openCloseTime.closedAt, anotherDateTime))) {
            isLogic = false;
            break;
          }
        }
      }else{
        for (var openCloseTime in operationHourGroup[index].openCloseTime) {
          if (!(DateTimeCheck().isBeforeOrSame(openCloseTime.closedAt, dateTime) &&
              DateTimeCheck().isAfterOrSame(anotherDateTime, openCloseTime.openAt))) {
            isLogic = false;
            break;
          }
        }
      }
      /*for (var openCloseTime in operationHourGroup[index].openCloseTime) {
        DateTime compareTime = dateTime;/*isOpen
            ? dateTime.add(const Duration(hours: 1))
            : dateTime.subtract(const Duration(hours: 1));*/

        isLogic = isOpen
            ? DateTimeCheck().isBeforeOrSame(compareTime, anotherDateTime)
            : DateTimeCheck().isAfterOrSame(compareTime, anotherDateTime);
        while (isOpen
            ? DateTimeCheck().isBeforeOrSame(compareTime, anotherDateTime)
            : DateTimeCheck().isAfterOrSame(compareTime, anotherDateTime)) {

          if (DateTimeCheck().isBetween(compareTime, openCloseTime.openAt, openCloseTime.closedAt)) {
            isLogic = false;
            break;
          }

          if (!isLogic) {
            break;
          }
          compareTime = compareTime.add(const Duration(hours: 1));

        }

        if (!isLogic) {
          break;
        }
      }*/
    }

    /*if (operationHourGroup[index].openCloseTime.isNotEmpty) {
      int previousCloseHour = int.parse(DateFormat("HH").format(operationHourGroup[index]
          .openCloseTime[operationHourGroup[index].openCloseTime.length - 1]
          .closedAt));
      int previousCloseMinutes = int.parse(DateFormat("mm").format(operationHourGroup[index]
          .openCloseTime[operationHourGroup[index].openCloseTime.length - 1]
          .closedAt));

      if (!((apm !=
              DateFormat("a")
                  .format(operationHourGroup[index].openCloseTime[secondaryIndex].closedAt)) ||
          previousCloseHour >= hour ||
          (previousCloseHour == hour && previousCloseMinutes > minutes))) {
        isLogic = false;
      }
    }

    if (isLogic) {
      if (isOpen) {
        int closeHour = int.parse(DateFormat("HH")
            .format(operationHourGroup[index].openCloseTime[secondaryIndex].closedAt));
        int closeMinutes = int.parse(DateFormat("mm")
            .format(operationHourGroup[index].openCloseTime[secondaryIndex].closedAt));

        if (!((apm !=
                DateFormat("a")
                    .format(operationHourGroup[index].openCloseTime[secondaryIndex].closedAt)) ||
            closeHour >= hour ||
            (closeHour == hour && closeMinutes > minutes))) {
          isLogic = false;
        }
      } else {
        int openHour = int.parse(DateFormat("HH")
            .format(operationHourGroup[index].openCloseTime[secondaryIndex].openAt));
        int openMinutes = int.parse(DateFormat("mm")
            .format(operationHourGroup[index].openCloseTime[secondaryIndex].openAt));

        if (!((apm !=
                DateFormat("a")
                    .format(operationHourGroup[index].openCloseTime[secondaryIndex].openAt)) ||
            (openHour <= hour) ||
            (openHour == hour && openMinutes < minutes))) {
          isLogic = false;
        }
      }
    }*/

    if (isLogic) {
      if (isOpen) {
        operationHourGroup[index].openCloseTime[secondaryIndex].openAt = dateTime;
        operationHourGroup[index].openCloseTime[secondaryIndex].closedAt = anotherDateTime;
      } else {
        operationHourGroup[index].openCloseTime[secondaryIndex].closedAt = dateTime;
        operationHourGroup[index].openCloseTime[secondaryIndex].openAt = anotherDateTime;
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

  addOpenCloseTime(int index, String message, String message2) {
    int deletedIndex =
        operationHourGroup[index].openCloseTime.indexWhere((element) => element.isDelete == true);
    if (deletedIndex >= 0) {
      operationHourGroup[index].openCloseTime[deletedIndex].isDelete = false;
    } else {
      bool isOver = false;
      DateTime startDate = operationHourGroup[index].openCloseTime.isEmpty
          ? DateFormat("hh:mm a").parse("12:00 AM")
          : operationHourGroup[index]
              .openCloseTime[operationHourGroup[index].openCloseTime.length - 1]
              .closedAt
              .add(const Duration(hours: 1));
      DateTime endDate = operationHourGroup[index].openCloseTime.isEmpty
          ? DateFormat("hh:mm a").parse("11:00 PM")
          : operationHourGroup[index]
              .openCloseTime[operationHourGroup[index].openCloseTime.length - 1]
              .closedAt
              .add(const Duration(hours: 2));

      int startApm = DateFormat("a").format(startDate) == "AM" ? 1 : 0;
      int startHour = int.parse(DateFormat("HH").format(startDate));
      int startMinutes = int.parse(DateFormat("mm").format(startDate));
      int endApm = DateFormat("a").format(endDate) == "AM" ? 1 : 0;
      int endHour = int.parse(DateFormat("HH").format(endDate));
      int endMinutes = int.parse(DateFormat("mm").format(endDate));

      if (operationHourGroup[index].openCloseTime.isNotEmpty) {
        int totalDifferenceHours = 0;
        for (int i = 0; i < operationHourGroup[index].openCloseTime.length; i++) {
          DateTime openTime = operationHourGroup[index].openCloseTime[i].openAt;
          DateTime closeTime = operationHourGroup[index].openCloseTime[i].closedAt;

          totalDifferenceHours += closeTime.difference(openTime).inHours;
        }

        if (totalDifferenceHours >= 22) {
          isOver = true;
        }
      }

      if (!isOver) {
        bool isLogic = true;
        for (int i = 0; i < operationHourGroup[index].openCloseTime.length; i++) {
          int openApm =
              DateFormat("a").format(operationHourGroup[index].openCloseTime[i].openAt) == "AM"
                  ? 1
                  : 0;
          int openHour =
              int.parse(DateFormat("HH").format(operationHourGroup[index].openCloseTime[i].openAt));
          int openMinutes =
              int.parse(DateFormat("mm").format(operationHourGroup[index].openCloseTime[i].openAt));
          int closeApm =
              DateFormat("a").format(operationHourGroup[index].openCloseTime[i].closedAt) == "AM"
                  ? 1
                  : 0;
          int closeHour = int.parse(
              DateFormat("HH").format(operationHourGroup[index].openCloseTime[i].closedAt));
          int closeMinutes = int.parse(
              DateFormat("mm").format(operationHourGroup[index].openCloseTime[i].closedAt));

          if (!(((openApm > startApm) ||
              (openHour >= startHour) ||
              (openHour == startHour && openMinutes > startMinutes) && (closeApm < endApm) ||
              (closeHour <= endHour) ||
              (closeHour == endHour && closeMinutes < endMinutes)))) {
            isLogic = false;
          }
        }

        if (isLogic) {
          operationHourGroup[index]
              .openCloseTime
              .add(OpenCloseTime(id: 0, openAt: startDate, closedAt: endDate, isDelete: false));
        } else {
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
    }

    notifyListeners();
  }

  removeOpenCloseTime(int index, int secondaryIndex) {
    if (operationHourGroup[index].openCloseTime[secondaryIndex].id == 0) {
      operationHourGroup[index].openCloseTime.removeAt(secondaryIndex);
    } else {
      operationHourGroup[index].openCloseTime[secondaryIndex].isDelete = true;
    }

    notifyListeners();
  }
}
