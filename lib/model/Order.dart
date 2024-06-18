class Order {
	int? orderId;
	int? queueId;
	String? contactNumber;
	String? userName;
	int? merchantId;
	String? merchantName;
	String? totalAmount;
	String? paymentMethod;
	String? paymentDescription;
	String? referenceNo;
	int? paymentStatus;
	int? status;
	int? orderPreference;
	String? orderNote;
	String? tableNo;
	String? address;
	String? deliveryLatitude;
	String? deliveryLongitude;
	String? floorUnit;
	String? noteDelivery;
	String? discountAmount;
	String? merchantVoucherDiscountAmount;
	int? tfTaxRate;
	String? taxAmount;
	//int? tfDiscountRate;
	//String? tfDiscountAmount;
	String? serviceChargeRate;
	String? serviceChargeAmount;
	String? governmentTaxRate;
	String? governmentTaxAmount;
	String? merchantCommissionRate;
	String? merchantCommissionAmount;
	String? merchantChargesRate;
	String? merchantChargesAmount;
	String? deliveryAmount;
	//String? deliveryMarkupRate;
	//String? deliveryMarkupAmount;
	String? deliveryDiscountAmount; //merchant
	String? tfDeliveryDiscountAmount; //platform
	int? mrspeedyOrderId;
	String? lalamoveOrderId;
	String? trackingUrl;
	String? orderDateTime;
	String? paymentDateTime;
	String? scheduledAt;
	int? itemCount;

	Order(
			{orderId,
				queueId,
				contactNumber,
				userName,
				merchantId,
				merchantName,
				totalAmount,
				paymentMethod,
				paymentDescription,
				referenceNo,
				paymentStatus,
				status,
				orderPreference,
				orderNote,
				tableNo,
				address,
				deliveryLatitude,
				deliveryLongitude,
				floorUnit,
				noteDelivery,
				discountAmount,
				merchantVoucherDiscountAmount,
				tfTaxRate,
				taxAmount,
				//tfDiscountRate,
				//tfDiscountAmount,
				serviceChargeRate,
				serviceChargeAmount,
				governmentTaxRate,
				governmentTaxAmount,
				merchantCommissionRate,
				merchantCommissionAmount,
				merchantChargesRate,
				merchantChargesAmount,
				deliveryAmount,
				//deliveryMarkupRate,
				//deliveryMarkupAmount,
				deliveryDiscountAmount,
				tfDeliveryDiscountAmount,
				mrspeedyOrderId,
				lalamoveOrderId,
				trackingUrl,
				orderDateTime,
				paymentDateTime,
				scheduledAt,
				itemCount});

	Order.fromJson(Map<String, dynamic> json) {
		orderId = json['orderId'];
		queueId = json['queue_id'];
		contactNumber = json['contact_number'];
		userName = json['user_name'];
		merchantId = json['merchant_id'];
		merchantName = json['merchantName'];
		totalAmount = json['totalAmount'];
		paymentMethod = json['paymentMethod'];
		paymentDescription = json['paymentDescription'];
		referenceNo = json['referenceNo'];
		paymentStatus = json['paymentStatus'];
		status = json['status'];
		orderPreference = json['orderPreference'];
		orderNote = json['order_note'];
		tableNo = json['table_no'];
		address = json['address'];
		deliveryLatitude = json['delivery_latitude'];
		deliveryLongitude = json['delivery_longitude'];
		floorUnit = json['floor_unit'];
		noteDelivery = json['note_delivery'];
		discountAmount = json['discountAmount'];
		merchantVoucherDiscountAmount = json['merchant_voucher_discount_amount'];
		tfTaxRate = json['tf_tax_rate'];
		taxAmount = json['taxAmount'];
		//tfDiscountRate = json['tf_discount_rate'];
		//tfDiscountAmount = json['tf_discount_amount'];
		serviceChargeRate = json['service_charge_rate'];
		serviceChargeAmount = json['service_charge_amount'];
		governmentTaxRate = json['government_tax_rate'];
		governmentTaxAmount = json['government_tax_amount'];
		merchantCommissionRate = json['merchant_commission_rate'];
		merchantCommissionAmount = json['merchant_commission_amount'];
		merchantChargesRate = json['merchant_charges_rate'];
		merchantChargesAmount = json['merchant_charges_amount'];
		deliveryAmount = json['delivery_amount'];
		//deliveryMarkupRate = json['delivery_markup_rate'];
		//deliveryMarkupAmount = json['delivery_markup_amount'];
		deliveryDiscountAmount = json['delivery_discount_amount'];
		tfDeliveryDiscountAmount = json['tf_delivery_discount_amount'];
		mrspeedyOrderId = json['mrspeedy_orderId'];
		lalamoveOrderId = json['lalamove_orderId'];
		trackingUrl = json['tracking_url'];
		orderDateTime = json['orderDateTime'];
		paymentDateTime = json['paymentDateTime'];
		scheduledAt = json['scheduled_at'];
		itemCount = json['order_items_count'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['orderId'] = orderId;
		data['queue_id'] = queueId;
		data['contact_number'] = contactNumber;
		data['user_name'] = userName;
		data['merchant_id'] = merchantId;
		data['merchantName'] = merchantName;
		data['totalAmount'] = totalAmount;
		data['paymentMethod'] = paymentMethod;
		data['paymentDescription'] = paymentDescription;
		data['referenceNo'] = referenceNo;
		data['paymentStatus'] = paymentStatus;
		data['status'] = status;
		data['orderPreference'] = orderPreference;
		data['order_note'] = orderNote;
		data['table_no'] = tableNo;
		data['address'] = address;
		data['delivery_latitude'] = deliveryLatitude;
		data['delivery_longitude'] = deliveryLongitude;
		data['floor_unit'] = floorUnit;
		data['note_delivery'] = noteDelivery;
		data['discountAmount'] = discountAmount;
		data['merchant_voucher_discount_amount'] =
				merchantVoucherDiscountAmount;
		data['tf_tax_rate'] = tfTaxRate;
		data['taxAmount'] = taxAmount;
		//data['tf_discount_rate'] = tfDiscountRate;
		//data['tf_discount_amount'] = tfDiscountAmount;
		data['service_charge_rate'] = serviceChargeRate;
		data['service_charge_amount'] = serviceChargeAmount;
		data['government_tax_rate'] = governmentTaxRate;
		data['government_tax_amount'] = governmentTaxAmount;
		data['merchant_commission_rate'] = merchantCommissionRate;
		data['merchant_commission_amount'] = merchantCommissionAmount;
		data['merchant_charges_rate'] = merchantChargesRate;
		data['merchant_charges_amount'] = merchantChargesAmount;
		data['delivery_amount'] = deliveryAmount;
		//data['delivery_markup_rate'] = deliveryMarkupRate;
		//data['delivery_markup_amount'] = deliveryMarkupAmount;
		data['delivery_discount_amount'] = deliveryDiscountAmount;
		data['tf_delivery_discount_amount'] = tfDeliveryDiscountAmount;
		data['mrspeedy_orderId'] = mrspeedyOrderId;
		data['lalamove_orderId'] = lalamoveOrderId;
		data['tracking_url'] = trackingUrl;
		data['orderDateTime'] = orderDateTime;
		data['paymentDateTime'] = paymentDateTime;
		data['scheduled_at'] = scheduledAt;
		data['order_items_count'] = itemCount;
		return data;
	}
}

class Courier {
	int? id;
	int? orderId;
	int? courierId;
	String? surname;
	String? name;
	String? middlename;
	String? phone;
	String? photoUrl;
	String? plateNumber;

	Courier(
			{this.id,
				this.orderId,
				this.courierId,
				this.surname,
				this.name,
				this.middlename,
				this.phone,
				this.photoUrl,
				this.plateNumber});

	Courier.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		orderId = json['order_id'];
		courierId = json['courier_id'];
		surname = json['surname'];
		name = json['name'];
		middlename = json['middlename'];
		phone = json['phone'];
		photoUrl = json['photo_url'];
		plateNumber = json['plate_number'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['id'] = id;
		data['order_id'] = orderId;
		data['courier_id'] = courierId;
		data['surname'] = surname;
		data['name'] = name;
		data['middlename'] = middlename;
		data['phone'] = phone;
		data['photo_url'] = photoUrl;
		data['plate_number'] = plateNumber;
		return data;
	}
}
