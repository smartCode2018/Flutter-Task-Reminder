// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_reminder/services/notification_services.dart';
import 'package:task_reminder/services/theme_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // ignore: prefer_typing_uninitialized_variables
  var notifyHelper;
  @override
  void initState(){
    super.initState();
    notifyHelper=Notifyhelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          Text("Theme Data", 
          style: TextStyle(fontSize: 30),
          )
      ],)
    );
  }


  _appBar(){
    return AppBar(
      leading: GestureDetector(
        onTap:(){
          ThemeService().switchTheme();

          //recieve notification immediatly function
          notifyHelper.displayNotification(
            title:"Them Changed",
            body: Get.isDarkMode?"Activated Light Theme":"Activated Dark Theme "
          );

          //scheduled notification function
          notifyHelper.scheduledNotification();
        } ,
        child: Icon(Icons.nightlight_sharp,
        size: 20,
        ),
      ),
      actions: [
        Icon(Icons.person,
        size: 20,
        ),
        SizedBox(width: 20,)
      ],
    );
  }
}