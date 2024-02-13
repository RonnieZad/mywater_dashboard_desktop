import 'dart:convert';

import 'package:get/get.dart';
import 'package:mywater_dashboard_revamp/v1/controller/campaign_controller.dart';
import 'package:mywater_dashboard_revamp/v1/utils/screen_overlay.dart';
import 'package:web_socket_client/web_socket_client.dart';

class WebSocketService {
  WebSocketService._();

  static void initiateAndListenConnection(context, String socketServiceUrl) {
    final uri = Uri.parse(socketServiceUrl);
    const backoff = ConstantBackoff(Duration(seconds: 1));
    final socket = WebSocket(uri, backoff: backoff);

    // Listen for changes in the connection state.
    socket.connection.listen((state) {
      print(state);

      if (state is Connected) {
        // Listen for incoming messages.
        socket.messages.listen((message) {
          // attach scan ad channel
          socket.send('{"action": 10, "channel": "scanAdChannel"}');
          if (jsonDecode(message)['action'] == 15 &&
              jsonDecode(message)['channel'] == 'scanAdChannel') {
            processScanAdChannel(context);
            print('message: "$message"');
          }
        });
      } else if (state is Disconnected) {}
    });
  }

  static void processScanAdChannel(context) {
    CampaignController campaignController = Get.find();
    campaignController.getCampaignMetrics();
    campaignController.fetchCampaigns();
    ScreenOverlay.showToast(context, title: 'New add scan', message: 'A user recently scanned this promo add');
  }
}
