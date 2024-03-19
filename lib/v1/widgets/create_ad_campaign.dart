import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mywater_dashboard_revamp/v1/constants/colors.dart';
import 'package:mywater_dashboard_revamp/v1/controller/campaign_controller.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:mywater_dashboard_revamp/v1/models/campaign_model.dart';
import 'package:mywater_dashboard_revamp/v1/utils/file_picker.dart';
import 'package:mywater_dashboard_revamp/v1/utils/screen_overlay.dart';
import 'package:mywater_dashboard_revamp/v1/utils/utils.dart';

class CreateCampaign extends StatefulWidget {
  const CreateCampaign({super.key});

  @override
  State<CreateCampaign> createState() => _CreateCampaignState();
}

class _CreateCampaignState extends State<CreateCampaign> {
  CampaignController campaignController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SizedBox(
        width: 500.w,
        child: ListView(
          padding: EdgeInsets.all(18.w),
          shrinkWrap: true,
          children: [
            heading(text: 'Create New Ad Campaign', color: baseColor),
            10.ph,
            paragraph(
                text: 'Submit campaign artwork to MyWater to create an ad',
                color: Colors.black54),
            30.ph,
            if (campaignController.artworkFile.value!.files.isNotEmpty) ...[
              Row(
                children: [
                  Expanded(
                    child: kIsWeb
                        ? Image.memory(
                            campaignController
                                .artworkFile.value!.files.first.bytes!,
                            height: 280.h,
                            fit: BoxFit.cover)
                        : Image.file(
                            File(campaignController
                                .artworkFile.value!.files.first.path!),
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
                  campaignController.artworkFile.value =
                      await FilePicker.platform.pickFiles();
                  setState(() {});
                },
              ),
            ),
            20.ph,
            fluent.InfoLabel(
              label: 'Promotion Title',
              labelStyle: TextStyle(fontFamily: 'Poppins', fontSize: 13.sp),
              child: fluent.TextBox(
                prefix: fluent.Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Icon(
                    fluent.FluentIcons.text_field,
                    color: Colors.black54,
                    size: 13.w,
                  ),
                ),
                padding:
                    EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                controller: campaignController.campaignTitleController,
                placeholder: 'eg App download Promotion',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11.sp,
                    color: Colors.black54),
                expands: false,
              ),
            ),
            20.ph,
            fluent.InfoLabel(
              label: 'Promotion Description',
              labelStyle: TextStyle(fontFamily: 'Poppins', fontSize: 13.sp),
              child: fluent.TextBox(
                prefix: fluent.Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Icon(
                    fluent.FluentIcons.text_field,
                    color: Colors.black54,
                    size: 13.w,
                  ),
                ),
                padding:
                    EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                controller:
                    campaignController.campaignDescriptionController,
                placeholder: 'eg Get 10% off on your first purchase',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11.sp,
                    color: Colors.black54),
                expands: false,
              ),
            ),
            20.ph,
            fluent.InfoLabel(
              label: 'Survey Question',
              labelStyle: TextStyle(fontFamily: 'Poppins', fontSize: 13.sp),
              child: fluent.TextBox(
                prefix: fluent.Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Icon(
                    fluent.FluentIcons.text_field,
                    color: Colors.black54,
                    size: 13.w,
                  ),
                ),
                padding:
                    EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                controller:
                    campaignController.campaignSurveyQuestionOneController,
                placeholder: 'optional',
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
                  header: 'Campaign Start Date',
                  headerStyle:
                      TextStyle(fontFamily: 'Poppins', fontSize: 13.sp),
                  startDate: DateTime.now(),
                  selected: campaignController.campaignStartDate,
                  onChanged: (time) => setState(
                      () => campaignController.campaignStartDate = time),
                ),
                const Spacer(),
                fluent.DatePicker(
                  header: 'Campaign End Date',
                  headerStyle:
                      TextStyle(fontFamily: 'Poppins', fontSize: 13.sp),
                  selected: campaignController.campaignEndDate,
                  onChanged: (time) => setState(
                      () => campaignController.campaignStartDate = time),
                ),
              ],
            ),
            50.ph,
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 45.h,
                    child: fluent.FilledButton(
                      child: fluent.Center(
                          child: label(
                        text: 'Submit Campaign',
                        color: Colors.white,
                        fontSize: 10.sp,
                      )),
                      onPressed: () async {
                        print('we are');
                        String? uploadedImageUrl;
      
                        if (campaignController
                            .artworkFile.value!.files.isNotEmpty) {
                          for (PlatformFile file in campaignController
                              .artworkFile.value!.files) {
                            if (!kIsWeb) {
                              File pickedFile = File(file.path!);
      
                              final List<int> imageBytes =
                                  await pickedFile.readAsBytes();
                              uploadedImageUrl =
                                  await uploadImageToImageKit(context,
                                      imageBytes, 'myWaterCampaignArtwork');
                            } else {
                              Uint8List? pickedFile = file.bytes;
      
                              uploadedImageUrl =
                                  await uploadImageToImageKit(
                                      context,
                                      pickedFile!.toList(),
                                      'myWaterCampaignArtwork');
                            }
                          }
                        }
      
                        if (campaignController.artworkFile == null) {
                          ScreenOverlay.showToast(context,
                              title: 'Missing Field',
                              message: 'Attach artwork',
                              isWarning: true);
                        } else if (campaignController
                            .campaignTitleController.text.isEmpty) {
                          ScreenOverlay.showToast(context,
                              title: 'Missing Field',
                              message: 'Fill in title',
                              isWarning: true);
                        } else if (campaignController
                            .campaignDescriptionController.text.isEmpty) {
                          ScreenOverlay.showToast(context,
                              title: 'Missing Field',
                              message: 'Fill in description',
                              isWarning: true);
                        } else {
                          CampaignModel campaignModel = CampaignModel(
                            advertiserId: GetStorage().read('partnerId'),
                            promotionText: campaignController
                                .campaignTitleController.text,
                            promotionDescription: campaignController
                                .campaignDescriptionController.text,
                            pictureUrl: uploadedImageUrl!,
                          );
                          campaignController
                              .createCampaign(context,
                                  campaignModel: campaignModel)
                              .then((callback) {
                            Navigator.pop(context);
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
