import 'dart:convert';

import 'package:pakar_cmms/models/user_info_obj.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs
{

  static Future<void> saveUserPrefs(UserInfo userInfo) async{

    SharedPreferences userPrefs = await SharedPreferences.getInstance();
    String userJsonData = jsonEncode(userInfo.toJson());
    await userPrefs.setString('currentUser', userJsonData); 
   }
  
  static Future<void> getUserPrefs() async{

    UserInfo currentUserInfo;
    SharedPreferences userPrefs = await SharedPreferences.getInstance();
    String? userInfo = userPrefs.getString("currentUser"); 
    if(userInfo != null){
      Map<String,dynamic> userDataMap = jsonDecode(userInfo);
      currentUserInfo = UserInfo.fromJson(userDataMap);
    }

  }
}