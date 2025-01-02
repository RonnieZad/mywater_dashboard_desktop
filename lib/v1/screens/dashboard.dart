import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mywater_dashboard_revamp/v1/constants/colors.dart';
import 'package:mywater_dashboard_revamp/v1/controller/campaign_controller.dart';
import 'package:mywater_dashboard_revamp/v1/screens/app_dashboard.dart';
import 'package:mywater_dashboard_revamp/v1/screens/company_profile.dart';

import 'package:mywater_dashboard_revamp/v1/utils/screen_overlay.dart';
import 'package:mywater_dashboard_revamp/v1/utils/utils.dart';

class RefreshPageIntent extends Intent {
  const RefreshPageIntent();
}

class RefreshPageAction extends Action<RefreshPageIntent> {
  RefreshPageAction(this.controller, this.context);
  CampaignController controller;
  BuildContext context;

  @override
  void invoke(covariant RefreshPageIntent intent) {
    // controller.getCampaignMetrics();
    ScreenOverlay.showToast(context, title: 'Data refreshed', message: 'Showing the most recent records');
  }
}

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
    super.initState();
  }

  List<fluent.NavigationPaneItem> items = [
    fluent.PaneItemSeparator(),
    fluent.PaneItem(
      icon: const Icon(fluent.FluentIcons.power_b_i_logo, size: 18),
      title: AppTypography.titleMedium(text: 'Summary'),
      body: const DashboardOverview(),
    ),
    fluent.PaneItem(
      icon: const Icon(fluent.FluentIcons.chart, size: 18),
      title: AppTypography.titleMedium(text: 'Reports'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(fluent.FluentIcons.blocked2, size: 50, color: baseColor), 20.ph, AppTypography.bodyMedium(text: 'Your reports and analytics will appear here', color: Colors.black54)],
      ),
    ),
    fluent.PaneItem(
      icon: const Icon(fluent.FluentIcons.info, size: 18),
      title: AppTypography.titleMedium(
        text: 'Profile',
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
          displayMode: isPaneOpen ? fluent.PaneDisplayMode.compact : fluent.PaneDisplayMode.open,
          size: const fluent.NavigationPaneSize(openMinWidth: 100, openMaxWidth: 220),
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
              width: 160,
            ),
          ),
          selected: topIndex,
          onChanged: (index) => setState(() => topIndex = index),
          items: items,
          footerItems: [
            fluent.PaneItemAction(
              icon: const Icon(fluent.FluentIcons.power_button, size: 18),
              title: AppTypography.titleMedium(
                text: 'Log out',
                color: Colors.red[300],
              ),
              onTap: () {
                fluent.showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return fluent.ContentDialog(
                        title: AppTypography.titleLarge(text: 'Log out'),
                        content: AppTypography.titleSmall(text: 'Are you sure you want to log out?'),
                        actions: [
                          fluent.Button(
                            onPressed: () {
                              GetStorage().erase();
                              Phoenix.rebirth(context);
                              Navigator.pop(context);
                            },
                            child: AppTypography.labelLarge(text: 'Yes'),
                          ),
                          fluent.Button(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: AppTypography.labelLarge(text: 'No'),
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
                      child: AppTypography.bodyMedium(
                        text: 'Version 1.0.2+2',
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
