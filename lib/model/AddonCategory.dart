class AddonCategory {
	int? id;
	String? name;
	String? description;
	int? type;
	int? status;
	int? merchantId;
	String? createdDateTime;
	String? deletedDateTime;
	int? itemCount;

	AddonCategory(
			{this.id,
				this.name,
				this.description,
				this.type,
				this.status,
				this.merchantId,
				this.createdDateTime,
				this.deletedDateTime,
				this.itemCount});

	AddonCategory.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		name = json['name'];
		description = json['description'];
		type = json['type'];
		status = json['status'];
		merchantId = json['merchantId'];
		createdDateTime = json['createdDateTime'];
		deletedDateTime = json['deletedDateTime'];
		itemCount = json['item_count'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['id'] = id;
		data['name'] = name;
		data['description'] = description;
		data['type'] = type;
		data['status'] = status;
		data['merchantId'] = merchantId;
		data['createdDateTime'] = createdDateTime;
		data['deletedDateTime'] = deletedDateTime;
		data['item_count'] = itemCount;
		return data;
	}
}