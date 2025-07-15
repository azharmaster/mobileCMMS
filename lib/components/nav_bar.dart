import 'package:flutter/material.dart';

Widget navBar(){
  return BottomNavigationBar(
        backgroundColor: const Color(0xff343A40),
        unselectedItemColor: const Color(0xffBBFFEB),
        selectedItemColor: const Color(0xff02D696),
        currentIndex: 1,
        items: 
        const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'),

            BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'QR'),

            BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings'),
        ],
      );
}