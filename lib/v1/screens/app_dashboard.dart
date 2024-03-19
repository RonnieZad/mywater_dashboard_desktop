import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:mywater_dashboard_revamp/v1/constants/colors.dart';
import 'package:mywater_dashboard_revamp/v1/controller/campaign_controller.dart';
import 'package:mywater_dashboard_revamp/v1/screens/dashboard.dart';
import 'package:mywater_dashboard_revamp/v1/utils/screen_overlay.dart';
import 'package:mywater_dashboard_revamp/v1/utils/utils.dart';
import 'package:mywater_dashboard_revamp/v1/widgets/app_button.dart';
import 'package:mywater_dashboard_revamp/v1/widgets/campaign_stat_card.dart';
import 'package:mywater_dashboard_revamp/v1/widgets/create_ad_campaign.dart';
import 'package:mywater_dashboard_revamp/v1/widgets/dashboard_widgets.dart';
import 'package:mywater_dashboard_revamp/v1/widgets/screen_overlay.dart';

class DashboardOverview extends StatefulWidget {
  const DashboardOverview({super.key});

  @override
  State<DashboardOverview> createState() => DashboardOverviewState();
}

class DashboardOverviewState extends State<DashboardOverview> {
  CampaignController campaignController = Get.put(CampaignController());

  final contextController = fluent.FlyoutController();
  final contextAttachKey = GlobalKey();
  Color? selectedDistrict;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyR):
              const RefreshPageIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            RefreshPageIntent: RefreshPageAction(campaignController, context),
          },
          child: Focus(
            autofocus: true,
            child: Container(
              padding: EdgeInsets.only(top: 20.h, right: 20.0, left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: fluent.TextBox(
                          suffix: fluent.Padding(
                            padding: EdgeInsets.only(right: 20.w),
                            child: Icon(
                              fluent.FluentIcons.search,
                              color: Colors.black54,
                              size: 13.w,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 15.h, horizontal: 10.w),
                          placeholder:
                              'Search anything like campaign id, name, etc.',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12.sp,
                              color: Colors.black54),
                          expands: false,
                        ),
                      ),
                      const Spacer(),
                      AppButton(
                        buttonLabel: 'Create Campaign',
                        action: () {
                          ScreenAppOverlay.showAppDialogWindow(context,
                              body: const CreateCampaign());
                        },
                      ),
                      10.pw,
                      IconButton(
                          onPressed: () {
                            ScreenOverlay.showToast(context,
                                title: 'No new notifications',
                                message: 'There are no notifications',
                                isWarning: true);
                          },
                          icon: const Icon(fluent.FluentIcons.ringer_active,
                              size: 28))
                    ],
                  ),
                  35.ph,
                  Row(
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            headingBig(text: 'Welcome back!'),
                            6.ph,
                            paragraphSmallItalic(
                                text:
                                    'Here\'s an overview summary of your campaign performance.',
                                color: Colors.grey),
                          ]),
                    ],
                  ),
                  40.ph,
                  Expanded(
                    child: PageView(
                      scrollDirection: Axis.vertical,
                      children: [
                        Column(
                          children: [
                            Row(
                                children: campaignController.campaigns
                                    .map(
                                      (campaign) => StatCard(
                                        pad: (campaignController.campaigns
                                                        .indexOf(campaign) ==
                                                    0 &&
                                                campaignController
                                                        .campaigns.length >
                                                    1)
                                            ? true
                                            : (campaignController.campaigns
                                                            .indexOf(campaign) +
                                                        1 ==
                                                    campaignController
                                                        .campaigns.length)
                                                ? false
                                                : true,
                                        advertId: campaign.advertId!,
                                        pictureUrl: campaign.pictureUrl,
                                        iconData: fluent.FluentIcons.home,
                                        capacity: campaign.scanCount!,
                                        color: campaignPlotColors[
                                            campaignController.campaigns
                                                .indexOf(campaign)],
                                        percentage: 98,
                                        title: campaign.promotionText,
                                        description:
                                            campaign.promotionDescription,
                                      ),
                                    )
                                    .toList()),
                            15.ph,
                            Expanded(
                              child: Row(
                                children: [
                                  const LineChartSeries(),
                                  10.pw,
                                  ReachHotspotMap(
                                      contextController: contextController,
                                      contextAttachKey: contextAttachKey,
                                      context: context),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
