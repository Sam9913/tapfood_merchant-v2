import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:tapfood_v2/config/appConfig.dart';
import 'package:tapfood_v2/utils/apiHelper.dart';

class AuthServices {
  late Response response;
  Config config = Config();
  ApiHelper apiHelper = ApiHelper(Config().authUrl);

  Future<Response> signIn(String email, String password) async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      response = await apiHelper.post('login',
          data: json.encode({
            'email': email,
            "password": password,
            'role_id': "2",
            "device_name": androidInfo.model
          }));

    } catch (e) {
      rethrow;
    }
    return response;
  }

  Future<bool> signOut() async {
    try {
      response = await apiHelper.post('logout');
      apiHelper.deleteCookies();

      return true;
    } catch (e) {
      return false;
    }
  }

/*Future<Response> changeBasicInfo(
			{String firstName, String lastName, required String email, String bio}) async {
		try {
			response = await apiBaseHelper.patch('basic-profile',
					data: json.encode({
						'first_name': firstName,
						'last_name': lastName,
						'email': email,
						'bio': bio
					}));
		} catch (e) {
			throw e;
		}
		return response;
	}*/
}