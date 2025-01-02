import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mywater_dashboard_revamp/v1/constants/colors.dart';
import 'package:mywater_dashboard_revamp/v1/controller/campaign_controller.dart';
import 'package:mywater_dashboard_revamp/v1/models/dashboard_statistic_model.dart';
import 'package:mywater_dashboard_revamp/v1/screens/dashboard.dart';
import 'package:mywater_dashboard_revamp/v1/services/firestore_service.dart';
import 'package:mywater_dashboard_revamp/v1/utils/screen_overlay.dart';
import 'package:mywater_dashboard_revamp/v1/utils/utils.dart';
import 'package:mywater_dashboard_revamp/v1/widgets/app_button.dart';
import 'package:mywater_dashboard_revamp/v1/widgets/create_ad_campaign.dart';
import 'package:mywater_dashboard_revamp/v1/widgets/redemption_location_map_widget.dart';
import 'package:mywater_dashboard_revamp/v1/widgets/screen_overlay.dart';

class DashboardLoadingView extends StatelessWidget {
  const DashboardLoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          16.ph,
          AppTypography.bodyLarge(
            text: 'Loading dashboard...',
          ),
        ],
      ),
    );
  }
}

class DashboardLayout extends StatelessWidget {
  final Widget header;
  final Widget body;

  const DashboardLayout({
    Key? key,
    required this.header,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50], // Light background
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          24.ph,
          Expanded(child: body),
        ],
      ),
    );
  }
}

class DashboardHeader extends StatelessWidget {
  final Widget searchBar;
  final List<Widget> actions;

  const DashboardHeader({
    super.key,
    required this.searchBar,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search Bar
        Expanded(child: searchBar),
        24.pw,
        // Action Buttons
        Row(
          children: actions,
        )
      ],
    );
  }
}

class DashboardOverview extends StatefulWidget {
  const DashboardOverview({super.key});

  @override
  State<DashboardOverview> createState() => _DashboardOverviewState();
}

class _DashboardOverviewState extends State<DashboardOverview> {
  final CampaignController campaignController = Get.put(CampaignController());
  final contextController = fluent.FlyoutController();
  final contextAttachKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyR): const RefreshPageIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          RefreshPageIntent: RefreshPageAction(campaignController, context),
        },
        child: DashboardLayout(
          header: _buildHeader(),
          body: _buildDashboardContent(),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return DashboardHeader(
      searchBar: _buildSearchBar(),
      actions: _buildHeaderActions(),
    );
  }

  Widget _buildSearchBar() {
    return const fluent.TextBox(
      suffix: fluent.Padding(
        padding: EdgeInsets.only(right: 20),
        child: Icon(
          fluent.FluentIcons.search,
          color: Colors.black54,
          size: 13,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      placeholder: 'Search anything like campaign id, name, etc.',
      style: TextStyle(fontFamily: 'Poppins', fontSize: 16, color: Colors.black54),
      expands: false,
    );
  }

  List<Widget> _buildHeaderActions() {
    return [
      AppButton(
        buttonLabel: 'Create Campaign',
        action: () => _showCreateCampaignDialog(),
      ),
      10.pw,
      IconButton(
        onPressed: _showNotificationToast,
        icon: const Icon(fluent.FluentIcons.ringer_active, size: 24),
      ),
    ];
  }

  Widget _buildDashboardContent() {
    return StreamBuilder<DashboardStats>(
      stream: FirestoreService().getDashboardStats(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const DashboardLoadingView();
        }

        final stats = snapshot.data!;
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // Summary Stats
                  SummaryStats(stats: stats),
                  20.ph,

                  // Weekly Activity
                  WeeklyActivityCard(stats: stats),
                  20.ph,

                  // Bottom Section
                  SizedBox(
                    height: 815, //
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column - Analysis
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              TopPerformingBatches(stats: stats),
                              16.ph,
                              HourlyScanActivity(stats: stats),
                            ],
                          ),
                        ),
                        10.pw,
                        // Right Column - Map
                        const Expanded(
                          flex: 2,
                          child: SizedBox.expand(
                            child: RedemptionLocationMap(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCreateCampaignDialog() {
    ScreenAppOverlay.showAppDialogWindow(
      context,
      body: const CreateCampaign(),
    );
  }

  void _showNotificationToast() {
    ScreenOverlay.showToast(
      context,
      title: 'No new notifications',
      message: 'There are no notifications',
      isWarning: true,
    );
  }
}

class SummaryStats extends fluent.StatelessWidget {
  const SummaryStats({
    super.key,
    required this.stats,
  });

  final DashboardStats stats;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    return Row(children: [
      _buildStatCard(
        'Total Scans',
        stats.totalScans.toString(),
        '${stats.todayScans} today',
        Icons.qr_code_scanner,
        Colors.blue,
      ),
      10.pw,
      _buildStatCard(
        'Total Points',
        '${stats.totalPoints}',
        '${stats.pendingPoints} pending',
        Icons.star,
        Colors.amber,
      ),
      10.pw,
      _buildStatCard(
        'Active Campaigns',
        stats.activeCampaigns.toString(),
        '${stats.upcomingCampaigns} upcoming',
        Icons.campaign,
        Colors.green,
      ),
      10.pw,
      _buildStatCard(
        'Active Users',
        stats.aceiveUsers.toString(),
        '',
        Icons.people,
        Colors.orange,
      ),
    ]);
  }
}

class HourlyScanActivity extends fluent.StatelessWidget {
  const HourlyScanActivity({
    super.key,
    required this.stats,
  });

  final DashboardStats stats;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: baseColorLight, width: 0.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
    
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTypography.titleLarge(
                text: 'Hourly Scan Activity',
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: AppTypography.labelLarge(
                  text: 'Peak: ${_getPeakHour(stats.scansPerHour)}',
                ),
              ),
            ],
          ),
          10.ph,
          // Activity Summary Cards
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildSummaryCard(
                'Most Active Time',
                _getMostActiveTime(stats.scansPerHour),
                Icons.access_time,
                Colors.blue,
              ),
              _buildSummaryCard(
                'Quiet Hours',
                _getQuietHours(stats.scansPerHour),
                Icons.nights_stay,
                Colors.grey,
              ),
              _buildSummaryCard(
                'Peak Volume',
                '${_getPeakVolume(stats.scansPerHour)} scans/hour',
                Icons.show_chart,
                Colors.green,
              ),
            ],
          ),

          30.ph,
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final hour = value.toInt();
                        // Only show labels for every 4 hours
                        if (hour % 4 == 0) {
                          String period = hour >= 12 ? 'PM' : 'AM';
                          final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: AppTypography.bodySmall(
                              text: '$displayHour$period',
                              color: Colors.grey[600],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 5,
                      reservedSize: 35,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: AppTypography.bodySmall(
                            text: value.toInt().toString(),
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: _getBarGroups(stats.scansPerHour),
                maxY: (_getMaxValue(stats.scansPerHour) * 1.2).ceilToDouble(),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    // tooltipBgColor: Colors.blueAccent,
                    tooltipRoundedRadius: 8,
                    tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final hour = group.x;
                      final count = rod.toY.toInt();
                      final period = hour >= 12 ? 'PM' : 'AM';
                      final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
                      return BarTooltipItem(
                        '$count scans\n$displayHour:00 $period',
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          15.ph,
          15.ph,
          // Activity Analysis
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTypography.titleMedium(text: 'Activity Analysis'),
              10.ph,
              ..._getActivityAnalysis(stats.scansPerHour).map(
                (analysis) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_right,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      8.pw,
                      Expanded(
                        child: AppTypography.bodyMedium(
                          text: analysis,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TopPerformingBatches extends fluent.StatelessWidget {
  const TopPerformingBatches({
    super.key,
    required this.stats,
  });

  final DashboardStats stats;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    return Container(
          padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: baseColorLight, width: 0.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
    
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTypography.titleLarge(
            text: 'Top Performing Batches',
          ),
          10.ph,
          Column(
            children: () {
              var sortedEntries = stats.scansPerBatch.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
              return sortedEntries
                  .take(4)
                  .map((entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppTypography.bodyMedium(text: formatBatchName(entry.key)),
                            AppTypography.bodyMedium(
                              text: '${entry.value} scans',
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                      ))
                  .toList();
            }(),
          ),
        ],
      ),
    );
  }
}

class WeeklyActivityCard extends fluent.StatelessWidget {
  const WeeklyActivityCard({
    super.key,
    required this.stats,
  });

  final DashboardStats stats;

  @override
  fluent.Widget build(fluent.BuildContext context) {
    return Container(
      height: 380,
          padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: baseColorLight, width: 0.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with insights
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTypography.titleLarge(text: 'Weekly Scan Activity'),
              Row(
                children: [
                  _buildInsightPill(
                    'Avg: ${stats.averageScansPerDay.toStringAsFixed(1)}/day',
                    Colors.blue,
                  ),
                  8.pw,
                  _buildInsightPill(
                    _calculateGrowth(stats.trendData),
                    _getGrowthColor(_calculateGrowthValue(stats.trendData)),
                  ),
                ],
              ),
            ],
          ),
          20.ph,
          // Quick stats row
          Row(
            children: [
              _buildQuickStat(
                'Total',
                stats.trendData.fold(0, (sum, item) => sum + item.value).toString(),
                Icons.analytics,
                Colors.blue,
              ),
              15.pw,
              _buildQuickStat(
                'Peak Day',
                _getPeakDay(stats.trendData),
                Icons.trending_up,
                Colors.green,
              ),
              15.pw,
              _buildQuickStat(
                'Lowest',
                _getLowestDay(stats.trendData),
                Icons.trending_down,
                Colors.orange,
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                        return AppTypography.bodySmall(
                          text: _formatDate(date),
                          color: Colors.grey[600],
                        );
                      },
                      interval: 24 * 60 * 60 * 1000,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10,
                      reservedSize: 35,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: AppTypography.bodySmall(
                            text: value.toInt().toString(),
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: stats.trendData
                        .map((e) => FlSpot(
                              e.date.millisecondsSinceEpoch.toDouble(),
                              e.value.toDouble(),
                            ))
                        .toList(),
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: Colors.blue,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.withOpacity(0.2),
                          Colors.blue.withOpacity(0.05),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((touchedSpot) {
                        final date = DateTime.fromMillisecondsSinceEpoch(touchedSpot.x.toInt());
                        return LineTooltipItem(
                          '${touchedSpot.y.toInt()} scans\n${_formatDateDetailed(date)}',
                          const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }).toList();
                    },
                  ),
                  handleBuiltInTouches: true,
                  getTouchedSpotIndicator: (barData, spotIndexes) {
                    return spotIndexes.map((index) {
                      return TouchedSpotIndicatorData(
                        FlLine(
                          color: Colors.blue.withOpacity(0.2),
                          strokeWidth: 2,
                          dashArray: [5, 5],
                        ),
                        FlDotData(
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 6,
                              color: Colors.white,
                              strokeWidth: 3,
                              strokeColor: Colors.blue,
                            );
                          },
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildInsightPill(String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: AppTypography.labelLarge(
      text: text,
    ),
  );
}

Widget _buildQuickStat(String label, String value, IconData icon, Color color) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          8.pw,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTypography.labelLarge(
                text: label,
                color: Colors.grey[800],
              ),
              4.ph,
              AppTypography.bodySmall(
                text: value,
                color: Colors.grey[800],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

String _formatDate(DateTime date) {
  final now = DateTime.now();
  if (date.year == now.year && date.month == now.month && date.day == now.day) {
    return 'Today';
  }
  if (date.year == now.year && date.month == now.month && date.day == now.day - 1) {
    return 'Yesterday';
  }
  return '${date.day}/${date.month}';
}

String _formatDateDetailed(DateTime date) {
  final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return '${weekdays[date.weekday - 1]}, ${date.day}/${date.month}';
}

String _calculateGrowth(List<TimeSeriesData> data) {
  if (data.length < 2) return 'N/A';

  final firstValue = data.first.value;
  final lastValue = data.last.value;

  if (firstValue == 0) return '+$lastValue%';

  final growth = ((lastValue - firstValue) / firstValue * 100).toStringAsFixed(1);
  return '${growth.startsWith('-') ? '' : '+'}$growth%';
}

double _calculateGrowthValue(List<TimeSeriesData> data) {
  if (data.length < 2) return 0;

  final firstValue = data.first.value;
  final lastValue = data.last.value;

  if (firstValue == 0) return 100;

  return (lastValue - firstValue) / firstValue * 100;
}

Color _getGrowthColor(double growth) {
  if (growth > 0) return Colors.green;
  if (growth < 0) return Colors.red;
  return Colors.grey;
}

String _getPeakDay(List<TimeSeriesData> data) {
  if (data.isEmpty) return 'N/A';

  final peak = data.reduce((a, b) => a.value > b.value ? a : b);
  return '${peak.value} (${_formatDate(peak.date)})';
}

String _getLowestDay(List<TimeSeriesData> data) {
  if (data.isEmpty) return 'N/A';

  final lowest = data.reduce((a, b) => a.value < b.value ? a : b);
  return '${lowest.value} (${_formatDate(lowest.date)})';
}

Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        8.pw,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTypography.bodySmall(
              text: title,
              color: Colors.grey[800],
            ),
            4.ph,
            AppTypography.labelLarge(
              text: value,
              color: Colors.grey[800],
            ),
          ],
        ),
      ],
    ),
  );
}

String _getMostActiveTime(Map<String, int> hourlyData) {
  if (hourlyData.isEmpty) return 'N/A';

  // Group hours into periods
  Map<String, int> periods = {
    'Morning (6AM-12PM)': 0,
    'Afternoon (12PM-5PM)': 0,
    'Evening (5PM-9PM)': 0,
    'Night (9PM-6AM)': 0,
  };

  hourlyData.forEach((key, value) {
    final hour = int.parse(key.split(':')[0]);
    if (hour >= 6 && hour < 12) {
      periods['Morning (6AM-12PM)'] = (periods['Morning (6AM-12PM)'] ?? 0) + value;
    } else if (hour >= 12 && hour < 17) {
      periods['Afternoon (12PM-5PM)'] = (periods['Afternoon (12PM-5PM)'] ?? 0) + value;
    } else if (hour >= 17 && hour < 21) {
      periods['Evening (5PM-9PM)'] = (periods['Evening (5PM-9PM)'] ?? 0) + value;
    } else {
      periods['Night (9PM-6AM)'] = (periods['Night (9PM-6AM)'] ?? 0) + value;
    }
  });

  return periods.entries.reduce((a, b) => a.value > b.value ? a : b).key.split(' ')[0]; // Return just the period name without time range
}

String _getQuietHours(Map<String, int> hourlyData) {
  if (hourlyData.isEmpty) return 'N/A';

  List<int> quietHours = [];
  for (int i = 0; i < 24; i++) {
    if (hourlyData['$i:00'] == null || hourlyData['$i:00']! <= 1) {
      quietHours.add(i);
    }
  }

  if (quietHours.isEmpty) return 'None';

  int start = quietHours[0];
  int end = quietHours.last;
  String startPeriod = start >= 12 ? 'PM' : 'AM';
  String endPeriod = end >= 12 ? 'PM' : 'AM';
  int displayStart = start == 0 ? 12 : (start > 12 ? start - 12 : start);
  int displayEnd = end == 0 ? 12 : (end > 12 ? end - 12 : end);

  return '$displayStart$startPeriod-$displayEnd$endPeriod';
}

String _getPeakVolume(Map<String, int> hourlyData) {
  if (hourlyData.isEmpty) return '0';
  return hourlyData.values.reduce(max).toString();
}

List<String> _getActivityAnalysis(Map<String, int> hourlyData) {
  if (hourlyData.isEmpty) return ['No activity data available'];

  List<String> analysis = [];

  // Calculate average scans per hour
  double average = hourlyData.values.reduce((a, b) => a + b) / 24;

  // Find peak hours (hours with activity > 150% of average)
  List<int> peakHours = [];
  hourlyData.forEach((key, value) {
    if (value > average * 1.5) {
      peakHours.add(int.parse(key.split(':')[0]));
    }
  });

  // Add insights
  analysis.add('Average of ${average.toStringAsFixed(1)} scans per hour');

  if (peakHours.isNotEmpty) {
    analysis.add('High activity detected during ${_formatHoursList(peakHours)}');
  }

  // Add recommendation based on quiet hours
  var quietHours = _getQuietHours(hourlyData);
  if (quietHours != 'None') {
    analysis.add('Consider running promotions during quiet hours ($quietHours) to increase engagement');
  }

  return analysis;
}

String _formatHoursList(List<int> hours) {
  List<String> formatted = hours.map((hour) {
    String period = hour >= 12 ? 'PM' : 'AM';
    int displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$displayHour$period';
  }).toList();

  return formatted.join(', ');
}

List<BarChartGroupData> _getBarGroups(Map<String, int> hourlyData) {
  return List.generate(24, (index) {
    final value = hourlyData['$index:00']?.toDouble() ?? 0;
    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          toY: value,
          color: _getBarColor(index, value, hourlyData),
          width: 12,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ],
    );
  });
}

Color _getBarColor(int hour, double value, Map<String, int> hourlyData) {
  final maxValue = _getMaxValue(hourlyData);
  if (value == maxValue) {
    return Colors.blue;
  }
  final intensity = value / maxValue;
  return Colors.blue.withOpacity(0.3 + (intensity * 0.7));
}

double _getMaxValue(Map<String, int> hourlyData) {
  if (hourlyData.isEmpty) return 0;
  return hourlyData.values.reduce(max).toDouble();
}

String _getPeakHour(Map<String, int> hourlyData) {
  if (hourlyData.isEmpty) return 'N/A';

  var maxEntry = hourlyData.entries.reduce((a, b) => a.value > b.value ? a : b);

  final hour = int.parse(maxEntry.key.split(':')[0]);
  final period = hour >= 12 ? 'PM' : 'AM';
  final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

  return '$displayHour:00 $period';
}

String _getActivitySummary(Map<String, int> hourlyData) {
  if (hourlyData.isEmpty) return 'No scan data available';

  // Identify busy periods
  var morning = 0, afternoon = 0, evening = 0;
  hourlyData.forEach((key, value) {
    final hour = int.parse(key.split(':')[0]);
    if (hour >= 6 && hour < 12)
      morning += value;
    else if (hour >= 12 && hour < 18)
      afternoon += value;
    else if (hour >= 18 && hour < 22) evening += value;
  });

  // Determine busiest period
  final periods = {
    'Morning (6AM-12PM)': morning,
    'Afternoon (12PM-6PM)': afternoon,
    'Evening (6PM-10PM)': evening,
  };

  final busiestPeriod = periods.entries.reduce((a, b) => a.value > b.value ? a : b).key;

  return 'Busiest period: $busiestPeriod';
}

Widget _buildStatCard(
  String title,
  String value,
  String subtitle,
  IconData icon,
  Color color,
) {
  return Expanded(
    child: Container(
        padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: baseColorLight, width: 0.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
    
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              8.pw,
              AppTypography.labelLarge(
                text: title,
                color: Colors.grey[600],
              ),
            ],
          ),
          12.ph,
          AppTypography.headlineMedium(text: value),
          4.ph,
          AppTypography.bodySmall(
            text: subtitle,
            color: Colors.grey[600],
          ),
        ],
      ),
    ),
  );
}

String formatBatchName(String batchId) {
  // Remove BATCH_XX_ prefix first
  final withoutPrefix = batchId.replaceFirst(RegExp(r'BATCH_\d+_'), '');

  // Split by underscore and join with spaces
  final companies = withoutPrefix.split('_');

  // Format each company name for display
  final formattedCompanies = companies.map((company) {
    // Convert to Title Case and handle special cases
    if (company == 'MPOX') return 'MPOX'; // Keep acronyms in uppercase
    if (company == 'MYWATER') return 'MyWater';
    return company.substring(0, 1).toUpperCase() + company.substring(1).toLowerCase();
  });

  // Join with commas and 'and' for the last item
  if (formattedCompanies.length > 1) {
    final allButLast = formattedCompanies.take(formattedCompanies.length - 1);
    final last = formattedCompanies.last;
    return '${allButLast.join(", ")} & $last';
  }

  return formattedCompanies.first;
}

class StatisticCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String subtitle;

  const StatisticCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              8.pw,
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          12.ph,
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          4.ph,
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
