import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pakar_cmms/pages/home.dart';
import 'package:pakar_cmms/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import '../models/user_info_obj.dart';
import '../api/api_connection.dart';


class LoginController extends GetxController{
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String loginError = "";

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    Future loginUser() async{
    try{
      if(usernameController.text.isEmpty == false && passwordController.text.isEmpty == false){
      var response = await http.post(Uri.parse(API.login),
      body:{
        'submit':"submit",
        'username': usernameController.text,
        'password': passwordController.text
      });
      
      var login = jsonDecode(response.body);
      UserInfo userInfo = UserInfo.fromJson(login[0]);

        if(userInfo.userId != null){
          // save data to user preferences
          // await UserPrefs.saveUserPrefs(userInfo);
          final SharedPreferences? prefs = await _prefs;
          await prefs?.setString("id", userInfo.userId);

          usernameController.clear();
          passwordController.clear();
          Get.to(() => Home());        
        } else {
          debugPrint("Username and password does not match");
          var login = jsonDecode(response.body);
          debugPrint(login[0]);
        }

      } else{
        debugPrint("Field Empty. Enter username or password");
      }
    }
    catch(e){
      debugPrint("Error in login: $e");
    }
  }

  void logoutUser() async{
    final SharedPreferences? prefs = await _prefs;
    prefs?.clear();
    Get.offAll(Login());
  }
}