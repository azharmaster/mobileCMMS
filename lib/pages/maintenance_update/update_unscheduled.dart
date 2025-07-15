import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pakar_cmms/components/inner_app_bar.dart';
import 'package:pakar_cmms/models/main_info_object.dart';
import 'package:pakar_cmms/models/task_detail_obj.dart';
import 'package:pakar_cmms/models/img_object.dart';

import 'package:pakar_cmms/pages/completed/unscheduled_completed.dart';
import 'package:pakar_cmms/api/api_connection.dart';
import 'package:http/http.dart' as http;

import '/models/scheduled_wo_object.dart';

const List<String> performanceItem = <String>["Done", "Not Done", "Not Applicable"];
const List<String> elecSafetyItem = <String>["Done", "Not Done", "Not Applicable"];
const List<String> rescheduledItem = <String>["Yes", "No"];
List qcItem = [];

String performanceValue = performanceItem.first;
String elecSafetyValue = elecSafetyItem.first;
String reshceduledValue = rescheduledItem.first;
String _qcValue = "QE1 A";
String actionTakenValue = "2";

class UpdateUnscheduled  extends StatefulWidget {
   final assetNo, workOrderNo;
  const UpdateUnscheduled ({Key? mykey, this.assetNo, this.workOrderNo}): super(key: mykey);

  @override
  State<UpdateUnscheduled> createState() => _UpdateUnscheduledState();
}

class _UpdateUnscheduledState extends State<UpdateUnscheduled> {

  ScheduledWOObject assetDetail = ScheduledWOObject();
  TaskDetail taskDetail = TaskDetail();
  MainInfo mainInfo = MainInfo();

  File? _image;
  String imgName = "";
  final picker = ImagePicker();
  ImageObject imgObject = ImageObject();


    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAssetDetail();
    getQrCode();
    _getImage();
  }

  TextEditingController actionTaken = TextEditingController(text: actionTakenValue);

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    actionTaken.dispose();
  }

   pickImage(ImageSource imgSource) async{
      var img = await picker.pickImage(source: imgSource);
    if(img != null){
      setState(() {
        imgObject.image = null;
        _image = File(img.path);
        imgName = img.path.split(Platform.pathSeparator).last;
      });
      debugPrint(imgName);
    }
  }

  Future _showBottomSheet(BuildContext context){
    return showModalBottomSheet(
      context: context, 
      builder: ((context) => Container(
        alignment: Alignment.center,
        height: 120,
        child: Column(children: [
          TextButton(
            onPressed: () => pickImage(ImageSource.gallery), 
            child: const Row(children:[
              Padding(padding: EdgeInsets.all(10),
              child: Icon(Icons.image_outlined),),
              Text("Gallery")]
            )),

            TextButton(
            onPressed: () => pickImage(ImageSource.camera), 
            child: const Row(children:[
              Padding(padding: EdgeInsets.all(10),
              child: Icon(Icons.camera),),
              Text("Camera")]
            )),

        ]),)
      ));
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
      var imgName = imgObject.image.toString();
      debugPrint(imgName.substring(7));
    } else{
      debugPrint("no image");
    }
  }

  // Get asset detail
  void getAssetDetail() async{
    try{
    var response = await http.post(Uri.parse(API.getAssetDetail),
      body: {"assetNo" : widget.assetNo});
      var r = jsonDecode(response.body);
      debugPrint("Get Asset Detail");
      setState(() {
        assetDetail = ScheduledWOObject.fromJson(r);
      });
    }
    catch(e){
      debugPrint("Problem assetDetail : $e");
    }
  }

  // get codes from DB, convert to list
  Future getQrCode() async{
    var response = await http.get(Uri.parse(API.getQcCode));

    if(response.statusCode == 200){
      
      qcItem = jsonDecode(response.body);

    } else {
      throw Exception("failed to load qc item");
    }
  }

  // set initial value of dropwdown
  void setInitialValue() async{
    try {
      var response = await http.post(Uri.parse(API.getDoneScheduled),
      body: {
        'assetNo' : widget.assetNo
      });

      if(response.statusCode == 200){
         taskDetail = TaskDetail.fromJson(jsonDecode(response.body));
         if(taskDetail.performance != null){
          debugPrint(taskDetail.performance);
          setState(() {
            reshceduledValue = taskDetail.rescheduled;
            performanceValue = taskDetail.performance;
            elecSafetyValue = taskDetail.elecSafety;
            _qcValue = taskDetail.qc;
          });
         } else{
          debugPrint("Performance empty");
         }
      } else{
        debugPrint("Status Code not 200");
      }
    } catch(e) {
      debugPrint("Problem initValue : $e");
    }
  }

  // Update maintenance
  void updateMain() async {
    var imgName = imgObject.image.toString();
    try{
      if(_image != null && imgObject.image != imgName){
      var request = http.MultipartRequest('POST', Uri.parse(API.updateImage));
      request.fields['main_workno'] = widget.workOrderNo;
      var pic = await http.MultipartFile.fromPath("image", _image!.path);
      request.files.add(pic);
      var response = await request.send();

        if(response.statusCode == 200){
        debugPrint("Image uploaded");
        }else{
        debugPrint("Image not uploaded");
        }
    }

      var response = await http.post(Uri.parse(API.updateUnscheduled), 
      body:{
        'submit': "submit",
        'main': widget.workOrderNo,
        'pid' : widget.assetNo,
        'res' : reshceduledValue,
        'per': performanceValue,
        'ele': elecSafetyValue,
        'act': actionTaken.text,
        'qc': _qcValue,
        });

        Fluttertoast.showToast(msg: "Maintenance info sent");

        debugPrint(response.body);

        navigate();
        
        // if(response.body.isNotEmpty){
        //   var r = jsonDecode(response.body);
        //   print(widget.workOrderNo.toString());
        //   if(r["success"] == true){
        //     Fluttertoast.showToast(msg: "Data inserted");
        //   } 
        // } else{
        //     //Fluttertoast.showToast(msg: "huhu ada error");
        //     print(widget.workOrderNo);
        //     Fluttertoast.showToast(msg: "Data not inserted");
        //     print("huhu ada error");
        //   }
        // final Map<String, dynamic> data = json.decode(response.body);
        // print(data);

    } catch(e){
      debugPrint("Problem updateMain : $e");
    }
      
  }

  Future<dynamic> navigate() {
    return Navigator.push(context, 
        MaterialPageRoute(
          builder: (context)=> UnscheduledCompleted(
            assetNo: widget.assetNo, 
            workOrderNo: widget.workOrderNo,
            taskType: "Updated",
          )
        )
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: innerAppBar("UNS"),
      body: ListView(
        children: [
          Container(
            child: Column(
              children: [
                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
                  child:  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(children: [
                      const Text("Asset Detail"),

                      Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                        const Text("Type Code"),
                        Text(assetDetail.typeCode ?? "null")
                      ],),

                      Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                        const Text("Model"),
                        Text(assetDetail.model ?? "null", softWrap: false,)
                      ],),

                      Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                        const Text("Serial No."),
                        Text(assetDetail.serialNo ?? "null")
                      ],),

                      Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                        const Text("Classification"),
                        Text(assetDetail.workGroup ?? "null")
                      ],),

                      Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                        const Text("Description"),
                        Text(assetDetail.assetDesc ?? "null")
                      ],),

                      Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                        const Text("Manufacturer"),
                        Text(assetDetail.manufact ?? "null")
                      ],),

                      Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                        const Text("Remark"),
                        Text(assetDetail.remark ?? "null")
                      ],)


                    ]),
                  ) ,),
              ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      child: Column(children: [
                        const Padding(
                          padding:  EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("In-Charge Technician", style: TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(mainAxisAlignment:MainAxisAlignment.spaceAround,
                            children: [
                            Column(
                              children: [
                                Container(
                                  width: 60, 
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Icon(Icons.person_4_outlined),
                                  ),
                                  ),
                                  const SizedBox(height: 15,),
                                  const Text('Tech Name')
                              ],
                            ),
                        
                              Column(
                                children: [
                                  Container(
                                  width: 60, 
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Icon(Icons.add),
                                  ),
                                  ),
                                  const SizedBox(height: 15,),
                                  const Text("Add Partner")
                                ],
                              )
                          ],),
                        ),
                      ]),
                    ) ,),
                ),

                // dropDownField("Rescheduled", reshceduledValue, rescheduledItem),
                // dropDownField("Performance Test", performanceValue, performanceItem),

              Padding(padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const Text("Rescheduled"),
                  const SizedBox(height: 10),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
                    ),
                    value: reshceduledValue,
                    onChanged: (value) {
                        // This is called when the user selects an item.
                        setState(() {
                          reshceduledValue = value.toString();
                        });
                      },
                    items: rescheduledItem.map((value){
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );}).toList(),
                    )
                ]),
              ),
              
               Padding(padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const Text("Performance Test"),
                  const SizedBox(height: 10),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
                    ),
                    value: performanceValue,
                    onChanged: (value) {
                        // This is called when the user selects an item.
                        setState(() {
                          performanceValue = value.toString();
                        });
                      },
                    items: performanceItem.map((value){
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );}).toList(),
                    )
                ]),
              ),

              Padding(padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const Text("Electrical Safety Test"),
                  const SizedBox(height: 10),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
                    ),
                    value: elecSafetyValue,
                    onChanged: (value) {
                        // This is called when the user selects an item.
                        setState(() {
                          elecSafetyValue = value.toString();
                        });
                      },
                    items: elecSafetyItem.map((value){
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );}).toList(),
                    )
                ]),
              ),

                // dropDownField("Electrical Safety Test", elecSafetyValue, elecSafetyItem),
                // dropDownField("QC Code", qcValue, qcItem),

              Padding(padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const Text("QR Code"),
                  const SizedBox(height: 10),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
                    ),
                    isExpanded: true,
                    value: _qcValue,
                    onChanged: (v) {
                        // This is called when the user selects an item.
                        setState(() {
                          _qcValue = v.toString();
                        });
                      },
                    items: qcItem.map((value){
                            return DropdownMenuItem(
                              value: value['qc_code'],
                              child: Text(value['qc_code'] + "/" + value['details']),
                            );}).toList(),
                    )
                ]),
              ),


                Padding(padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Action Taken"),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: actionTaken,
                      minLines: 6,
                      maxLines: 12,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.grey[350]!)
                        )
                      ),
                    ),
                  ],
                ),),
 
                loadImage(),

              Padding(padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () => _showBottomSheet(context),
                child: const Text("Select Image")),),
              

              Padding(padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: updateMain,
                child: const Text("Apply changes"),
                ),)

              ]
            ),
          )
        ],
      ),
    );
  }

  Padding loadImage() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        child: ((){
          if(imgObject.image == null && _image == null){
            return const Icon(Icons.image);
          } else if(imgObject.image != null) {
            return Image.network('${API.hostImage}/${imgObject.image}');
          } else {
            return Image.file(_image!);
          }
        }())
      ),
    );
  }
}