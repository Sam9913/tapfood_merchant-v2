import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapfood_v2/model/Merchant.dart';
import 'package:tapfood_v2/provider/NotificationProvider.dart';
import 'package:tapfood_v2/services/PusherServices.dart';
import 'package:tapfood_v2/services/AuthServices.dart';
import 'package:tapfood_v2/services/MerchantServices.dart';

class AuthProvider extends ChangeNotifier {
  late Merchant _auth;
  bool _isAuth = false;
  bool get isAuth => _isAuth;
  Merchant get auth => _auth;
  AuthServices authServices = AuthServices();
  MerchantServices merchantServices = MerchantServices();

  Future<void> saveUserDateToPref() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', json.encode(_auth.toJson()));
  }

  Future<bool> signIn(String email, String password) async {
    const _storage = FlutterSecureStorage();
    final prefs = await SharedPreferences.getInstance();
    try {
      Response response = await authServices.signIn(email, password);

      if (response.statusCode == 200 && !response.data.toString().contains("{")) {
        //var userData = Merchant.fromJson(response.data['results']);
        //_auth = userData;
        prefs.setString('token', response.data.toString());
        await _storage.write(key: 'isAuth', value: 'true');
        _isAuth = true;

        bool gotData = await getMerchant();

        if(!gotData){
          prefs.remove('token');
          await _storage.write(key: 'isAuth', value: 'false');
          _isAuth = false;
        }

        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> getMerchant() async {
    try {
      _auth = await merchantServices.getDetail();

      notifyListeners();
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> logout() async {
    const _storage = FlutterSecureStorage();
    final prefs = await SharedPreferences.getInstance();

    NotificationProvider notificationProvider = NotificationProvider();
    await notificationProvider.removeToken();
    prefs.remove('FcmToken');

    bool isSuccess = await authServices.signOut();

    if (isSuccess) {
      PusherServices pusherServices = PusherServices(null);
      pusherServices.clear(prefs.getString('channelName').toString());
      prefs.remove('channelName');
      prefs.remove('token');

      _isAuth = false;
      await _storage.write(key: 'isAuth', value: 'false');

      final cacheDir = await getTemporaryDirectory();
      if (cacheDir.existsSync()) {
        cacheDir.deleteSync(recursive: true);
      }

      final appDir = await getApplicationSupportDirectory();
      if (appDir.existsSync()) {
        appDir.deleteSync(recursive: true);
      }
    }else{
      await notificationProvider.setToken();
    }

    notifyListeners();
    return isSuccess;
  }

  Future<bool> checkIsAuth() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getString('token') != null) {
      final tempJson = prefs.getString('token');
      _isAuth = tempJson != null ? true : false;

      if (_isAuth) {
        _isAuth = await getMerchant();

        if (!_isAuth) {
          prefs.remove('token');
        }
      }

      return _isAuth;
    } else {
      return false;
    }
  }
}
