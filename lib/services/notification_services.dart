// ignore_for_file: avoid_print, prefer_const_constructors, unnecessary_new

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:task_reminder/models/task.dart';
import 'package:task_reminder/ui/notified.dart';
//port 'package:flutter/cupertino.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Notifyhelper{
  FlutterLocalNotificationsPlugin
  flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin(); 

  initializeNotification() async {
    _configureLocalTimezone();
 final IOSInitializationSettings initializationSettingsIOS =
     IOSInitializationSettings(
         requestSoundPermission: false,
         requestBadgePermission: false,
         requestAlertPermission: false,
         onDidReceiveLocalNotification: onDidReceiveLocalNotification
     );


    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings("appicon");

    final InitializationSettings initializationSettings =
        InitializationSettings(
       iOS: initializationSettingsIOS,
       android:initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: selectNotification);
  }

  //request for permission ios
  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

//recieve notification immediatly function
  displayNotification({required String title, required String body}) async {
    print("doing test");
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high);

    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics, 
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: title,
    );
  }

    //scheduled notification function
    scheduledNotification(int hour, int minutes, Task task) async {
     await flutterLocalNotificationsPlugin.zonedSchedule(
         task.id!.toInt(),
         task.title,
         task.note,
         _convertTime(hour, minutes),
         //tz.TZDateTime.now(tz.local).add(const Duration(seconds: newTime)),
         const NotificationDetails(
             android: AndroidNotificationDetails('your channel id',
                 'your channel name')),
         androidAllowWhileIdle: true,
         uiLocalNotificationDateInterpretation:
         UILocalNotificationDateInterpretation.absoluteTime,
         matchDateTimeComponents: DateTimeComponents.time,
         payload: "${task.title}|"+"${task.note}|"+"${task.startTime}|",

         );  
 
   }

   tz.TZDateTime _convertTime(int hour, int minutes){
     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduleDate = 
      tz.TZDateTime(tz.local, now.year, now.month,now.day, hour, minutes);

    if(scheduleDate.isBefore(now)){
      scheduleDate = scheduleDate.add(const Duration(days:1));
    }

    return scheduleDate;

  }

  Future<void> _configureLocalTimezone()async{
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

//what happens when you click on notification. goes to new page
  Future selectNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }

    if(payload=="Theme Changed"){
      //noting to nagigate to cause this is just a theme changed notification
    }else{

     Get.to(()=>NotifiedPage(label:payload));
    }
  }


//what happens after receiving notification
Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
  //   showDialog(
  //     //context: context,
  //     builder: (BuildContext context) => CupertinoAlertDialog(
  //       title: Text(title),
  //       content: Text(body),
  //       actions: [
  //         CupertinoDialogAction(
  //           isDefaultAction: true,
  //           child: Text('Ok'),
  //           onPressed: () async {
  //             Navigator.of(context, rootNavigator: true).pop();
  //             await Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => SecondScreen(payload),
  //               ),
  //             );
  //           },
  //         )
  //       ],
  //     ),
  //   );

  Get.dialog(Text("Welcome to flutter"));
}

}