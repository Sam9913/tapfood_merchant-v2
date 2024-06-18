class OrderDetail {
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
	String? deliveryVehicleType;
	String? deliveryLatitude;
	String? deliveryLongitude;
	String? floorUnit;
	String? noteDelivery;
	String? discountAmount;
	String? merchantVoucherDiscountAmount;
	int? tfTaxRate;
	String? taxAmount;
	int? tfDiscountRate;
	String? tfDiscountAmount;
	String? serviceChargeRate;
	String? serviceChargeAmount;
	String? governmentTaxRate;
	String? governmentTaxAmount;
	String? merchantCommissionRate;
	String? merchantCommissionAmount;
	String? merchantChargesRate;
	String? merchantChargesAmount;
	String? deliveryAmount;
	String? deliveryMarkupRate;
	String? deliveryMarkupAmount;
	String? deliveryDiscountAmount;
	String? tfDeliveryDiscountAmount;
	int? mrspeedyOrderId;
	String? lalamoveOrderId;
	String? lalamoveQuotationId;
	String? trackingUrl;
	String? orderDateTime;
	String? paymentDateTime;
	String? scheduledAt;
	List<OrderItems>? orderItems;
	UserVoucher? userVoucher;

	OrderDetail(
			{this.orderId,
				this.queueId,
				this.contactNumber,
				this.userName,
				this.merchantId,
				this.merchantName,
				this.totalAmount,
				this.paymentMethod,
				this.paymentDescription,
				this.referenceNo,
				this.paymentStatus,
				this.status,
				this.orderPreference,
				this.orderNote,
				this.tableNo,
				this.address,
				this.deliveryVehicleType,
				this.deliveryLatitude,
				this.deliveryLongitude,
				this.floorUnit,
				this.noteDelivery,
				this.discountAmount,
				this.merchantVoucherDiscountAmount,
				this.tfTaxRate,
				this.taxAmount,
				this.tfDiscountRate,
				this.tfDiscountAmount,
				this.serviceChargeRate,
				this.serviceChargeAmount,
				this.governmentTaxRate,
				this.governmentTaxAmount,
				this.merchantCommissionRate,
				this.merchantCommissionAmount,
				this.merchantChargesRate,
				this.merchantChargesAmount,
				this.deliveryAmount,
				this.deliveryMarkupRate,
				this.deliveryMarkupAmount,
				this.deliveryDiscountAmount,
				this.tfDeliveryDiscountAmount,
				this.mrspeedyOrderId,
				this.lalamoveOrderId,
				this.lalamoveQuotationId,
				this.trackingUrl,
				this.orderDateTime,
				this.paymentDateTime,
				this.scheduledAt,
				this.orderItems,
			this.userVoucher});

	OrderDetail.fromJson(Map<String, dynamic> json) {
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
		deliveryVehicleType = json['delivery_vehicle_type'];
		deliveryLatitude = json['delivery_latitude'];
		deliveryLongitude = json['delivery_longitude'];
		floorUnit = json['floor_unit'];
		noteDelivery = json['note_delivery'];
		discountAmount = json['discountAmount'];
		merchantVoucherDiscountAmount = json['merchant_voucher_discount_amount'];
		tfTaxRate = json['tf_tax_rate'];
		taxAmount = json['taxAmount'];
		tfDiscountRate = json['tf_discount_rate'];
		tfDiscountAmount = json['tf_discount_amount'];
		serviceChargeRate = json['service_charge_rate'];
		serviceChargeAmount = json['service_charge_amount'];
		governmentTaxRate = json['government_tax_rate'];
		governmentTaxAmount = json['government_tax_amount'];
		merchantCommissionRate = json['merchant_commission_rate'];
		merchantCommissionAmount = json['merchant_commission_amount'];
		merchantChargesRate = json['merchant_charges_rate'];
		merchantChargesAmount = json['merchant_charges_amount'];
		deliveryAmount = json['delivery_amount'];
		deliveryMarkupRate = json['delivery_markup_rate'];
		deliveryMarkupAmount = json['delivery_markup_amount'];
		deliveryDiscountAmount = json['delivery_discount_amount'];
		tfDeliveryDiscountAmount = json['tf_delivery_discount_amount'];
		mrspeedyOrderId = json['mrspeedy_orderId'];
		lalamoveOrderId = json['lalamove_orderId'];
		lalamoveQuotationId = json['lalamove_quotationId'];
		trackingUrl = json['tracking_url'];
		orderDateTime = json['orderDateTime'];
		paymentDateTime = json['paymentDateTime'];
		scheduledAt = json['scheduled_at'];
		if (json['order_items'] != null) {
			orderItems = <OrderItems>[];
			json['order_items'].forEach((v) {
				orderItems!.add(new OrderItems.fromJson(v));
			});
		}
		if (json['user_voucher'] != null) {
			userVoucher = UserVoucher.fromJson(json['user_voucher']);
		}
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
		data['delivery_vehicle_type'] = deliveryVehicleType;
		data['delivery_latitude'] = deliveryLatitude;
		data['delivery_longitude'] = deliveryLongitude;
		data['floor_unit'] = floorUnit;
		data['note_delivery'] = noteDelivery;
		data['discountAmount'] = discountAmount;
		data['merchant_voucher_discount_amount'] =
				merchantVoucherDiscountAmount;
		data['tf_tax_rate'] = tfTaxRate;
		data['taxAmount'] = taxAmount;
		data['tf_discount_rate'] = tfDiscountRate;
		data['tf_discount_amount'] = tfDiscountAmount;
		data['service_charge_rate'] = serviceChargeRate;
		data['service_charge_amount'] = serviceChargeAmount;
		data['government_tax_rate'] = governmentTaxRate;
		data['government_tax_amount'] = governmentTaxAmount;
		data['merchant_commission_rate'] = merchantCommissionRate;
		data['merchant_commission_amount'] = merchantCommissionAmount;
		data['merchant_charges_rate'] = merchantChargesRate;
		data['merchant_charges_amount'] = merchantChargesAmount;
		data['delivery_amount'] = deliveryAmount;
		data['delivery_markup_rate'] = deliveryMarkupRate;
		data['delivery_markup_amount'] = deliveryMarkupAmount;
		data['delivery_discount_amount'] = deliveryDiscountAmount;
		data['tf_delivery_discount_amount'] = tfDeliveryDiscountAmount;
		data['mrspeedy_orderId'] = mrspeedyOrderId;
		data['lalamove_orderId'] = lalamoveOrderId;
		data['lalamove_quotationId'] = lalamoveQuotationId;
		data['tracking_url'] = trackingUrl;
		data['orderDateTime'] = orderDateTime;
		data['paymentDateTime'] = paymentDateTime;
		data['scheduled_at'] = scheduledAt;
		if (orderItems != null) {
			data['order_items'] = orderItems!.map((v) => v.toJson()).toList();
		}
		if (userVoucher != null) {
			data['user_voucher'] = userVoucher?.toJson();
		}
		return data;
	}
}

class OrderItems {
	int? orderItemId;
	int? orderId;
	int? menuItemId;
	String? remarks;
	int? quantity;
	String? amount;
	int? status;
	String? createdDateTime;
	String? updatedDateTime;
	MenuItem? menuItem;
	List<OrderItemAddons>? orderItemAddons;

	OrderItems(
			{this.orderItemId,
				this.orderId,
				this.menuItemId,
				this.remarks,
				this.quantity,
				this.amount,
				this.status,
				this.createdDateTime,
				this.updatedDateTime,
				this.menuItem,
				this.orderItemAddons});

	OrderItems.fromJson(Map<String, dynamic> json) {
		orderItemId = json['orderItemId'];
		orderId = json['orderId'];
		menuItemId = json['menuItemId'];
		remarks = json['remarks'];
		quantity = json['quantity'];
		amount = json['amount'];
		status = json['status'];
		createdDateTime = json['createdDateTime'];
		updatedDateTime = json['updatedDateTime'];
		menuItem = json['menu_item'] != null
				? new MenuItem.fromJson(json['menu_item'])
				: null;
		if (json['order_item_addons'] != null) {
			orderItemAddons = <OrderItemAddons>[];
			json['order_item_addons'].forEach((v) {
				orderItemAddons!.add(new OrderItemAddons.fromJson(v));
			});
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['orderItemId'] = orderItemId;
		data['orderId'] = orderId;
		data['menuItemId'] = menuItemId;
		data['remarks'] = remarks;
		data['quantity'] = quantity;
		data['amount'] = amount;
		data['status'] = status;
		data['createdDateTime'] = createdDateTime;
		data['updatedDateTime'] = updatedDateTime;
		if (menuItem != null) {
			data['menu_item'] = menuItem!.toJson();
		}
		if (orderItemAddons != null) {
			data['order_item_addons'] =
					orderItemAddons!.map((v) => v.toJson()).toList();
		}
		return data;
	}
}

class MenuItem {
	int? menuItemId;
	String? name;
	String? description;
	int? category;
	int? halal;
	String? price;
	String? takeAwayPrice;
	String? deliveryPrice;
	int? availability;
	int? status;
	String? menuItemImage;
	int? totalSold;
	int? menuId;
	String? createdDateTime;
	String? updatedDateTime;
	String? deletedDateTime;

	MenuItem(
			{this.menuItemId,
				this.name,
				this.description,
				this.category,
				this.halal,
				this.price,
				this.takeAwayPrice,
				this.deliveryPrice,
				this.availability,
				this.status,
				this.menuItemImage,
				this.totalSold,
				this.menuId,
				this.createdDateTime,
				this.updatedDateTime,
				this.deletedDateTime});

	MenuItem.fromJson(Map<String, dynamic> json) {
		menuItemId = json['menuItemId'];
		name = json['name'];
		description = json['description'];
		category = json['category'];
		halal = json['halal'];
		price = json['price'];
		takeAwayPrice = json['takeAwayPrice'];
		deliveryPrice = json['deliveryPrice'];
		availability = json['availability'];
		status = json['status'];
		menuItemImage = json['menuItemImage'];
		totalSold = json['total_sold'];
		menuId = json['menuId'];
		createdDateTime = json['createdDateTime'];
		updatedDateTime = json['updatedDateTime'];
		deletedDateTime = json['deletedDateTime'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['menuItemId'] = menuItemId;
		data['name'] = name;
		data['description'] = description;
		data['category'] = category;
		data['halal'] = halal;
		data['price'] = price;
		data['takeAwayPrice'] = takeAwayPrice;
		data['deliveryPrice'] = deliveryPrice;
		data['availability'] = availability;
		data['status'] = status;
		data['menuItemImage'] = menuItemImage;
		data['total_sold'] = totalSold;
		data['menuId'] = menuId;
		data['createdDateTime'] = createdDateTime;
		data['updatedDateTime'] = updatedDateTime;
		data['deletedDateTime'] = deletedDateTime;
		return data;
	}
}

class OrderItemAddons {
	int? orderItemAddonId;
	int? orderItemId;
	int? addonId;
	int? quantity;
	String? price;
	String? createdDateTime;
	String? updatedDateTime;
	Addon? addon;

	OrderItemAddons(
			{this.orderItemAddonId,
				this.orderItemId,
				this.addonId,
				this.quantity,
				this.price,
				this.createdDateTime,
				this.updatedDateTime,
				this.addon});

	OrderItemAddons.fromJson(Map<String, dynamic> json) {
		orderItemAddonId = json['orderItemAddonId'];
		orderItemId = json['orderItemId'];
		addonId = json['addonId'];
		quantity = json['quantity'];
		price = json['price'];
		createdDateTime = json['createdDateTime'];
		updatedDateTime = json['updatedDateTime'];
		addon = json['addon'] != null ? new Addon.fromJson(json['addon']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['orderItemAddonId'] = orderItemAddonId;
		data['orderItemId'] = orderItemId;
		data['addonId'] = addonId;
		data['quantity'] = quantity;
		data['price'] = price;
		data['createdDateTime'] = createdDateTime;
		data['updatedDateTime'] = updatedDateTime;
		if (addon != null) {
			data['addon'] = addon!.toJson();
		}
		return data;
	}
}

class Addon {
	int? addonId;
	String? name;
	String? price;
	int? status;
	int? addonCategoryId;
	int? merchantId;
	String? createdDateTime;
	String? updatedDateTime;
	String? deletedDateTime;

	Addon(
			{this.addonId,
				this.name,
				this.price,
				this.status,
				this.addonCategoryId,
				this.merchantId,
				this.createdDateTime,
				this.updatedDateTime,
				this.deletedDateTime});

	Addon.fromJson(Map<String, dynamic> json) {
		addonId = json['addonId'];
		name = json['name'];
		price = json['price'];
		status = json['status'];
		addonCategoryId = json['addonCategoryId'];
		merchantId = json['merchantId'];
		createdDateTime = json['createdDateTime'];
		updatedDateTime = json['updatedDateTime'];
		deletedDateTime = json['deletedDateTime'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['addonId'] = addonId;
		data['name'] = name;
		data['price'] = price;
		data['status'] = status;
		data['addonCategoryId'] = addonCategoryId;
		data['merchantId'] = merchantId;
		data['createdDateTime'] = createdDateTime;
		data['updatedDateTime'] = updatedDateTime;
		data['deletedDateTime'] = deletedDateTime;
		return data;
	}
}

class UserVoucher {
	int? id;
	String? contactNumber;
	int? voucherId;
	int? orderId;
	String? discountTotalAmount;
	int? status;
	String? dateCreated;
	Voucher? voucher;

	UserVoucher(
			{this.id,
				this.contactNumber,
				this.voucherId,
				this.orderId,
				this.discountTotalAmount,
				this.status,
				this.dateCreated,
				this.voucher});

	UserVoucher.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		contactNumber = json['contact_number'];
		voucherId = json['voucherId'];
		orderId = json['orderId'];
		discountTotalAmount = json['discountTotalAmount'];
		status = json['status'];
		dateCreated = json['date_created'];
		voucher =
		json['voucher'] != null ? new Voucher.fromJson(json['voucher']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['contact_number'] = this.contactNumber;
		data['voucherId'] = this.voucherId;
		data['orderId'] = this.orderId;
		data['discountTotalAmount'] = this.discountTotalAmount;
		data['status'] = this.status;
		data['date_created'] = this.dateCreated;
		if (this.voucher != null) {
			data['voucher'] = this.voucher!.toJson();
		}
		return data;
	}
}

class Voucher {
	int? id;
	String? code;
	String? name;
	String? description;
	int? uses;
	int? maxUses;
	String? minimumOrderAmount;
	int? discountAmount;
	String? maximumOfferAmount;
	int? type;
	int? preference;
	int? tapPlusOnly;
	int? maximumRedemptionPerUser;
	int? maximumRedemptionPerDay;
	int? maximumRedemptionPerUserPerDay;
	String? startTime;
	String? endTime;
	String? contactNumber;
	String? merchantIds;
	String? startsAt;
	String? expiresAt;
	int? bareType;
	int? isHidden;
	int? userId;

	Voucher(
			{this.id,
				this.code,
				this.name,
				this.description,
				this.uses,
				this.maxUses,
				this.minimumOrderAmount,
				this.discountAmount,
				this.maximumOfferAmount,
				this.type,
				this.preference,
				this.tapPlusOnly,
				this.maximumRedemptionPerUser,
				this.maximumRedemptionPerDay,
				this.maximumRedemptionPerUserPerDay,
				this.startTime,
				this.endTime,
				this.contactNumber,
				this.merchantIds,
				this.startsAt,
				this.expiresAt,
				this.bareType,
				this.isHidden,
				this.userId});

	Voucher.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		code = json['code'];
		name = json['name'];
		description = json['description'];
		uses = json['uses'];
		maxUses = json['max_uses'];
		minimumOrderAmount = json['minimumOrderAmount'];
		discountAmount = json['discountAmount'];
		maximumOfferAmount = json['maximumOfferAmount'];
		type = json['type'];
		preference = json['preference'];
		tapPlusOnly = json['tap_plus_only'];
		maximumRedemptionPerUser = json['maximum_redemption_per_user'];
		maximumRedemptionPerDay = json['maximum_redemption_per_day'];
		maximumRedemptionPerUserPerDay =
		json['maximum_redemption_per_user_per_day'];
		startTime = json['start_time'];
		endTime = json['end_time'];
		contactNumber = json['contact_number'];
		merchantIds = json['merchantIds'];
		startsAt = json['starts_at'];
		expiresAt = json['expires_at'];
		bareType = json['bare_type'];
		isHidden = json['is_hidden'];
		userId = json['userId'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['code'] = this.code;
		data['name'] = this.name;
		data['description'] = this.description;
		data['uses'] = this.uses;
		data['max_uses'] = this.maxUses;
		data['minimumOrderAmount'] = this.minimumOrderAmount;
		data['discountAmount'] = this.discountAmount;
		data['maximumOfferAmount'] = this.maximumOfferAmount;
		data['type'] = this.type;
		data['preference'] = this.preference;
		data['tap_plus_only'] = this.tapPlusOnly;
		data['maximum_redemption_per_user'] = this.maximumRedemptionPerUser;
		data['maximum_redemption_per_day'] = this.maximumRedemptionPerDay;
		data['maximum_redemption_per_user_per_day'] =
				this.maximumRedemptionPerUserPerDay;
		data['start_time'] = this.startTime;
		data['end_time'] = this.endTime;
		data['contact_number'] = this.contactNumber;
		data['merchantIds'] = this.merchantIds;
		data['starts_at'] = this.startsAt;
		data['expires_at'] = this.expiresAt;
		data['bare_type'] = this.bareType;
		data['is_hidden'] = this.isHidden;
		data['userId'] = this.userId;
		return data;
	}
}