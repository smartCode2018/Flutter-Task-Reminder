import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_reminder/ui/theme.dart';

class NotifiedPage extends StatelessWidget {
  final String? label;
  const NotifiedPage({ Key? key, required this.label }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.isDarkMode?Colors.grey[600]:Colors.white,
        leading: IconButton(
          onPressed: ()=>Get.back(),
          icon: Icon(Icons.arrow_back_ios,
          color: Get.isDarkMode?Colors.white:Colors.grey,),
        ),
        title: Text(this.label.toString().split("|")[0],
          style: TextStyle(color: Colors.black, ),
        ),
      ),
      body:
      Container(
        //decoration: BoxDecoration(color: Colors.red),
        margin: const EdgeInsets.only(left: 40, right: 40),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(height: 40,),
                    Text("Hello Justice", style: headingStyle,),
                    SizedBox(height: 6,),
                    Text("You have a new reminder", style: subHeadingStyle,),
                    SizedBox(height: 40,),
                      ],
                )
               ],
            ),
            Container(
                  height: 500,
                  width: 300,
                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(20),
                    color:Get.isDarkMode?Colors.white:primaryClr
                  ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.pages_outlined, 
                              color:Get.isDarkMode?Colors.white:Colors.white,
                              size: 30,
                              ),
                              SizedBox(width: 20,),
                              Text("Task Title", style: TextStyle(color: Get.isDarkMode?Colors.black:Colors.white,
                              fontSize: 20),)
                            ],
                          ),
                          SizedBox(height: 15,),
                          Row(
                            children: [
                              Text(this.label.toString().split("|")[0],
                              style: TextStyle(
                                color: Get.isDarkMode?Colors.black:Colors.white,
                                fontSize: 17
                              ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: 40,),

                          Row(
                            children: [
                              Icon(Icons.book_online_outlined, 
                              color:Get.isDarkMode?Colors.white:Colors.white,
                              size: 30,
                              ),
                              SizedBox(width: 20,),
                              Text("Descreption", style: TextStyle(color: Get.isDarkMode?Colors.black:Colors.white,
                              fontSize: 20),)
                            ],
                          ),
                          SizedBox(height: 15,),
                          Row(   
                            children: [
                              Text(this.label.toString().split("|")[1],
                              style: TextStyle(
                                color: Get.isDarkMode?Colors.black:Colors.white,
                                fontSize: 17
                              ),
                              ),
                            ],
                          ),
                        SizedBox(height: 40,),
                        Row(
                            children: [
                              Icon(Icons.access_time_rounded, 
                              color:Get.isDarkMode?Colors.white:Colors.white,
                              size: 30,
                              ),
                              SizedBox(width: 20,),
                              Text("Task Time", style: TextStyle(color: Get.isDarkMode?Colors.black:Colors.white,
                              fontSize: 20),)
                            ],
                          ),
                          SizedBox(height: 15,),
                          Row(
                            
                            children: [
                              Text(this.label.toString().split("|")[2],
                              style: TextStyle(
                                color: Get.isDarkMode?Colors.black:Colors.white,
                                fontSize: 17
                              ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 155),
                            child: Text("smartcode", style: TextStyle(color: Colors.lime),))
                        
                        ],
                      ),
                    
                    ),
                  ),

          ],
        ),
      ),
    );
  }
}