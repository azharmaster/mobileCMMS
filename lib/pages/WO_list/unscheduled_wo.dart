import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pakar_cmms/components/inner_app_bar.dart';
import 'package:pakar_cmms/pages/maintenance_form/unscheduled_wo_form.dart';
import 'package:pakar_cmms/api/api_connection.dart';
import 'package:pakar_cmms/db/connect.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String _userId = "0";

class UnscheduledWO extends StatefulWidget {
  const UnscheduledWO({super.key});

  @override
  State<UnscheduledWO> createState() => _UnscheduledWOState();
}

class _UnscheduledWOState extends State<UnscheduledWO> {

    var db = Mysql();

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
  }

    Future _getUSWO() async{
    try{
    var response = await http.post(Uri.parse(API.getUnscheduled),
    body: {
      "id":_userId
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

    return Scaffold(
      appBar: innerAppBar("UNSCHEDULED"),

      body: FutureBuilder(
        future: _getUSWO(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) debugPrint(snapshot.error as String?);

          return snapshot.hasData ? 
          
          ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              List list = snapshot.data!;
              return Padding(
          padding: const EdgeInsets.symmetric(horizontal:20.0, vertical: 10.0),
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
                  child: Container(
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
            })
          : const Center(child: CircularProgressIndicator());
        }))

      // ListView(
      //   children: [
      //     Padding(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      //     child: Text("Pending Tasks", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),),

      //     woCard(context),
      //   ],
      // ),
    );
  }

  Padding woCard(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.symmetric(horizontal:20.0, vertical: 10.0),
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
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UnscheduledWOForm())),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                Expanded(
                  child: Container(
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
                              const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                  Text("MWRWAC/F/2022/006426", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
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
                                      const Text("WV109000101A", style: TextStyle(fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                        
                                  Row(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: SvgPicture.asset('assets/icons/pin-alt.svg', height: 15, width: 15, fit: BoxFit.scaleDown,),
                                    ),
                                    const Text("L1-CA-045(luar)", style: TextStyle(fontWeight: FontWeight.w500))
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
                                        const Text("Maznah", style: TextStyle(fontWeight: FontWeight.w500))
                                      ],
                                    ),
                                  ),
                            
                                  const VerticalDivider(width: 20, color: Colors.grey, thickness: 1, indent: 10, endIndent: 10,),
                            
                                  const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                      Text("Door access tercabut", style: TextStyle(fontWeight: FontWeight.w500),),
                                      Text("2022-02-04")
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
                    decoration:const  BoxDecoration(
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
  }
}