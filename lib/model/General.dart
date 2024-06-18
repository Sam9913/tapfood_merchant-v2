import 'package:intl/intl.dart';

class ItemType {
  String? name;
  int? id;

  ItemType({this.name, this.id});

  ItemType.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}

class DeliveryVehicleType {
  String? vehicleName;
  int? id;

  DeliveryVehicleType({this.vehicleName, this.id});

  DeliveryVehicleType.fromJson(Map<String, dynamic> json) {
    vehicleName = json['vehicleName'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vehicleName'] = vehicleName;
    data['id'] = id;
    return data;
  }
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

class Language {
  String? name;
  int? id;
  String? langCode;

  Language({this.name, this.id, this.langCode});

  Language.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    langCode = json['langCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['langCode'] = langCode;
    return data;
  }
}

class OpenCloseTime {
  int id = 0;
  DateTime openAt = DateTime.now();
  DateTime closedAt = DateTime.now();
  bool isDelete = false;

  OpenCloseTime({required this.id, required this.openAt, required this.closedAt, required this.isDelete});

  OpenCloseTime.fromJson(Map<String, dynamic> json) {
    openAt = json['openAt'];
    closedAt = json['closedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['opened_at'] = DateFormat("hh:mm:ss").format(openAt);
    data['closed_at'] = DateFormat("hh:mm:ss").format(closedAt);
    data['is_delete'] = isDelete;
    return data;
  }
}

class Time {
  String? openAt;
  String? closeAt;

  Time({this.openAt, this.closeAt});

  Time.fromJson(Map<String, dynamic> json) {
    openAt = json['openAt'];
    closeAt = json['closeAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['openAt'] = openAt;
    data['closeAt'] = closeAt;
    return data;
  }
}

class Printer {
  String name = "";
  String mac = "";
  bool isConnected = false;

  Printer({required this.name, required this.mac, required this.isConnected});
}
