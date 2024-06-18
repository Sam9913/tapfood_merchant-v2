import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:tapfood_v2/model/Addon.dart';
import 'package:tapfood_v2/model/AddonCategory.dart';
import 'package:tapfood_v2/model/Menu.dart';
import 'package:tapfood_v2/model/MenuAddon.dart';
import 'package:tapfood_v2/model/MenuItem.dart';
import 'package:tapfood_v2/model/SearchResult.dart';
import 'package:tapfood_v2/services/AddonServices.dart';

class AddonProvider extends ChangeNotifier {
  List<MenuAddon> _menuAddonList = [];
  List<AddonCategory> _addonCategoryList = [];
  List<AddonCategory> _dropDownCategoryList = [];
  List<AddonCategory> _activeAddonCategory = [];
  List<AddonCategory> _inactiveAddonCategory = [];
  Addon _addon = Addon();
  List<MenuAddon> get menuAddonList => _menuAddonList;
  List<AddonCategory> get dropDownCategoryList => _dropDownCategoryList;
  List<AddonCategory> get addonCategoryList => _addonCategoryList;
  List<AddonCategory> get inactiveAddonCategory => _inactiveAddonCategory;
  List<AddonCategory> get activeAddonCategory => _activeAddonCategory;
  Addon get addon => _addon;
  AddonServices addonServices = AddonServices();

  Future<bool> getAllCategory() async {
    try {
      _dropDownCategoryList = await addonServices.getAll();

      notifyListeners();
      return true;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> getCategoryByType(int type) async {
    try {
      _addonCategoryList = await addonServices.getByType(type);

      _inactiveAddonCategory = [];
      _activeAddonCategory = [];

      for (var i = 0; i < _addonCategoryList.length; i++) {
        if (_addonCategoryList[i].status == 0) {
          _inactiveAddonCategory.add(_addonCategoryList[i]);
        } else {
          _activeAddonCategory.add(_addonCategoryList[i]);
        }
      }

      notifyListeners();
      return true;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Addon>> getByCategory(int category) async {
    try {
      final _addonList = await addonServices.getByCategory(category);

      notifyListeners();
      return _addonList;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> getById(int id) async {
    try {
      final addon = await addonServices.getById(id);

      _addon = addon;

      notifyListeners();
      return true;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> insertAddon(
      String name, String price, bool status, int category) async {
    try {
      final response =
          await addonServices.insertAddon(name, price, status, category);

      notifyListeners();
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> updateAddon(
      int id, String name, String price, bool status, int category) async {
    try {
      final response =
          await addonServices.updateAddon(id, name, price, status, category);

      notifyListeners();
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> updateAddonAvailability(int status, int addonId) async {
    try {
      final response = await addonServices.updateAddonStatus(status, addonId);

      notifyListeners();
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> insertAddonCategory(
      String name, String description, bool status, int type) async {
    try {
      final response = await addonServices.insertAddonCategory(
          name, description, type, status ? 1 : 0);

      notifyListeners();
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> deleteAddonCategory(int id) async {
    try {
      final response = await addonServices.deleteAddonCategory(id);

      notifyListeners();
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> updateAddonCategory(
      int id, String name, String description, bool status, int type) async {
    try {
      final response = await addonServices.updateAddonCategory(
          name, description, type, status ? 1 : 0, id);

      notifyListeners();
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> updateAddonCategoryAvailability(
      int status, int addonCategoryId) async {
    try {
      final response = await addonServices.updateAddonCategoryStatus(
          status, addonCategoryId);

      notifyListeners();
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> deleteAddon(int id) async {
    try {
      final response = await addonServices.deleteAddon(id);

      notifyListeners();
      return response;
    } catch (error) {
      rethrow;
    }
  }

  setEmptyAddon() {
    _addon = Addon();
    notifyListeners();
  }

  setAddon(Addon addon) {
    _addon = addon;
    notifyListeners();
  }

  Future<List<SearchResult>> search(String name) async {
    try {
      List<AddonCategory> addonResult =
          await addonServices.searchAddonCategory(name);
      List<Addon> addonItemResult = await addonServices.searchAddon(name);
      List<SearchResult> searchResult = [];

      for (var element in addonResult) {
        searchResult.add(SearchResult(
            name: element.name,
            type: 0,
            id: element.id,
            addonCategory: element,
            addon: Addon(),
            menu: Menu(menuId: 0),
            menuItem: MenuItem()));
      }

      for (var element in addonItemResult) {
        searchResult.add(SearchResult(
            name: element.name,
            type: 1,
            id: element.addonId,
            addon: element,
            addonCategory: AddonCategory(),
            menu: Menu(menuId: 0),
            menuItem: MenuItem()));
      }

      notifyListeners();
      return searchResult;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> getLinkedMenu(int addonCategoryId) async {
    try {
      _menuAddonList = await addonServices.getLinkedMenu(addonCategoryId);

      notifyListeners();
      return true;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> link(int menuItemId, int addonCategoryId) async {
    try {
      final response =
          await addonServices.insertMenuAddon(menuItemId, addonCategoryId);

      notifyListeners();
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> removeLink(int menuItemId, int addonCategoryId) async {
    try {
      final response =
          await addonServices.deleteMenuAddon(menuItemId, addonCategoryId);

      notifyListeners();
      return response;
    } catch (error) {
      rethrow;
    }
  }
}
