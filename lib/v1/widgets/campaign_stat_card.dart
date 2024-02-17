import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mywater_dashboard_revamp/v1/constants/colors.dart';
import 'package:mywater_dashboard_revamp/v1/screens/company_profile.dart';
import 'package:mywater_dashboard_revamp/v1/utils/extensions.dart';
import 'package:mywater_dashboard_revamp/v1/utils/screen_overlay.dart';
import 'package:mywater_dashboard_revamp/v1/utils/typography.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:mywater_dashboard_revamp/v1/widgets/ui_helpers.dart';
import 'package:octo_image/octo_image.dart';
import 'package:qr_flutter/qr_flutter.dart';

class StatCard extends StatelessWidget {
  const StatCard(
      {Key? key,
      this.capacityPrefix,
      required this.iconData,
      required this.capacity,
      required this.title,
      required this.color,
      required this.percentage,
      required this.description,
      required this.pictureUrl,
      required this.advertId,
      required this.pad})
      : super(key: key);
  final IconData iconData;
  final int capacity;
  final int percentage;
  final String title;
  final String? capacityPrefix;
  final String description;
  final String pictureUrl;
  final Color color;
  final String advertId;
  final pad;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> profileData = GetStorage().read('partnerData');

    return Expanded(
      child: InkWell(
        onTap: () {
          fluent.showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return Dialog(
                  insetPadding:
                      EdgeInsets.symmetric(horizontal: 150.w, vertical: 20.h),
                  child: fluent.Padding(
                    padding: EdgeInsets.all(18.w),
                    child: SizedBox(
                      width: 600.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          heading(text: title, color: baseColor),
                          10.ph,
                          paragraph(text: description, color: Colors.black54),
                          20.ph,
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5.h, horizontal: 5.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2.r),
                                  border: Border.all(
                                      color: baseColorLight, width: 0.5),
                                ),
                                child: paragraph(text: 'Active'),
                              ),
                              2.pw,
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5.h, horizontal: 5.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2.r),
                                  border: Border.all(
                                      color: baseColorLight, width: 0.5),
                                ),
                                child: paragraph(text: '$capacity Scans'),
                              ),
                              2.pw,
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5.h, horizontal: 5.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2.r),
                                  border: Border.all(
                                      color: baseColorLight, width: 0.5),
                                ),
                                child: paragraph(text: '2024-01-31 06:03'),
                              ),
                            ],
                          ),
                          20.ph,
                          Row(mainAxisSize: MainAxisSize.min, children: [
                            paragraph(
                                text:
                                    'https://app.mywater.agency/?code=$advertId',
                                fontSize: 9.sp,
                                color: baseColor),
                            10.pw,
                            fluent.Button(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text:
                                        'https://app.mywater.agency/?code=$advertId'));
                                ScreenOverlay.showToast(context,
                                    title: 'Successful',
                                    message: 'Link copied to clipboard');
                              },
                              child: fluent.Row(
                                children: [
                                  paragraph(text: 'Copy Link'),
                                  2.pw,
                                  Icon(
                                    fluent.FluentIcons.link,
                                    color: baseColor,
                                    size: 15.w,
                                  )
                                ],
                              ),
                            ),
                          ]),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: QrImageView(
                                gapless: false,
                                dataModuleStyle: const QrDataModuleStyle(
                                    dataModuleShape: QrDataModuleShape.circle),
                                eyeStyle: const QrEyeStyle(
                                    eyeShape: QrEyeShape.circle),
                                foregroundColor: baseColor,
                                data:
                                    'https://app.mywater.agency/?code=$advertId',
                                // embeddedImage: CachedNetworkImageProvider(
                                //     profileData['company_logo'],
                                //     maxWidth: 40,
                                //     maxHeight: 40
                                //     ),
                                size: 140.w),
                          ),
                          20.ph,
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: SizedBox(
                              width: 600.w,
                              height: 400.h,
                              child: OctoImage(
                                placeholderBuilder: OctoBlurHashFix.placeHolder(
                                    'LEHV6nWB2yk8pyo0adR*.7kCMdnj'),
                                errorBuilder: OctoError.icon(color: Colors.red),
                                image: CachedNetworkImageProvider(
                                  pictureUrl,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          20.ph,
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                    width: 150.w,
                                    height: 45.h,
                                    child: fluent.FilledButton(
                                        style: fluent.ButtonStyle(
                                          backgroundColor:
                                              fluent.ButtonState.all(
                                                  Colors.black),
                                        ),
                                        child: fluent.Center(
                                            child: label(
                                          text: 'Close',
                                          color: Colors.white,
                                          fontSize: 10.sp,
                                        )),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        })),
                              ),
                              10.pw,
                              Expanded(
                                child: SizedBox(
                                    width: 150.w,
                                    height: 45.h,
                                    child: fluent.FilledButton(
                                        child: fluent.Center(
                                            child: label(
                                          text: 'Edit',
                                          color: Colors.white,
                                          fontSize: 10.sp,
                                        )),
                                        onPressed: () {})),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
        child: Padding(
          padding: EdgeInsets.only(right: pad ? 4.w : 0),
          child: Material(
            elevation: 10.0,
            shadowColor: Colors.black26,
            borderRadius: BorderRadius.circular(6.r),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
              decoration: BoxDecoration(
                  border: Border.all(color: baseColorLight, width: 0.4),
                  borderRadius: BorderRadius.circular(6.r),
                  color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      paragraphBold(text: title, color: color),
                    ],
                  ),
                  6.ph,
                  paragraph(text: description, color: Colors.black38),
                  10.ph,
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 5.h,
                          decoration: BoxDecoration(
                              color: baseColorLight,
                              borderRadius: BorderRadius.circular(5.r)),
                          child: Row(
                            children: [
                              Expanded(
                                flex: percentage,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(5.r)),
                                ),
                              ),
                              Expanded(
                                flex: 100 - percentage,
                                child: Container(),
                              )
                            ],
                          ),
                        ),
                      ),
                      10.pw,
                      paragraph(text: '$percentage%', color: Colors.black38)
                    ],
                  ),
                  10.ph,
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 5.h, horizontal: 5.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.r),
                          border: Border.all(color: baseColorLight, width: 0.5),
                        ),
                        child: paragraph(text: 'Active'),
                      ),
                      2.pw,
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 5.h, horizontal: 5.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.r),
                          border: Border.all(color: baseColorLight, width: 0.5),
                        ),
                        child: paragraph(text: '$capacity Scans'),
                      ),
                      const Spacer(),
                      paragraph(text: 'View Details', color: baseColor),
                      5.pw,
                      Icon(
                        fluent.FluentIcons.chevron_down,
                        color: baseColor,
                        size: 15.w,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
