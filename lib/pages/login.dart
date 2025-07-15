import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pakar_cmms/models/user_info_obj.dart';
import 'package:pakar_cmms/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/notification_api.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pakar_cmms/user_preferences/user_preferences.dart';

import 'package:http/http.dart' as http;
import '../api/api_connection.dart';
import '../controller/login_controller.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  LoginController loginController = Get.put(LoginController());

  String loginError = "";


  @override
  void initState(){
    super.initState;
    NotificationApi.initialize(flutterLocalNotificationsPlugin);
  }

  Future getError() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    
  }

  // void loginUser() async{
  //   try{
  //     var response = await http.post(Uri.parse(API.login),
  //     body:{
  //       'submit':"submit",
  //       'username': usernameController.text,
  //       'password': passwordController.text
  //     });
  //     var login = jsonDecode(response.body);
  //     UserInfo userInfo = UserInfo.fromJson(login[0]);

  //     if(login[0] != null){

  //       // save data to user preferences
  //       // await UserPrefs.saveUserPrefs(userInfo);
  //       toHome(userInfo.userId);
  //     } else {
  //       setState(() {
  //         loginError = login['login'];
  //       });
  //     }
  //   }
  //   catch(e){
  //     debugPrint("Error in login: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: SafeArea(
        child: Center(
          child: ListView(
            children: [
              const SizedBox(height:50),

              const Icon(Icons.person_4,
              size: 100,),
              
              const SizedBox(height:50),

              Center(child: const Text("Welcome back!")),
              Text(loginError),

              const SizedBox(height:50),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: loginController.usernameController,
                  decoration: 
                  InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400)
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true
                  ),),
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  obscureText: true,
                  controller: loginController.passwordController,
                  decoration: 
                  InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400)
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true
                  ),),
              ),
                            
              const SizedBox(height:50),

              GestureDetector(
                onTap: (){loginController.loginUser();},
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: const Center(
                      child: Text(
                      "Sign In",
                      style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ),
              ),

              // GestureDetector(
              //   onTap: () => NotificationApi.showNotification(
              //     title: "Noti title", 
              //     body: "Noti body", 
              //     fln: flutterLocalNotificationsPlugin),

              //   child: Padding(
              //     padding: const EdgeInsets.all(20.0),
              //     child: Container(
              //       padding: const EdgeInsets.all(20),
              //       width: double.infinity,
              //       decoration: BoxDecoration(
              //         color: Colors.black,
              //         borderRadius: BorderRadius.circular(10)
              //       ),
              //       child: const Center(
              //         child: Text(
              //         "Test Notification",
              //         style: TextStyle(color: Colors.white),),
              //       ),
              //     ),
              //   ),
              // )


            ],
          ),
        ),
      ),);
  }
}