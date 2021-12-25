// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_reminder/services/notification_services.dart';
import 'package:task_reminder/services/theme_service.dart';
import 'package:task_reminder/ui/theme.dart';
import 'package:task_reminder/ui/widgets/button.dart';

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
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top:10),
            child: Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
              children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(DateFormat.yMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                  ),
                  Text("Today", style: headingStyle,)
                ],
              ),
              MyButton(label: "+ Add Task", onTap: ()=>null)
            ],),
          )
      ],)
    );
  }


  _appBar(){
    return AppBar(
      elevation:0,
      backgroundColor: context.theme.backgroundColor,
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
        child: Icon(Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
        size: 20,
        color: Get.isDarkMode ? Colors.white:Colors.black,
        ),
      ),
      actions: [
        CircleAvatar(
          backgroundImage:AssetImage(
            "images/smart.jpg" 
          ),
        ),
        SizedBox(width: 20,)
      ],
    );
  }
}