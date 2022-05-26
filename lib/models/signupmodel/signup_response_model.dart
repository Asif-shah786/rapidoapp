import 'dart:convert';

SignupResponseModel signupRequestJson(String str) =>
    SignupResponseModel.fromJson(json.decode(str));

class SignupResponseModel {
  String? message;
  Data? data;

  SignupResponseModel(String body, {this.message, this.data});

  SignupResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? email;
  String? username;
  String? id;
  String? date;

  Data({this.email, this.username, this.id, this.date});

  Data.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    username = json['username'];
    id = json['id'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['username'] = username;
    data['id'] = id;
    data['date'] = date;
    return data;
  }
}
