
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mywater_dashboard_revamp/services/firestore_service.dart';
import 'package:mywater_dashboard_revamp/v1/models/campaign_model.dart';
import 'package:mywater_dashboard_revamp/v1/utils/file_picker.dart';
import 'package:mywater_dashboard_revamp/v1/utils/screen_overlay.dart';

class CampaignService {
  final FirestoreService _firestoreService = FirestoreService();
  
  Future<String?> _uploadArtwork(BuildContext context, PlatformFile file) async {
    try {
      final List<int> imageBytes = !kIsWeb 
          ? await File(file.path!).readAsBytes()
          : file.bytes!.toList();
      
      return await uploadImageToImageKit(
        context, 
        imageBytes, 
        'myWaterCampaignArtwork'
      );
    } catch (e) {
      ScreenOverlay.showToast(
        context,
        title: 'Upload Failed',
        message: 'Failed to upload artwork',
        isWarning: true
      );
      return null;
    }
  }

  bool _validateInputs(BuildContext context, CampaignFormData form) {
    if (form.title.isEmpty) {
      ScreenOverlay.showToast(
        context,
        title: 'Missing Field',
        message: 'Fill in title',
        isWarning: true
      );
      return false;
    }
    if (form.description.isEmpty) {
      ScreenOverlay.showToast(
        context,
        title: 'Missing Field', 
        message: 'Fill in description',
        isWarning: true
      );
      return false;
    }
    if (form.publicUrl.isEmpty) {
      ScreenOverlay.showToast(
        context,
        title: 'Missing Field',
        message: 'Fill in public url',
        isWarning: true
      );
      return false;
    }
    return true;
  }

  Future<void> createCampaign(BuildContext context, CampaignFormData form) async {
    if (!_validateInputs(context, form)) return;

    String? uploadedImageUrl;
    if (form.artworkFile?.files.isNotEmpty ?? false) {
      uploadedImageUrl = await _uploadArtwork(
        context,
        form.artworkFile!.files.first
      );
    }

    if (uploadedImageUrl == null) return;

    await _firestoreService.createCampaign(
      context,
      pictureUrl: uploadedImageUrl,
      title: form.title,
      description: form.description,
      publicUrl: form.publicUrl,
      startDate: form.startDate,
      endDate: form.endDate,
    );
  }
}