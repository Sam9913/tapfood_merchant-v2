import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:tapfood_v2/config/appConfig.dart';
import 'package:tapfood_v2/services/PusherServices.dart';
import 'package:tapfood_v2/services/AuthServices.dart';
import 'package:tapfood_v2/utils/globalDialogHelper.dart';
import 'appException.dart';

enum ApiResponseType { get, post, patch, delete, put }

class ApiHelper {
  final String baseUrl;
  late Response response;
  late Dio dio;
  late PersistCookieJar persistentCookies;
  GlobalDiaLogHelper diaLogHelper = GlobalDiaLogHelper();

  ApiHelper(this.baseUrl);

  Future<void> init() async {
    dio = Dio(BaseOptions(
        connectTimeout: 5000,
        receiveTimeout: 5000,
        baseUrl: baseUrl != "" ? baseUrl : Config().baseUrl));

    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';
    if (token != null) {
      if (kDebugMode) {
        print(token);
      }
      dio.options.headers["Authorization"] = "Bearer $token";
    }

    persistentCookies = await localPath();
    dio.interceptors.add(CookieManager(persistentCookies));
  }

  void deleteCookies() {
    persistentCookies.deleteAll();
  }

  Future<PersistCookieJar> localPath() async {
    final directory = await getApplicationDocumentsDirectory();
    String path = directory.path;
    persistentCookies = PersistCookieJar(storage: FileStorage(path));
    return persistentCookies;
  }

  Future<dynamic> get(String url, {Map<String, dynamic>? queryParameters}) async {
    try {
      await init();
      response = await dio.get(url, queryParameters: queryParameters);
    } on DioError catch (e) {
      formatError(e, ApiResponseType.get);
    }
    return response;
  }

  Future<dynamic> post(String url, {dynamic data, Function(int, int)? onSendProgress}) async {
    try {
      await init();
      response = await dio.post(url, data: data, onSendProgress: onSendProgress);
    } on DioError catch (e) {
      formatError(e, ApiResponseType.post);
    }
    return response;
  }

  Future<dynamic> patch(String url, {dynamic data}) async {
    try {
      await init();
      response = await dio.patch(url, data: data);
    } on DioError catch (e) {
      formatError(e, ApiResponseType.patch);
    }
    return response;
  }

  Future<dynamic> delete(String url, {dynamic data}) async {
    try {
      await init();
      response = await dio.delete(url, data: data);
    } on DioError catch (e) {
      formatError(e, ApiResponseType.delete);
    }
    return response;
  }

  Future<dynamic> put(String url, {dynamic data}) async {
    try {
      await init();
      return response = await dio.put(url, data: data);
    } on DioError catch (e) {
      formatError(e, ApiResponseType.put);
    }
  }

  deleteLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getString('token') != null) {
      const _storage = FlutterSecureStorage();
      await _storage.write(key: 'isAuth', value: 'false');

      PusherServices pusherServices = PusherServices(null);
      pusherServices.clear(prefs.getString('channelName').toString());

      AuthServices authServices = AuthServices();
      await authServices.signOut();

      prefs.setString('channelName', '');
      prefs.remove('token');
    }
  }

  formatError(DioError e, ApiResponseType type) async {
    if (e.response?.statusCode == 502 && type != ApiResponseType.get) {
      diaLogHelper.showAPIErrorDialog(
          dialogTitle: "Server is Unavailable", dialogDescription: "Please contact support team.");
    }

    if (e.type == DioErrorType.connectTimeout) {
      // It occurs when url is opened timeout.
      if (kDebugMode) {
        print("CONNECT_TIMEOUT");
      }
    } else if (e.type == DioErrorType.sendTimeout) {
      // It occurs when url is sent timeout.
      if (kDebugMode) {
        print("SEND_TIMEOUT");
      }
    } else if (e.type == DioErrorType.receiveTimeout) {
      //It occurs when receiving timeout
      if (kDebugMode) {
        print("RECEIVE_TIMEOUT");
      }
    } else if (e.type == DioErrorType.response) {
      if (e.requestOptions.baseUrl != Config().authUrl && e.response?.statusCode == 401) {
        //print('E: ${e.response?.statusCode}');
        deleteCookies();
        deleteLocalData();
        throw UnauthorisedException;
      } else {
        throw e;
      }
    } else if (e.type == DioErrorType.cancel) {
      if (kDebugMode) {
        print("request is cancelled");
      }
    } else {
      if (kDebugMode) {
        print("unknown error");
      }

      if (e.message.contains("errno = 101") && type != ApiResponseType.get) {
        diaLogHelper.showAPIErrorDialog(
            dialogTitle: "No Internet Connection", dialogDescription: "Please try again.");
      }

      throw e;
    }
  }
}
