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