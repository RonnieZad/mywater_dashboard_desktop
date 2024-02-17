//  NYUMBA MOBILE APP
//
//  Created by Ronald Zad Muhanguzi .
//  2022, Zofi Cash App. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mywater_dashboard_revamp/v1/constants/colors.dart';


Widget title(
        {String text = '',
        Color color = Colors.black,
        TextAlign textAlign = TextAlign.start,
        int delay = 0,
        fontFamily = 'Poppins',
        double fontSize = 40}) =>
    Text(text,
            style: TextStyle(
                fontSize: fontSize,
                color: color,
                fontWeight: FontWeight.w800,
                fontFamily: fontFamily),
            textAlign: textAlign);
Widget subtitle(
        {String text = '',
        Color color = Colors.black,
        TextAlign textAlign = TextAlign.start,
        int delay = 0}) =>
    Text(text,
            style: TextStyle(
                fontSize: 30.sp,
                color: color,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins'),
            textAlign: textAlign);
Widget subtitleBold(
        {String text = '',
        Color color = secondaryColorWhite,
        TextAlign textAlign = TextAlign.start,
        int delay = 0}) =>
   Text(text,
            style: TextStyle(
                fontSize: 30.sp,
                color: color,
                fontWeight: FontWeight.w800,
                fontFamily: 'Poppins'),
            textAlign: textAlign);
Widget headingBig(
        {String text = '',
        Color color = Colors.black,
        TextAlign textAlign = TextAlign.start,
        int delay = 0}) =>
   Text(text,
            style: TextStyle(
                fontSize: 18.sp,
                color: color,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins'),
            textAlign: textAlign);
Widget heading(
        {String text = '',
        Color color = Colors.black,
        textAlign = TextAlign.start,
        int delay = 0}) =>
   Text(text,
            style: TextStyle(
                fontSize: 18.sp,
                color: color,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins'),
            textAlign: textAlign);
Widget subHeading(
        {String text = '',
        Color color = Colors.black,
        int delay = 0,
        double fontSize = 15.4,
        int? maxlines}) =>
    Text(text,
            maxLines: maxlines,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(

                fontSize: fontSize,
                color: color,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins'));
Widget paragraph(
        {String text = '',
        Color color = Colors.black,
        int? maxlines,
        double fontSize = 12,
FontWeight fontWeight = FontWeight.w400,
        TextAlign textAlign = TextAlign.start,
        int delay = 0}) =>
   Text(text,
            maxLines: maxlines,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: fontSize.sp,
                color: color,
                fontWeight: fontWeight,
                fontFamily: 'Poppins'),
            textAlign: textAlign);
Widget paragraphSmall(
        {String text = '',
        Color color = Colors.black,
        TextAlign textAlign = TextAlign.start,
        int delay = 0}) =>
    Text(text,
            style: TextStyle(
                fontSize: 11.sp,
                color: color,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins'),
            textAlign: textAlign);
Widget paragraphSmallItalic(
        {String text = '',
        Color color = Colors.black,
        TextAlign textAlign = TextAlign.start,
        int delay = 0}) =>
    Text(text,
            style: TextStyle(
                fontSize: 11.5.sp,
                color: color,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins'),
            textAlign: textAlign);
Widget paragraphBold(
        {String text = '',
        Color color = Colors.black,
        int delay = 0,
        textAlign = TextAlign.start}) =>
   Text(text,
            style: TextStyle(
                fontSize: 16.sp,
                color: color,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins'),
            textAlign: textAlign);
Widget label(
        {String text = '',
        Color color = Colors.black,
        int delay = 0,
        double fontSize = 10}) =>
Text(text,
            style: TextStyle(
                fontSize: fontSize.sp,
                color: color,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins'));
Widget buttonLabel(
        {String text = '', Color color = primaryColorWhite, int delay = 0}) =>
  Text(text,
            style: TextStyle(
                fontSize: 12.sp,
                color: color,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins'));
Widget buttonLabelSmallBold(
        {String text = '', Color color = Colors.black, int delay = 0}) =>
    
     Text(text,
            style: TextStyle(
                fontSize: 16.sp,
                color: color,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins'));
Widget buttonLabelBold(
        {String text = '', Color color = Colors.black, int delay = 0}) =>
   Text(text,
            style: TextStyle(
                fontSize: 13.sp,
                color: color,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins'));
Widget caption(
        {String text = '',
        Color color = primaryColorWhite,
        TextAlign textAlign = TextAlign.start,
        int delay = 0}) =>
   Text(text,
            style: TextStyle(
                fontSize: 20.sp,
                color: color,
                fontWeight: FontWeight.w300,
                fontFamily: 'Poppins'),
            textAlign: textAlign);
Widget captionBold(
        {String text = '',
        Color color = Colors.black,
        TextAlign textAlign = TextAlign.start,
        int delay = 0}) =>
 Text(text,
            style: TextStyle(
                fontSize: 18.sp,
                color: color,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins'),
            textAlign: textAlign);
