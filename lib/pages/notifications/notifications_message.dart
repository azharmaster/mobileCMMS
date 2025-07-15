import 'package:flutter/material.dart';

import '../../components/inner_app_bar.dart';

class NotiMessage extends StatelessWidget {
  final title, body;
  const NotiMessage({super.key, this.title, this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: innerAppBar('NOTIFICATION'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          SizedBox(height: 40,
          child: Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),),),
          Text(body)
        ]),
      ),
    );
  }
}