import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mywater_dashboard_revamp/v1/models/authentication_model.dart';
import 'package:mywater_dashboard_revamp/v1/screens/dashboard.dart';
import 'package:mywater_dashboard_revamp/v1/utils/screen_overlay.dart';
import 'package:mywater_dashboard_revamp/v1/utils/utils.dart';

import '../services/api_service.dart';

class AuthController extends GetxController {
  Rx<FilePickerResult?> artworkFile = const FilePickerResult([]).obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController companyDescriptionController = TextEditingController();
  TextEditingController companyWebsiteController = TextEditingController();

  _clearAuthForm() {
    artworkFile = const FilePickerResult([]).obs;
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    phoneNumberController.clear();
    companyNameController.clear();
    companyDescriptionController.clear();
    companyWebsiteController.clear();
  }

  ///create accouny for partner account
  createPartnerAccount(context, {required AuthenticationModel authModel}) {
    fluent.showDialog(
        context: context,
        dismissWithEsc: false,
        builder: (context) {
          return fluent.Center(
            child: fluent.Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: fluent.Padding(
                padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [const fluent.ProgressBar(), 20.ph, paragraph(text: 'Creating account...')],
                ),
              ),
            ),
          );
        });
    ApiService.postRequest(endPoint: '/account_registration', service: Services.authentication, body: authModel.toJson()).then((response) {
      print(response);
      if (response['payload']['status'] >= 200 && response['payload']['status'] < 300) {
        GetStorage().write('token', response['payload']['token']);
        GetStorage().write('partnerId', response['payload']['data']['id']);
        GetStorage().write('partnerData', response['payload']['data']);
        Phoenix.rebirth(context);
        Get.reset();

        Navigator.push(context, MaterialPageRoute(builder: (context) => const Dashboard()));
      } else {
        Navigator.pop(context);
        ScreenOverlay.showToast(context, title: 'Something went wrong', message: response['payload']['error'], isError: true);
      }
      _clearAuthForm();
    });
  }

  ///create accouny for partner account
  loginPartnerAccount(context, {required AuthenticationModel authModel}) {
    fluent.showDialog(
        context: context,
        dismissWithEsc: false,
        builder: (context) {
          return fluent.Center(
            child: fluent.Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: fluent.Padding(
                padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [const fluent.ProgressBar(), 20.ph, paragraph(text: 'Logging in...')],
                ),
              ),
            ),
          );
        });
    ApiService.postRequest(endPoint: '/account_login', service: Services.authentication, body: authModel.toJson()).then((response) {
      print(response);

      if (response['payload']['status'] >= 200 && response['payload']['status'] < 300) {
        GetStorage().write('token', response['payload']['token']);
        GetStorage().write('partnerId', response['payload']['data']['id']);
        GetStorage().write('partnerData', response['payload']['data']);
        Phoenix.rebirth(context);
        Get.reset();
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Dashboard()));
      } else {
        Navigator.pop(context);
        ScreenOverlay.showToast(context, title: 'Something went wrong', message: response['payload']['error'], isError: true);
      }
      _clearAuthForm();
    });
  }
}
