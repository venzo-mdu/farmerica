import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({Key key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  FlutterLocalNotificationsPlugin fltrNotification;
  int val;
  @override
  void initState() {
    super.initState();
    AndroidInitializationSettings androidInitilize =
        new AndroidInitializationSettings("@mipmap/ic_launcher");
    IOSInitializationSettings iOSinitilize = new IOSInitializationSettings();
    InitializationSettings initilizationsSettings = new InitializationSettings(
        android: androidInitilize, iOS: iOSinitilize);
    fltrNotification = new FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);
  }

  Future showNotification(String task) async {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "Desi programmer", "This is my channel",
        importance: Importance.max);
    var iOSDetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iOSDetails);

    // await fltrNotification.show(
    //     0, "Task", "You created a Task", generalNotificationDetails, payload: "Task");
    var scheduledTime;

    fltrNotification.show(
      1,
      "Farmerica App",
      task,
      generalNotificationDetails,
    );
  }

  Future notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification Clicked $payload"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView(children: [
          GestureDetector(
            onTap: () {
              showNotification("Check latest Offers");
            },
            child: ListTile(
              title: Text("Notifications Alert"),
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ]));
  }
}
