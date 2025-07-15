class NotificationObject {
  var title;
  var body;
  var status;


  NotificationObject({
    this.title,
    this.body,
    this.status,

  });

   NotificationObject fromJson(Map<String, dynamic> json) => NotificationObject(
    title: json['title'],
    body: json['body'],
    status: json['status'],

  );
}
