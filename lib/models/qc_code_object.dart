class QcCode{
  var causeCode;
  var desc;

  QcCode({this.causeCode, this.desc});

  static QcCode fromJson(Map<String, dynamic> json) => QcCode(
    causeCode: json['cause_code'],
    desc: json['descr']
  );
}