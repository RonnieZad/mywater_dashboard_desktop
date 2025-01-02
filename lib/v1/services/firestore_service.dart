import 'dart:math';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mywater_dashboard_revamp/v1/models/campaign_model.dart';
import 'package:mywater_dashboard_revamp/v1/models/dashboard_statistic_model.dart';
import 'package:mywater_dashboard_revamp/v1/models/redemption_location_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Campaign>> getCampaigns() {
    return _firestore.collection('campaigns').snapshots().map((snapshot) => snapshot.docs.map((doc) {
          final data = doc.data();

          // data['id'] = doc.id;
          Campaign campaign = Campaign.fromMap(data);

          print(campaign.name);
          return campaign;
        }).toList());
  }

  Stream<DashboardStats> getDashboardStats() {
    return StreamZip([
      _firestore.collection('campaigns').snapshots(),
      _firestore.collection('redemptions').snapshots(),
      _firestore.collection('users').snapshots(),
    ]).map((List<QuerySnapshot> snapshots) {
      try {
        final campaignSnapshot = snapshots[0];
        final redemptionSnapshot = snapshots[1];
        final usersSnapshot = snapshots[2];
        final now = DateTime.now();

        // Initialize counters and maps
        int activeCampaigns = 0;
        int totalCampaigns = campaignSnapshot.docs.length;
        int upcomingCampaigns = 0;
        int pendingRedemptions = 0;
        int todayScans = 0;
        int totalPoints = 0;
        int pendingPoints = 0;

        // Initialize tracking maps
        Map<String, int> scansPerBatch = {};
        Map<String, int> scansPerGender = {};
        Map<String, int> scansPerLocation = {};
        Map<String, int> scansPerHour = {};
        Map<String, int> scansPerDay = {};
        Map<String, int> scansPerCampaign = {};
        Map<String, String> campaignNames = {};

        // Process campaigns first
        for (var doc in campaignSnapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          final campaign = Campaign.fromMap(data);

          // Store campaign name
          campaignNames[doc.id] = campaign.name;

          // Check campaign status
          if (campaign.status == 'active' && campaign.startDate <= now.millisecondsSinceEpoch && campaign.endDate >= now.millisecondsSinceEpoch) {
            activeCampaigns++;
          } else if (campaign.startDate > now.millisecondsSinceEpoch) {
            upcomingCampaigns++;
          }
        }

        // Process redemptions
        final startOfDay = DateTime(now.year, now.month, now.day);
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

        final redemptions = redemptionSnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return RedemptionLocation.fromFirestore(data);
        }).toList();

        for (var redemption in redemptions) {
          // Batch statistics
          final batchId = redemption.batchId;
          scansPerBatch[batchId] = (scansPerBatch[batchId] ?? 0) + 1;

          // Gender statistics
          final gender = redemption.gender;
          scansPerGender[gender] = (scansPerGender[gender] ?? 0) + 1;

          // Location statistics
          if (redemption.location.isNotEmpty) {
            scansPerLocation[redemption.location] = (scansPerLocation[redemption.location] ?? 0) + 1;
          }

          // Time-based statistics
          final hour = redemption.timestamp.hour;
          final day = redemption.timestamp.toIso8601String().split('T')[0];

          scansPerHour['$hour:00'] = (scansPerHour['$hour:00'] ?? 0) + 1;
          scansPerDay[day] = (scansPerDay[day] ?? 0) + 1;

          // Campaign statistics
          final campaignId = redemption.campaignId;
          if (campaignId.isNotEmpty) {
            scansPerCampaign[campaignId] = (scansPerCampaign[campaignId] ?? 0) + 1;
          }

          // Points tracking
          totalPoints += redemption.rewardAmount;

          // Status tracking
          if (redemption.rewardStatus == 'pending') {
            pendingPoints += redemption.rewardAmount;
            pendingRedemptions++;
          }

          // Today's scans
          if (redemption.timestamp.isAfter(startOfDay)) {
            todayScans++;
          }
        }

        // Calculate averages and trends
        final firstScanDate = redemptions.isEmpty ? now : redemptions.map((r) => r.timestamp).reduce((a, b) => a.isBefore(b) ? a : b);

        final daysSinceFirst = max(now.difference(firstScanDate).inDays + 1, 1);

        final averageScansPerDay = redemptions.length / daysSinceFirst;

        // Generate last 7 days trend data
        final trendData = List.generate(7, (index) {
          final date = now.subtract(Duration(days: 6 - index));
          final dateStr = date.toIso8601String().split('T')[0];
          return TimeSeriesData(
            date: date,
            value: scansPerDay[dateStr] ?? 0,
          );
        });

        // Sort maps by values for top performers
        scansPerLocation = Map.fromEntries(scansPerLocation.entries.toList()..sort((a, b) => b.value.compareTo(a.value)));

        scansPerBatch = Map.fromEntries(scansPerBatch.entries.toList()..sort((a, b) => b.value.compareTo(a.value)));

        return DashboardStats(
          aceiveUsers: usersSnapshot.docs.length,
          totalCampaigns: totalCampaigns,
          activeCampaigns: activeCampaigns,
          upcomingCampaigns: upcomingCampaigns,
          totalScans: redemptions.length,
          pendingRedemptions: pendingRedemptions,
          todayScans: todayScans,
          totalPoints: totalPoints,
          pendingPoints: pendingPoints,
          scansPerGender: scansPerGender,
          scansPerLocation: scansPerLocation,
          scansPerBatch: scansPerBatch,
          scansPerHour: scansPerHour,
          scansPerDay: scansPerDay,
          averageScansPerDay: averageScansPerDay,
          trendData: trendData,
          scansPerCampaign: scansPerCampaign,
          campaignNames: campaignNames,
        );
      } catch (e, stackTrace) {
        print('Error processing dashboard stats: $e');
        print('Stack trace: $stackTrace');

        // Return empty stats in case of error
        return const DashboardStats(
          aceiveUsers: 0,
          totalCampaigns: 0,
          activeCampaigns: 0,
          upcomingCampaigns: 0,
          totalScans: 0,
          pendingRedemptions: 0,
          todayScans: 0,
          totalPoints: 0,
          pendingPoints: 0,
          scansPerGender: {},
          scansPerLocation: {},
          scansPerBatch: {},
          scansPerHour: {},
          scansPerDay: {},
          averageScansPerDay: 0,
          trendData: [],
          scansPerCampaign: {},
          campaignNames: {},
        );
      }
    });
  }

  Stream<List<RedemptionLocation>> getRedemptionLocations() {
    return _firestore.collection('redemptions').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            try {
              return RedemptionLocation(
                campaignId: doc.id,
                latitude: (data['coordinates'] as Map)['latitude'] as double? ?? 0.0,
                longitude: (data['coordinates'] as Map)['longitude'] as double? ?? 0.0,
                timestamp: DateTime.parse(data['scanTime'] as String),
                batchId: data['batchId'] as String? ?? '',
                location: data['location'] as String? ?? '',
                phoneNumber: data['phoneNumber'] as String? ?? '',
                gender: data['gender'] as String? ?? '',
                rewardStatus: data['rewardStatus'] as String? ?? 'pending',
                rewardAmount: (data['reward'] as Map?)?.containsKey('amount') ?? false ? (data['reward'] as Map)['amount'] as int : 0,
              );
            } catch (e) {
              print('Error parsing redemption data: $e');
              print('Problematic document: ${doc.id}');
              print('Data: $data');
              // Return a default location in case of parsing errors
              return RedemptionLocation(
                campaignId: '',
                latitude: 0.0,
                longitude: 0.0,
                timestamp: DateTime.now(),
                batchId: 'error',
                location: '',
                phoneNumber: '',
                gender: '',
                rewardStatus: 'error',
                rewardAmount: 0,
              );
            }
          })
          .where((location) =>
              // Filter out invalid coordinates
              location.latitude != 0.0 && location.longitude != 0.0)
          .toList();
    });
  }
}
