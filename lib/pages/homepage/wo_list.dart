import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pakar_cmms/user_preferences/user_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_connection.dart';
import 'package:http/http.dart' as http;

import '../../colors.dart';
import '../../models/user_info_obj.dart';
import '../completed/scheduled_completed.dart';
import '../WO_list/scheduled_wo.dart';
import '../completed/unscheduled_completed.dart';
import '../WO_list/unscheduled_wo.dart';

String _userId = "0";

class WOlist extends StatefulWidget {
  final userId;
  const WOlist({Key? mykey, this.userId}): super(key: mykey);

  @override
  State<WOlist> createState() => _WOlistState();
}

class _WOlistState extends State<WOlist> {

  late String pendingSWO;
  late String pendingUSWO;
  bool colords = true;

 UserInfo userInfo = UserInfo();

  @override
  void initState() {
    super.initState();
    setPending();
    getID();
  }

  getID() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = (_prefs.getString("id")??'');
    });
    getUserInfo();
  }

  void getUserInfo() async{
    try{
      var response = await http.post(Uri.parse(API.getUserInfo),
      body: {
        "id": _userId
      });
        setState(() {
          userInfo = UserInfo.fromJson(jsonDecode(response.body));
        });
    }
    catch(e){
      debugPrint("Error: $e");
    }
  }


    // get data of pending scheduled wo
  Future _getPendingSWO() async {
    try{
    await UserPrefs.getUserPrefs();
    final response = await http.post(Uri.parse(API.getAssigned),
    body: {
      'id': _userId
    });
    if (response.statusCode == 200) {
      var resDecode = jsonDecode(response.body);
      if(resDecode == null){
        setState(() {
          pendingSWO = "No pending WO";
        });
      } else {
        setState(() {
         pendingSWO = resDecode.length.toString();
        });
      }
      
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to retrieve row count');
    }
  } catch(e){
    debugPrint("getAssigned(): $e");
  }}

  // get data count of pending unscheduled
  Future _getPendingUSWO() async {
    try {
      var response = await http.post(Uri.parse(API.getUnscheduled),
      body: {
        "id":_userId
      });
      if (response.statusCode == 200) {
        var resDecode = jsonDecode(response.body);
        setState(() {
          pendingUSWO = resDecode.length.toString();
        });
        return resDecode;
      } else {
        debugPrint("No Data");
      }
    } catch (e) {
      debugPrint("getUnscheduled(): $e");
    }
  }

  setPending() {
    setState(() {
      pendingSWO = _getPendingSWO().toString();
      pendingUSWO = _getPendingUSWO().toString();
    });
  }

  // Get data for task completed in current day
  Future _getRecentWork() async{
    try{
      var response = await http.post(Uri.parse(API.getRecentWork),
      body: {
        "id": _userId
      });
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        return res;
      } else {
        debugPrint("no completed works");
      }
    } catch(e){
      debugPrint("$e");
    }
  }

    // Main page (pending WO and recent WO)
  _updateScheduled(String assetNo, String workNo){
    Navigator.push(context, 
      MaterialPageRoute(
        builder: (context)=> ScheduledCompleted(
          assetNo: assetNo,
          workOrderNo:workNo,
          taskType: "hihu",
        )
      )
    );
  }

   _updateUnscheduled(String assetNo, String workNo){
    Navigator.push(context, 
      MaterialPageRoute(
        builder: (context)=> UnscheduledCompleted(
          assetNo: assetNo,
          workOrderNo:workNo,
          taskType: "hehe",
        )
      )
    );
  }

  deleteRecent(String? main) async{
    try{
      var response = await http.post(Uri.parse(API.deleteRecent),
      body:{
        'main': main
      });

      if(response.statusCode == 200){
        var res = jsonDecode(response.body);
        return res;
      }
    }catch(e){
      debugPrint("$e");
    }

    setState(() {
      
    });
    debugPrint(main);
  }

  Future<void> refreshHomeView() async{
    setPending();
    _getRecentWork();
  }

  getCurrentUser(){
    
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshHomeView,
      child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Row(
                children: [
                  Column(mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome",
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
                      ),
                      Text(userInfo.name?? "Loading...", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                    ],
                  )
                ],
              ),


            ),
            // woReminder(primary),
            // woReminder(AppColors().unscheduled),
            // woReminder(AppColors().rescheduled),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Text(
                "Work Orders",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
              ),
            ),
            pendingWOTile(context, primary, "Scheduled", ScheduledWO(userId: _userId,),
                "$pendingSWO pending task"),
            pendingWOTile(context, AppColors().unscheduled, "Unshceduled",
                const UnscheduledWO(), "$pendingUSWO pending task"),
            // pendingWOTile(context, AppColors().rescheduled, "Reshceduled", const ScheduledWO()),
    
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(
                "Recent Work",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
              ),
            ),
    
            FutureBuilder(
                future: _getRecentWork(),
                builder: ((context, snapshot) {
                  if (snapshot.hasError) debugPrint("$snapshot.error");                                                                                                                             
                  return snapshot.hasData
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            List list = snapshot.data!;
                            Color colortype = list[index]['main_workno'][0]== "M"
                                ? AppColors().unscheduled
                                : primary;                                           
                            return GestureDetector(
                              onTap: () {
                                  list[index]['main_workno'][0]== "M" ?
                                //  _updateUnscheduled():
                                _updateUnscheduled(list[index]['asset_no'], list[index]['main_workno']):
    
                                 _updateScheduled(list[index]['asset_no'], list[index]['main_workno']);  },
                              child: Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(10.0),                              
                                      child: Container(
                                        height: 140,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.black12,
                                                  spreadRadius: 1,
                                                  blurRadius: 2,
                                                  offset: Offset(0, 2))
                                            ]),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(20),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Text(
                                                          list[index]['main_workno'],
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              fontSize: 16),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(
                                                              vertical: 10),
                                                          child: Text(
                                                            list[index]['asset_no'],
                                                            style: const TextStyle(
                                                                fontWeight: FontWeight.w400,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                        const Text(
                                                          "L1-CA-045(luar)",
                                                          style: TextStyle(
                                                              fontWeight:FontWeight.w400,
                                                              fontSize: 12),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                            
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        deleteRecent(list[index]['main_workno']);
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 20),
                                                      child: Container(
                                                        color: Colors.yellow.shade600,
                                                        padding: const EdgeInsets.all(8),
                                                        // Change button text when light changes state.
                                                        child: const Icon(Icons.delete),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: colortype,
                                                      borderRadius:
                                                          const BorderRadius.only(
                                                              bottomLeft: Radius.circular(10),
                                                              bottomRight: Radius.circular(10)
                                                                  )
                                                              ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(3.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        const Text(
                                                          "Completed on",
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 12),
                                                        ),
                                                        Text(
                                                            list[index]['workcompleted'],
                                                            style: const TextStyle(
                                                              color:Colors.white,
                                                              fontSize: 12)
                                                            )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            );
                          })
                      : const Center(child: Text("No recent works"));
                }))
          ],
        ),
    );
  }

    Padding pendingWOTile(BuildContext context, Color bgColor, String title, Widget route, String pendingTask) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => route)),
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 2))
              ]),
          child: ListTile(
            leading: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: bgColor, borderRadius: BorderRadius.circular(50)
                    ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SvgPicture.asset(
                    'assets/icons/clipboard2-data.svg',
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  )
                ),
            title: Text(title),
            subtitle: Text(
              pendingTask,
              style: const TextStyle(color: Color.fromARGB(255, 250, 189, 21)),
            ),
            trailing: SizedBox(
              width: 35,
              height: 35,
              child: SvgPicture.asset(
                'assets/icons/exclamation-triangle.svg',
                colorFilter: const ColorFilter.mode(
                    Color.fromARGB(255, 250, 189, 21), BlendMode.srcIn),
              ),
            ),
          ),
        ),
      ),
    );
  }
}