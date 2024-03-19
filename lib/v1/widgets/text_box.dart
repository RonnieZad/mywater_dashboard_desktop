import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextBox extends StatefulWidget {
  const AppTextBox({
    super.key,
    required this.title,
    required this.textEditingController,
    required this.hintText,
    required this.icon,
  });
  final String title;
  final TextEditingController textEditingController;
  final String hintText;
  final IconData icon;

  @override
  State<AppTextBox> createState() => _AppTextBoxState();
}

class _AppTextBoxState extends State<AppTextBox> {
  @override
  Widget build(BuildContext context) {
    return fluent.InfoLabel(
      label: widget.title,
      labelStyle: TextStyle(fontFamily: 'Poppins', fontSize: 13.sp),
      child: fluent.TextBox(
        prefix: fluent.Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: Icon(
            widget.icon,
            color: Colors.black54,
            size: 13.w,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
        controller: widget.textEditingController,
        placeholder: widget.hintText,
        style: TextStyle(
            fontFamily: 'Poppins', fontSize: 11.sp, color: Colors.black54),
        expands: false,
      ),
    );
  }
}
