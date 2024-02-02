//  ZOFI CASH MOBILE APP
//
//  Created by Ronald Zad Muhanguzi .
//  2022, Zofi Cash App. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// #####  TextStyle for home page title
/// Here we are setting the text style to font family `IBM Plex Sans` and font size to
/// `30.sp` from the `package:flutter_screenutil`, font weight to `600` and text color to `white70` to add a glass effect
TextStyle homePageTextStyle = TextStyle(
  fontFamily: 'IBM Plex Sans',
  fontWeight: FontWeight.w600,
  fontSize: 30.sp,
  color: Colors.white70,
);

/// #####  TextStyle for home page amount figure
/// Here we are setting the text style to font family `IBM Plex Sans` and font size to
/// `60.sp` from the `package:flutter_screenutil`, font weight to `800` and text color to `white70` to add a glass effect
TextStyle amountTextStyle = TextStyle(
  fontFamily: 'IBM Plex Sans',
  fontWeight: FontWeight.w800,
  fontSize: 60.sp,
  color: Colors.white,
);

/// #####  TextStyle for home page currency text
/// Here we are setting the text style to font family `IBM Plex Sans` and font size to
/// `18.sp` from the `package:flutter_screenutil`, font weight to `600` and text color to `white38` to add a glass effect
TextStyle currencyTextStyle = TextStyle(
  fontFamily: 'IBM Plex Sans',
  fontWeight: FontWeight.w600,
  fontSize: 18.sp,
  color: Colors.white38,
);

/// #####  TextStyle for home page amount buttons
/// Here we are setting the text style to font family `IBM Plex Sans` and font size to
/// `26.sp` from the `package:flutter_screenutil`, font weight to `800` and text color to `white54` to add a glass effect
TextStyle amountInputButtonTextStyle = TextStyle(
  color: Colors.white54,
  fontSize: 22.sp,
  fontFamily: 'IBM Plex Sans',
  fontWeight: FontWeight.w800,
);

/// #####  TextStyle for home page action button
/// Here we are setting the text style to font family `IBM Plex Sans` and font size to
/// `20.sp` from the `package:flutter_screenutil`, font weight to `600` and text color to `white`
TextStyle homeActionButtonTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 17.sp,
  fontFamily: 'IBM Plex Sans',
  fontWeight: FontWeight.w600,
);

/// #####  TextStyle for dialog title text
/// Here we are setting the text style to font family `IBM Plex Sans` and font size to
/// `34.sp` from the `package:flutter_screenutil`, font weight to `800` and text color to `black`
TextStyle dialogTitleTextStyle = TextStyle(
  fontFamily: 'IBM Plex Sans',
  fontSize: 34.sp,
  fontWeight: FontWeight.w800,
);

/// #####  TextStyle for dialog body text
/// Here we are setting the text style to font family `IBM Plex Sans` and font size to
/// `22.sp` from the `package:flutter_screenutil`, font weight to `500` and text color to `black`
TextStyle dialogBodyTextStyle = TextStyle(
  fontFamily: 'IBM Plex Sans',
  fontSize: 22.sp,
  fontWeight: FontWeight.w500,
);

/// #####  TextStyle for dialog button text
/// Here we are setting the text style to font family `IBM Plex Sans` and font size to
/// `24.sp` from the `package:flutter_screenutil`, font weight to `600` and text color to `white`
TextStyle dialogButtonTextStyle = TextStyle(
  fontFamily: 'IBM Plex Sans',
  fontSize: 24.sp,
  color: Colors.white,
  fontWeight: FontWeight.w600,
);

/// #####  TextStyle for bottom navigation bar text
/// Here we are setting the text style to font family `IBM Plex Sans` and font size to
/// `14.sp` from the `package:flutter_screenutil`, font weight to `Bold`
TextStyle navBarSelectedTabTextStyle = TextStyle(
  fontSize: 14.sp,
  fontWeight: FontWeight.bold,
  fontFamily: 'IBM Plex Sans',
);

/// #####  TextStyle for bottom navigation bar  unselected text
/// Here we are setting the text style to font family `IBM Plex Sans` and font size to
/// `14.sp` from the `package:flutter_screenutil`, font weight to `Bold`
TextStyle navBarUnSelectedTabTextStyle = TextStyle(
  fontSize: 14.sp,
  fontWeight: FontWeight.bold,
  fontFamily: 'IBM Plex Sans',
);

/// #####  TextStyle for bottom navigation bar  unselected text
/// Here we are setting the text style to font family `IBM Plex Sans` and font size to
/// `14.sp` from the `package:flutter_screenutil`, font weight to `Bold`

TextStyle headingTextStyle = const TextStyle(
  fontSize: 18.0,
  color: Colors.white24,
  fontWeight: FontWeight.w400,
  fontFamily: 'IBM Plex Sans',
);

TextStyle headingSmallTextStyle = const TextStyle(
  fontSize: 16.0,
  color: Colors.white24,
  fontWeight: FontWeight.w400,
  fontFamily: 'IBM Plex Sans',
);

TextStyle headingExtraSmallTextStyle = const TextStyle(
  fontSize: 14.0,
  color: Colors.white24,
  fontWeight: FontWeight.w400,
  fontFamily: 'IBM Plex Sans',
);

TextStyle descriptionTextStyle = const TextStyle(
  fontSize: 17.0,
  color: Colors.white24,
  fontWeight: FontWeight.w400,
  fontFamily: 'IBM Plex Sans',
);

TextStyle whiteBigTextStyle = const TextStyle(
  fontSize: 25.0,
  color: Colors.white,
  fontWeight: FontWeight.w600,
  fontFamily: 'IBM Plex Sans',
);

TextStyle greenTextStyle = const TextStyle(
  fontSize: 20.0,
  color: Color(0xff00F513),
  fontWeight: FontWeight.w600,
  fontFamily: 'IBM Plex Sans',
);

TextStyle yellowTextStyle = const TextStyle(
  fontSize: 20.0,
  color: Color(0xffFFD800),
  fontWeight: FontWeight.w600,
  fontFamily: 'IBM Plex Sans',
);

TextStyle blueTextStyle = const TextStyle(
  fontSize: 20.0,
  color: Color(0xff005EF5),
  fontWeight: FontWeight.w600,
  fontFamily: 'IBM Plex Sans',
);

TextStyle transactionDescriptionStyle = const TextStyle(
  fontSize: 14.0,
  color: Colors.white24,
  fontWeight: FontWeight.w500,
  fontFamily: 'IBM Plex Sans',
);

TextStyle transactionDateStyle = const TextStyle(
  fontSize: 20.0,
  color: Colors.white,
  fontWeight: FontWeight.w600,
  fontFamily: 'IBM Plex Sans',
);

TextStyle introSliderTextStyle = const TextStyle(
  fontSize: 34.0,
  fontWeight: FontWeight.w400,
  color: Colors.white,
  fontFamily: 'IBM Plex Sans',
);

TextStyle termsOfUseTextStyle = const TextStyle(
  fontSize: 21.0,
  fontWeight: FontWeight.w300,
  color: Colors.white,
  fontFamily: 'IBM Plex Sans',
);

TextStyle buttonLabelStyle = const TextStyle(
  fontSize: 17.0,
  fontWeight: FontWeight.w600,
  color: Colors.white,
  fontFamily: 'IBM Plex Sans',
);

TextStyle textBoxStyle = const TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.w300,
  color: Colors.white,
  fontFamily: 'IBM Plex Sans',
);

TextStyle textBoxHintStyle = TextStyle(
  fontSize: 16.5.sp,
  fontWeight: FontWeight.w300,
  color: Colors.white,
  fontFamily: 'IBM Plex Sans',
);

TextStyle textBoxHintStyleLight = TextStyle(
  fontSize: 16.sp,
  fontWeight: FontWeight.w500,
  color: Colors.white60,
  fontFamily: 'IBM Plex Sans',
);

TextStyle infoTitleTextStyle = const TextStyle(
  fontFamily: 'IBM Plex Sans',
  fontSize: 28.0,
  color: Colors.white30,
);

TextStyle infoTipTextStyle = const TextStyle(
  fontFamily: 'IBM Plex Sans',
  fontSize: 23.0,
  color: Colors.white30,
);

TextStyle generalTextStyle = const TextStyle(
  fontFamily: 'IBM Plex Sans',
  fontSize: 20.0,
  color: Colors.white,
);
