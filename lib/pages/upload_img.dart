import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pakar_cmms/api/api_connection.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DemoUploadImage(),
    );
  }
}

class DemoUploadImage extends StatefulWidget {
  @override
  DemoUploadImageState createState() => DemoUploadImageState();
}

class DemoUploadImageState extends State<DemoUploadImage> {
  
  File? _image;
  final picker = ImagePicker();
  TextEditingController nameController = TextEditingController();


  Future choiceImage()async{
    var pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedImage!.path);
    });
  }

  Future uploadImage()async{
    final uri = Uri.parse(API.uploadImage);
    var request = http.MultipartRequest('POST',uri);
    request.fields['name'] = nameController.text;
    var pic = await http.MultipartFile.fromPath("image", _image!.path);
    request.files.add(pic);
    var response = await request.send();

    if (response.statusCode == 200) {
      debugPrint('Image Uploded');
    }else{
      debugPrint('Image Not Uploded');
    }
    setState(() {
      
    });
  }

  String? _mySelection;
  final List<Map> _myJson = [{"id":0,"name":"<New>"},{"id":1,"name":"Test Practice"}];

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.camera),
              onPressed: () {
                choiceImage();
              },
            ),
            Container(
              child: _image == null ? const Text('No Image Selected') : Image.file(_image!),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              child: const Text('Upload Image'),
              onPressed: () {
                uploadImage();
              },
            ),
            
            Center(
          child:  DropdownButton(
            isDense: true,
            hint: const  Text("Select"),
            value: _mySelection,
            onChanged: ( newValue) {

              setState(() {
                _mySelection = newValue;
              });

              debugPrint (_mySelection);
            },
            items: _myJson.map((Map map) {
              return DropdownMenuItem(
                value: map["id"].toString(),
                child: Text(
                  map["name"],
                ),
              );
            }).toList(),
          ),
            ),

          ],
        ),
      ),
    );
  }
}
