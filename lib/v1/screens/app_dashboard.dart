import 'dart:ffi';
import 'dart:io';

import 'package:countries_world_map/countries_world_map.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:get_storage/get_storage.dart';
import 'package:mywater_dashboard_revamp/v1/constants/colors.dart';
import 'package:mywater_dashboard_revamp/v1/controller/campaign_controller.dart';
import 'package:mywater_dashboard_revamp/v1/models/campaign_model.dart';
import 'package:mywater_dashboard_revamp/v1/screens/dashboard.dart';
import 'package:mywater_dashboard_revamp/v1/utils/file_picker.dart';
import 'package:mywater_dashboard_revamp/v1/utils/screen_overlay.dart';
import 'package:mywater_dashboard_revamp/v1/utils/utils.dart';
import 'package:mywater_dashboard_revamp/v1/widgets/charts.dart';

class DashboardOverview extends StatefulWidget {
  const DashboardOverview({super.key});

  @override
  State<DashboardOverview> createState() => DashboardOverviewState();
}

class DashboardOverviewState extends State<DashboardOverview> {
  // PropertyController propertyController = Get.put(PropertyController());
  CampaignController campaignController = Get.put(CampaignController());

  final contextController = fluent.FlyoutController();
  final contextAttachKey = GlobalKey();
  Color? selectedDistrict;

  final List<Color> campaignPlotColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.yellow,
    Colors.pink,
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
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
                    padding:
                        EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                    placeholder: 'Search anything like campaign id, name, etc.',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12.sp,
                        color: Colors.black54),
                    expands: false,
                  ),
                ),
                const Spacer(),
                SizedBox(
                    width: 150.w,
                    height: 45.h,
                    child: fluent.Acrylic(
                        blurAmount: 40,
                        child: fluent.FilledButton(
                            child: fluent.Center(
                                child: label(
                              text: 'Create Campaign',
                              color: Colors.white,
                              fontSize: 10.sp,
                            )),
                            onPressed: () {
                              fluent.showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) {
                                    return Obx(() {
                                      return Dialog(
                                        insetPadding: EdgeInsets.symmetric(
                                            horizontal: 100.w, vertical: 20.h),
                                        child: fluent.Padding(
                                          padding: EdgeInsets.all(18.w),
                                          child: SizedBox(
                                            width: 500.w,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                heading(
                                                    text:
                                                        'Create New Ad Campaign',
                                                    color: baseColor),
                                                10.ph,
                                                paragraph(
                                                    text:
                                                        'Submit campaign artwork to MyWater to create an ad',
                                                    color: Colors.black54),
                                                30.ph,
                                                if (campaignController
                                                    .artworkFile
                                                    .value!
                                                    .files
                                                    .isNotEmpty) ...[
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Image.file(
                                                            File(
                                                                campaignController
                                                                    .artworkFile
                                                                    .value!
                                                                    .files
                                                                    .first
                                                                    .path!),
                                                            height: 280.h,
                                                            fit: BoxFit.cover),
                                                      ),
                                                    ],
                                                  ),
                                                  20.ph,
                                                ],
                                                SizedBox(
                                                  height: 45.h,
                                                  child: fluent.Button(
                                                    child: fluent.Center(
                                                        child: label(
                                                      text: 'Upload Artwork',
                                                      color: Colors.black54,
                                                      fontSize: 11.sp,
                                                    )),
                                                    onPressed: () async {
                                                      campaignController
                                                              .artworkFile
                                                              .value =
                                                          await FilePicker
                                                              .platform
                                                              .pickFiles();
                                                      setState(() {});
                                                    },
                                                  ),
                                                ),
                                                20.ph,
                                                fluent.InfoLabel(
                                                  label: 'Promotion Title',
                                                  labelStyle: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 13.sp),
                                                  child: fluent.TextBox(
                                                    prefix: fluent.Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 20.w),
                                                      child: Icon(
                                                        fluent.FluentIcons
                                                            .text_field,
                                                        color: Colors.black54,
                                                        size: 13.w,
                                                      ),
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 15.h,
                                                            horizontal: 10.w),
                                                    controller: campaignController
                                                        .campaignTitleController,
                                                    placeholder:
                                                        'eg App download Promotion',
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 11.sp,
                                                        color: Colors.black54),
                                                    expands: false,
                                                  ),
                                                ),
                                                20.ph,
                                                fluent.InfoLabel(
                                                  label:
                                                      'Promotion Description',
                                                  labelStyle: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 13.sp),
                                                  child: fluent.TextBox(
                                                    prefix: fluent.Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 20.w),
                                                      child: Icon(
                                                        fluent.FluentIcons
                                                            .text_field,
                                                        color: Colors.black54,
                                                        size: 13.w,
                                                      ),
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 15.h,
                                                            horizontal: 10.w),
                                                    controller: campaignController
                                                        .campaignDescriptionController,
                                                    placeholder:
                                                        'eg Get 10% off on your first purchase',
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 11.sp,
                                                        color: Colors.black54),
                                                    expands: false,
                                                  ),
                                                ),
                                                20.ph,
                                                Row(
                                                  children: [
                                                    fluent.DatePicker(
                                                      header:
                                                          'Campaign Start Date',
                                                      headerStyle: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 13.sp),
                                                      startDate: DateTime.now(),
                                                      selected:
                                                          campaignController
                                                              .campaignStartDate,
                                                      onChanged: (time) =>
                                                          setState(() =>
                                                              campaignController
                                                                      .campaignStartDate =
                                                                  time),
                                                    ),
                                                    const Spacer(),
                                                    fluent.DatePicker(
                                                      header:
                                                          'Campaign End Date',
                                                      headerStyle: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 13.sp),
                                                      selected:
                                                          campaignController
                                                              .campaignEndDate,
                                                      onChanged: (time) =>
                                                          setState(() =>
                                                              campaignController
                                                                      .campaignStartDate =
                                                                  time),
                                                    ),
                                                  ],
                                                ),
                                                50.ph,
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: SizedBox(
                                                        height: 45.h,
                                                        child: fluent.Acrylic(
                                                          blurAmount: 40,
                                                          child: fluent
                                                              .FilledButton(
                                                            child:
                                                                fluent.Center(
                                                                    child:
                                                                        label(
                                                              text:
                                                                  'Submit Campaign',
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10.sp,
                                                            )),
                                                            onPressed:
                                                                () async {
                                                              String?
                                                                  uploadedImageUrl;

                                                              if (campaignController
                                                                  .artworkFile
                                                                  .value!
                                                                  .files
                                                                  .isNotEmpty) {
                                                                for (PlatformFile file
                                                                    in campaignController
                                                                        .artworkFile
                                                                        .value!
                                                                        .files) {
                                                                  if (!kIsWeb) {
                                                                    File
                                                                        pickedFile =
                                                                        File(file
                                                                            .path!);

                                                                    final List<
                                                                            int>
                                                                        imageBytes =
                                                                        await pickedFile
                                                                            .readAsBytes();
                                                                    uploadedImageUrl = await uploadImageToImageKit(
                                                                        context,
                                                                        imageBytes,
                                                                        'myWaterCampaignArtwork');
                                                                  }
                                                                }
                                                              }

                                                              if (campaignController
                                                                      .artworkFile ==
                                                                  null) {
                                                                ScreenOverlay.showToast(
                                                                    context,
                                                                    title:
                                                                        'Missing Field',
                                                                    message:
                                                                        'Attach artwork',
                                                                    isWarning:
                                                                        true);
                                                              } else if (campaignController
                                                                  .campaignTitleController
                                                                  .text
                                                                  .isEmpty) {
                                                                ScreenOverlay.showToast(
                                                                    context,
                                                                    title:
                                                                        'Missing Field',
                                                                    message:
                                                                        'Fill in title',
                                                                    isWarning:
                                                                        true);
                                                              } else if (campaignController
                                                                  .campaignDescriptionController
                                                                  .text
                                                                  .isEmpty) {
                                                                ScreenOverlay.showToast(
                                                                    context,
                                                                    title:
                                                                        'Missing Field',
                                                                    message:
                                                                        'Fill in description',
                                                                    isWarning:
                                                                        true);
                                                              } else {
                                                                CampaignModel
                                                                    campaignModel =
                                                                    CampaignModel(
                                                                  advertiserId:
                                                                      GetStorage()
                                                                          .read(
                                                                              'partnerId'),
                                                                  promotionText:
                                                                      campaignController
                                                                          .campaignTitleController
                                                                          .text,
                                                                  promotionDescription:
                                                                      campaignController
                                                                          .campaignDescriptionController
                                                                          .text,
                                                                  pictureUrl:
                                                                      uploadedImageUrl!,
                                                                );
                                                                campaignController
                                                                    .createCampaign(
                                                                        context,
                                                                        campaignModel:
                                                                            campaignModel)
                                                                    .then(
                                                                        (callback) {
                                                                  Navigator.pop(
                                                                      context);
                                                                });
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                                  });
                            }))),
                10.pw,
                IconButton(
                    onPressed: () {},
                    icon:
                        const Icon(fluent.FluentIcons.ringer_active, size: 28))
              ],
            ),
            35.ph,
            Row(
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  headingBig(text: 'Welcome back!'),
                  6.ph,
                  paragraphSmallItalic(
                      text:
                          'Here\'s an overview summary of your campaign performance.',
                      color: Colors.grey),
                ]),
                const Spacer(),
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
                                          campaignController.campaigns.length >
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
                                  color: campaignPlotColors[campaignController
                                      .campaigns
                                      .indexOf(campaign)],
                                  percentage: 98,
                                  title: campaign.promotionText,
                                  description: campaign.promotionDescription,
                                ),
                              )
                              .toList()),
                      15.ph,
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Material(
                                elevation: 10.0,
                                shadowColor: Colors.black26,
                                borderRadius: BorderRadius.circular(6.r),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20.h, horizontal: 15.w),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: baseColorLight, width: 0.4),
                                      borderRadius: BorderRadius.circular(6.r),
                                      color: Colors.white),
                                  child: const LineChartSample1(),
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
                                  width: 460,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20.h, horizontal: 15.w),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: baseColorLight, width: 0.4),
                                      borderRadius: BorderRadius.circular(6.r),
                                      color: Colors.white),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      headingBig(text: 'Reach Hotspots'),
                                      20.ph,
                                      Expanded(
                                        child: fluent.FlyoutTarget(
                                          controller: contextController,
                                          child: SimpleMap(
                                            key: contextAttachKey,
                                            instructions:
                                                SMapUganda.instructions,
                                            defaultColor: baseColorLight,
                                            colors: SMapUgandaColors().toMap(),
                                            countryBorder: const CountryBorder(
                                                color: Colors.white),
                                            callback: (id, name, tapdetails) {
                                              print(id);
                                              print(name);

                                              final targetContext =
                                                  contextAttachKey
                                                      .currentContext;

                                              if (targetContext == null) return;
                                              final box = targetContext
                                                      .findRenderObject()
                                                  as RenderBox;
                                              final position =
                                                  box.localToGlobal(
                                                tapdetails.localPosition,
                                                ancestor: Navigator.of(context)
                                                    .context
                                                    .findRenderObject(),
                                              );

                                              if (id.isNotEmpty) {
                                                contextController.showFlyout(
                                                    margin: 0,
                                                    additionalOffset: 0,
                                                    dismissOnPointerMoveAway:
                                                        true,
                                                    barrierColor: Colors.black
                                                        .withOpacity(0.1),
                                                    position: position,
                                                    builder: (context) {
                                                      return fluent
                                                          .FlyoutContent(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            paragraph(
                                                                text: name,
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 8.sp),
                                                          ],
                                                        ),
                                                      );
                                                    });
                                              }
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
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
      );
    });
  }
}
