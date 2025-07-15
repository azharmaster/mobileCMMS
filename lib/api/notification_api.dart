import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi{
  static Future initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async{
    var androidInitialize = const AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettings =  new InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future showNotification({
    var id = 0, required String title, required String body, var payload, required FlutterLocalNotificationsPlugin fln
  }) async {
    AndroidNotificationDetails androidPlatformChannelSpefics = 
    const AndroidNotificationDetails('channelId', 'channelName');

    var noti = NotificationDetails(android: androidPlatformChannelSpefics);
    await fln.show(id, title, body, noti);
  }
}