import 'dart:convert';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pakar_cmms/pages/maintenance_form/unscheduled_wo_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_connection.dart';

import 'package:pakar_cmms/pages/maintenance_form/scheduled_wo_form.dart';
import 'package:pakar_cmms/components/inner_app_bar.dart';
import 'package:pakar_cmms/models/scheduled_wo_object.dart';

import 'home.dart';

String _userId = "0";

class AssetDetail extends StatefulWidget {
  final String? assetNo;
  const AssetDetail({super.key, this.assetNo});

  @override
  State<AssetDetail> createState() => _AssetDetail();
}

class _AssetDetail extends State<AssetDetail> with TickerProviderStateMixin{
    ScheduledWOObject assetDetail = ScheduledWOObject();
    final color = [Colors.amberAccent, Colors.blueAccent];
    List item = [];
    int currentWO = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAssetDetail();
    getID();
  }

  getID() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = (_prefs.getString("id")??'');
    });
  }


    void getAssetDetail() async{
    try{
    var response = await http.post(Uri.parse(API.getAssetDetail),
      body: {"assetNo" : widget.assetNo});

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

  Future _getWO() async{
    try{
    var response = await http.post(Uri.parse(API.getAssetScheduled),
    body : {
      "assetNo" : widget.assetNo,
      "id": _userId
      });
    if(response.statusCode == 200){
      debugPrint("response good");
        return jsonDecode(response.body);
    } else{
      debugPrint("No New Data");
    }
    }
    catch(e){
      debugPrint("$e");
    }
  }

  Future _getUSWO() async{
    try{
    var response = await http.post(Uri.parse(API.getAssetUnscheduled),
    body: {
      "assetNo": widget.assetNo,
      "id": _userId
      });
    if(response.statusCode == 200){
      debugPrint("status 200");
      var resDecode = jsonDecode(response.body);
      return resDecode;
    } else{
      debugPrint("No Data");
    }
    }
    catch(e){
      debugPrint("$e");
    }
  }



  @override
  Widget build(BuildContext context) {
    List body = [scheduled(), unscheduled()];
    return Scaffold(
        appBar: innerAppBar(widget.assetNo!),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView(
            children: [Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                        Text(assetDetail.typeCode ?? "Not Available")
                      ],),
        
                      Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                        const Text("Model"),
                        Text(assetDetail.model ?? "Not Available", softWrap: false,)
                      ],),
        
                      Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                        const Text("Serial No."),
                        Text(assetDetail.serialNo ?? "Not Available")
                      ],),
        
                      Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                        const Text("Classification"),
                        Text(assetDetail.workGroup ?? "Not Available")
                      ],),
        
                      Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                        const Text("Description"),
                        Text(assetDetail.assetDesc ?? "Not Available")
                      ],),
        
                      Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                        const Text("Manufacturer"),
                        Text(assetDetail.manufact ?? "Not Available")
                      ],),
        
                      Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                        const Text("Remark"),
                        Text(assetDetail.remark ?? "Not Available")
                      ],)
        
        
                    ]),
                  ) ,),
              ),
            ],),
            
            const SizedBox(height: 20,),
            
            const Text("Available Work Orders"),
        
            SingleChildScrollView(
              child: Column(children: [
                const SizedBox(height: 20),

                TabPageSelector(
                  controller: TabController(length: 2, vsync: this, initialIndex: currentWO),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height/2.2,
                  width: MediaQuery.of(context).size.width,
                  child: PageView.builder(
                    itemCount: color.length,
                    controller: PageController(
                      viewportFraction: 1.0
                    ),
                    onPageChanged: (value){
                      setState(() {
                      currentWO = value;                        
                      });
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5.0,vertical:5.0),
                        child: body[index],);
                    },),
                )
              ],),
            ),

        
            Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Home())),
              // onPressed: _getTaskDetail,
              child: const Text("Return to Home")),
          ),
        
            ],
          ),
        ));
  }

  Widget scheduled(){
    return Column(
      children: [
        const Text("Scheduled"),
        FutureBuilder(
                future: _getWO(),
                builder: ((context, snapshot){
                  if(snapshot.hasError) debugPrint("$snapshot.error");
              
                  return snapshot.hasData ? 
                  
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        List list = snapshot.data!;
                        return 
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Container(
                            decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: Offset(0, 2)
                                  )]),
                  
                            child: GestureDetector(
                                onTap: () => Navigator.push(context, 
                                  MaterialPageRoute(builder: (context) => 
                                    ScheduledWOForm(
                                      assetNo: list[index]['asset_no'], 
                                      workOrderNo:list[index]['main_workno']
                                      )
                                    )
                                  ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                Expanded(
                                  child: SizedBox(
                                    width: 340,
                                    child: Stack(children: [
                                      // top half of card
                                      Container(
                                        height: 200,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                              SizedBox(child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                Padding(padding: const EdgeInsets.all(10),
                                                child: SvgPicture.asset('assets/icons/warning-circle.svg', 
                                                colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                                                
                                                )),
                                            
                                                Text(list[index]['main_workno'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
                                                ],
                                              ),),
                                              Text(list[index]['taskcode'], style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),)
                                            ],),
                                            
                                            Padding(
                                              padding: const EdgeInsets.all(12.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                const Text("Target Date", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12)),
                                                Text(list[index]['target_date'], style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12))
                                              ],),
                                            )
                                          ],
                                        ),
                                        ),
                                            
                                      // bottom half of card
                                      Positioned.fill(
                                        top: 90,
                                        child: Container(
                                          height: 110,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            boxShadow: [BoxShadow(
                                              color: Colors.black12,
                                              spreadRadius: 0,
                                              blurRadius: 2,
                                              offset: Offset(0, -1)
                                            )]
                                          ),
                                            
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(right: 5),
                                                            child: SvgPicture.asset('assets/icons/hard-drive.svg', height: 15, width: 15, fit: BoxFit.scaleDown,),
                                                          ),
                                                          Text(list[index]['asset_no'], style: const TextStyle(fontWeight: FontWeight.w500)),
                                                        ],
                                                      ),
                                                                        
                                                      Row(children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 5),
                                                          child: SvgPicture.asset('assets/icons/pin-alt.svg', height: 15, width: 15, fit: BoxFit.scaleDown,),
                                                        ),
                                                        Text(list[index]['user_area'], style: const TextStyle(fontWeight: FontWeight.w500))
                                                      ],)
                                                  ],),
                                                ),
                                          
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 250,
                                                        child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                                                        child: Text(list[index]['asset_desc'], style: const TextStyle(fontSize: 12),),
                                                      ),),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          ),
                                      )
                                          ],),
                                  ),
                                ),
                              
                                ConstrainedBox( constraints: 
                                  const BoxConstraints(maxWidth: 30, maxHeight: 200),
                                  child: DecoratedBox(
                                    decoration: const BoxDecoration(
                                      color: Color(0xffFFC453),
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset('assets/icons/nav-arrow-right.svg')
                                      ],
                                    ),),)
                              ],
                                
                              ),
                            ),
                          )
                        );
                      }),
                  ) 
                    
                    : const Center(child: Text("No Scheduled Work Order"));
                })
              ),
      ],
    );
  }

  Widget unscheduled(){
    return Column(
      children: [
        const Text("Unscheduled"),
        FutureBuilder(
            future: _getUSWO(),
            builder: ((context, snapshot) {
              if (snapshot.hasError) debugPrint(snapshot.error as String?);

              return snapshot.hasData ? 
              
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    List list = snapshot.data!;
                    return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 2)
                        )]),
              
                  child: GestureDetector(
                      onTap: () => Navigator.push(context, 
                        MaterialPageRoute(builder: (context) => 
                      UnscheduledWOForm(
                        assetNo: list[index]['asset_no'], 
                        workOrderNo:list[index]['main_workno'])
                        )
                      ),
              
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      Expanded(
                        child: SizedBox(
                          width: 340,
                          child: Stack(children: [
                            // top half of card
                            Container(
                              height: 200,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                        Text(list[index]['main_workno'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
                                      ],),
                                    ),
                                    
                                     Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:  const EdgeInsets.only(right: 5),
                                              child: SvgPicture.asset('assets/icons/hard-drive.svg', height: 15, width: 15, fit: BoxFit.scaleDown,),
                                            ),
                                            Text(list[index]['asset_no'], style: const TextStyle(fontWeight: FontWeight.w500)),
                                          ],
                                        ),
                              
                                        Row(children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 5),
                                            child: SvgPicture.asset('assets/icons/pin-alt.svg', height: 15, width: 15, fit: BoxFit.scaleDown,),
                                          ),
                                          Text(list[index]['locationno'], style: const TextStyle(fontWeight: FontWeight.w500))
                                        ],)
                                      ],),
                                    )
                                  ],
                                ),
                              ),
                              ),
                                  
                            // bottom half of card
                            Positioned.fill(
                              top: 90,
                              child: Container(
                                height: 110,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  boxShadow: [BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 0,
                                    blurRadius: 2,
                                    offset: Offset(0, -1)
                                  )]
                                ),
                                  
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 40,
                                                width: 40,
                                                child: DecoratedBox(
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue[50],
                                                    borderRadius: BorderRadius.circular(40)),
                                                  child: const Icon(Icons.person_outline),),
                                              ),
                                              Text(list[index]['reportby'], style: const TextStyle(fontWeight: FontWeight.w500))
                                            ],
                                          ),
                                        ),
                                  
                                        const VerticalDivider(width: 20, color: Colors.grey, thickness: 1, indent: 10, endIndent: 10,),
                                  
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                            Text(list[index]['detailsreport'], style: const TextStyle(fontWeight: FontWeight.w500),),
                                            Text(list[index]['date_req'])
                                          ],),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                ),
                            )
                                ],),
                        ),
                      ),
                    
                      ConstrainedBox( constraints: 
                        const BoxConstraints(maxWidth: 30, maxHeight: 200),
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                            color: Color(0xffFFC453),
                            borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/icons/nav-arrow-right.svg')
                            ],
                          ),),)
                    ],
                      
                    ),
                  ),
                )
                          );
                  }),
              )
              : const Center(child: Text("No work order"));
            })),
      ],
    );
  }
}