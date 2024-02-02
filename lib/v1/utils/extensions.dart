//  ENYUMBA MOBILE APP
//
//  Created by Ronald Zad Muhanguzi .
//  2023, Enyumba App. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

extension ImagePath on String {
  String get toSvg => 'assets/files/$this.svg';
  String get toPng => 'assets/images/$this.png';
  String get toJpeg => 'assets/images/$this.jpeg';
  String get toMp4 => 'assets/files/$this.mp4';
  String get toJson => 'assets/lotties/$this.json';
}

extension EmptyPadding on num {
  SizedBox get ph => SizedBox(height: toDouble().h);
  SizedBox get pw => SizedBox(width: toDouble().w);
}

extension FormatAmount on int {
  static final format = NumberFormat("#,##0", "en_US");
  String get formatCurrency => "${format.format(this)} UGX";
}
