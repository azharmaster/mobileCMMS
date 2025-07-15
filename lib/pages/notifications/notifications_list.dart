import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pakar_cmms/colors.dart';
import 'package:pakar_cmms/components/inner_app_bar.dart';
import 'package:pakar_cmms/models/notification_object.dart';
import 'package:pakar_cmms/pages/notifications/notifications_message.dart';
import 'package:pakar_cmms/api/api_connection.dart';
import 'package:http/http.dart' as http;


class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  NotificationObject notiObj = NotificationObject();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotiList();
  }

  Future getNotiList() async{
    try{
      var response = await http.post(Uri.parse(API.getNotification));
      if(response.statusCode == 200){
        debugPrint("Notifications retrieved");
        return jsonDecode(response.body);
      }
    } catch(e){
      debugPrint("getNotiList() Error: $e");
    }
  }

  readMessage(String notiTitle, String notiBody, String id, String status){

    if(status == "0"){
      updateNotiStatus(id);
    }

    Navigator.push(context, 
      MaterialPageRoute(
        builder: (context)=> NotiMessage(title: notiTitle, body: notiBody)
      ));
  }

  void updateNotiStatus(String id) async{
    await http.post(Uri.parse(API.updateReadNoti),
    body: {
      "id" : id,
      "status" : "1"
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: innerAppBar('NOTIFICATION'),
      body: FutureBuilder(
        future: getNotiList(),
        builder: ((context, snapshot){
          if(snapshot.hasError) debugPrint("$snapshot.error");

          return snapshot.hasData ? 

          ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index){
              List data = snapshot.data;
              return GestureDetector(
                onTap: (){readMessage(data[index]['title'], data[index]['body'], data[index]['id'], data[index]['status']);},
                child: Container(
                  decoration: data[index]['status'] == "0" ? const BoxDecoration(color: Color(0xffE9FFF8)) : null,
                  child: Row(children: [
                    Padding(padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset('assets/icons/clipboard2-data.svg', 
                            width: 25,
                            colorFilter: const ColorFilter.mode(Color(0xffE9FFF8), BlendMode.srcIn)),
                          
                        ),),) ),
                      
                    Padding(padding: const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(data[index]['title'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                      Text(data[index]['body'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400))
                    ],),)
                  ],),
                ),
              );
            }) : const Center(child: Text("No new notification"),);
        })
        )
      
      // ListView(children: [
      //   const Padding(
      //     padding: EdgeInsets.all(12.0),
      //     child: SizedBox(child: Text("Notifications", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),),
      //   ),

        // GestureDetector(
        //   onTap: notiMessage,
        //   child: Container(
        //     decoration: const BoxDecoration(color: Color(0xffE9FFF8)),
        //     child: Row(children: [
        //       Padding(padding: const EdgeInsets.all(20),
        //       child: SizedBox(
        //         child: DecoratedBox(
        //           decoration: BoxDecoration(
        //             color: primary,
        //             borderRadius: BorderRadius.circular(30)),
        //           child: Padding(
        //             padding: const EdgeInsets.all(12.0),
        //             child: SvgPicture.asset('assets/icons/clipboard2-data.svg', 
        //               width: 25,
        //               colorFilter: const ColorFilter.mode(Color(0xffE9FFF8), BlendMode.srcIn)),
                    
        //           ),),) ),
                
        //       const Padding(padding: EdgeInsets.all(5),
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //         Text("12 new task added", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
        //         Text("Yesterday", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400))
        //       ],),)
        //     ],),
        //   ),
        // ),
        
      // ],),
    );
  }
}