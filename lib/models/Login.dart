import 'dart:core';

class LoginResponse {
  bool success;
  int statusCode;
  String code;
  String message;
  Data data;

  LoginResponse(
      {this.data, this.statusCode, this.code, this.message, this.success});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    code = json['code'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = this.success;
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String token;
  int id;
  String email;
  String niceName;
  String firstName;
  String lastName;
  String displayNmae;

  Data(
      {this.email,
      this.id,
      this.displayNmae,
      this.firstName,
      this.lastName,
      this.niceName,
      this.token});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    id = json['id'];
    email = json['email'];
    niceName = json['niceName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    displayNmae = json['display Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['token'] = this.token;
    data['id'] = this.id;
    data['email'] = this.email;
    data['nicename'] = this.niceName;
    data['firstName'] = this.firstName;
    data['displayNmae'] = this.displayNmae;
    return data;
  }
}
