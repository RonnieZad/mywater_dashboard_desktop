import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

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
            // surfaceTintColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 150, vertical: 20),
            child: fluent.Acrylic(
              shadowColor: Colors.black12,
              elevation: 100,
              tint: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: const BorderSide(
                  color: Colors.white,
                ),
              ),
              child: body,
            ),
          );
        });
  }
}
