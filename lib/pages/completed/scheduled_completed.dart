import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pakar_cmms/components/inner_app_bar.dart';
import 'package:pakar_cmms/pages/home.dart';
import 'package:pakar_cmms/pages/maintenance_update/update_scheduled.dart';
import 'package:pakar_cmms/models/task_detail_obj.dart';
import 'package:pakar_cmms/models/img_object.dart';

import 'package:http/http.dart' as http;
import '../../api/api_connection.dart';
import '../../models/scheduled_wo_object.dart';


class ScheduledCompleted extends StatefulWidget {
  final assetNo, workOrderNo, taskType;
  const ScheduledCompleted ({Key? mykey, this.assetNo, this.workOrderNo, this.taskType}): super(key: mykey);

  @override
  State<ScheduledCompleted> createState() => _ScheduledCompletedState();
}

class _ScheduledCompletedState extends State<ScheduledCompleted> {
  TaskDetail taskDetail = TaskDetail();
  ScheduledWOObject assetDetail = ScheduledWOObject();
  ImageObject imgObject = ImageObject();
  String imgUrl = "";

  bool taskCodeVisibility = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTaskDetail();
    getAssetDetail();
    setVis();
    _getImage();
  }

  void setVis(){
    if(widget.taskType == "Unscheduled"){
      setState(() {
        taskCodeVisibility = false;
      });
    }
  }

  _getImage() async {
    var response = await http.post(Uri.parse(API.getImage),
    body:{
      "main":widget.workOrderNo
    });
    if(response.statusCode == 200){
        setState(() {
          imgObject = ImageObject.fromJson(jsonDecode(response.body));
        });
      
      debugPrint(imgObject.image);
    } else{
      debugPrint("no image");
    }
  }

  Future _getTaskDetail() async{
    var response = await http.post(Uri.parse(API.getDone),
    body : {
      'assetNo' : widget.assetNo
    });
    if(response.statusCode == 200){
    setState(() {
      taskDetail = TaskDetail.fromJson(jsonDecode(response.body));
    });
    }
      }

  void getAssetDetail() async{
    try{
    var response = await http.post(Uri.parse(API.getAssetDetail),
      body: {
        "assetNo" : widget.assetNo,
        "workOrderNo" : widget.workOrderNo});

      var r = jsonDecode(response.body);

      debugPrint("me have neww data");
      setState(() {
        assetDetail = ScheduledWOObject.fromJson(r);
      });
    }
    catch(e){
      debugPrint("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: innerAppBar(widget.taskType),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0) ,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 2)
            )]),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(children: [
                Row(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                    Text(widget.workOrderNo, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),),
                  ],
                ),
                const SizedBox(height: 20,),
                const Row(
                  mainAxisAlignment:MainAxisAlignment.start,
                  children: [
                    Text("Work order detail", style: TextStyle(fontWeight: FontWeight.w500),),
                  ],
                ),

                Visibility(
                  visible: taskCodeVisibility,
                  child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: [
                    const Text("Task Code"),
                    Text(taskDetail.taskCode.toString())
                  ],),
                ),
        
                Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: [
                  const Text("Maintenance Date"),
                  Text(taskDetail.taskDate.toString())
                ],),

                Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: [
                  const Text("Time Start"),
                  Text(taskDetail.timeStart.toString())
                ],),
        
                Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: [
                  const Text("Time End"),
                  Text(taskDetail.timeEnd.toString())
                ],),

                const SizedBox(height: 30),

                const Row(mainAxisAlignment:MainAxisAlignment.start,
                  children: [
                  Text("Asset Info", style: TextStyle(fontWeight: FontWeight.w500)),
                ],),
        
                Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: [
                  const Text("Asset No."),
                  Text(widget.assetNo)
                ],),

                Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: [
                  const Text("Asset Location"),
                  Text(assetDetail.assetLocation ?? "null")
                ],),

                Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      child: imgObject.image == null ?
                            const CircularProgressIndicator() :
                            Image.network('${API.hostImage}/${imgObject.image}'),
                    ),
                  ),   
              ]),
            ) ,),
        ),

        Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateScheduled(
              assetNo: widget.assetNo,
              workOrderNo: widget.workOrderNo,
            ))),
            // onPressed: _getTaskDetail,
            child: const Text("Edit Maintenance")),
        ),

        Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Home())),
            // onPressed: _getTaskDetail,
            child: const Text("Return to Home")),
        ),

      ],),
    );
  }
}