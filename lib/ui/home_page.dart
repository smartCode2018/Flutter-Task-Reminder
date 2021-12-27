// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

//import 'dart:js';

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_reminder/controllers/task_controller.dart';
import 'package:task_reminder/models/task.dart';
import 'package:task_reminder/services/notification_services.dart';
import 'package:task_reminder/services/theme_service.dart';
import 'package:task_reminder/ui/add_task_bar.dart';
import 'package:task_reminder/ui/theme.dart';
import 'package:task_reminder/ui/widgets/button.dart';
import 'package:task_reminder/ui/widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // ignore: prefer_typing_uninitialized_variables
  var notifyHelper;
  DateTime _selectedDate = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());

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
      //backgroundColor: context.theme.backgroundColor,
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          SizedBox(height: 14,),
          _showTask(),
      ],)
    );
  }

  _addDateBar(){
  return           Container(
            margin: const EdgeInsets.only(top:20, left: 10, right: 10),
            child: DatePicker(
              DateTime.now(),
              height: 100,
              width: 80,
              initialSelectedDate: DateTime.now(),
              selectionColor: primaryClr,
              selectedTextColor: Colors.white,
              dateTextStyle: GoogleFonts.lato(
                textStyle: TextStyle(fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.grey
               )
              ),
              dayTextStyle: GoogleFonts.lato(
                textStyle: TextStyle(fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.grey
                ),
              ),
              monthTextStyle: GoogleFonts.lato(
                textStyle: TextStyle(fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.grey
                )
              ),
              onDateChange: (date){
                setState(() {
                  _selectedDate=date;
                });
              },
            )
          );
}

  _addTaskBar(){
  return  Container( 
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
              MyButton(label: "+ Add Task", onTap: () async{ 
                await Get.to(() => AddTaskPage());
                _taskController.getTasks();
                }
                )
            ],),
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
            title:"Theme Changed",
            body: Get.isDarkMode?"Activated Light Theme":"Activated Dark Theme "
          );

          //scheduled notification function
          //notifyHelper.scheduledNotification();
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

  _showTask(){
    _taskController.getTasks();
    return Expanded(
      child:Obx((){
        return ListView.builder (
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, index){
            Task task = _taskController.taskList[index];
            print(task.toJson());
            if(task.repeat=="Daily"){

              DateTime date = DateFormat.jm().parse(task.startTime.toString());
              var myTime = DateFormat("HH:mm").format(date);
              notifyHelper.scheduledNotification(
                int.parse(myTime.toString().split(":")[0]),
                int.parse(myTime.toString().split(":")[1]),
                task
              );
              return AnimationConfiguration.staggeredList(position: index, 
              child: SlideAnimation(child: FadeInAnimation(child: Row(
                children: [
                  GestureDetector(
                    onTap:(){
                      _showBottomSheet(context, task);
                    },
                    child: TaskTile(task),
                  )
                ],
              ),
              ),
              )
              );
            
            }

            if(task.date==DateFormat.yMd().format(_selectedDate)){
              return AnimationConfiguration.staggeredList(position: index, 
              child: SlideAnimation(child: FadeInAnimation(child: Row(
                children: [
                  GestureDetector(
                    onTap:(){
                      _showBottomSheet(context, task);
                    },
                    child: TaskTile(task),
                  )
                ],
              ),
              ),
              )
              );
            
            }else{
              return Container();
            }
          
        });
      }),
      );
  }


_showBottomSheet(BuildContext context, Task task){
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted==1?
        MediaQuery.of(context).size.height*0.24 :
        MediaQuery.of(context).size.height*0.32,
        color: Get.isDarkMode?darkGreyClr:Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:Get.isDarkMode?Colors.grey[600]:Colors.grey[300]
              ),
            ),
            Spacer(),
            task.isCompleted==1
            ?Container():
            _bottomSheetButton(
              label:"Task Completed",
              onTap:(){
                _taskController.markTaskCompleted(task.id!);
                Get.back();
              },
              clr:primaryClr,
              context:context
            ),
            SizedBox(height: 5,),
            _bottomSheetButton(
              label:"Delete Task",
              onTap:(){
                _taskController.delete(task);
                Get.back();
              },
              clr:Colors.red[300]!,
              context:context
            ),
            SizedBox(height: 30,),
            _bottomSheetButton(
              label:"Close",
              onTap:(){
                Get.back();
              },
              clr:Colors.red[300]!,
              isClose: true,
              context:context
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
  
  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose=false,
    required BuildContext context,
  }){
    return GestureDetector(
      onTap:onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width*0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose==true?Get.isDarkMode?Colors.grey[600]!:Colors.grey[300]!:clr
          ),
          borderRadius: BorderRadius.circular(30),
          color:isClose==true?Colors.transparent:clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose?titleStyle:titleStyle.copyWith(color:Colors.white),
          ),
        ),
      ),
    );
  }

}