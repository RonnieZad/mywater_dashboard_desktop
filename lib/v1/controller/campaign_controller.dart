import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mywater_dashboard_revamp/v1/models/campaign_metrics.dart';
import 'package:mywater_dashboard_revamp/v1/models/campaign_model.dart';
import 'package:mywater_dashboard_revamp/v1/services/api_service.dart';
import 'package:mywater_dashboard_revamp/v1/utils/screen_overlay.dart';

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

  final _campaigns = <CampaignModel>[].obs;
  final _campaignMetrics = <CampaignMetrics>[].obs;

  List<CampaignMetrics> get getCampaignMetricsData => _campaignMetrics;
  List<CampaignModel> get campaigns => _campaigns;

  var campaignMetrics = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCampaigns();
    getCampaignMetrics();
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

  Future<void> fetchCampaigns() async {
    return ApiService.getRequest(
            endPoint: '/get_user_label_advert/$partnerId',
            service: Services.application)
        .then((response) {
      debugPrint(response.toString());
      if (response['payload']['status'] >= 200 &&
          response['payload']['status'] < 300) {
        print(response['payload']['adverts']);
        _campaigns.value = (response['payload']['adverts'] as List)
            .map((e) => CampaignModel.fromJson(e))
            .toList();
      } else {
        debugPrint(response['payload']['error'].toString());
      }
    });
  }

  Future createCampaign(context, {required CampaignModel campaignModel}) {
    return ApiService.postRequest(
            endPoint: '/add_advert_label',
            service: Services.application,
            body: campaignModel.toJson())
        .then((response) {
      debugPrint(response.toString());
      if (response['payload']['status'] >= 200 &&
          response['payload']['status'] < 300) {
        fetchCampaigns();
        ScreenOverlay.showToast(context,
                title: 'Success', message: 'Campaign added successfully')
            .then((callback) {
          Navigator.pop(context);
        });
      } else {
        ScreenOverlay.showToast(context,
                title: 'Something went wrong',
                message: response['payload']['error'],
                isError: true)
            .then((callback) {
          Navigator.pop(context);
        });
        debugPrint(response['payload']['error'].toString());
      }
      _clearCreateCampaignSheet();
    });
  }

  Future getCampaignMetrics() {
    return ApiService.getRequest(
            endPoint: '/get_metrics/$partnerId', service: Services.application)
        .then((response) {
      debugPrint(response.toString());
      if (response['payload']['status'] >= 200 &&
          response['payload']['status'] < 300) {
        _campaignMetrics.value = (response['payload']['analytics'] as List)
            .map((e) => CampaignMetrics.fromJson(e))
            .toList();
        debugPrint(response['payload']['metrics'].toString());
        campaignMetrics.value = response['payload']['analytics'];
      } else {
        debugPrint(response['payload']['error'].toString());
      }
    });
  }
}
