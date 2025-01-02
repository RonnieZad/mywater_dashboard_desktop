// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:fluent_ui/fluent_ui.dart' as fluent;
// import 'package:get/get.dart';
// import 'package:mywater_dashboard_revamp/v1/constants/colors.dart';
// import 'package:mywater_dashboard_revamp/v1/controller/campaign_controller.dart';
// import 'package:mywater_dashboard_revamp/v1/utils/typography.dart';

// class _LineChart extends StatefulWidget {
//   const _LineChart({required this.isShowingMainData});

//   final bool isShowingMainData;

//   @override
//   State<_LineChart> createState() => _LineChartState();
// }

// class _LineChartState extends State<_LineChart> {
//   CampaignController campaignController = Get.find();
//   List<String> frequencies = ['Daily', 'Weekly', 'Monthly', 'Yearly'];

//   String frequenctValue = 'Daily';
//   List<FlSpot> spots = [];
//   var totalImpressions = 0;

//   double getTimeValue(String time) {
//     switch (time) {
//       case "0-4 hours":
//         return 0;
//       case "4-8 hours":
//         return 1;
//       case "8-12 hours":
//         return 2;
//       case "12-24 hours":
//         return 3;
//       default:
//         return 0;
//     }
//   }

//   List<String> getBottomTitles = ['0-4 hrs', '4-8 hrs', '8-12 hrs', '12-24 hrs']; // Adjust according to the number of intervals

//   selectedDurationInterval(frequencyValue) {
//     totalImpressions = 0;
//     spots.clear();

//     switch (frequencyValue) {
//       case 'Daily':
//         for (var metric in campaignController.getCampaignMetricsData) {
//           Map<String, dynamic> dailyMetrics = metric.dailyMetrics.toJson();
//           List values = dailyMetrics.values.toList();

//           totalImpressions += values.fold(0, (previousValue, element) => previousValue + int.parse(element.toString()));

//           spots.addAll(values.asMap().entries.map((entry) {
//             return FlSpot(entry.key.toDouble(), entry.value.toDouble());
//           }));
//         }
//         break;
//       // Add cases for other frequencies if needed
//       default:
//     }

//     setState(() {});
//   }

//   late List<LineChartBarData> lineData;
//   List<List<FlSpot>> spotsList = [];

//   @override
//   Widget build(BuildContext context) {
//     spotsList.clear();
//     totalImpressions = 0;

//     for (var metric in campaignController.getCampaignMetricsData) {
//       List values = metric.dailyMetrics.toJson().values.toList();
//       totalImpressions += values.fold(0, (previousValue, element) => previousValue + int.parse(element.toString()));
//       spotsList.add(values.asMap().entries.map((entry) {
//         return FlSpot(entry.key.toDouble(), entry.value.toDouble());
//       }).toList());
//     }

//     lineData = spotsList.asMap().entries.map((entry) {
//       int index = entry.key;
//       List<FlSpot> spots = entry.value;

//       return LineChartBarData(
//         isCurved: false,
//         curveSmoothness: 0,
//         color: campaignPlotColors[index],
//         barWidth: 4,
//         isStrokeCapRound: false,
//         dotData: const FlDotData(show: false),
//         belowBarData: BarAreaData(show: false),
//         spots: spots,
//       );
//     }).toList();

//     return Stack(
//       alignment: Alignment.topRight,
//       children: [
//         LineChart(
//           LineChartData(
//             gridData: gridData,
//             titlesData: FlTitlesData(
//               bottomTitles: AxisTitles(
//                 axisNameWidget: label(text: 'Time frame'),
//                 sideTitles: SideTitles(
//                   showTitles: true,
//                   interval: 1,
//                   getTitlesWidget: ((value, meta) {
//                     return label(text: getBottomTitles[value.toInt()]);
//                   }),
//                 ),
//               ),
//               rightTitles: const AxisTitles(
//                 sideTitles: SideTitles(showTitles: false),
//               ),
//               topTitles: const AxisTitles(
//                 sideTitles: SideTitles(showTitles: false),
//               ),
//               leftTitles: AxisTitles(
//                 sideTitles: leftTitles(),
//               ),
//             ),
//             borderData: borderData,
//             lineBarsData: lineData,
//             minX: 0,
//             maxX: 3,
//             maxY: totalImpressions.toDouble(),
//             minY: 0,
//           ),
//         ),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 heading(text: 'Total Impressions'),
//                 // heading(
//                 //     text: totalImpressions.toString(),
//                 //    ),
//               ],
//             ),
//             fluent.ComboBox<String>(
//                 value: frequenctValue,
//                 items: frequencies.map((e) {
//                   return fluent.ComboBoxItem(
//                     value: e,
//                     child: label(text: e),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     frequenctValue = value!;
//                   });

//                   selectedDurationInterval(frequenctValue);
//                 }),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget leftTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//       fontFamily: 'Poppins',
//       color: Color.fromARGB(255, 196, 193, 235),
//       fontWeight: FontWeight.w500,
//       fontSize: 12,
//     );
//     // String text;
//     return Text(value.toInt().toString(), style: style, textAlign: TextAlign.center);

//     // return Text(text, style: style, textAlign: TextAlign.center);
//   }

//   SideTitles leftTitles() => SideTitles(
//         getTitlesWidget: leftTitleWidgets,
//         showTitles: true,
//         interval: 1,
//         // reservedSize: 40,
//       );

//   FlGridData get gridData => const FlGridData(show: false);

//   FlBorderData get borderData => FlBorderData(
//         show: true,
//         border: const Border(
//           bottom: BorderSide(color: Color(0xff4e4965), width: 2),
//           left: BorderSide(color: Colors.transparent),
//           right: BorderSide(color: Colors.transparent),
//           top: BorderSide(color: Colors.transparent),
//         ),
//       );
// }

// class LineChartSample1 extends StatefulWidget {
//   const LineChartSample1({Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => LineChartSample1State();
// }

// class LineChartSample1State extends State<LineChartSample1> {
//   late bool isShowingMainData;

//   @override
//   void initState() {
//     super.initState();
//     isShowingMainData = true;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _LineChart(isShowingMainData: isShowingMainData);
//   }
// }
