import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:tapfood_v2/config/appConfig.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/model/DeliverySetting.dart';
import 'package:tapfood_v2/model/General.dart';
import 'package:tapfood_v2/model/Merchant.dart';
import 'package:tapfood_v2/model/OperationHour.dart';
import 'package:tapfood_v2/model/OperationHourException.dart';
import 'package:tapfood_v2/utils/apiHelper.dart';

class MerchantServices {
  late Response response;
  Config config = Config();
  ApiHelper apiHelper = ApiHelper(Config().baseUrl);

  Future<Merchant> getDetail() async {
    late Merchant merchant;
    try {
      response = await apiHelper.get('detail/get');

      if (response.data != null) {
        merchant = Merchant.fromJson(response.data);
      }
    } catch (e) {
      rethrow;
    }
    return merchant;
  }

  Future<DeliverySetting> getDeliverySetting() async {
    late DeliverySetting deliverySetting;
    try {
      response = await apiHelper.get('preference/getDeliveryDetail');

      if (response.data != null) {
        deliverySetting = DeliverySetting.fromJson(response.data);
      }
    } catch (e) {
      rethrow;
    }
    return deliverySetting;
  }

  Future<String> updateDeliverySetting(int vehicle, int preparationTime) async {
    String responseMsg = "";
    try {
      response = await apiHelper.post('preference/updateDeliveryDetail',
          data: {"vehicle": vehicle, "preparationTime": preparationTime});

      if (response.statusCode == 200) {
        responseMsg = response.data;
      }
    } catch (e) {
      rethrow;
    }
    return responseMsg;
  }

  Future<List<OperationHourGrouped>> getOperationHour(AppLocalizations appLocalizations) async {
    List<OperationHour> temporaryOperationHour = [];
    List<ItemType> weekday = [
      ItemType(name: appLocalizations.monday, id: 1),
      ItemType(name: appLocalizations.tuesday, id: 2),
      ItemType(name: appLocalizations.wednesday, id: 3),
      ItemType(name: appLocalizations.thursday, id: 4),
      ItemType(name: appLocalizations.friday, id: 5),
      ItemType(name: appLocalizations.saturday, id: 6),
      ItemType(name: appLocalizations.sunday, id: 7),
    ];
    final List<OperationHour> _operationHour = [
      OperationHour(id: 0, merchantId: 0, day: 1, openedAt: "", closedAt: ""),
      OperationHour(id: 0, merchantId: 0, day: 2, openedAt: "", closedAt: ""),
      OperationHour(id: 0, merchantId: 0, day: 3, openedAt: "", closedAt: ""),
      OperationHour(id: 0, merchantId: 0, day: 5, openedAt: "", closedAt: ""),
      OperationHour(id: 0, merchantId: 0, day: 6, openedAt: "", closedAt: ""),
      OperationHour(id: 0, merchantId: 0, day: 7, openedAt: "", closedAt: "")
    ];
    List<OperationHourGrouped> _operationHourGrouped = [];

    try {
      response = await apiHelper.get('operation/get');

      if (response.data != null) {
        response.data.forEach((e) => {temporaryOperationHour.add(OperationHour.fromJson(e))});
        for (var k = 0; k < temporaryOperationHour.length; k++) {
          int indexOf =
              _operationHour.indexWhere((element) => element.day == temporaryOperationHour[k].day);
          if (indexOf >= 0) {
            if (_operationHour[indexOf].id != 0) {
              _operationHour[indexOf].openedAt =
                  "${_operationHour[indexOf].openedAt},${temporaryOperationHour[k].openedAt}";
              _operationHour[indexOf].closedAt =
                  "${_operationHour[indexOf].closedAt},${temporaryOperationHour[k].closedAt}";
            } else {
              _operationHour[indexOf] = temporaryOperationHour[k];
            }
          }
        }

        var dayName = weekday.firstWhere((element) => element.id == _operationHour[0].day).name;

        var openHour = int.parse(_operationHour[0].openedAt.toString().substring(0, 2));
        var openTime = openHour > 12
            ? (openHour - 12).toString() +
                ":" +
                _operationHour[0].openedAt.toString().substring(3, 5) +
                " PM"
            : _operationHour[0].openedAt.toString().substring(0, 5) + " AM";

        var closeHour = int.parse(_operationHour[0].closedAt.toString().substring(0, 2));
        var closeTime = closeHour > 12
            ? (closeHour - 12).toString() +
                ":" +
                _operationHour[0].closedAt.toString().substring(3, 5) +
                " PM"
            : _operationHour[0].closedAt.toString().substring(0, 5) + " AM";

        List<OperationHourGrouped> newOperationHour = [
          OperationHourGrouped(
              firstDay: dayName, time: [Time(openAt: openTime, closeAt: closeTime)])
        ];
        var tempOperationHour = _operationHour[0];
        for (var i = 1; i < _operationHour.length; i++) {
          dayName = weekday.firstWhere((element) => element.id == _operationHour[i].day).name;
          List<Time> timeList = [];

          if(_operationHour[i].id != 0){
            openHour = int.parse(_operationHour[i].openedAt.toString().substring(0, 2));
            openTime = openHour > 12
                ? (openHour - 12).toString() +
                ":" +
                _operationHour[i].openedAt.toString().substring(3, 5) +
                " PM"
                : _operationHour[i].openedAt.toString().substring(0, 5) + " AM";

            closeHour = int.parse(_operationHour[i].closedAt.toString().substring(0, 2));
            closeTime = closeHour > 12
                ? (closeHour - 12).toString() +
                ":" +
                _operationHour[i].closedAt.toString().substring(3, 5) +
                " PM"
                : _operationHour[i].closedAt.toString().substring(0, 5) + " AM";

            if (_operationHour[i].openedAt.toString().indexOf(",") > 0) {
              List<String> openArr = _operationHour[i].openedAt.toString().split(",");

              openTime = "";
              for (var i = 0; i < openArr.length; i++) {
                openHour = int.parse(openArr[i].substring(0, 2));
                openTime += "," +
                    (openHour > 12
                        ? (openHour - 12).toString() + ":" + openArr[i].substring(3, 5) + " PM"
                        : openArr[i].substring(0, 5) + " AM");

                timeList.add(Time(
                    openAt: (openHour > 12
                        ? (openHour - 12).toString() + ":" + openArr[i].substring(3, 5) + " PM"
                        : openArr[i].substring(0, 5) + " AM")));
              }
            }

            if (_operationHour[i].closedAt.toString().indexOf(",") > 0) {
              List<String> closeArr = _operationHour[i].closedAt.toString().split(",");

              closeTime = "";
              for (var i = 0; i < closeArr.length; i++) {
                closeHour = int.parse(closeArr[i].substring(0, 2));
                closeTime += "," +
                    (closeHour > 12
                        ? (closeHour - 12).toString() + ":" + closeArr[i].substring(3, 5) + " PM"
                        : closeArr[i].substring(0, 5) + " AM");

                timeList[i].closeAt = (closeHour > 12
                    ? (closeHour - 12).toString() + ":" + closeArr[i].substring(3, 5) + " PM"
                    : closeArr[i].substring(0, 5) + " AM");
              }
            }

            if (_operationHour[i].openedAt == tempOperationHour.openedAt &&
                _operationHour[i].closedAt == tempOperationHour.closedAt) {
              if (newOperationHour.isEmpty) {
                newOperationHour.add(OperationHourGrouped(
                    firstDay: dayName,
                    time: timeList.isNotEmpty
                        ? timeList
                        : [Time(openAt: openTime, closeAt: closeTime)]));
              } else {
                var lastIndex = newOperationHour.length - 1;
                var dayName =
                    weekday.firstWhere((element) => element.id == _operationHour[i].day).name;
                newOperationHour[lastIndex].lastDay = dayName;
              }
            } else {
              tempOperationHour = _operationHour[i];
              var index = newOperationHour.indexWhere((element) =>
              element.time ==
                  (timeList.isNotEmpty ? timeList : [Time(openAt: openTime, closeAt: closeTime)]));
              if (index >= 0) {
                newOperationHour[index].lastDay = dayName;
              } else {
                newOperationHour.add(OperationHourGrouped(
                    firstDay: dayName,
                    time: timeList.isNotEmpty
                        ? timeList
                        : [Time(openAt: openTime, closeAt: closeTime)]));
              }
            }
          }
        }
        _operationHourGrouped = newOperationHour;
      }
    } catch (e) {
      rethrow;
    }
    return _operationHourGrouped;
  }

  Future<List<OperationHourGroup>> getOperationHourGroup() async {
    List<OperationHourGroup> operationHourGroup = [
      OperationHourGroup(day: 1, merchantId: 0, openCloseTime: [], isSet: false, is24: false),
      OperationHourGroup(day: 2, merchantId: 0, openCloseTime: [], isSet: false, is24: false),
      OperationHourGroup(day: 3, merchantId: 0, openCloseTime: [], isSet: false, is24: false),
      OperationHourGroup(day: 4, merchantId: 0, openCloseTime: [], isSet: false, is24: false),
      OperationHourGroup(day: 5, merchantId: 0, openCloseTime: [], isSet: false, is24: false),
      OperationHourGroup(day: 6, merchantId: 0, openCloseTime: [], isSet: false, is24: false),
      OperationHourGroup(day: 7, merchantId: 0, openCloseTime: [], isSet: false, is24: false)
    ];
    List<OperationHour> temporaryOperationHour = [];

    try {
      response = await apiHelper.get('operation/get');

      if (response.data != null) {
        response.data.forEach((e) => {temporaryOperationHour.add(OperationHour.fromJson(e))});

        for (var i = 0; i < temporaryOperationHour.length; i++) {
          int index = operationHourGroup
              .indexWhere((element) => element.day == temporaryOperationHour[i].day);
          operationHourGroup[index].openCloseTime.add(OpenCloseTime(
              id: temporaryOperationHour[i].id ?? 0,
              openAt: DateFormat("hh:mm:ss").parse(temporaryOperationHour[i].openedAt.toString()),
              closedAt: DateFormat("hh:mm:ss").parse(temporaryOperationHour[i].closedAt.toString()),
              isDelete: false));
          operationHourGroup[index].isSet = true;

          if (temporaryOperationHour[i].openedAt.toString() ==
              temporaryOperationHour[i].closedAt.toString()) {
            operationHourGroup[index].is24 = true;
          }
        }
      }
    } catch (e) {
      rethrow;
    }

    return operationHourGroup;
  }

  Future<bool> updateOperationHour(List<Map<String, dynamic>> operationList) async {
    bool isSuccess = false;
    try {
      response = await apiHelper.post('operation/update', data: operationList);

      if (response.statusCode == 200) {
        isSuccess = true;
      }
    } catch (e) {
      rethrow;
    }
    return isSuccess;
  }

  Future<List<SpecialHourGrouped>> getOperationHourExceptionGrouped() async {
    List<SpecialHourGrouped> specialHourGroupedList = [];
    List<OperationHourException> operationHourExceptionList = [];

    try {
      response = await apiHelper.get('operation/exception/get');

      if (response.data != null) {
        response.data
            .forEach((e) => {operationHourExceptionList.add(OperationHourException.fromJson(e))});

        for (int i = 0; i < operationHourExceptionList.length; i++) {
          int index = specialHourGroupedList
              .indexWhere((element) => element.date == operationHourExceptionList[i].date);
          if (index >= 0) {
            specialHourGroupedList[index].time.add(Time(
                openAt: operationHourExceptionList[i].openedAt,
                closeAt: operationHourExceptionList[i].closedAt));
          } else {
            specialHourGroupedList.add(SpecialHourGrouped(
                date: operationHourExceptionList[i].date,
                closeStatus: operationHourExceptionList[i].closeStatus,
                time: [
                  Time(
                      openAt: operationHourExceptionList[i].openedAt,
                      closeAt: operationHourExceptionList[i].closedAt)
                ]));
          }
        }
      }
    } catch (e) {
      rethrow;
    }
    return specialHourGroupedList;
  }

  Future<List<OperationHourException>> getOperationHourException() async {
    List<OperationHourException> operationHourExceptionList = [];
    try {
      response = await apiHelper.get('operation/exception/get');

      if (response.data != null) {
        response.data
            .forEach((e) => {operationHourExceptionList.add(OperationHourException.fromJson(e))});
      }
    } catch (e) {
      rethrow;
    }
    return operationHourExceptionList;
  }

  Future<bool> insertOperationHourException(
      List<Map<String, dynamic>> operationExceptionList) async {
    bool isSuccess = false;
    try {
      response = await apiHelper.put('operation/exception/insert', data: operationExceptionList);

      if (response.statusCode == 200) {
        isSuccess = true;
      }
    } catch (e) {
      rethrow;
    }
    return isSuccess;
  }

  Future<bool> deleteOperationHourException(String date) async {
    bool isSuccess = false;
    try {
      response = await apiHelper.delete('operation/exception/delete', data: {"date": date});

      if (response.statusCode == 200) {
        isSuccess = true;
      }
    } catch (e) {
      rethrow;
    }
    return isSuccess;
  }

  Future<bool> updateStatus() async {
    bool isSuccess = false;
    try {
      response = await apiHelper.post('detail/updateOperationStatus');

      if (response.statusCode == 200) {
        isSuccess = true;
      }
    } catch (e) {
      rethrow;
    }
    return isSuccess;
  }
}
