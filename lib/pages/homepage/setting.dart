import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pakar_cmms/models/user_info_obj.dart';
import 'package:pakar_cmms/pages/login.dart';
import 'package:pakar_cmms/api/api_connection.dart';
import 'package:http/http.dart' as http;

import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/login_controller.dart';

String _userId = "0";

class SettingsPage extends StatefulWidget {
  final userId;
  const SettingsPage({Key? mykey, this.userId}): super(key: mykey);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  UserInfo userInfo = UserInfo();
  TextEditingController nameController = TextEditingController();
  TextEditingController noTelController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  LoginController loginController = Get.put(LoginController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getID();
  }

  getID() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = (_prefs.getString("id")??'');
    });
    getUserInfo();
  }

  void logout() async{
    Get.offAll(() => const Login());
    debugPrint("Logout. Preferences Cleared!");
  }

  void getUserInfo() async{
    try{
      debugPrint("useId: $_userId");
      var response = await http.post(Uri.parse(API.getUserInfo),
      body: {
        "id": _userId
      });
        setState(() {
          userInfo = UserInfo.fromJson(jsonDecode(response.body));
          nameController.text = userInfo.name;
          noTelController.text = userInfo.noTel;
          emailController.text = userInfo.email;
        });
    }
    catch(e){
      debugPrint("Error: $e");
    }
  }

  void updateProfile() async{
    try{
      var response = await http.post(Uri.parse(API.updateUserInfo),
      body: {
        "id": _userId,
        "name" : nameController.text,
        "noTel" : noTelController.text,
        "email" : emailController.text
      });

      if(response.statusCode == 200){
        Fluttertoast.showToast(msg: "Update user: $_userId successful");
      } else {

      }
    }
    catch(e){
      debugPrint("updateProfile Error: $e, userId: $_userId");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Profile", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),),
              ],
            ),
    
            SizedBox(
              width: 150,
              height: 150,
              child: ClipRRect(borderRadius: BorderRadius.circular(80),
              child: Image(image: AssetImage("assets/images/dev.jpg")),),
            ),
    
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),),
                
            )),
    
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: TextField(
                controller: noTelController,
                decoration: InputDecoration(
                  border: OutlineInputBorder()),
                
            )),
    
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder()),
                
            )),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: GestureDetector(
                onTap: updateProfile,
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height/15,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    alignment: Alignment.center,
                    child: const Text("Update Profile", style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                    ),)),
                ),
              ),
            ),
    
            GestureDetector(
              onTap: (){loginController.logoutUser();},
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height/15,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade600,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  alignment: Alignment.center,
                  child: const Text("Logout", style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white
                  ),)),
              ),
            ),
    
    
          ],
        )
      ),
    );
  }
}