import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get_storage/get_storage.dart';

import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:mywater_dashboard_revamp/v1/constants/colors.dart';
import 'package:mywater_dashboard_revamp/v1/constants/strings.dart';

import 'package:mywater_dashboard_revamp/v1/screens/app_dashboard.dart';
import 'package:mywater_dashboard_revamp/v1/screens/company_profile.dart';
import 'package:mywater_dashboard_revamp/v1/services/websocket_service.dart';
import 'package:mywater_dashboard_revamp/v1/utils/utils.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final pageStorageBucket = PageStorageBucket();
  int topIndex = 0;
  bool isPaneOpen = false;

  @override
  void initState() {
    WebSocketService.initiateAndListenConnection(context, socketServiceUrl);
    super.initState();
  }

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
      body: const DashboardOverview(),
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
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(fluent.FluentIcons.blocked2, size: 50.w, color: baseColor),
            20.ph,
            paragraph(
                text: 'Your reports and analytics will appear here',
                color: Colors.black54)
          ],
        ),
      ),
    ),
    fluent.PaneItem(
      icon: const Icon(fluent.FluentIcons.info, size: 18),
      title: Text(
        'Profile',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12.sp,
          fontWeight: FontWeight.w300,
        ),
      ),
      body: const CompanyProfile(),
    ),
    fluent.PaneItemSeparator(),
  ];

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
          items: items,
          footerItems: [
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
                fluent.showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return fluent.ContentDialog(
                        title: heading(text: 'Log out'),
                        content: paragraph(
                            text: 'Are you sure you want to log out?'),
                        actions: [
                          fluent.Button(
                            onPressed: () {
                              GetStorage().erase();
                              Phoenix.rebirth(context);
                              Navigator.pop(context);
                            },
                            child: label(text: 'Yes'),
                          ),
                          fluent.Button(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: label(text: 'No'),
                          ),
                        ],
                      );
                    });
              },
            ),
            fluent.PaneItemSeparator(),
            isPaneOpen
                ? fluent.PaneItemHeader(
                    header: const SizedBox.shrink(),
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
