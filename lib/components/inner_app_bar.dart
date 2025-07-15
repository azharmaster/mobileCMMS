import 'package:flutter/material.dart';

import '../colors.dart';

AppBar innerAppBar(String title){
  return AppBar(
        title: Text(title, 
        style: TextStyle(
          color: primary.shade500,
          fontWeight: FontWeight.w700),),
          centerTitle: true,
      );
}