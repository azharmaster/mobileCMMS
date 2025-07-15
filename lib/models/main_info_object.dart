class MainInfo {
  var rescheduled;
  var performance;
  var elecSafety;
  var qcCode;
  var actionTaken;

  MainInfo({
    this.rescheduled,
    this.performance,
    this.elecSafety,
    this.qcCode,
    this.actionTaken
  });

   MainInfo fromJson(Map<String, dynamic> json) => MainInfo(
    rescheduled: json['rescheduled'],
    performance: json['performance'],
    elecSafety: json['electrical_safety_test'],
    qcCode: json['qccode'],
    actionTaken: json['actiontaken']
  );
}
