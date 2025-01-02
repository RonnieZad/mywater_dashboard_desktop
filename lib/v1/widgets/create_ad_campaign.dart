import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mywater_dashboard_revamp/v1/constants/colors.dart';
import 'package:mywater_dashboard_revamp/v1/controller/campaign_controller.dart';
import 'package:mywater_dashboard_revamp/v1/models/campaign_model.dart';
import 'package:mywater_dashboard_revamp/v1/services/campaign_service.dart';
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
        width: 700,
        child: ListView(
          padding: const EdgeInsets.all(18),
          shrinkWrap: true,
          children: [
            AppTypography.titleLarge(text: 'Create New Ad Campaign', color: baseColor),
            10.ph,
            AppTypography.titleMedium(text: 'Submit campaign artwork to MyWater to create an ad', color: Colors.black54),
            30.ph,
            if (campaignController.artworkFile.value!.files.isNotEmpty) ...[
              Row(
                children: [
                  Expanded(
                    child: kIsWeb ? Image.memory(campaignController.artworkFile.value!.files.first.bytes!, height: 280, fit: BoxFit.cover) : Image.file(File(campaignController.artworkFile.value!.files.first.path!), height: 280, fit: BoxFit.cover),
                  ),
                ],
              ),
              20.ph,
            ],
            SizedBox(
              height: 45,
              child: fluent.Button(
                child: fluent.Center(
                    child: AppTypography.labelLarge(
                  text: 'Upload Artwork',
                  color: Colors.black54,
                )),
                onPressed: () async {
                  campaignController.artworkFile.value = await FilePicker.platform.pickFiles();
                  setState(() {});
                },
              ),
            ),
            20.ph,
            fluent.InfoLabel(
              label: 'Promotion Title',
              labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 16,fontWeight:FontWeight.w500),
              child: fluent.TextBox(
                prefix: const fluent.Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Icon(
                    fluent.FluentIcons.text_field,
                    color: Colors.black54,
                    size: 13,
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                controller: campaignController.campaignTitleController,
                placeholder: 'eg App download Promotion',
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.black54),
                expands: false,
              ),
            ),
            20.ph,
            fluent.InfoLabel(
              label: 'Promotion Description',
              labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight:FontWeight.w500),
              child: fluent.TextBox(
                prefix: const fluent.Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Icon(
                    fluent.FluentIcons.text_field,
                    color: Colors.black54,
                    size: 13,
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                controller: campaignController.campaignDescriptionController,
                placeholder: 'eg Get 10% off on your first purchase',
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.black54),
                expands: false,
              ),
            ),
            20.ph,
            fluent.InfoLabel(
              label: 'Promotion public url',
              labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 16,fontWeight:FontWeight.w500),
              child: fluent.TextBox(
                prefix: const fluent.Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Icon(
                    fluent.FluentIcons.text_field,
                    color: Colors.black54,
                    size: 13,
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                controller: campaignController.campaignPublicUrlController,
                placeholder: 'eg www.publicUrlGoesHere.com',
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.black54),
                expands: false,
              ),
            ),
            20.ph,
            fluent.InfoLabel(
              label: 'Survey Question',
              labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 16,fontWeight:FontWeight.w500),
              child: fluent.TextBox(
                prefix: const fluent.Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Icon(
                    fluent.FluentIcons.text_field,
                    color: Colors.black54,
                    size: 13,
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                controller: campaignController.campaignSurveyQuestionOneController,
                placeholder: 'optional',
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.black54),
                expands: false,
              ),
            ),
            20.ph,
            Row(
              children: [
                fluent.DatePicker(
                  header: 'Campaign Start Date',
                  headerStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 16,fontWeight:FontWeight.w500),
                  startDate: DateTime.now(),
                  selected: campaignController.campaignStartDate,
                  onChanged: (time) => setState(() => campaignController.campaignStartDate = time),
                ),
                const Spacer(),
                fluent.DatePicker(
                  header: 'Campaign End Date',
                  headerStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 16,fontWeight:FontWeight.w500),
                  selected: campaignController.campaignEndDate,
                  onChanged: (time) => setState(() => campaignController.campaignEndDate = time),
                ),
              ],
            ),
            50.ph,
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: fluent.FilledButton(
                      child: fluent.Center(
                          child: AppTypography.labelLarge(
                        text: 'Submit Campaign',
                        color: Colors.white,
                      )),
                      onPressed: () async {
                        final formData = CampaignFormData(
                          title: campaignController.campaignTitleController.text,
                          description: campaignController.campaignDescriptionController.text,
                          publicUrl: campaignController.campaignPublicUrlController.text,
                          startDate: campaignController.campaignStartDate!,
                          endDate: campaignController.campaignEndDate!,
                          artworkFile: campaignController.artworkFile.value,
                        );

                        await CampaignService().createCampaign(context, formData);
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
