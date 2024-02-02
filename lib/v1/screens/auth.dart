import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mywater_dashboard_revamp/v1/constants/colors.dart';
import 'package:mywater_dashboard_revamp/v1/controller/auth_controller.dart';
import 'package:mywater_dashboard_revamp/v1/models/authentication_model.dart';
import 'package:mywater_dashboard_revamp/v1/screens/dashboard.dart';
import 'package:mywater_dashboard_revamp/v1/utils/file_picker.dart';
import 'package:mywater_dashboard_revamp/v1/utils/screen_overlay.dart';
import 'package:mywater_dashboard_revamp/v1/utils/utils.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthController authController = Get.put(AuthController());
  bool oldUser = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const fluent.Color.fromARGB(255, 240, 239, 239),
      body: Row(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 100.h),
            padding: EdgeInsets.symmetric(horizontal: 70.w),
            height: double.infinity,
            width: 0.5.sw,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'assets/images/app_logo.svg',
                    width: 180.w,
                    color: const Color.fromRGBO(14, 74, 111, 1),
                  ),
                  20.ph,
                  paragraph(
                      text: 'Reinventing Advertising With Purpose',
                      fontSize: 16.sp),
                  const Spacer(),
                  if (oldUser) ...[
                    fluent.InfoLabel(
                      label: 'Enter email address',
                      labelStyle:
                          TextStyle(fontFamily: 'Poppins', fontSize: 13.sp),
                      child: fluent.TextBox(
                        prefix: fluent.Padding(
                          padding: EdgeInsets.only(left: 20.w),
                          child: Icon(
                            fluent.FluentIcons.mail,
                            color: Colors.black54,
                            size: 13.w,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 15.h, horizontal: 10.w),
                        controller: authController.emailController,
                        placeholder: 'eg info@example.com',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12.sp,
                            color: Colors.black54),
                        expands: false,
                      ),
                    ),
                    20.ph,
                    fluent.InfoLabel(
                      label: 'Enter Password',
                      labelStyle:
                          TextStyle(fontFamily: 'Poppins', fontSize: 13.sp),
                      child: fluent.PasswordBox(
                        controller: authController.passwordController,
                        leadingIcon: fluent.Padding(
                          padding: EdgeInsets.only(left: 20.w),
                          child: Icon(
                            fluent.FluentIcons.password_field,
                            color: Colors.black54,
                            size: 13.w,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 15.h, horizontal: 20.w),
                        placeholder: 'Password',
                        revealMode: fluent.PasswordRevealMode.peek,
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12.sp,
                            color: Colors.black54),
                      ),
                    ),
                  ] else ...[
                    // 20.ph,
                    Obx(() {
                      return fluent.SizedBox(
                        height: 0.5.sh,
                        child: fluent.Scrollbar(
                          thumbVisibility: true,
                          child: ListView(
                            padding: EdgeInsets.only(right: 15.w),
                            children: [
                              
                              if (authController
                                  .artworkFile.value!.files.isNotEmpty) ...[
                             CircleAvatar(
                              radius: 60.r,
                              child: Image.file(
                                File(authController.artworkFile.value!.files.first.path!),
                                fit: BoxFit.cover,
                              ),
                             ),
                                20.ph,
                              ],
                              SizedBox(
                                height: 45.h,
                                child: fluent.Button(
                                  child: fluent.Center(
                                      child: label(
                                    text: 'Attach Company Logo',
                                    color: Colors.black54,
                                    fontSize: 11.sp,
                                  )),
                                  onPressed: () async {
                                    authController.artworkFile.value =
                                        await FilePicker.platform.pickFiles();
                                  },
                                ),
                              ),
                              20.ph,
                              fluent.InfoLabel(
                                label: 'Enter email address',
                                labelStyle: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 13.sp),
                                child: fluent.TextBox(
                                  prefix: fluent.Padding(
                                    padding: EdgeInsets.only(left: 20.w),
                                    child: Icon(
                                      fluent.FluentIcons.mail,
                                      color: Colors.black54,
                                      size: 13.w,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15.h, horizontal: 10.w),
                                  controller: authController.emailController,
                                  placeholder: 'eg info@example.com',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12.sp,
                                      color: Colors.black54),
                                  expands: false,
                                ),
                              ),
                              20.ph,
                              fluent.InfoLabel(
                                label: 'Enter company name',
                                labelStyle: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 13.sp),
                                child: fluent.TextBox(
                                  prefix: fluent.Padding(
                                    padding: EdgeInsets.only(left: 20.w),
                                    child: Icon(
                                      fluent.FluentIcons.text_field,
                                      color: Colors.black54,
                                      size: 13.w,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15.h, horizontal: 10.w),
                                  controller:
                                      authController.companyNameController,
                                  placeholder: 'eg Acme Ltd',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12.sp,
                                      color: Colors.black54),
                                  expands: false,
                                ),
                              ),
                              20.ph,
                              fluent.InfoLabel(
                                label: 'Enter company description',
                                labelStyle: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 13.sp),
                                child: fluent.TextBox(
                                  prefix: fluent.Padding(
                                    padding: EdgeInsets.only(left: 20.w),
                                    child: Icon(
                                      fluent.FluentIcons.text_field,
                                      color: Colors.black54,
                                      size: 13.w,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15.h, horizontal: 10.w),
                                  controller: authController
                                      .companyDescriptionController,
                                  placeholder:
                                      'eg We are a leading company in the region',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12.sp,
                                      color: Colors.black54),
                                  expands: false,
                                ),
                              ),
                              20.ph,
                              fluent.InfoLabel(
                                label: 'Enter company phone number',
                                labelStyle: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 13.sp),
                                child: fluent.TextBox(
                                  maxLength: 12,
                                  prefix: fluent.Padding(
                                    padding: EdgeInsets.only(left: 20.w),
                                    child: Icon(
                                      fluent.FluentIcons.phone,
                                      color: Colors.black54,
                                      size: 13.w,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15.h, horizontal: 10.w),
                                  controller:
                                      authController.phoneNumberController,
                                  placeholder: 'eg +256 700 000 000',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12.sp,
                                      color: Colors.black54),
                                  expands: false,
                                ),
                              ),
                              20.ph,
                              fluent.InfoLabel(
                                label: 'Enter company website',
                                labelStyle: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 13.sp),
                                child: fluent.TextBox(
                                  prefix: fluent.Padding(
                                    padding: EdgeInsets.only(left: 20.w),
                                    child: Icon(
                                      fluent.FluentIcons.globe,
                                      color: Colors.black54,
                                      size: 13.w,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15.h, horizontal: 10.w),
                                  controller:
                                      authController.companyWebsiteController,
                                  placeholder: 'eg www.acme.com',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12.sp,
                                      color: Colors.black54),
                                  expands: false,
                                ),
                              ),
                              20.ph,
                              fluent.InfoLabel(
                                label: 'Enter Password',
                                labelStyle: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 13.sp),
                                child: fluent.PasswordBox(
                                  controller: authController.passwordController,
                                  leadingIcon: fluent.Padding(
                                    padding: EdgeInsets.only(left: 20.w),
                                    child: Icon(
                                      fluent.FluentIcons.password_field,
                                      color: Colors.black54,
                                      size: 13.w,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15.h, horizontal: 20.w),
                                  placeholder: 'Password',
                                  revealMode: fluent.PasswordRevealMode.peek,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12.sp,
                                      color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                  ],
                  20.ph,
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 45.h,
                          child: fluent.Acrylic(
                            blurAmount: 40,
                            child: fluent.FilledButton(
                              child: fluent.Center(
                                  child: label(
                                text: oldUser ? 'Sign in' : 'Create Account',
                                color: Colors.white,
                                fontSize: 10.sp,
                              )),
                              onPressed: () async {
                                String? uploadedImageUrl;

                                if (!oldUser) {
                                  if (authController.artworkFile.value!.files.isNotEmpty) {
                                    for (PlatformFile file
                                        in authController.artworkFile.value!.files) {
                                      if (!kIsWeb) {
                                        File pickedFile = File(file.path!);

                                        final List<int> imageBytes =
                                            await pickedFile.readAsBytes();
                                        uploadedImageUrl =
                                            await uploadImageToImageKit(
                                                context,
                                                imageBytes,
                                                'myWaterCompanyLogos');
                                      }
                                    }
                                  }
                                }
                                AuthenticationModel authenticationModel =
                                    AuthenticationModel(
                                  logoUrl: uploadedImageUrl,
                                  role: 'advertiser',
                                  email: authController.emailController.text,
                                  password:
                                      authController.passwordController.text,
                                  phoneNumber:
                                      authController.phoneNumberController.text,
                                  companyName:
                                      authController.companyNameController.text,
                                  description: authController
                                      .companyDescriptionController.text,
                                  website: authController
                                      .companyWebsiteController.text,
                                );

                                if (oldUser) {
                                  if (authController
                                      .emailController.text.isEmpty) {
                                    ScreenOverlay.showToast(context,
                                        title: 'Missing Field',
                                        message: 'Email is required',
                                        isWarning: true);
                                  } else if (authController
                                      .passwordController.text.isEmpty) {
                                    ScreenOverlay.showToast(context,
                                        title: 'Missing Field',
                                        message: 'Password is required',
                                        isWarning: true);
                                  } else {
                                    authController.loginPartnerAccount(context,
                                        authModel: authenticationModel);
                                  }
                                } else {
                                  if (authController.artworkFile == null) {
                                    ScreenOverlay.showToast(context,
                                        title: 'Missing Field',
                                        message: 'Attach artwork',
                                        isWarning: true);
                                  } else if (authController
                                      .emailController.text.isEmpty) {
                                    ScreenOverlay.showToast(context,
                                        title: 'Missing Field',
                                        message: 'Email is required',
                                        isWarning: true);
                                  } else if (authController
                                      .companyNameController.text.isEmpty) {
                                    ScreenOverlay.showToast(context,
                                        title: 'Missing Field',
                                        message: 'Company Name is required',
                                        isWarning: true);
                                  } else if (authController
                                      .companyDescriptionController
                                      .text
                                      .isEmpty) {
                                    ScreenOverlay.showToast(context,
                                        title: 'Missing Field',
                                        message:
                                            'Company Description is required',
                                        isWarning: true);
                                  } else if (authController
                                      .phoneNumberController.text.isEmpty) {
                                    ScreenOverlay.showToast(context,
                                        title: 'Missing Field',
                                        message: 'Phone Number is required',
                                        isWarning: true);
                                  } else if (authController
                                      .companyWebsiteController.text.isEmpty) {
                                    ScreenOverlay.showToast(context,
                                        title: 'Missing Field',
                                        message: 'Company Website is required',
                                        isWarning: true);
                                  } else if (authController
                                      .passwordController.text.isEmpty) {
                                    ScreenOverlay.showToast(context,
                                        title: 'Missing Field',
                                        message: 'Password is required',
                                        isWarning: true);
                                  } else {
                                    authController.createPartnerAccount(context,
                                        authModel: authenticationModel);
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  20.ph,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      fluent.HyperlinkButton(
                        onPressed: () {
                          setState(() {
                            oldUser = !oldUser;
                          });
                        },
                        child: paragraph(
                          text: oldUser
                              ? 'Create Account'
                              : 'Already have an account?',
                          color: Colors.black,
                        ),
                      ),
                      if (oldUser) ...[
                        20.pw,
                        fluent.HyperlinkButton(
                          onPressed: () {},
                          child: paragraph(
                            text: 'Forgot Password?',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (oldUser) ...[
                    const Spacer(),
                    paragraph(
                        text: '2024 All rights reserved, MyWater Agency',
                        color: Colors.black54
                        // color: baseColor,
                        ),
                  ],
                ]),
          ),
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: const [0.1, 0.9],
                      colors: [baseColor, baseColorLight])),
              height: double.infinity,
              width: 0.5.sw,
              child: Stack(children: [
                Positioned(
                  bottom: 0,
                  right: -100,
                  left: 100.0,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(2.r),
                      child: Image.network(
                          'https://ik.imagekit.io/ecjzuksxj/man-holding-mywater-bottle.JPG?updatedAt=1703765623937',
                          width: 900.w,
                          height: 600.h,
                          fit: BoxFit.cover)),
                ),
                Positioned(
                  top: 100.h,
                  right: 100,
                  left: 100.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      label(
                        text:
                            'My Water is a pioneering Ad-Tech startup in Uganda, revolutionizing advertising solutions for companies',
                        color: Colors.white,
                        fontSize: 12.sp,
                      ),
                      20.ph,
                      paragraph(
                        text: ' - Don Casey, CEO MyWater',
                        color: Colors.white54,
                        // fontSize: 14.sp,
                      ),
                    ],
                  ),
                ),
              ])),
        ],
      ),
    );
  }
}
