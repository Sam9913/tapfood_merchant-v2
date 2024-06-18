class MenuAddon {
  int? menuId;
  String? name;
  int? type;
  int? status;
  int? merchantId;
  String? createdDateTime;
  String? updatedDateTime;
  String? deletedDateTime;
  int? totalLinkedCount;
  int? itemCount;
  List<MenuAddonItem>? menuItems;

  MenuAddon(
      {this.menuId,
      this.name,
      this.type,
      this.status,
      this.merchantId,
      this.createdDateTime,
      this.updatedDateTime,
      this.deletedDateTime,
      this.totalLinkedCount,
      this.itemCount,
      this.menuItems});

  MenuAddon.fromJson(Map<String, dynamic> json) {
    menuId = json['menuId'];
    name = json['name'];
    type = json['type'];
    status = json['status'];
    merchantId = json['merchantId'];
    createdDateTime = json['createdDateTime'];
    updatedDateTime = json['updatedDateTime'];
    deletedDateTime = json['deletedDateTime'];
    itemCount = json['item_count'];
    totalLinkedCount = json['total_linked_count'];
    if (json['menu_items'] != null) {
      menuItems = <MenuAddonItem>[];
      json['menu_items'].forEach((v) {
        menuItems!.add(MenuAddonItem.fromJson(v));
      });
    }
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
    data['total_linked_count'] = totalLinkedCount;
    if (menuItems != null) {
      data['menu_items'] = menuItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MenuAddonItem {
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
  int? linkedCount;
  List<MenuItemAddons>? menuItemAddons;

  MenuAddonItem(
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
      this.deletedDateTime,
        this.linkedCount,
        this.menuItemAddons});

  MenuAddonItem.fromJson(Map<String, dynamic> json) {
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
    linkedCount = json['linked_count'];
    if (json['menu_item_addons'] != null) {
      menuItemAddons = <MenuItemAddons>[];
      json['menu_item_addons'].forEach((v) {
        menuItemAddons!.add(MenuItemAddons.fromJson(v));
      });
    }
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
    data['linked_count'] = linkedCount;
    if (menuItemAddons != null) {
      data['menu_item_addons'] =
          menuItemAddons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MenuItemAddons {
  int? menuitemaddonId;
  int? addonCategoryId;
  int? menuitemId;
  String? createdDateTime;
  String? updatedDateTime;
  String? deletedDateTime;

  MenuItemAddons(
      {this.menuitemaddonId,
        this.addonCategoryId,
        this.menuitemId,
        this.createdDateTime,
        this.updatedDateTime,
        this.deletedDateTime});

  MenuItemAddons.fromJson(Map<String, dynamic> json) {
    menuitemaddonId = json['menuitemaddonId'];
    addonCategoryId = json['addonCategoryId'];
    menuitemId = json['menuitemId'];
    createdDateTime = json['createdDateTime'];
    updatedDateTime = json['updatedDateTime'];
    deletedDateTime = json['deletedDateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['menuitemaddonId'] = menuitemaddonId;
    data['addonCategoryId'] = addonCategoryId;
    data['menuitemId'] = menuitemId;
    data['createdDateTime'] = createdDateTime;
    data['updatedDateTime'] = updatedDateTime;
    data['deletedDateTime'] = deletedDateTime;
    return data;
  }
}