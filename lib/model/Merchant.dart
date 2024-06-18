class Merchant {
	int? merchantId;
	String? name;
	String? location;
	String? latitude;
	String? longitude;
	String? url;
	int? operationStatus;
	int? promoStatus;
	String? averageRating;
	int? totalRate;
	int? totalSold;
	int? paymentPreference;
	String? autoOperationOnoff;
	int? autoAcceptOrder;
	String? coverImage;
	int? tapPlus;
	String? tapPlusImage1;
	String? tapPlusImage2;
	String? tapPlusImage3;
	int? bankAccountId;
	int? merchantPreferenceId;
	int? userId;
	int? cityId;
	String? createdDateTime;
	String? updatedDateTime;
	User? user;

	Merchant(
			{this.merchantId,
				this.name,
				this.location,
				this.latitude,
				this.longitude,
				this.url,
				this.operationStatus,
				this.promoStatus,
				this.averageRating,
				this.totalRate,
				this.totalSold,
				this.paymentPreference,
				this.autoOperationOnoff,
				this.autoAcceptOrder,
				this.coverImage,
				this.tapPlus,
				this.tapPlusImage1,
				this.tapPlusImage2,
				this.tapPlusImage3,
				this.bankAccountId,
				this.merchantPreferenceId,
				this.userId,
				this.cityId,
				this.createdDateTime,
				this.updatedDateTime,
			this.user});

	Merchant.fromJson(Map<String, dynamic> json) {
		merchantId = json['merchantId'];
		name = json['name'];
		location = json['location'];
		latitude = json['latitude'];
		longitude = json['longitude'];
		url = json['url'];
		operationStatus = json['operationStatus'];
		promoStatus = json['promo_status'];
		averageRating = json['average_rating'];
		totalRate = json['total_rate'];
		totalSold = json['total_sold'];
		paymentPreference = json['payment_preference'];
		autoOperationOnoff = json['auto_operation_onoff'];
		autoAcceptOrder = json['auto_accept_order'];
		coverImage = json['cover_image'];
		tapPlus = json['tap_plus'];
		tapPlusImage1 = json['tap_plus_image_1'];
		tapPlusImage2 = json['tap_plus_image_2'];
		tapPlusImage3 = json['tap_plus_image_3'];
		bankAccountId = json['bank_account_id'];
		merchantPreferenceId = json['merchantPreferenceId'];
		userId = json['userId'];
		cityId = json['city_id'];
		createdDateTime = json['createdDateTime'];
		updatedDateTime = json['updatedDateTime'];
		user = json['user'] != null ? User.fromJson(json['user']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['merchantId'] = merchantId;
		data['name'] = name;
		data['location'] = location;
		data['latitude'] = latitude;
		data['longitude'] = longitude;
		data['url'] = url;
		data['operationStatus'] = operationStatus;
		data['promo_status'] = promoStatus;
		data['average_rating'] = averageRating;
		data['total_rate'] = totalRate;
		data['total_sold'] = totalSold;
		data['payment_preference'] = paymentPreference;
		data['auto_operation_onoff'] = autoOperationOnoff;
		data['auto_accept_order'] = autoAcceptOrder;
		data['cover_image'] = coverImage;
		data['tap_plus'] = tapPlus;
		data['tap_plus_image_1'] = tapPlusImage1;
		data['tap_plus_image_2'] = tapPlusImage2;
		data['tap_plus_image_3'] = tapPlusImage3;
		data['bank_account_id'] = bankAccountId;
		data['merchantPreferenceId'] = merchantPreferenceId;
		data['userId'] = userId;
		data['city_id'] = cityId;
		data['createdDateTime'] = createdDateTime;
		data['updatedDateTime'] = updatedDateTime;
		if(user != null){
			data['user'] = user!.toJson();
		}
		return data;
	}
}

class User {
	int? id;
	String? name;
	String? email;
	String? contactNumber;
	int? roleId;
	int? status;
	String? language;
	String? userImage;
	String? themeMode;
	String? emailVerifiedAt;
	String? createdAt;
	String? updatedAt;

	User(
			{this.id,
				this.name,
				this.email,
				this.contactNumber,
				this.roleId,
				this.status,
				this.language,
				this.userImage,
				this.themeMode,
				this.emailVerifiedAt,
				this.createdAt,
				this.updatedAt});

	User.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		name = json['name'];
		email = json['email'];
		contactNumber = json['contactNumber'];
		roleId = json['roleId'];
		status = json['status'];
		language = json['language'];
		userImage = json['userImage'];
		themeMode = json['theme_mode'];
		emailVerifiedAt = json['email_verified_at'];
		createdAt = json['created_at'];
		updatedAt = json['updated_at'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['id'] = id;
		data['name'] = name;
		data['email'] = email;
		data['contactNumber'] = contactNumber;
		data['roleId'] = roleId;
		data['status'] = status;
		data['language'] = language;
		data['userImage'] = userImage;
		data['theme_mode'] = themeMode;
		data['email_verified_at'] = emailVerifiedAt;
		data['created_at'] = createdAt;
		data['updated_at'] = updatedAt;
		return data;
	}
}