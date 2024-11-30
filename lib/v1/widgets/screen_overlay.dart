import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenAppOverlay {
  ScreenAppOverlay._();

  static Future<Object?> showAppDialogWindow(BuildContext context, {required Widget body}) {
    return fluent.showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.white38,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            insetPadding: EdgeInsets.symmetric(horizontal: 150.w, vertical: 20.h),
            child: fluent.Acrylic(
              shadowColor: Colors.black12,
              elevation: 10,
              tint: Colors.white10,
              blurAmount: 30,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
                side: const BorderSide(
                  color: Colors.white,
                ),
              ),
              child: fluent.Stack(
                children: [
                  body,
                  Positioned(
                    top: 10.0,
                    right: 10.0,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        CupertinoIcons.multiply,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
