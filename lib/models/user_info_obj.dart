import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UserInfo{
  var userId;
  var username;
  var name;
  var noTel;
  var email;

  UserInfo({
    this.userId, 
    this.username,
    this.name,
    this.noTel,
    this.email
  });

    Map<String, dynamic> toJson()=>{
    'id': userId,
    'staf_id' : username,
    'name': name,
    'notel' : noTel,
    'email' : email,
  };

  static UserInfo fromJson(Map<String, dynamic> json) => UserInfo(
    userId: json['id'],
    username: json['staf_id'],
    name: json['name'],
    noTel: json['notel'],
    email: json['email']
  );
}