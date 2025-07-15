import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pakar_cmms/pages/homepage/asset_list.dart';
import 'package:pakar_cmms/pages/homepage/qr_camera.dart';
import 'package:pakar_cmms/pages/homepage/wo_list.dart';

import 'package:pakar_cmms/pages/notifications/notifications_list.dart';

import 'package:pakar_cmms/pages/homepage/setting.dart';

import 'package:pakar_cmms/colors.dart';


class Home extends StatefulWidget {
  final userId;
  const Home({Key? mykey, this.userId}): super(key: mykey);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String pendingSWO;
  late String pendingUSWO;
  bool colords = true;
  int bbIndex = 0;
  
  @override
  void initState() {
    super.initState();
  }

  // BUILD WIDGET 
  @override
  Widget build(BuildContext context) {
    List body = [
      const WOlist(),
      const QRcamera(),
      const AssetList(),
      const SettingsPage()
    ];

    return Scaffold(
        appBar: appBar(),

        body: body[bbIndex],

        // bottom navigation bar
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: const Color(0xff343A40),
            unselectedItemColor: const Color(0xffBBFFEB),
            selectedItemColor: const Color(0xff02D696),
            currentIndex: bbIndex,
            items: 
            const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home'),

                BottomNavigationBarItem(
                icon: Icon(Icons.qr_code_scanner),
                label: 'QR'),

                BottomNavigationBarItem(
                icon: Icon(Icons.format_list_bulleted_outlined),
                label: 'Assets'),

                BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings'),
            ],
            onTap: (index){
              setState(() {
                bbIndex = index;
              });
            }
          )

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

  // Column recentWO() {
  //   return Column(
  //     children: [
  //       Padding(
  //           padding: const EdgeInsets.all(10.0),
  //           child: Container(
  //             height: 140,
  //             decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(10),
  //                 boxShadow: const [
  //                   BoxShadow(
  //                       color: Colors.black12,
  //                       spreadRadius: 1,
  //                       blurRadius: 2,
  //                       offset: Offset(0, 2))
  //                 ]),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Container(
  //                   padding: const EdgeInsets.all(20),
  //                   child: const Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     children: [
  //                       Text(
  //                         "MWRWAC/F/2022/006426",
  //                         style: TextStyle(
  //                             fontWeight: FontWeight.w600, fontSize: 16),
  //                       ),
  //                       Padding(
  //                         padding: EdgeInsets.symmetric(vertical: 10),
  //                         child: Text(
  //                           "WV109000101A",
  //                           style: TextStyle(
  //                               fontWeight: FontWeight.w400, fontSize: 12),
  //                         ),
  //                       ),
  //                       Text(
  //                         "L1-CA-045(luar)",
  //                         style: TextStyle(
  //                             fontWeight: FontWeight.w400, fontSize: 12),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Column(
  //                   mainAxisAlignment: MainAxisAlignment.end,
  //                   children: [
  //                     Container(
  //                       decoration: const BoxDecoration(
  //                           color: primary,
  //                           borderRadius: BorderRadius.only(
  //                               bottomLeft: Radius.circular(10),
  //                               bottomRight: Radius.circular(10))),
  //                       child: const Padding(
  //                         padding: EdgeInsets.all(3.0),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                           children: [
  //                             Text(
  //                               "Completed on",
  //                               style: TextStyle(
  //                                   color: Colors.white, fontSize: 12),
  //                             ),
  //                             Text("20-06-2023",
  //                                 style: TextStyle(
  //                                     color: Colors.white, fontSize: 12))
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 )
  //               ],
  //             ),
  //           )),
  //     ],
  //   );
  // }

  AppBar appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: RichText(
        text: TextSpan(children: [
          const TextSpan(
              text: "PAKAR",
              style: TextStyle(color: primary, fontWeight: FontWeight.w700)),
          TextSpan(
              text: "CMMS",
              style: TextStyle(
                  color: Colors.grey[800], fontWeight: FontWeight.w700))
        ], style: const TextStyle(fontSize: 24)),
      ),
      actions: [
        GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NotificationPage())),
          child: Container(
              margin: const EdgeInsets.only(right: 20),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/icons/bell-fill.svg',
                colorFilter:
                    const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                width: 22,
                height: 22,
              )),
        )
      ],
    );
  }
  
}
