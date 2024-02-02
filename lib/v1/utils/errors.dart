// //  ZOFI CASH MOBILE APP
// //
// //  Created by Ronald Zad Muhanguzi .
// //  2022, Zofi Cash App. All rights reserved.

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:nyumba_admin/v1/utils/screen_overlay.dart';




class Errors {
  ///#### Errors
  ///This [Errors] class catches all possbile exceptions accross the system
  Errors._();

  ///#### `Display Exception method`
  ///This [displayException] catches all possbile network errors `SocketExceptions`, `TimeoutExceptions`,
  ///`ClientExceptions` and `HttpExceptions` and shows a toast message using `showToast` method from
  ///the [CustomOverlay] class.
  // static displayException(Exception exception) {
  //   if (exception is SocketException) {
  //     ScreenOverlay.showToast(context,exception.message, Colors.blue[700]!, Colors.white);
  //     return false;
  //   } else if (exception is TimeoutException) {
  //     ScreenOverlay.showToast(context,exception.message!, Colors.blue[700]!, Colors.white);
  //     return false;
  //   }
  //   // else if (exception is http.ClientException) {
  //   //   ScreenOverlay.showToast(context,exception.message, Colors.blue[700]!, Colors.white);
  //   //   return false;
  //   // }
  //   else if (exception is HttpException) {
  //     ScreenOverlay.showToast(context,exception.message, Colors.blue[700]!, Colors.white);
  //     return false;
  //   }
  // }
}
