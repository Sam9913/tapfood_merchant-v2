import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:tapfood_v2/model/Addon.dart';
import 'package:tapfood_v2/model/AddonCategory.dart';
import 'package:tapfood_v2/model/Menu.dart';
import 'package:tapfood_v2/model/MenuItem.dart';
import 'package:tapfood_v2/model/SearchResult.dart';
import 'package:tapfood_v2/services/MenuServices.dart';

class MenuProvider extends ChangeNotifier {
  List<Menu> _menuList = [];
  List<Menu> _inactiveMenuList = [];
  List<Menu> _activeMenuList = [];
  late MenuItem _selectedMenuItem;
  List<Menu> get menuList => _menuList;
  List<Menu> get inactiveMenuList => _inactiveMenuList;
  List<Menu> get activeMenuList => _activeMenuList;
  MenuItem get selectedMenuItem => _selectedMenuItem;
  MenuServices menuServices = MenuServices();

  Future<bool> getAll() async {
    try {
      _menuList = await menuServices.getAll();

      _inactiveMenuList = [];
      _activeMenuList = [];
      for (var i = 0; i < _menuList.length; i++) {
        if (_menuList[i].status == 0) {
          _inactiveMenuList.add(_menuList[i]);
        } else {
          _activeMenuList.add(_menuList[i]);
        }
      }

      notifyListeners();
      return true;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<MenuItem>> getByMenuId(int menuId) async {
    try {
      final _menuItemList = await menuServices.getByMenuId(menuId);

      notifyListeners();
      return _menuItemList;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> getMenuItemById(int menuItemId) async {
    try {
      _selectedMenuItem = await menuServices.getMenuItemById(menuItemId);

      notifyListeners();
      return true;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> insertMenu(String name, bool status, int typeId) async {
    try {
      final response = await menuServices.insertMenu(name, typeId, status ? 1 : 0);

      notifyListeners();
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> updateMenu(String name, bool status, int typeId, int menuId) async {
    try {
      final response = await menuServices.updateMenu(name, typeId, status ? 1 : 0, menuId);

      notifyListeners();
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> deleteMenu(int menuId) async {
    try {
      final response = await menuServices.deleteMenu(menuId);

      notifyListeners();
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> insertMenuItem(
      String name,
      int category,
      String description,
      String price,
      String takeAwayPrice,
      String deliveryPrice,
      int menuId,
      int availability,
      int status,
      MultipartFile? menuItemImage) async {
    try {
      final response = await menuServices.insertMenuItem(name, category, description, price,
          takeAwayPrice, deliveryPrice, menuItemImage, menuId, availability, status);

      notifyListeners();
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> updateMenuItem(
      String name,
      int category,
      String description,
      String price,
      String takeAwayPrice,
      String deliveryPrice,
      int menuId,
      int availability,
      int status,
      int menuItemId,
      MultipartFile? menuItemImage) async {
    try {
      bool iSuccess = await menuServices.updateMenuItem(name, category, description, price,
          takeAwayPrice, deliveryPrice, menuId, availability, status, menuItemId);

      if (iSuccess && menuItemImage != null) {
        iSuccess = await menuServices.updateMenuItemImage(menuItemImage, menuItemId);
      }

      notifyListeners();
      return iSuccess;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> updateMenuItemStatus(int status, int menuItemId) async {
    try {
      final response = await menuServices.updateMenuItemStatus(status, menuItemId);

      notifyListeners();
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> deleteMenuItem(int menuItemId) async {
    try {
      final response = await menuServices.deleteMenuItem(menuItemId);

      notifyListeners();
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<SearchResult>> search(String name) async {
    try {
      List<Menu> menuResult = await menuServices.searchMenu(name);
      List<MenuItem> menuItemResult = await menuServices.searchMenuItem(name);
      List<SearchResult> searchResult = [];

      for (var element in menuResult) {
        searchResult.add(SearchResult(
            id: element.menuId,
            name: element.name,
            type: 0,
            addon: Addon(),
            addonCategory: AddonCategory(),
            menuItem: MenuItem(),
            menu: element));
      }

      for (var element in menuItemResult) {
        searchResult.add(SearchResult(
            id: element.menuItemId,
            name: element.name,
            type: 1,
            addon: Addon(),
            addonCategory: AddonCategory(),
            menuItem: element,
            menu: Menu(menuId: 0)));
      }

      notifyListeners();
      return searchResult;
    } catch (error) {
      rethrow;
    }
  }
}
