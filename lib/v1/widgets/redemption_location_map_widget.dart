import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:mywater_dashboard_revamp/v1/constants/colors.dart';
import 'package:mywater_dashboard_revamp/v1/models/redemption_location_model.dart';
import 'package:mywater_dashboard_revamp/v1/screens/app_dashboard.dart';
import 'package:mywater_dashboard_revamp/v1/services/firestore_service.dart';
import 'package:mywater_dashboard_revamp/v1/utils/utils.dart';
import 'package:mywater_dashboard_revamp/v1/widgets/screen_overlay.dart';

class RedemptionLocationMap extends StatefulWidget {
  const RedemptionLocationMap({super.key});

  @override
  State<RedemptionLocationMap> createState() => _RedemptionLocationMapState();
}

class _RedemptionLocationMapState extends State<RedemptionLocationMap> {
  final MapController _mapController = MapController();
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RedemptionLocation>>(
      stream: _firestoreService.getRedemptionLocations(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final locations = snapshot.data!;
        final markers = locations
            .map((loc) => Marker(
                  point: LatLng(loc.latitude, loc.longitude),
                  width: 30,
                  height: 30,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ))
            .toList();

        // Calculate center point based on markers
        final center = _calculateCenter(locations);

        return Container(
          height: 600,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: baseColorLight, width: 0.4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: center,
                initialZoom: 12,
                maxZoom: 18,
                minZoom: 3,
              ),
              children: [
                TileLayer(
                  tileProvider: CancellableNetworkTileProvider(),
                  urlTemplate: 'https://api.mapbox.com/styles/v1/ronzad/clglfccmb00ae01qtb0fy495p/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoicm9uemFkIiwiYSI6ImNsZ2wzcHZhNjBqdmMzZnFzcnZxY29lNGUifQ.YMwS_jvPBGE_bwwS9TApXA',
                ),
                MarkerClusterLayerWidget(
                  options: MarkerClusterLayerOptions(
                    maxClusterRadius: 45,
                    size: const Size(40, 40),
                    markers: markers,
                    builder: (context, markers) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue,
                        ),
                        child: Center(
                          child: Text(
                            // Always show count, even for single markers
                            markers.length.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                    // Add these options for more consistent clustering
                    zoomToBoundsOnClick: true,
                    centerMarkerOnClick: true,
                    showPolygon: false, // Disable polygon to keep UI clean
                    spiderfyCircleRadius: 60,
                    spiderfySpiralDistanceMultiplier: 2,
                    onMarkerTap: (marker) {
                      final redemption = locations.firstWhere((loc) => loc.latitude == marker.point.latitude && loc.longitude == marker.point.longitude);

                      ScreenAppOverlay.showAppDialogWindow(context,
                          body: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppTypography.titleLarge(text: 'Scan Details'),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue.withOpacity(0.1),
                                    child: const Icon(
                                      Icons.qr_code_scanner,
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                  ),
                                  title: AppTypography.bodyLarge(
                                    text: formatBatchName(redemption.batchId),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  subtitle: AppTypography.bodyMedium(
                                    text: formatDateTime(redemption.timestamp),
                                    color: Colors.grey[600],
                                  ),
                                ),
                                15.ph,
                                _buildInfoRow(
                                  'Location',
                                  redemption.location.isEmpty ? 'Unknown Location' : redemption.location,
                                  Icons.location_on,
                                ),
                                10.ph,
                                _buildInfoRow(
                                  'Phone',
                                  redemption.phoneNumber,
                                  Icons.phone,
                                ),
                                10.ph,
                                _buildInfoRow(
                                  'Gender',
                                  redemption.gender,
                                  Icons.person,
                                ),
                                15.ph,
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(redemption.rewardStatus).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              _getStatusIcon(redemption.rewardStatus),
                                              color: _getStatusColor(redemption.rewardStatus),
                                              size: 20,
                                            ),
                                            8.pw,
                                            AppTypography.bodyMedium(
                                              text: '${redemption.rewardStatus.toUpperCase()} - ${redemption.rewardAmount} points',
                                              color: _getStatusColor(redemption.rewardStatus),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ));
                    },
                    onClusterTap: (cluster) {
                      // Extract all redemption locations in this cluster
                      final clusterPoints = cluster.markers.map((marker) {
                        return locations.firstWhere((loc) => loc.latitude == marker.point.latitude && loc.longitude == marker.point.longitude);
                      }).toList();
                      ScreenAppOverlay.showAppDialogWindow(context,
                          body: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppTypography.titleLarge(text: 'Scan Details'),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                                10.ph,
                                AppTypography.titleMedium(
                                  text: '${cluster.markers.length} scans in this area',
                                  color: Colors.grey[600],
                                ),
                                15.ph,
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: clusterPoints.length,
                                    itemBuilder: (context, index) {
                                      final point = clusterPoints[index];
                                      return Card(
                                        margin: const EdgeInsets.only(bottom: 8),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.blue.withOpacity(0.1),
                                            child: const Icon(
                                              Icons.qr_code_scanner,
                                              color: Colors.blue,
                                              size: 20,
                                            ),
                                          ),
                                          title: AppTypography.bodyLarge(
                                            text: formatBatchName(point.batchId),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              AppTypography.bodyMedium(
                                                text: formatTimeAgo(point.timestamp),
                                                color: Colors.grey[600],
                                              ),
                                              if (point.rewardStatus == 'pending')
                                                Container(
                                                  margin: const EdgeInsets.only(top: 4),
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: AppTypography.bodySmall(
                                                    text: 'Pending Reward',
                                                    color: Colors.black,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          trailing: AppTypography.bodySmall(
                                            text: '${point.rewardAmount} pts',
                                            color: Colors.green,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ));
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String formatTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey[600],
        ),
        12.pw,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTypography.bodyLarge(
              text: label,
              color: Colors.grey[600],
            ),
            4.ph,
            AppTypography.bodyMedium(
              text: value,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.timer;
      case 'completed':
        return Icons.check_circle;
      case 'failed':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  String formatDateTime(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  LatLng _calculateCenter(List<RedemptionLocation> locations) {
    if (locations.isEmpty) {
      return const LatLng(0.3476, 32.5825); // Kampala coordinates as default
    }

    double sumLat = 0;
    double sumLng = 0;

    for (var location in locations) {
      sumLat += location.latitude;
      sumLng += location.longitude;
    }

    return LatLng(
      sumLat / locations.length,
      sumLng / locations.length,
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
