import 'package:tapfood_v2/model/General.dart';

class OperationHourException {
  int? id;
  int? merchantId;
  String? date;
  String? openedAt;
  String? closedAt;
  bool? closeStatus;

  OperationHourException(
      {this.id,
        this.merchantId,
        this.date,
        this.openedAt,
        this.closedAt,
        this.closeStatus});

  OperationHourException.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchantId = json['merchant_id'];
    date = json['date'];
    openedAt = json['opened_at'];
    closedAt = json['closed_at'];
    closeStatus = json['close_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['merchant_id'] = merchantId;
    data['date'] = date;
    data['opened_at'] = openedAt;
    data['closed_at'] = closedAt;
    data['close_status'] = closeStatus;
    return data;
  }
}
class SpecialHourGrouped {
  String? date;
  bool? closeStatus;
  List<Time> time = [];

  SpecialHourGrouped({this.date, this.closeStatus, required this.time});

  SpecialHourGrouped.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    closeStatus = json['closeStatus'];
    if (json['time'] != null) {
      time = <Time>[];
      json['time'].forEach((v) {
        time.add(Time.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['closeStatus'] = closeStatus;
    data['time'] = time.map((v) => v.toJson()).toList();
    return data;
  }
}