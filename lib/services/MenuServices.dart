import 'package:dio/dio.dart';
import 'package:tapfood_v2/config/appConfig.dart';
import 'package:tapfood_v2/model/Menu.dart';
import 'package:tapfood_v2/model/MenuItem.dart';
import 'package:tapfood_v2/utils/apiHelper.dart';

class MenuServices {
  late Response response;
  Config config = Config();
  ApiHelper apiHelper = ApiHelper(Config().baseUrl);

  Future<List<Menu>> getAll() async {
    List<Menu> menuList = [];

    try {
      response = await apiHelper.get('menu/getAll');

      if (response.data != null) {
        response.data.forEach((e) => {menuList.add(Menu.fromJson(e))});
      }
    } catch (e) {
      rethrow;
    }
    return menuList;
  }

  Future<Menu> getMenuById(int menuId) async {
    late Menu menu;

    try {
      response = await apiHelper.get('menu/getById/$menuId');

      if (response.data != null) {
        menu = Menu.fromJson(response.data);
      }
    } catch (e) {
      rethrow;
    }
    return menu;
  }

  Future<bool> insertMenu(String name, int type, int status) async {
    bool isSuccess = false;

    try {
      response =
          await apiHelper.put('menu/insert', data: {"name": name, "type": type, "status": status});

      if (response.statusCode == 200) {
        isSuccess = true;
      }
    } catch (e) {
      isSuccess = false;
      //rethrow;
    }
    return isSuccess;
  }

  Future<bool> updateMenu(String name, int type, int status, int menuId) async {
    bool isSuccess = false;

    try {
      response = await apiHelper.post('menu/update',
          data: {"name": name, "type": type, "status": status, "menuId": menuId});

      if (response.statusCode == 200) {
        isSuccess = true;
      }
    } catch (e) {
      isSuccess = false;
      //rethrow;
    }
    return isSuccess;
  }

  Future<bool> updateMenuStatus(int status, int menuId) async {
    bool isSuccess = false;

    try {
      response = await apiHelper.post('menu/updateStatus', data: {"status": status, "id": menuId});

      if (response.statusCode == 200) {
        isSuccess = true;
      }
    } catch (e) {
      isSuccess = false;
      //rethrow;
    }
    return isSuccess;
  }

  Future<bool> deleteMenu(int menuId) async {
    bool isSuccess = false;

    try {
      response = await apiHelper.delete('menu/delete', data: {"menuId": menuId});

      if (response.statusCode == 200) {
        isSuccess = true;
      }
    } catch (e) {
      isSuccess = false;
      //rethrow;
    }
    return isSuccess;
  }

  Future<List<MenuItem>> getByMenuId(int menuId) async {
    List<MenuItem> menuItemList = [];

    try {
      response = await apiHelper.get('menuItem/getByMenuId/$menuId}');

      if (response.data != null) {
        response.data.forEach((e) => {menuItemList.add(MenuItem.fromJson(e))});
      }
    } catch (e) {
      rethrow;
    }
    return menuItemList;
  }

  Future<MenuItem> getMenuItemById(int menuItemId) async {
    late MenuItem menuItem;

    try {
      response = await apiHelper.get('menuItem/getById/$menuItemId');

      if (response.data != null) {
        menuItem = MenuItem.fromJson(response.data[0]);
      }
    } catch (e) {
      rethrow;
    }

    return menuItem;
  }

  Future<bool> insertMenuItem(
      String name,
      int category,
      String description,
      String price,
      String takeAwayPrice,
      String deliveryPrice,
      MultipartFile? menuItemImage,
      int menuId,
      int availability,
      int status) async {
    bool isSuccess = false;

    try {
      response = await apiHelper.post('menuItem/insert',
          data: FormData.fromMap({
            "name": name,
            "category": category,
            "description": description,
            "price": price,
            "takeAwayPrice": takeAwayPrice,
            "deliveryPrice": deliveryPrice,
            "menuItemImage": menuItemImage,
            "menuId": menuId,
            "availability": availability,
            "status": status
          }));

      if (response.statusCode == 200) {
        isSuccess = true;
      }
    } catch (e) {
      isSuccess = false;
    }
    return isSuccess;
  }

  Future<bool> updateMenuItemImage(MultipartFile menuItemImage, int menuItemId) async {
    bool isSuccess = false;

    try {
      response = await apiHelper.post('menuItem/updateImage',
          data: FormData.fromMap({"menuItemImage": menuItemImage, "menuItemId": menuItemId}));

      if (response.statusCode == 200) {
        isSuccess = true;
      }
    } catch (e) {
      print("error: $e");
      isSuccess = false;
    }
    return isSuccess;
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
      int menuItemId) async {
    bool isSuccess = false;

    try {
      response = await apiHelper.put('menuItem/update', data: {
        "name": name,
        "category": category,
        "description": description,
        "price": price,
        "takeAwayPrice": takeAwayPrice,
        "deliveryPrice": deliveryPrice,
        "menuId": menuId,
        "availability": availability,
        "status": status,
        "menuItemId": menuItemId
      });

      if (response.statusCode == 200) {
        isSuccess = true;
      }
    } catch (e) {
      print("error: $e");
      isSuccess = false;
    }
    return isSuccess;
  }

  Future<bool> updateMenuItemStatus(int status, int menuItemId) async {
    bool isSuccess = false;

    try {
      response =
          await apiHelper.post('menuItem/updateStatus', data: {"status": status, "id": menuItemId});

      if (response.statusCode == 200) {
        isSuccess = true;
      }
    } catch (e) {
      isSuccess = false;
    }
    return isSuccess;
  }

  Future<bool> deleteMenuItem(int menuItemId) async {
    bool isSuccess = false;

    try {
      response = await apiHelper.delete('menuItem/delete', data: {"menuItemId": menuItemId});

      if (response.statusCode == 200) {
        isSuccess = true;
      }
    } catch (e) {
      isSuccess = false;
      //rethrow;
    }
    return isSuccess;
  }

  Future<List<Menu>> searchMenu(String name) async {
    List<Menu> menuList = [];

    try {
      response = await apiHelper.get('menu/search?name=$name');

      if (response.data != null) {
        response.data.forEach((e) => {menuList.add(Menu.fromJson(e))});
      }
    } catch (e) {
      rethrow;
    }
    return menuList;
  }

  Future<List<MenuItem>> searchMenuItem(String name) async {
    List<MenuItem> menuItemList = [];

    try {
      response = await apiHelper.get('menuItem/search?name=$name');

      if (response.data != null) {
        response.data.forEach((e) => {menuItemList.add(MenuItem.fromJson(e))});
      }
    } catch (e) {
      rethrow;
    }
    return menuItemList;
  }
}
