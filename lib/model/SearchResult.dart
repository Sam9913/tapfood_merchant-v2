import 'package:tapfood_v2/model/Addon.dart';
import 'package:tapfood_v2/model/AddonCategory.dart';
import 'package:tapfood_v2/model/Menu.dart';
import 'package:tapfood_v2/model/MenuItem.dart';

class SearchResult {
  int? type;
  String? name;
  int? id;
  late AddonCategory addonCategory;
  late Addon addon;
  late Menu menu;
  late MenuItem menuItem;

  SearchResult(
      {this.type,
      this.name,
      this.id,
      required this.addon,
      required this.addonCategory,
      required this.menuItem,
      required this.menu});

  SearchResult.fromJson(Map<String, dynamic> json) {
    type = json['Type'];
    name = json['Name'];
    id = json['id'];
    addon = json['addon'];
    addonCategory = json['addonCategory'];
    menuItem = json['menuItem'];
    menu = json['menu'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Type'] = type;
    data['Name'] = name;
    data['id'] = id;
    data['addon'] = addon;
    data['addonCategory'] = addonCategory;
    data['menuItem'] = menuItem;
    data['menu'] = menu;
    return data;
  }
}
