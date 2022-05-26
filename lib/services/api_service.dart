import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rapido_app/models/loginmodel/login_request_model.dart';
import 'package:rapido_app/models/loginmodel/login_response_model.dart';
import 'package:rapido_app/models/signupmodel/signup_request_model.dart';
import 'package:rapido_app/models/signupmodel/signup_response_model.dart';
import 'package:rapido_app/services/shared_service.dart';
import '../models/config_file.dart';

class ApiService {
  static var client = http.Client();

  static Future<bool> login(LoginRequestModel model) async {
    Map<String, String> requestHeader = {'Content-type': 'application/json'};
    var url = Uri.http(Config.apiUrl, Config.loginApi);

    var response = await client.post(url,
        headers: requestHeader, body: jsonEncode(model.toJson()));

    if (response.statusCode == 200) {
      //deal with data
      await SharedService.setLoginDetails(loginResponseJson(response.body));
      return true;
    } else {
      return false;
    }
  }

  static Future<SignupResponseModel> regiser(SignupRequestModel model) async {
    Map<String, String> requestHeader = {'Content-type': 'application/json'};
    var url = Uri.http(Config.apiUrl, Config.registerApi);

    var response = await client.post(url,
        headers: requestHeader, body: jsonEncode(model.toJson()));

    return SignupResponseModel(response.body);
  }
}
