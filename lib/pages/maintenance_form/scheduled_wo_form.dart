import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pakar_cmms/components/inner_app_bar.dart';
import 'package:pakar_cmms/pages/completed/scheduled_completed.dart';
import 'package:http/http.dart' as http;
import 'package:pakar_cmms/models/scheduled_wo_object.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_connection.dart';

String _userId = "0";

const List<String> performanceItem = <String>["Have Done", "Not Applicable", "Not Done"];
const List<String> elecSafetyItem = <String>["Done", "Not Applicable", "Not Done"];
const List<String> rescheduledItem = <String>["Yes", "No"];

List causeCodeItem = [];
List qcItem = [];
List techItem = [];

TextEditingController actionTaken = TextEditingController();

class ScheduledWOForm  extends StatefulWidget {
  final assetNo, workOrderNo;
  const ScheduledWOForm ({Key? mykey, this.assetNo, this.workOrderNo}): super(key: mykey);

  @override
  State<ScheduledWOForm> createState() => _ScheduledWOFormState();
}

class _ScheduledWOFormState extends State<ScheduledWOForm> {

  ScheduledWOObject assetDetail = ScheduledWOObject();
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getID();
    getAssetDetail();
    getCauseCode();
    getQrCode();
    getTechs();
  }

  String performanceValue = performanceItem.last;
  String elecSafetyValue = elecSafetyItem.first;
  String reshceduledValue = rescheduledItem.first;
  String causeCodeValue = "QE1";
  String _qcValue = "QE1 A";
  String techValue = "2";

  TimeOfDay _startTime = const TimeOfDay(hour: 8, minute: 30,);
  TimeOfDay _endTime = const TimeOfDay(hour: 8, minute: 30);
  bool startTimePicked = false;
  bool endTimePicked = false;

  List list = [];

  getID() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = (_prefs.getString("id")??'');
    });
  }

  void _startTimePicker(){
    showTimePicker(context: context, 
    initialTime: TimeOfDay.now()).then((value){
      if(value != null){
        setState(() {
          startTimePicked = true;
          _startTime = value;
        });
      }
    });
  }

  void _endTimePicker(){
    showTimePicker(context: context, 
    initialTime: TimeOfDay.now()).then((value){
      if(value != null){
        setState(() {
          endTimePicked = true;
          _endTime = value;
        });
      }
    });
  }

  pickImage(ImageSource imgSource) async{
      var img = await picker.pickImage(source: imgSource);

      if(img != null){
        setState(() {
          _image = File(img.path);
        });
      }
  }

  Widget showImage(){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        child: _image == null ?
        const Icon(Icons.image) :
        Image.file(_image!),
      ),
    );
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
      )
    );
  }

  void getAssetDetail() async{
    try{
    var response = await http.post(Uri.parse(API.getAssetDetail),
      body: {"assetNo" : widget.assetNo});

      var r = jsonDecode(response.body);

      debugPrint("Asset detail fetched");
      setState(() {
        assetDetail = ScheduledWOObject.fromJson(r);
      });
    }
    catch(e){
      debugPrint("$e");
    }
  }

    // get codes from DB, convert to list
    Future getCauseCode() async{
      var response = await http.get(Uri.parse(API.getCauseCode));

      if(response.statusCode == 200){
        
        causeCodeItem = jsonDecode(response.body);

      } else {
        throw Exception("failed to load qc item");
      }
    }

  // get codes from DB, convert to list
  Future getQrCode() async {
    var response = await http.get(Uri.parse(API.getQcCode));
    if(response.statusCode == 200){
      qcItem = jsonDecode(response.body);
    } else {
      throw Exception("failed to load qc item");
    }
  }

  //get list of technicians
    Future getTechs() async {
    var response = await http.get(Uri.parse(API.getTechs));
    if(response.statusCode == 200){
      techItem = jsonDecode(response.body);
    } else {
      throw Exception("failed to load technicians");
    }
  }

   void submitMain() async {
    try{
      if(_image != null){
        var request = http.MultipartRequest('POST', Uri.parse(API.uploadImage));
        request.fields['main_workno'] = widget.workOrderNo;
        var pic = await http.MultipartFile.fromPath("image", _image!.path);
        request.files.add(pic);
        var response = await request.send();

         if(response.statusCode == 200){
          debugPrint("Image uploaded");
         } else {
          debugPrint("Image not uploaded");
         }
      }

      await http.post(Uri.parse(API.mainScheduled), 
      body:{
        'submit': "submit",
        'id': _userId,
        'starttime' : _startTime.format(context).toString(),
        'endtime' : _endTime.format(context).toString(),
        'main': widget.workOrderNo,
        'res': reshceduledValue,
        'pid' : widget.assetNo,
        'per': performanceValue,
        'ele': elecSafetyValue,
        'act': actionTaken.text,
        'cause' : causeCodeValue,
        'qr': _qcValue,
        'tech2' : techValue
        });

        Fluttertoast.showToast(msg: "Maintenance info sent");

        // redirect to scheduled completed page
        navScheduledCompleted();
    } catch(e) {
      debugPrint("$e");
    }
  }

   void navScheduledCompleted() {
     Navigator.push(context, 
       MaterialPageRoute(
         builder: (context)=> ScheduledCompleted(
           assetNo: widget.assetNo, 
           workOrderNo: widget.workOrderNo,
           taskType: "SCHEDULED",
           )));
   }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: innerAppBar(widget.assetNo),
      body: 
      ListView(
        children: [
          Column(
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
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                    child: Column(children: [
                      const Text("Add Technician", style: TextStyle(fontWeight: FontWeight.w600),),

                      const SizedBox(height: 20,),

                      Column(children: [
                        DropdownButtonFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
                          ),
                          isExpanded: true,
                          value: techValue,
                          onChanged: (v) {
                              // This is called when the user selects an item.
                              setState(() {
                                techValue = v.toString();
                              });
                            },
                          items: techItem.map((value){
                                  return DropdownMenuItem(
                                    value: value['id'],
                                    child: Text(value['name']),
                                  );}).toList(),
                          )
                      ],)
                    ]),
                  ) ,),
              ),

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

            Padding(padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                const Text("Cause Code"),
                const SizedBox(height: 10),
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
                  ),
                  isExpanded: true,
                  value: causeCodeValue,
                  onChanged: (value) {
                      // This is called when the user selects an item.
                      setState(() {
                        causeCodeValue = value.toString();
                      });
                    },
                  items: causeCodeItem.map((value){
                          return DropdownMenuItem(
                            value: value['cause_code'],
                            child: Text(value['cause_code'] + " / " + value['descr']),
                          );}).toList(),
                  )
              ]),
            ),

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
                            child: Text(value['qc_code'] + " / " + value['details']),
                          );}).toList(),
                  )
              ]),
            ),

              // pick start and end time
              Padding(padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Column(
                  children: [
                    const Text("Start Time"),
                    const SizedBox(height: 10),
                    OutlinedButton(onPressed: _startTimePicker,
                    child: startTimePicked ? Text(_startTime.format(context).toString()) : const Text("Start Time"),),
                  ],
                ),

                Column(
                  children: [
                    const Text("End Time"),
                    const SizedBox(height: 10),
                    OutlinedButton(
                    onPressed: _endTimePicker,
                    child: endTimePicked ? Text(_endTime.format(context).toString()) : const Text("End Time"),),
                  ],
                )
              ],),),

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
                            
            showImage(),

            Padding(padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () => _showBottomSheet(context),
              child: const Text("Select Image")),),
            

            Padding(padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: submitMain,
              child: const Text("Submit"),
              ),)

            ]
          )
        ],
      ),
    );
  }

  Padding dropDownField(String title, String dropdownValue, List dropDownItem) {
    return Padding(padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(title),
                  const SizedBox(height: 10),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
                    ),
                    value: dropdownValue,
                    onChanged: (value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue = value.toString();
                        });
                      },
                    items: dropDownItem.map((value){
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );}).toList(),
                    )
                ]),
              );
  }
}