
class TaskDetail{

  var taskCode;
  var taskDate;
  var timeStart;
  var timeEnd;
  var rescheduled;
  var performance;
  var elecSafety;
  var qc;
  var actionTaken;
  var tech2;

  TaskDetail({
    this.taskCode, 
    this.taskDate, 
    this.timeStart, 
    this.timeEnd,
    this.rescheduled, 
    this.performance, 
    this.elecSafety,
    this.qc,
    this.actionTaken,
    this.tech2});

  static TaskDetail fromJson(Map<String, dynamic> json) => TaskDetail(
  taskCode : json['taskcode'], 
  taskDate : json['workcompleted'], 
  timeStart : json['starttime'], 
  timeEnd : json['endtime'],
  rescheduled : json['rescheduled'],
  performance : json['performance'],
  elecSafety : json['electrical_safety_test'],
  qc : json['qccode'],
  actionTaken : json['actiontaken'],
  tech2: json['tech2']
  );
}

