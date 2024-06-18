class DeliverySetting {
  int? id;
  int? merchantId;
  int? sameAsStorePrice;
  int? dineIn;
  int? dineinType;
  int? takeAway;
  int? delivery;
  int? deliveryPartner;
  int? deliveryVehicle;
  int? deliveryPreparationTime;
  int? driveThru;
  int? campusDelivery;
  String? campusDeliveryRedirect;
  String? notice;
  String? minOrderAmount;
  String? taxOrderPreference;
  String? serviceCharge;
  String? governmentTax;
  String? tfCharges;
  int? tfDiscount;
  String? merchantCommission;
  String? merchantCharges;
  String? deliveryMinOrder;
  String? deliveryWaiveAmount;
  String? tfDeliveryWaiveAmount;
  String? markupDelivery;
  String? campusDeliveryFee;

  DeliverySetting(
      {this.id,
        this.merchantId,
        this.sameAsStorePrice,
        this.dineIn,
        this.dineinType,
        this.takeAway,
        this.delivery,
        this.deliveryPartner,
        this.deliveryVehicle,
        this.deliveryPreparationTime,
        this.driveThru,
        this.campusDelivery,
        this.campusDeliveryRedirect,
        this.notice,
        this.minOrderAmount,
        this.taxOrderPreference,
        this.serviceCharge,
        this.governmentTax,
        this.tfCharges,
        this.tfDiscount,
        this.merchantCommission,
        this.merchantCharges,
        this.deliveryMinOrder,
        this.deliveryWaiveAmount,
        this.tfDeliveryWaiveAmount,
        this.markupDelivery,
        this.campusDeliveryFee});

  DeliverySetting.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchantId = json['merchantId'];
    sameAsStorePrice = json['same_as_store_price'];
    dineIn = json['dineIn'];
    dineinType = json['dinein_type'];
    takeAway = json['takeAway'];
    delivery = json['delivery'];
    deliveryPartner = json['delivery_partner'];
    deliveryVehicle = json['delivery_vehicle'];
    deliveryPreparationTime = json['delivery_preparation_time'];
    driveThru = json['drive_thru'];
    campusDelivery = json['campus_delivery'];
    campusDeliveryRedirect = json['campus_delivery_redirect'];
    notice = json['notice'];
    minOrderAmount = json['min_order_amount'];
    taxOrderPreference = json['tax_order_preference'];
    serviceCharge = json['service_charge'];
    governmentTax = json['government_tax'];
    tfCharges = json['tf_charges'];
    tfDiscount = json['tf_discount'];
    merchantCommission = json['merchant_commission'];
    merchantCharges = json['merchant_charges'];
    deliveryMinOrder = json['delivery_min_order'];
    deliveryWaiveAmount = json['delivery_waive_amount'];
    tfDeliveryWaiveAmount = json['tf_delivery_waive_amount'];
    markupDelivery = json['markup_delivery'];
    campusDeliveryFee = json['campus_delivery_fee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['merchantId'] = merchantId;
    data['same_as_store_price'] = sameAsStorePrice;
    data['dineIn'] = dineIn;
    data['dinein_type'] = dineinType;
    data['takeAway'] = takeAway;
    data['delivery'] = delivery;
    data['delivery_partner'] = deliveryPartner;
    data['delivery_vehicle'] = deliveryVehicle;
    data['delivery_preparation_time'] = deliveryPreparationTime;
    data['drive_thru'] = driveThru;
    data['campus_delivery'] = campusDelivery;
    data['campus_delivery_redirect'] = campusDeliveryRedirect;
    data['notice'] = notice;
    data['min_order_amount'] = minOrderAmount;
    data['tax_order_preference'] = taxOrderPreference;
    data['service_charge'] = serviceCharge;
    data['government_tax'] = governmentTax;
    data['tf_charges'] = tfCharges;
    data['tf_discount'] = tfDiscount;
    data['merchant_commission'] = merchantCommission;
    data['merchant_charges'] = merchantCharges;
    data['delivery_min_order'] = deliveryMinOrder;
    data['delivery_waive_amount'] = deliveryWaiveAmount;
    data['tf_delivery_waive_amount'] = tfDeliveryWaiveAmount;
    data['markup_delivery'] = markupDelivery;
    data['campus_delivery_fee'] = campusDeliveryFee;
    return data;
  }
}
