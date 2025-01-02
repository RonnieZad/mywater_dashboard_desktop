import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mywater_dashboard_revamp/v1/models/campaign_model.dart';
import 'package:mywater_dashboard_revamp/v1/utils/screen_overlay.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createCampaign(
    BuildContext context, {
    required String pictureUrl,
    required String title,
    required String description,
    required String publicUrl,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final campaign = Campaign(
      ad: [
        Ad(
          adArtworkUrl: pictureUrl,
          adName: title,
          adPhone: '',
          adWebsite: publicUrl,
          companyEmail: GetStorage().read('partnerEmail') ?? '',
          companyLogo: '',
          companyName: GetStorage().read('partnerName') ?? '',
          companyPhone: '',
          companyWebsite: publicUrl,
          description: description,
        )
      ],
      clients: ['MY WATER'],
      endDate: endDate.millisecondsSinceEpoch,
      name: title,
      reward: Reward(amount: 0, type: 'points'),
      startDate: startDate.millisecondsSinceEpoch,
      status: 'active',
      campaignLogo: pictureUrl,
    );

    try {
      final WriteBatch batch = _firestore.batch();
      final campaignRef = _firestore.collection('campaigns').doc();
      final batchRef = _firestore.collection('batches').doc();

      batch.set(campaignRef, {
        'ad': campaign.ad
            .map((ad) => {
                  'adArtworkUrl': ad.adArtworkUrl,
                  'adName': ad.adName,
                  'adPhone': ad.adPhone,
                  'adWebsite': ad.adWebsite,
                  'companyEmail': ad.companyEmail,
                  'companyLogo': ad.companyLogo,
                  'companyName': ad.companyName,
                  'companyPhone': ad.companyPhone,
                  'companyWebsite': ad.companyWebsite,
                  'description': ad.description,
                })
            .toList(),
        'clients': campaign.clients,
        'endDate': campaign.endDate,
        'name': campaign.name,
        'reward': {
          'amount': campaign.reward.amount,
          'type': campaign.reward.type,
        },
        'startDate': campaign.startDate,
        'status': campaign.status,
        'campaignLogo': campaign.campaignLogo,
      });

      batch.set(batchRef, {'campaignId': campaignRef.id, 'clients': campaign.clients, 'bottleCount': 100, 'currentToken': generateToken()});

      await batch.commit();
      Navigator.pop(context);
      ScreenOverlay.showToast(context, title: 'Success', message: 'Campaign created successfully');
    } catch (e) {
      ScreenOverlay.showToast(context, title: 'Error', message: 'Failed to create campaign', isWarning: true);
    }
  }
}

String generateToken() {
  final random = Random.secure();
  final values = List<int>.generate(32, (i) => random.nextInt(256));
  return values.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
}
