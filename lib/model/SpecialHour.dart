class SpecialOperationHour {
  int? id;
  int? merchantId;
  String? date;
  String? openedAt;
  String? closedAt;

  SpecialOperationHour(
      {this.id, this.merchantId, this.date, this.openedAt, this.closedAt});

  SpecialOperationHour.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchantId = json['merchant_id'];
    date = json['date'];
    openedAt = json['opened_at'];
    closedAt = json['closed_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['merchant_id'] = merchantId;
    data['date'] = date;
    data['opened_at'] = openedAt;
    data['closed_at'] = closedAt;
    return data;
  }
}
