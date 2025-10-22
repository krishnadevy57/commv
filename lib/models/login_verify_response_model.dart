// To parse this JSON data, do
//
//     final loginVerifyModel = loginVerifyModelFromJson(jsonString);

import 'dart:convert';


class LoginVerifyModel {
  LoginVerifyModel loginVerifyModelFromJson(String str) => LoginVerifyModel.fromJson(json.decode(str));

  String loginVerifyModelToJson(LoginVerifyModel data) => json.encode(data.toJson());

  User? user;
  String? token;

  LoginVerifyModel({
     this.user,
     this.token,
  });

  factory LoginVerifyModel.fromJson(Map<String, dynamic> json) => LoginVerifyModel(
    user: User.fromJson(json["user"]),
    token: json.containsKey("token")?json["token"]:null,
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "token": token,
  };
}

class User {
  int? id;
  String? username;
  String? useremail;
  String? userphoneNo;
  String? userIdentity;
  String? deviceId;
  String? deviceType;
  String? deviceToken;


  User({
     this.id,
     this.username,
     this.useremail,
     this.userphoneNo,
     this.userIdentity,
     this.deviceId,
     this.deviceType,
     this.deviceToken,

  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    username: json["username"],
    useremail: json["useremail"],
    userphoneNo: json["userphoneNo"],
    userIdentity: json["userIdentity"],
    deviceId: json["deviceId"],
    deviceType: json["deviceType"],
    deviceToken: json["deviceToken"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "useremail": useremail,
    "userphoneNo": userphoneNo,
    "userIdentity": userIdentity,
    "deviceId": deviceId,
    "deviceType": deviceType,
    "deviceToken": deviceToken,
  };
}
