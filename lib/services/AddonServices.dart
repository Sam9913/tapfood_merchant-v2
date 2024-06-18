import 'package:dio/dio.dart';
import 'package:tapfood_v2/config/appConfig.dart';
import 'package:tapfood_v2/model/Addon.dart';
import 'package:tapfood_v2/model/AddonCategory.dart';
import 'package:tapfood_v2/model/MenuAddon.dart';
import 'package:tapfood_v2/utils/apiHelper.dart';

class AddonServices {
  late Response response;
  Config config = Config();
  ApiHelper apiHelper = ApiHelper(Config().baseUrl);

  Future<List<AddonCategory>> getAll() async {
    List<AddonCategory> addonCategoryList = [];

    try {
      response = await apiHelper.get('addonCategory/getAll');

      if (response.data != null) {
        response.data
            .forEach((e) => {addonCategoryList.add(AddonCategory.fromJson(e))});
      }
    } catch (e) {
      rethrow;
    }
    return addonCategoryList;
  }

  Future<List<AddonCategory>> getByType(int type) async {
    List<AddonCategory> addonCategoryList = [];

    try {
      response = await apiHelper.get('addonCategory/getByType/$type');

      if (response.data != null) {
        response.data
            .forEach((e) => {addonCategoryList.add(AddonCategory.fromJson(e))});
      }
    } catch (e) {
      rethrow;
    }
    return addonCategoryList;
  }

  Future<bool> insertAddonCategory(
      String name, String description, int type, int status) async {
    bool isSuccess = false;
    try {
      response = await apiHelper.put('addonCategory/insert', data: {
        "name": name,
        "description": description,
        "type": type,
        "status": status
      });

      if (response.statusCode == 200) {
        isSuccess = true;
      }
    } catch (e) {
      isSuccess = false;
      //rethrow;
    }
    return isSuccess;
  }

  Future<bool> updateAddonCategory(String name, String description, int type,
      int status, int addonCategoryId) async {
    bool isSuccess = false;
    try {
      response = await apiHelper.post('addonCategory/update', data: {
        "name": name,
        "description": description,
        "type": type,
        "status": status,
        "addonCategoryId": addonCategoryId
      });

      if (response.statusCode == 200) {
        isSuccess = true;
      }
    } catch (e) {
      isSuccess = false;
      //rethrow;
    }
    return isSuccess;
  }

  Future<bool> updateAddonCategoryStatus(
      int status, int addonCategoryId) async {
    bool isSuccess = false;
    try {
      response = await apiHelper.post('addonCategory/updateStatus',
          data: {"status": status, "id": addonCategoryId});

      if (response.statusCode == 200) {
        isSuccess = true;
      }
    } catch (e) {
      isSuccess = false;
      //rethrow;
    }
    return isSuccess;
  }

  Future<bool> deleteAddonCategory(int addonCategoryId) async {
    bool isSuccess = false;
    try {
      response = await apiHelper.delete('addonCategory/delete',
          data: {"addonCategoryId": addonCategoryId});

      if (response.statusCode == 200) {
        isSuccess = true;
      }
    } catch (e) {
      isSuccess = false;
      //rethrow;
    }
    return isSuccess;
  }

  Future<List<Addon>> getByCategory(int category) async {
    List<Addon> addonList = [];

    try {
      response = await apiHelper.get('addon/getByCategory/$category');

      if (response.data != null) {
        response.data.forEach((e) => {addonList.add(Addon.fromJson(e))});
      }
    } catch (e) {
      rethrow;
    }
    return addonList;
  }

  Future<Addon> getById(int id) async {
    late Addon addon;

    try {
      response = await apiHelper.get('addon/getById/$id');

      if (response.data != null) {
        addon = Addon.fromJson(response.data);
      }
    } catch (e) {
      rethrow;
    }
    return addon;
  }

  Future<bool> insertAddon(
      String name, String price, bool status, int addonCategoryId) async {
    bool isSuccess = false;
    try {
      response = await apiHelper.put('addon/insert', data: {
        "name": name,
        "price": price,
        "status": status ? 1 : 0,
        "addonCategoryId": addonCategoryId
      });

      if (response.statusCode == 200) {
        isSuccess = true;
      }
    } catch (e) {
      isSuccess = false;
      //rethrow;
    }

    return isSuccess;
  }

  Future<bool> updateAddon(int id, String name, String price, bool status,
      int addonCategoryId) async {
    bool isSuccess = false;
    try {
      response = await apiHelper.post('addon/update', data: {
        "addonId": id,
        "name": name,
        "price": price,
        "status": status ? 1 : 0,
        "addonCategoryId": addonCategoryId
      });

      if (response.statusCode == 200) {
        isSuccess = true;
      }
    } catch (e) {
      isSuccess = false;
      //rethrow;
    }

    return isSuccess;
  }

  Future<bool> updateAddonStatus(int status, int id) async {
    bool isSuccess = false;
    try {
      response = await apiHelper
          .post('addon/updateStatus', data: {"status": status, "id": id});

      if (response.statusCode == 200) {
        isSuccess = true;
      }
    } catch (e) {
      isSuccess = false;
    }

    return isSuccess;
  }

  Future<bool> deleteAddon(int id) async {
    bool isSuccess = false;
    try {
      response = await apiHelper.delete('addon/delete', data: {"addonId": id});

      if (response.statusCode == 200) {
        isSuccess = true;
      }
    } catch (e) {
      isSuccess = false;
      //rethrow;
    }

    return isSuccess;
  }

  Future<List<AddonCategory>> searchAddonCategory(String name) async {
    List<AddonCategory> addonCategoryList = [];

    try {
      response = await apiHelper.get('addonCategory/search?name=$name');

      if (response.data != null) {
        response.data
            .forEach((e) => {addonCategoryList.add(AddonCategory.fromJson(e))});
      }
    } catch (e) {
      rethrow;
    }
    return addonCategoryList;
  }

  Future<List<Addon>> searchAddon(String name) async {
    List<Addon> addonList = [];

    try {
      response = await apiHelper.get('addon/search?name=$name');

      if (response.data != null) {
        response.data.forEach((e) => {addonList.add(Addon.fromJson(e))});
      }
    } catch (e) {
      rethrow;
    }
    return addonList;
  }

  Future<List<MenuAddon>> getLinkedMenu(int addonCategoryId) async {
    List<MenuAddon> menuAddonList = <MenuAddon>[];

    try {
      response =
          await apiHelper.get('menuAddon/get?addonCategoryId=$addonCategoryId');

      if (response.data != null) {
        response.data
            .forEach((e) => {menuAddonList.add(MenuAddon.fromJson(e))});

        for (var element in menuAddonList) {
          element.menuItems?.removeWhere((element) => element.deletedDateTime != null);
        }
      }
    } catch (e) {
      rethrow;
    }

    return menuAddonList;
  }

  Future<bool> insertMenuAddon(int menuItemId, int addonCategoryId) async {
    try {
      response = await apiHelper.put('menuAddon/insert',
          data: {"menuItemId": menuItemId, "addonCategoryId": addonCategoryId});

      if (response.statusCode == 200) {
        return response.data == "success" ? true : false;
      }
    } catch (e) {
      rethrow;
    }

    return false;
  }

  Future<bool> deleteMenuAddon(int menuItemId, int addonCategoryId) async {
    try {
      response = await apiHelper.delete('menuAddon/delete',
          data: {"menuItemId": menuItemId, "addonCategoryId": addonCategoryId});

      if (response.statusCode == 200) {
        return response.data == "success" ? true : false;
      }
    } catch (e) {
      rethrow;
    }

    return false;
  }
}
