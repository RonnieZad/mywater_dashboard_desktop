import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:mywater_dashboard_revamp/v1/constants/colors.dart';
import 'package:mywater_dashboard_revamp/v1/utils/utils.dart';
import 'package:mywater_dashboard_revamp/v1/widgets/ui_helpers.dart';
import 'package:octo_image/octo_image.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyProfile extends StatefulWidget {
  const CompanyProfile({super.key});

  @override
  State<CompanyProfile> createState() => CompanyProfileState();
}

class CompanyProfileState extends State<CompanyProfile> {
  Map<String, dynamic> profileData = GetStorage().read('partnerData');

  final contextController = fluent.FlyoutController();
  final contextAttachKey = GlobalKey();
  Color? selectedDistrict;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin:
              EdgeInsets.only( left: 20.w, right: 20.0),  
          padding:
              EdgeInsets.only(bottom: 20.h, top: 20.h, left: 20.w, right: 20.0),
          decoration:  BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(6.r), bottomRight: Radius.circular(6.r))
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipOval(
                    child: SizedBox(
                      height: 140.w,
                      width: 140.w,
                      child: OctoImage(
                        placeholderBuilder: OctoBlurHashFix.placeHolder(
                            'LEHV6nWB2yk8pyo0adR*.7kCMdnj'),
                        errorBuilder: OctoError.icon(color: Colors.red),
                        image: CachedNetworkImageProvider(
                          profileData['company_logo'],
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              20.pw,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  subHeading(
                      text: '${profileData['company_name']}', fontSize: 35.sp),
                  10.ph,
                  paragraphSmall(
                      text: 'Website: ${profileData['company_website']}',
                      color: Colors.grey),
                  20.ph,
                ],
              )
            ],
          ),
        ),
        10.ph,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Material(
                  elevation: 10.0,
                  shadowColor: Colors.black26,
                  borderRadius: BorderRadius.circular(6.r),
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: 20.h, top: 20.h, left: 20.w, right: 20.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: baseColorLight, width: 0.4),
                        borderRadius: BorderRadius.circular(6.r),
                        color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                subHeading(
                                    text: 'Company Profile', fontSize: 16.sp),
                                6.ph,
                                paragraphSmallItalic(
                                    text:
                                        'Manage information about your business.',
                                    color: Colors.grey),
                              ],
                            ),
                            fluent.Button(
                              child: label(text: 'Edit Profile'),
                              onPressed: () => debugPrint('pressed button'),
                            )
                          ],
                        ),
                        20.ph,
                        subHeading(text: 'DESCRIPTION'),
                        10.ph,
                        paragraphSmall(
                            text: profileData['company_description'],
                            color: Colors.grey),
                        10.ph,
                        20.ph,
                        subHeading(text: 'CONTACT'),
                        10.ph,
                        paragraphSmallItalic(
                            text: 'Email: ${profileData['company_email']}'),
                        10.ph,
                        paragraphSmallItalic(
                            text: 'Website: ${profileData['company_website']}'),
                        10.ph,
                        paragraphSmallItalic(
                            text: 'Phone: +${profileData['company_phone']}'),
                        40.ph,
                        SizedBox(
                          height: 45.h,
                          child: fluent.FilledButton(
                            child: fluent.Center(
                                child: label(
                              text: 'Get Support',
                              color: Colors.white,
                              fontSize: 10.sp,
                            )),
                            onPressed: () {
                              final Uri emailLaunchUri = Uri(
                                scheme: 'mailto',
                                path: 'info@mywater.agency',
                              );
                              launchUrl(emailLaunchUri);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              10.pw,
              Expanded(
                child: Material(
                  elevation: 10.0,
                  shadowColor: Colors.black26,
                  borderRadius: BorderRadius.circular(6.r),
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: 20.h, top: 20.h, left: 20.w, right: 20.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: baseColorLight, width: 0.4),
                        borderRadius: BorderRadius.circular(6.r),
                        color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  subHeading(
                                      text: 'Team Members', fontSize: 16.sp),
                                  6.ph,
                                  paragraphSmallItalic(
                                      text:
                                          'This is a list of team members you have set up and invited',
                                      color: Colors.grey),
                                ],
                              ),
                            ),
                            fluent.Button(
                              child: label(text: 'Manage'),
                              onPressed: () => debugPrint('pressed button'),
                            )
                          ],
                        ),
                        60.ph,
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(fluent.FluentIcons.blocked2,
                                  size: 30.w, color: baseColor),
                              20.ph,
                              paragraph(
                                  text:
                                      'Your collaborating team members will\nappear here',
                                  color: Colors.black38,
                                  textAlign:TextAlign.center
                                  )
                            ],
                          ),
                        ),
                        60.ph,
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
