import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mywater_dashboard_revamp/v1/models/campaign_metrics.dart';
import 'package:mywater_dashboard_revamp/v1/services/api_service.dart';

class CampaignController extends GetxController {
  var partnerId = GetStorage().read('partnerId');
  Rx<FilePickerResult?> artworkFile = const FilePickerResult([]).obs;
  DateTime? campaignStartDate;
   DateTime? campaignEndDate;

  TextEditingController campaignTitleController = TextEditingController();
  TextEditingController campaignDescriptionController = TextEditingController();
  TextEditingController campaignPublicUrlController = TextEditingController();
  TextEditingController campaignStartDateController = TextEditingController();
  TextEditingController campaignEndDateController = TextEditingController();
  TextEditingController campaignSurveyQuestionOneController = TextEditingController();
  TextEditingController campaignSurveyQuestionTwoController = TextEditingController();
  TextEditingController campaignSurveyQuestionThreeController = TextEditingController();

  // final _campaigns = <CampaignModel>[].obs;
  final _campaignMetrics = <CampaignMetrics>[].obs;

  List<CampaignMetrics> get getCampaignMetricsData => _campaignMetrics;
  // List<CampaignModel> get campaigns => _campaigns;

  var campaignMetrics = [].obs;

  @override
  void onInit() {
    super.onInit();

    // getCampaignMetrics();
  }

  _clearCreateCampaignSheet() {
    campaignTitleController.clear();
    campaignDescriptionController.clear();
    campaignStartDateController.clear();
    campaignEndDateController.clear();
    campaignSurveyQuestionOneController.clear();
    campaignSurveyQuestionTwoController.clear();
    campaignSurveyQuestionThreeController.clear();
    artworkFile = const FilePickerResult([]).obs;
  }

 
}
