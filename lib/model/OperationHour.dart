import 'package:tapfood_v2/model/General.dart';

class OperationHour {
  int? id;
  int? merchantId;
  int? day;
  String? openedAt;
  String? closedAt;

  OperationHour(
      {this.id, this.merchantId, this.day, this.openedAt, this.closedAt});

  OperationHour.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchantId = json['merchant_id'];
    day = json['day'];
    openedAt = json['opened_at'];
    closedAt = json['closed_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['merchant_id'] = merchantId;
    data['day'] = day;
    data['opened_at'] = openedAt;
    data['closed_at'] = closedAt;
    return data;
  }
}

class OperationHourGrouped {
  String? firstDay;
  String? lastDay;
  List<Time> time = [];

  OperationHourGrouped(
      {this.firstDay, this.lastDay, required this.time});

  OperationHourGrouped.fromJson(Map<String, dynamic> json) {
    firstDay = json['firstDay'];
    lastDay = json['lastDay'];
    if (json['time'] != null) {
      time = <Time>[];
      json['time'].forEach((v) {
        time.add(Time.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstDay'] = firstDay;
    data['lastDay'] = lastDay;
    data['time'] = time.map((v) => v.toJson()).toList();
    return data;
  }
}

class OperationHourGroup {
  int? day;
  int? merchantId;
  bool is24 = false;
  bool isSet = false;
  List<OpenCloseTime> openCloseTime = [];

  OperationHourGroup({this.day, this.merchantId, required this.openCloseTime, required this.is24, required this.isSet});

  OperationHourGroup.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    merchantId = json['merchantId'];
    if (json['openCloseTime'] != null) {
      openCloseTime = <OpenCloseTime>[];
      json['openCloseTime'].forEach((v) {
        openCloseTime.add(OpenCloseTime.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    data['merchantId'] = merchantId;
    data['openCloseTime'] =
        openCloseTime.map((v) => v.toJson()).toList();
    return data;
  }
}
