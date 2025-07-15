import 'package:json_annotation/json_annotation.dart';

//Class for scheduledWO
@JsonSerializable()
class ImageObject{

  var image;

  // Model constructor
  ImageObject({
    this.image});

  Map<String, dynamic> toJson()=>{
    'image' : image
  };

  static ImageObject fromJson(Map<String, dynamic> json) => ImageObject(
    image: json['image']);
}