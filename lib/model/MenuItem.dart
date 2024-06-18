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

class MenuItemDetail {
	late MenuItem detail;
	List<String>? addon;

	MenuItemDetail({required this.detail, this.addon});

	MenuItemDetail.fromJson(Map<String, dynamic> json) {
		detail = MenuItem.fromJson(json['detail']);
		if (json['addon'] != null) {
			addon = <String>[];
			json['addon'].forEach((v) {
				addon!.add(v);
			});
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['detail'] = detail.toJson();
		if (addon != null) {
			data['addon'] = addon!.toList();
		}
		return data;
	}
}