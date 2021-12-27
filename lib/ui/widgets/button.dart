import 'package:flutter/material.dart';
import 'package:task_reminder/ui/theme.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;
  double width;
  MyButton({ Key? key, required this.label, required this.onTap, this.width = 120 }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(width:width,
        height: 50,
        decoration: BoxDecoration(color: primaryClr,
          borderRadius: BorderRadius.circular(30)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      
      ),
    );
  }
}