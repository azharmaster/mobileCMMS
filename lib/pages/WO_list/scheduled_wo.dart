import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pakar_cmms/components/inner_app_bar.dart';
import 'package:pakar_cmms/pages/maintenance_form/scheduled_wo_form.dart';
import 'package:pakar_cmms/api/api_connection.dart';
import 'package:pakar_cmms/db/connect.dart';
import 'package:http/http.dart' as http;

class ScheduledWO extends StatefulWidget {
  final userId;
  const ScheduledWO({super.key, this.userId});

  @override
  State<ScheduledWO> createState() => _ScheduledWOState();
}

class _ScheduledWOState extends State<ScheduledWO> {

  Future _getWO() async{
    try{
    var response = await http.post(Uri.parse(API.getAssigned),
    body: {
      "id": widget.userId
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

  // postData(String assetNo) async{
  //   var response = await http.post(Uri.parse(API.getAssetDetail),
  //   body: {
  //     "assetNo": assetNo
  //   });
  // }

  // doMaintenance(){

  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: innerAppBar("SCHEDULED"),

      body: FutureBuilder(
            future: _getWO(),
            builder: ((context, snapshot){
              if(snapshot.hasError) debugPrint("$snapshot.error");
          
              return snapshot.hasData ? 
              
              ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  List list = snapshot.data!;
                  return 
                  Padding(
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
                }) 
                
                : const Center(child: Text("No Pending Work Orders"));
            })
          ),
    );
  }

  // Padding woCard(BuildContext context, List list) {
  //   return Padding(
  //         padding: const EdgeInsets.symmetric(horizontal:20.0, vertical: 10.0),
  //         child: Container(
  //           decoration: const BoxDecoration(
  //                   borderRadius: BorderRadius.all(Radius.circular(10)),
  //                   boxShadow: [BoxShadow(
  //                   color: Colors.black12,
  //                   spreadRadius: 1,
  //                   blurRadius: 2,
  //                   offset: Offset(0, 2)
  //                 )]),

  //           child: GestureDetector(
  //               onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduledWOForm(assetNo: assetNo,))),
  //             child: Row(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //               Expanded(
  //                 child: Container(
  //                   width: 340,
  //                   child: Stack(children: [
  //                     // top half of card
  //                     Container(
  //                       height: 200,
  //                       decoration: const BoxDecoration(
  //                         color: Colors.white,
  //                         borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
  //                       ),
  //                       child: Column(
  //                         children: [
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                             children: [
  //                             SizedBox(child: Row(
  //                               mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                               children: [
  //                               Padding(padding: const EdgeInsets.all(10),
  //                               child: SvgPicture.asset('assets/icons/warning-circle.svg', 
  //                               colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                                
  //                               )),
                            
  //                               const Text("dsfsdfsdfrs", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
  //                               ],
  //                             ),),
  //                             const Text("E06075", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),)
  //                           ],),
                            
  //                           const Padding(
  //                             padding: EdgeInsets.all(12.0),
  //                             child: Row(
  //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                               children: [
  //                               Text("Target Date", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12)),
  //                               Text("2022-06-27", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12))
  //                             ],),
  //                           )
  //                         ],
  //                       ),
  //                       ),
                            
  //                     // bottom half of card
  //                     Positioned.fill(
  //                       top: 90,
  //                       child: Container(
  //                         height: 110,
  //                         decoration: const BoxDecoration(
  //                           color: Colors.white,
  //                           borderRadius: BorderRadius.all(Radius.circular(10)),
  //                           boxShadow: [BoxShadow(
  //                             color: Colors.black12,
  //                             spreadRadius: 0,
  //                             blurRadius: 2,
  //                             offset: Offset(0, -1)
  //                           )]
  //                         ),
                            
  //                         child: Padding(
  //                           padding: const EdgeInsets.symmetric(vertical: 10),
  //                           child: Column(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             children: [
  //                               Expanded(
  //                                 child: Row(
  //                                   mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                                   children: [
  //                                     Row(
  //                                       children: [
  //                                         Padding(
  //                                           padding: const EdgeInsets.only(right: 5),
  //                                           child: SvgPicture.asset('assets/icons/hard-drive.svg', height: 15, width: 15, fit: BoxFit.scaleDown,),
  //                                         ),
  //                                         const Text("WV109000101A", style: TextStyle(fontWeight: FontWeight.w500)),
  //                                       ],
  //                                     ),
                                                        
  //                                     Row(children: [
  //                                       Padding(
  //                                         padding: const EdgeInsets.only(right: 5),
  //                                         child: SvgPicture.asset('assets/icons/pin-alt.svg', height: 15, width: 15, fit: BoxFit.scaleDown,),
  //                                       ),
  //                                       const Text("L1-CA-045(luar)", style: TextStyle(fontWeight: FontWeight.w500))
  //                                     ],)
  //                                 ],),
  //                               ),
                          
  //                               const Expanded(
  //                                 child: Row(
  //                                   mainAxisAlignment: MainAxisAlignment.start,
  //                                   children: [
  //                                     SizedBox(
  //                                       width: 250,
  //                                       child: Padding(
  //                                       padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
  //                                       child: Text("Communication, Nurse Call  System, Control Panel / Electrical", style: TextStyle(fontSize: 12),),
  //                                     ),),
  //                                   ],
  //                                 ),
  //                               )
  //                             ],
  //                           ),
  //                         ),
  //                         ),
  //                     )
  //                         ],),
  //                 ),
  //               ),
              
  //               ConstrainedBox( constraints: 
  //                 const BoxConstraints(maxWidth: 30, maxHeight: 200),
  //                 child: DecoratedBox(
  //                   decoration: const BoxDecoration(
  //                     color: Color(0xffFFC453),
  //                     borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))
  //                   ),
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       SvgPicture.asset('assets/icons/nav-arrow-right.svg')
  //                     ],
  //                   ),),)
  //             ],
                
  //             ),
  //           ),
  //         )
  //       );
  // }

}