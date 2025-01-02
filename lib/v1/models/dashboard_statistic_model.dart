// models/time_series_data.dart
class TimeSeriesData {
  final DateTime date;
  final int value;

  TimeSeriesData({
    required this.date,
    required this.value,
  });
}

// models/dashboard_stats.dart
class DashboardStats {
  final int totalCampaigns;
  final int activeCampaigns;
  final int upcomingCampaigns;
  final int totalScans;
  final int pendingRedemptions;
  final int todayScans;
  final int totalPoints;
  final int pendingPoints;
  final int aceiveUsers;
  final Map<String, int> scansPerGender;
  final Map<String, int> scansPerLocation;
  final Map<String, int> scansPerBatch;
  final Map<String, int> scansPerHour;
  final Map<String, int> scansPerDay;
  final double averageScansPerDay;
  final List<TimeSeriesData> trendData;
  final Map<String, int> scansPerCampaign; // Added this field
  final Map<String, String> campaignNames; // To store campaign names

  const DashboardStats({
    required this.totalCampaigns,
    required this.activeCampaigns,
    required this.upcomingCampaigns,
    required this.totalScans,
    required this.pendingRedemptions,
    required this.todayScans,
    required this.totalPoints,
    required this.pendingPoints,
    required this.scansPerGender,
    required this.scansPerLocation,
    required this.scansPerBatch,
    required this.scansPerHour,
    required this.scansPerDay,
    required this.averageScansPerDay,
    required this.trendData,
    required this.scansPerCampaign, // Added this
    required this.campaignNames, // Added this
    required this.aceiveUsers,
  });
}
