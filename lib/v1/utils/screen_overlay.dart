//  ZOFI CASH MOBILE APP
//
//  Created by Ronald Zad Muhanguzi .
//  2022, Zofi Cash App. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:mywater_dashboard_revamp/v1/constants/colors.dart';
import 'package:mywater_dashboard_revamp/v1/utils/utils.dart';

class ScreenOverlay {
  ScreenOverlay._();

  static showNyumbaSidePaneDialog(BuildContext context, {required Widget child}) {
    return fluent.showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
          elevation: 10.0,
          alignment: Alignment.centerRight,
          insetAnimationCurve: Curves.slowMiddle,
          child: child,
        );
      },
    );
  }

  /// #### Show Toast method
  /// Here we have a static `showToast` method of type [ToastFuture] from the `package:oktoast`
  /// It takes parameters message of type [String] which is th text to display, bgColor od type
  /// [Color] which is the background color of the Toast and textColor of type [Color] which is the
  /// color of the text.
  /// This method returns the `showToastWidget` from `package:oktoast` which displays a toast
  static Future showToast(context, {isError = false, isWarning = false, required String title, required String message}) async {
    return await fluent.displayInfoBar(context, alignment: Alignment.topRight, builder: (context, close) {
      return fluent.InfoBar(
        title: Text(
          title,
          style: TextStyle(fontFamily: 'Poppins', fontSize: 12.sp),
        ),
        content: Text(
          message,
          style: TextStyle(fontFamily: 'Poppins', fontSize: 11.sp),
        ),
        action: IconButton(
          icon: const Icon(fluent.FluentIcons.clear),
          onPressed: close,
        ),
        severity: isWarning
            ? fluent.InfoBarSeverity.warning
            : isError
                ? fluent.InfoBarSeverity.error
                : fluent.InfoBarSeverity.success,
      );
    });
  }

  // ///specify duration in seconds eg 2
  // static showLoaderOverlay({int? duration}) {
  //   IgnorePointer loaderOverlay = IgnorePointer(
  //     child: SizedBox(
  //       width: 80.w,
  //       height: 80.w,
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(12.r),
  //         child: Container(
  //           decoration: BoxDecoration(
  //             color: Colors.black38,
  //             borderRadius: BorderRadius.circular(12.r),
  //           ),
  //           child: Center(
  //             child: SizedBox(
  //               width: 30.w,
  //               height: 30.w,
  //               child: CircularProgressIndicator(
  //                 strokeWidth: 4.w,
  //                 valueColor: const AlwaysStoppedAnimation(
  //                   Colors.white,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  //   showToastWidget(
  //     loaderOverlay,
  //     dismissOtherToast: true,
  //     position: ToastPosition.center,
  //     animationCurve: Curves.easeInOut,
  //     animationDuration: const Duration(milliseconds: 300),
  //     duration: Duration(seconds: duration ?? 1),
  //   );
  // }

  static Future<void> showCustomDialogOverlay(
    BuildContext context, {
    required String headingText,
    required String paragraphText,
    required String rightActionText,
    required String leftActionText,
    required VoidCallback leftAction,
    required VoidCallback rightAction,
    Widget? child,
  }) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: SizedBox(
              width: 320.w,
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heading(text: headingText, color: Colors.black),
                    20.ph,
                    child ?? paragraph(text: paragraphText, color: Colors.black),
                    30.ph,
                  ],
                ),
              ),
            ),
          );
        });
  }

  static Future<void> showModalViewOverlay(
    BuildContext context, {
    required String headingText,
    required String paragraphText,
    required Widget child,
  }) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: SizedBox(
              width: 720.w,
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heading(text: headingText, color: Colors.black),
                    20.ph,
                    paragraph(text: paragraphText, color: Colors.black),
                    20.ph,
                    Expanded(child: child),
                  ],
                ),
              ),
            ),
          );
        });
  }

  static Future<void> showCustomDocumentOverlay(
    BuildContext context, {
    required String headingText,
    required String paragraphText,
    required Widget child,
  }) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            insetPadding: EdgeInsets.zero,
            child: SizedBox(
              width: 320.w,
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heading(text: headingText, color: Colors.black),
                    20.ph,
                    child,
                    30.ph,
                  ],
                ),
              ),
            ),
          );
        });
  }

  static Future<void> showImagePickerConfirmOverlay(
    BuildContext context, {
    required String headingText,
    required String paragraphText,
    required Widget child,
    required VoidCallback action,
  }) {
    return showDialog(
        context: context,
        barrierColor: Colors.black87,
        builder: (context) {
          return Dialog(
            insetPadding: EdgeInsets.zero,
            child: SizedBox(
              width: 460.w,
              height: 460.h,
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        heading(text: headingText, color: Colors.black),
                        10.ph,
                        label(text: paragraphText, color: Colors.black),
                        25.ph,
                        Expanded(child: Center(child: child)),
                        20.ph,
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: action,
                                child: Container(
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.r),
                                    color: baseColor,
                                  ),
                                  child: Center(child: buttonLabel(text: 'Upload File(s)', color: Colors.white)),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  static Future<void> showGeneralInfoOverlay(
    BuildContext context, {
    required String headingText,
    required String paragraphText,
    required Widget child,
  }) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            insetPadding: EdgeInsets.zero,
            child: SizedBox(
              width: 320.w,
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heading(text: headingText, color: Colors.black),
                    10.ph,
                    label(text: paragraphText, color: Colors.black),
                    25.ph,
                    child,
                  ],
                ),
              ),
            ),
          );
        });
  }

  static Future<void> showDialogOverlay(
    BuildContext context, {
    required String headingText,
    required String paragraphText,
    required String rightActionText,
    required String leftActionText,
    required VoidCallback leftAction,
    required VoidCallback rightAction,
  }) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: SizedBox(
              width: 320.w,
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heading(text: headingText, color: Colors.black),
                    10.ph,
                    paragraph(text: paragraphText, color: Colors.black, maxlines: 4),
                  ],
                ),
              ),
            ),
          );
        });
  }

  /// #####  showSuccessDialog
  /// Here were are returning the `showDialog` method which displays a success dialog overlay to a user
}
