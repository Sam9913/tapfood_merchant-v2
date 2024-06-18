class Menu {
	late final int menuId;
	String? name;
	int? type;
	int? status;
	int? merchantId;
	String? createdDateTime;
	String? updatedDateTime;
	String? deletedDateTime;
	int? itemCount;

	Menu(
			{required this.menuId,
				this.name,
				this.type,
				this.status,
				this.merchantId,
				this.createdDateTime,
				this.updatedDateTime,
				this.deletedDateTime,
				this.itemCount});

	Menu.fromJson(Map<String, dynamic> json) {
		menuId = json['menuId'];
		name = json['name'];
		type = json['type'];
		status = json['status'];
		merchantId = json['merchantId'];
		createdDateTime = json['createdDateTime'];
		updatedDateTime = json['updatedDateTime'];
		deletedDateTime = json['deletedDateTime'];
		itemCount = json['item_count'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['menuId'] = menuId;
		data['name'] = name;
		data['type'] = type;
		data['status'] = status;
		data['merchantId'] = merchantId;
		data['createdDateTime'] = createdDateTime;
		data['updatedDateTime'] = updatedDateTime;
		data['deletedDateTime'] = deletedDateTime;
		data['item_count'] = itemCount;
		return data;
	}
}