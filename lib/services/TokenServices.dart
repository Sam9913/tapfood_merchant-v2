import 'package:dio/dio.dart';
import 'package:tapfood_v2/config/appConfig.dart';
import 'package:tapfood_v2/utils/apiHelper.dart';

class TokenServices {
  late Response response;
  Config config = Config();
  ApiHelper apiHelper = ApiHelper(Config().baseUrl);

  Future<bool> insertToken(String token) async {
    bool isSuccess = false;

    try {
      response = await apiHelper.post('token/insert', data: {"token": token});

      if (response.statusCode == 200) {
        isSuccess = true;
      }
    } catch (e) {
      isSuccess = false;
    }
    return isSuccess;
  }

  Future<bool> deleteToken(String token) async {
    bool isSuccess = false;

    try {
      print(token);
      response = await apiHelper.delete('token/delete', data: {"token": token});

      if (response.statusCode == 200) {
        isSuccess = true;
      }
    } catch (e) {
      isSuccess = false;
    }
    return isSuccess;
  }
}
