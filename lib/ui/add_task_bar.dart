// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_reminder/controllers/task_controller.dart';
import 'package:task_reminder/models/task.dart';
import 'package:task_reminder/ui/theme.dart';
import 'package:task_reminder/ui/widgets/button.dart';
import 'package:task_reminder/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({ Key? key }) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {

  final TaskController _taskController = Get.put(TaskController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _endTime = "09:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList=[
    5,
    10,
    15,
    20
  ];

  String _selectedRepeat = "none";
  List<String> repeatList=[
    "none",
    "Daily",
    "weekly",
    "Monthly"
  ];
  
  int _selectedColor = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right:20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Task",
                style: headingStyle,
              ),

              MyInputField(title: "Title", hint: "Enter your title", controller: _titleController,),
              MyInputField(title: "Note", hint: "Enter your note", controller: _noteController),
              MyInputField(title: "Date", hint: DateFormat.yMd().format(_selectedDate), 
                widget: IconButton(
                  icon: Icon(Icons.calendar_today_outlined,
                  color: Colors.grey,),
                  onPressed: (){
                    _getDateFromUser();
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(title: "Start Time", hint: _startTime,
                      widget: IconButton(onPressed: (){
                        //call get time function
                        _getTimeFromUser(true);
                      }, 
                      icon: Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey,
                      )
                      ),
                    )
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: MyInputField(title: "End Time", hint: _endTime,
                      widget: IconButton(onPressed: (){
                        //call get time function
                        _getTimeFromUser(false);
                      }, 
                      icon: Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey,
                      )
                      ),
                    )
                  )
                ],
              ),
              
              MyInputField(title: "Remind", hint: "$_selectedRemind minutes early",
                  widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down,
                  color:Colors.grey,
                  ) ,
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0,),
                  onChanged: (String? newValue){
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                    });
                  },
                  items:remindList.map<DropdownMenuItem<String>>((int value){
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child:Text(value.toString())
                    );
                  }).toList(),
                
                ),
              ),

              MyInputField(title: "Repeat", hint: "$_selectedRepeat",
                  widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down,
                  color:Colors.grey,
                  ) ,
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0,),
                  onChanged: (String? newValue){
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                  items:repeatList.map<DropdownMenuItem<String>>((String? value){
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child:Text(value!, style: TextStyle(color: Colors.grey))
                    );
                  }).toList(),
                
                ),
              ),
              SizedBox(height: 18,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallet(),
                  MyButton(label: "Create Task", onTap: ()=>_validateData(), width: 135,)
                ],
              )

            ],

          ),
        ),
      ),
    );
  }

  _appBar(BuildContext context){
    return AppBar(
      elevation:0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap:(){
          Get.back();
          } ,
        child: Icon(Icons.arrow_back_ios,
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

  _getDateFromUser()async{
  DateTime? _pickerDate = await showDatePicker(context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2015),
    lastDate: DateTime(2121)
  );

  if(_pickerDate!=null){
    setState((){
      _selectedDate = _pickerDate;
    });
  }else{

  }
}

  _getTimeFromUser(bool isStartTime)async{
    var pickedTime = await _showTimePicker();
    
    if(pickedTime == null){

    }else if(isStartTime==true){
      String _formatedTime = pickedTime?.format(context);
      print(_formatedTime);
      setState(() {
        _startTime=_formatedTime;
      });
    }else if(isStartTime==false){
      String _formatedTime = pickedTime?.format(context);
      print(_formatedTime);
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  

  _showTimePicker(){
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context, 
      //initialTime: TimeOfDay.now(),
      initialTime: TimeOfDay(
        // "convert to int and split 9:30 PM taking out the space and PM or AM"
        hour: int.parse(_startTime.split(":")[0]..split(" ")[0]), 
        minute: int.parse(_endTime.split(":")[1].split(" ")[0]),
        ),
      );
  }

  _colorPallet(){
    return                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text("Color",
                      style: titleStyle,
                    ),
                    SizedBox(height: 8.0,),
                    Wrap(
                      children: List<Widget>.generate(3, (int index){
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              _selectedColor = index;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CircleAvatar(
                              radius:18,
                              backgroundColor: index==0?primaryClr: index==1?pinkClr:yellowClr,
                              child: _selectedColor == index ? Icon(Icons.done,
                              color: Colors.white,
                              size:20,
                              ) : Container(),
                            ),
                          ),
                        );
                      }),
                    )
                  ],
                  );
 
  }

  _validateData(){
    if(_titleController.text.isNotEmpty && _noteController.text.isNotEmpty){
      //add to database
      _addTaskToDb();

      Get.back();
    }else if(_titleController.text.isEmpty || _noteController.text.isEmpty){
      Get.snackbar("Required", "All fields are required !", 
        snackPosition: SnackPosition.BOTTOM,
        colorText: pinkClr,

        backgroundColor: Colors.white,
        icon: Icon(Icons.warning_amber_rounded,
        color:Colors.red
        )
      );
    }
  }

  _addTaskToDb() async {
    int value = await _taskController.addTask(
      task:Task(
      note: _noteController.text,
      title: _titleController.text,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
      color: _selectedColor,
      isCompleted: 0
    ),
    );

    print(value);
  }

}