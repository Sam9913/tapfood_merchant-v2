class Report {
  String? orderCount;
  String? cancelCount;
  String? orderDateTime;
  String? totalAmount;
  String? totalCancelAmount;
  String? giveAmount;
  String? takeAmount;

  Report({
    this.orderCount,
    this.cancelCount,
    this.orderDateTime,
    this.totalAmount,
    this.totalCancelAmount,
    this.giveAmount,
    this.takeAmount,
  });

  Report.fromJson(Map<String, dynamic> json) {
    orderCount = json['orderCount'];
    cancelCount = json['cancelCount'];
    orderDateTime = json['orderDateTime'];
    totalAmount = json['totalAmount'];
    totalCancelAmount = json['totalCancelAmount'];
    giveAmount = json['give_amount'];
    takeAmount = json['take_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderCount'] = orderCount;
    data['cancelCount'] = cancelCount;
    data['orderDateTime'] = orderDateTime;
    data['totalAmount'] = totalAmount;
    data['totalCancelAmount'] = totalCancelAmount;
    data['give_amount'] = giveAmount;
    data['take_amount'] = takeAmount;
    return data;
  }
}
