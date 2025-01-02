class RedemptionLocation {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final String batchId;
  final String location;
  final String phoneNumber;
  final String gender;
  final String rewardStatus;
  final int rewardAmount;
  final String campaignId;

  RedemptionLocation({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.batchId,
    required this.location,
    required this.phoneNumber,
    required this.gender,
    required this.rewardStatus,
    required this.rewardAmount,
    required this.campaignId,
  });

  factory RedemptionLocation.fromFirestore(Map<String, dynamic> data) {
    return RedemptionLocation(
      campaignId: data['campaignId'] as String,
      latitude: (data['coordinates'] as Map)['latitude'] as double,
      longitude: (data['coordinates'] as Map)['longitude'] as double,
      timestamp: DateTime.parse(data['scanTime'] as String),
      batchId: data['batchId'] as String,
      location: data['location'] as String? ?? '',
      phoneNumber: data['phoneNumber'] as String,
      gender: data['gender'] as String,
      rewardStatus: data['rewardStatus'] as String,
      rewardAmount: data['reward']['amount'] as int? ?? 0,
    );
  }
}
