import 'package:json_annotation/json_annotation.dart';

//Class for scheduledWO
@JsonSerializable()
class ScheduledWOObject{
  var assetNo;
  var assetName;
  var typeCode;
  var model;
  var serialNo;
  var workGroup;
  var assetDesc;
  var manufact;
  var remark;
  var targetDate;
  var taskCode;
  var assetLocation;
  var image;

  // Model constructor
  ScheduledWOObject({
    this.assetNo, 
    this.assetName, 
    this.typeCode,
    this.model,
    this.serialNo,
    this.workGroup,
    this.assetDesc, 
    this.manufact,
    this.remark,
    this.targetDate, 
    this.taskCode, 
    this.assetLocation,});

  Map<String, dynamic> toJson()=>{
    'assetNo': assetNo,
    'assetDesc' : assetDesc,
    'assetName': assetName,
    'typeCode' : typeCode,
    'assetModel' : model,
  };

  static ScheduledWOObject fromJson(Map<String, dynamic> json) => ScheduledWOObject(
    assetNo: json['asset_no'], 
    typeCode: json['type_code'],
    model: json['model'],
    serialNo: json['serial_no'],
    workGroup: json['work_group'],
    assetDesc: json['asset_desc'], 
    manufact: json['manufacurer'],
    remark: json['remark'],
    targetDate: json['target_date'], 
    taskCode: json['task_code'], 
    assetLocation: json['location_code']
    );
}