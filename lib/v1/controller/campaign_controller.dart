import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mywater_dashboard_revamp/v1/models/campaign_model.dart';
import 'package:mywater_dashboard_revamp/v1/services/api_service.dart';
import 'package:mywater_dashboard_revamp/v1/utils/screen_overlay.dart';
import 'package:mywater_dashboard_revamp/v1/utils/typography.dart';
import 'package:mywater_dashboard_revamp/v1/utils/utils.dart';

class CampaignController extends GetxController {
  var partnerId = GetStorage().read('partnerId');
  Rx<FilePickerResult?> artworkFile = const FilePickerResult([]).obs;
  DateTime? campaignStartDate;
  DateTime? campaignEndDate;

  TextEditingController campaignTitleController = TextEditingController();
  TextEditingController campaignDescriptionController = TextEditingController();
  TextEditingController campaignStartDateController = TextEditingController();
  TextEditingController campaignEndDateController = TextEditingController();

  final _campaigns = <CampaignModel>[].obs;
  List<CampaignModel> get campaigns => _campaigns;

  @override
  void onInit() {
    super.onInit();
    fetchCampaigns();
  }

  void fetchCampaigns() async {
    return ApiService.getRequest(
            endPoint: '/get_user_label_advert/$partnerId',
            service: Services.application)
        .then((response) {
      print(response);
      if (response['payload']['status'] >= 200 &&
          response['payload']['status'] < 300) {
        _campaigns.value = (response['payload']['adverts'] as List)
            .map((e) => CampaignModel.fromJson(e))
            .toList();
      } else {
        print(response['payload']['error']);
      }
    });
  }

  Future createCampaign(context, {required CampaignModel campaignModel}) {
    
    return ApiService.postRequest(
            endPoint: '/add_advert_label',
            service: Services.application,
            body: campaignModel.toJson())
        .then((response) {
      print(response);
      if (response['payload']['status'] >= 200 &&
          response['payload']['status'] < 300) {
        fetchCampaigns();
        ScreenOverlay.showToast(context,
            title: 'Success', message: 'Campaign added successfully').then((callback){
              Navigator.pop(context);
            });
      } else {
        ScreenOverlay.showToast(context,
            title: 'Something went wrong',
            message: response['payload']['error'],
            isError: true).then((callback){
              Navigator.pop(context);
            });
        print(response['payload']['error']);
      }
    });
  }
}
