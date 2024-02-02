// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:nyumba/v1/services/services.dart';

// class AppLifeTime {
//   AppLifeTime._();

//   ///called when the app is started, resumed to determine and establish auth status
//   static void initAppStatus(BuildContext context, mounted) async {
//     ApiService.getRequest(service: Services.authentication, endPoint: '/verify-account').then((response) async {
//       if (response['statusCode'] >= 200 && response['statusCode'] < 300) {
//         GetStorage().write('is_account_verified', response['response']['account_verified']);

//         GetStorage().write('is_security_question_setup', response['response']['is_security_question_setup']);

//         GetStorage().write('security_question_setup_id', response['response']['security_question_setup_id']);
//       } else if (response['statusCode'] == 401) {
//         GetStorage().erase();

//         await Get.deleteAll(force: true);

//         // if (mounted) {
//         //   Phoenix.rebirth(context);
//         // }

//         Get.reset();
//       }
//     });
//   }

//   ///retrives auth status of the current app user
//   static getCurrentUserAuthStatus() {
//     //checks wehther user account is verified and whether security question is answered and that implies user is
//     //well authentocated
//     bool userCompletedBasicAuth = GetStorage().read('is_account_verified') == true && GetStorage().read('is_security_question_setup') == true;

//     //checks whether user account is verified
//     bool accountVerified = GetStorage().read('is_account_verified') == true;

//     return userCompletedBasicAuth && accountVerified;
//   }

// presetAppControllers(){

// }

// }
