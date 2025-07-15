import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../api/api_connection.dart';
import '../../models/scheduled_wo_object.dart';

import 'package:http/http.dart' as http;

import '../asset_detail.dart';


class AssetList extends StatefulWidget {
  const AssetList({super.key});

  @override
  State<AssetList> createState() => _AssetListState();
}

class _AssetListState extends State<AssetList> {
    List<ScheduledWOObject> assetDetail = [];

  List<Map<String, dynamic>> listAssets = [
    {"assetNo":"WV5854789S", "assetName":"AC", "assetCode":"09842", "assetModel":"nd-3287"},
    {"assetNo":"WV43565635", "assetName":"AB", "assetCode":"09453", "assetModel":"nd-9087"},
    {"assetNo":"WF43456346", "assetName":"AG", "assetCode":"56745", "assetModel":"nd-9087"},
    {"assetNo":"WFGTRR5345", "assetName":"AJ", "assetCode":"23465", "assetModel":"nd-9087"},
    {"assetNo":"WB45654676", "assetName":"A7", "assetCode":"98045", "assetModel":"nd-9087"},
  ];

  List<ScheduledWOObject> foundAssets = [];

  @override
  void initState() {
    super.initState();
    _getAsset();
  }

      _getAsset() async{
    try{
    var response = await http.get(Uri.parse(API.getAssets));
      if(response.statusCode == 200){
        debugPrint("response good get asset");
        assetDetail = (jsonDecode(response.body) as List).map((e) => ScheduledWOObject.fromJson(e)).toList();

        setState(() {
          foundAssets = assetDetail;
        });

      } else{
        debugPrint("No New Data");
      }      
    }
    catch(e){
      debugPrint("el problemo: $e");
    }
  }

  Future<void> refreshAssetView() async{
  _getAsset();
}
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshAssetView,
      child: Padding(padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
                "Some Assets",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
              ),
    
          TextField(
            onChanged: (value) => _runFilter(value),
            decoration: const InputDecoration(
              hintText: "Search"
            ),
          ),
    
          const SizedBox(height:30),
          
          Expanded(
                child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: foundAssets.length, 
                itemBuilder: (context, index){
                  return woCard(context, foundAssets[index].assetNo, "name", foundAssets[index].assetLocation, foundAssets[index].model);
                }),
              ),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("Total Assets: ${assetDetail.length}")
            ],
          )
          
          // Expanded(
          //   child: GridView.builder(
          //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 2,
          //     mainAxisSpacing: 1),
          //       itemCount: foundAssets.length, 
          //       itemBuilder: (context, index){
          //         return woCard(context, foundAssets[index]['asset_no'], foundAssets[index]['item_name'], foundAssets[index]['item_code'], foundAssets[index]['model']);
          //       }),
          // ),
        ],
      )),
    );
  }

    void _runFilter(String keyword){
    List<ScheduledWOObject> results = [];
    if(keyword.isEmpty){
      results = assetDetail;
    } else {
      results = assetDetail.where((asset) => asset.assetNo.toLowerCase().contains(keyword.toLowerCase())).toList();
    }

    setState(() {
      foundAssets = results;
    });
  }

    Padding woCard(BuildContext context, String assetNo, String itemName, String itemCode, String itemModel) {
    return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AssetDetail(assetNo: assetNo))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
              SizedBox(
                width: 170,
                child: Container(
                  height: 140,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 0.5,
                    blurRadius: 1,
                    offset: Offset(0, 1)
                  )]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(child: Text(assetNo, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),)),
                        ),
                        
                         Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                           Text(itemName, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12)),
                  
                           Text(itemCode, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12)),

                           Text(itemModel, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12)),

                         ],)
                      ],
                    ),
                  ),
                  ),
              ),
            ],
            ),
          )
        );
  }
}