import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

import 'package:intl/intl.dart';

import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:mywater_dashboard_revamp/v1/constants/colors.dart';
import 'package:mywater_dashboard_revamp/v1/controller/campaign_controller.dart';
import 'package:mywater_dashboard_revamp/v1/screens/app_dashboard.dart';
import 'package:mywater_dashboard_revamp/v1/utils/screen_overlay.dart';
import 'package:mywater_dashboard_revamp/v1/utils/utils.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final PageController _menuPageController = PageController();
  

  // PropertyController propertyController = Get.put(PropertyController());
  // RoommateApplcationController roommateApplcationController =
  //     Get.put(RoommateApplcationController());
  // LandlordInviteController landlordInviteController =
  //     Get.put(LandlordInviteController());
  // RentFinanceApplicationController rentFinanceApplicationController =
  //     Get.put(RentFinanceApplicationController());
  // UserController userController = Get.put(UserController());
  // PaymentController paymentController = Get.put(PaymentController());

  List<fluent.NavigationPaneItem> items = [
    fluent.PaneItemSeparator(),
    fluent.PaneItem(
      icon: const Icon(fluent.FluentIcons.power_b_i_logo, size: 18),
      title: Text(
        'Summary',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12.sp,
          fontWeight: FontWeight.w300,
        ),
      ),
      body: DashboardOverview(),
    ),

    fluent.PaneItem(
      icon: const Icon(fluent.FluentIcons.presentation, size: 18),
      title: Text(
        'Campaigns',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12.sp,
          fontWeight: FontWeight.w300,
        ),
      ),
      body: SizedBox.shrink(),
    ),
    fluent.PaneItem(
      icon: const Icon(fluent.FluentIcons.chart, size: 18),
      title: Text(
        'Reports',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12.sp,
          fontWeight: FontWeight.w300,
        ),
      ),
      body: SizedBox.shrink(),
    ),
    // fluent.PaneItem(
    //   icon: const Icon(fluent.FluentIcons.people_alert, size: 18),
    //   title: Text(
    //     'Roommate Host',
    //     style: TextStyle(
    //       fontFamily: 'Poppins',
    //       fontSize: 12.sp,
    //       fontWeight: FontWeight.w300,
    //     ),
    //   ),
    //   body: RoommateApplication(),
    // ),
    // fluent.PaneItem(
    //   icon: const Icon(fluent.FluentIcons.people, size: 18),
    //   title: Text(
    //     'Landlord Invites',
    //     style: TextStyle(
    //       fontFamily: 'Poppins',
    //       fontSize: 12.sp,
    //       fontWeight: FontWeight.w300,
    //     ),
    //   ),
    //   body: LanlordInvites(),
    // ),
    // fluent.PaneItem(
    //   icon: const Icon(fluent.FluentIcons.trigger_user, size: 18),
    //   title: Text(
    //     'Maintenance',
    //     style: TextStyle(
    //       fontFamily: 'Poppins',
    //       fontSize: 12.sp,
    //       fontWeight: FontWeight.w300,
    //     ),
    //   ),
    //   body: MaintenanceApplication(),
    // ),
    // fluent.PaneItem(
    //   icon: const Icon(fluent.FluentIcons.money, size: 18),
    //   title: Text(
    //     'Rent Financing',
    //     style: TextStyle(
    //       fontFamily: 'Poppins',
    //       fontSize: 12.sp,
    //       fontWeight: FontWeight.w300,
    //     ),
    //   ),
    //   body: RentFinanceApplication(),
    // ),
    // fluent.PaneItem(
    //   icon: const Icon(fluent.FluentIcons.group, size: 18),
    //   title: Text(
    //     'Users',
    //     style: TextStyle(
    //       fontFamily: 'Poppins',
    //       fontSize: 12.sp,
    //       fontWeight: FontWeight.w300,
    //     ),
    //   ),
    //   body: Users(),
    // ),
    // fluent.PaneItem(
    //   icon: const Icon(fluent.FluentIcons.financial, size: 18),
    //   title: Text(
    //     'Transactions',
    //     style: TextStyle(
    //       fontFamily: 'Poppins',
    //       fontSize: 12.sp,
    //       fontWeight: FontWeight.w300,
    //     ),
    //   ),
    //   body: Transactions(),
    // ),

    // fluent.PaneItemSeparator(),
  ];
  final pageStorageBucket = PageStorageBucket();
  int topIndex = 0;
  bool isPaneOpen = false;
  @override
  Widget build(BuildContext context) {
    return PageStorage(
      bucket: pageStorageBucket,
      child: fluent.NavigationView(
        appBar: const fluent.NavigationAppBar(leading: SizedBox.shrink()),
        pane: fluent.NavigationPane(
          displayMode: isPaneOpen
              ? fluent.PaneDisplayMode.compact
              : fluent.PaneDisplayMode.open,
          size: const fluent.NavigationPaneSize(
              openMinWidth: 100, openMaxWidth: 260
              // width: 200,
              ),
          menuButton: fluent.Padding(
            padding: const EdgeInsets.only(bottom: 90.0),
            child: IconButton(
              icon: const Icon(fluent.FluentIcons.list),
              onPressed: () {
                setState(() {
                  isPaneOpen = !isPaneOpen;
                });
              },
            ),
          ),
          header: fluent.Padding(
            padding: const EdgeInsets.only(bottom: 90.0),
            child: SvgPicture.asset(
              'assets/images/app_logo.svg',
              width: 120.w,
            ),
          ),

          selected: topIndex,
          onChanged: (index) => setState(() => topIndex = index),
          // displayMode: displayMode,
          items: items,
          footerItems: [
            // fluent.PaneItem(
            //   icon: const Icon(fluent.FluentIcons.settings, size: 18),
            //   title: Text(
            //     'Settings',
            //     style: TextStyle(
            //       fontFamily: 'Poppins',
            //       fontSize: 12.sp,
            //       fontWeight: FontWeight.w300,
            //     ),
            //   ),
            //   body: DashboardOverview(),
            // ),
            fluent.PaneItemAction(
              icon: const Icon(fluent.FluentIcons.power_button, size: 18),
              title: Text(
                'Log out',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w300,
                ),
              ),
              onTap: () {
                GetStorage().erase();
                Phoenix.rebirth(context);
              },
            ),
            fluent.PaneItemSeparator(),
            isPaneOpen
                ? fluent.PaneItemHeader(
                    header: SizedBox.shrink(),
                  )
                : fluent.PaneItemHeader(
                    header: fluent.Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Text(
                        'Version 1.0.2+2',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class TargetWidget extends StatelessWidget {
  const TargetWidget({
    Key? key,
    required this.category,
    required this.target,
    required this.percentage,
  }) : super(key: key);
  final String category;
  final String target;
  final int percentage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            paragraphSmallItalic(text: category, color: Colors.black),
            const Spacer(),
            paragraph(text: '$percentage% of goal reached', color: Colors.grey),
            15.pw
          ],
        ),
        10.ph,
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 13.h,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.w),
          ),
          child: Slider(
              min: 0,
              max: 100.0,
              value: percentage.toDouble(),
              inactiveColor: const Color.fromARGB(92, 188, 218, 220),
              activeColor: baseColor,
              onChanged: (value) {}),
        ),
        Row(
          children: [
            const Spacer(),
            paragraph(text: 'Target $target', color: Colors.grey),
            15.pw
          ],
        )
      ],
    );
  }
}

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
      required this.pad
      })
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
    print(pad);
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        heading(text: title, color: baseColor),
                        10.ph,
                        paragraph(
                            text:
                                description,
                            color: Colors.black54),
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
                              text: 'https://app.mywater.agency/$advertId',
                              fontSize: 9.sp,
                              color: baseColor),
                          10.pw,
                          fluent.Button(
                          onPressed: (){
                            Clipboard.setData(ClipboardData(text: 'https://app.mywater.agency/$advertId'));
                             ScreenOverlay.showToast(context, title: 'Successful', message: 'Link copied to clipboard');
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
                              eyeStyle:
                                  const QrEyeStyle(eyeShape: QrEyeShape.circle),
                              foregroundColor: baseColor,
                              
                              data:
                                  'https://app.mywater.agency/$advertId',
                              size: 110.w),
                        ),
                        Image.network(
                          pictureUrl,
                          width: 600.w,
                          height: 400.h,
                        ),
                        
                      ],
                    ),
                  ),
                );
              });
        },
        child: Padding(
          padding: EdgeInsets.only( right: pad ? 4.w : 0),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row(
                          //   children: [
                          //     capacityPrefix != null
                          //         ? Row(
                          //             children: [
                          //               label(
                          //                   text: capacityPrefix!,
                          //                   fontSize: 12.sp),
                          //               5.pw,
                          //             ],
                          //           )
                          //         : const SizedBox.shrink(),
                          //     headingBig(
                          //         text: NumberFormat.decimalPattern()
                          //             .format(capacity)),
                          //   ],
                          // ),
                          paragraphBold(text: title, color: color),
                        ],
                      ),
                      // Icon(
                      //   iconData,
                      //   color: baseColorLight,
                      //   size: 25.w,
                      // )
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
                        padding:
                            EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.r),
                          border: Border.all(color: baseColorLight, width: 0.5),
                        ),
                        child: paragraph(text: 'Active'),
                      ),
                      2.pw,
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.r),
                          border: Border.all(color: baseColorLight, width: 0.5),
                        ),
                        child: paragraph(text: '$capacity Scans'),
                      ),
                      Spacer(),
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

// class MenuWidget extends StatelessWidget {
//   const MenuWidget(
//       {Key? key,
//       this.isSelected = false,
//       required this.title,
//       required this.iconData,
//       required this.action})
//       : super(key: key);
//   final String title;
//   final IconData iconData;
//   final VoidCallback action;
//   final bool? isSelected;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8.h),
//       child: InkWell(
//         onTap: action,
//         child: Container(
//           padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 5.w),
//           decoration: BoxDecoration(
//               color: isSelected == true ? Colors.white24 : Colors.transparent,
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(5.r),
//                   bottomLeft: Radius.circular(5.r))),
//           child: Row(
//             // mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 iconData,
//                 color: Colors.white,
//                 size: 15.w,
//               ),
//               4.pw,
//               paragraphSmall(text: title, color: Colors.white)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
