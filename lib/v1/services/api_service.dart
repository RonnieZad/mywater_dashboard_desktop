//  ZOFI CASH MOBILE APP
//
//  Created by Ronald Zad Muhanguzi .
//  2022, Zofi Cash App. All rights reserved.

import 'dart:async';
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;



enum Services { authentication, property, payment, application, network }

class ApiService {
  static final ApiService _instance = ApiService._();

  // using a factory is important
  // because it promises to return _an_object of this type
  // but it doesn't promise to make a new one.
  factory ApiService() {
    return _instance;
  }

  // This named constructor is the "real" constructor
  // It'll be called exactly once, by the static property assignment above
  // it's also private, so it can only be called in this class
  ApiService._();

  static String authApi({version = 'v1', environment = 'staging'}) =>
      'https://mywater-go-grpc-api-gateway.fly.dev/auth';
  static String propertyApi({version = 'v1', environment = 'staging'}) =>
      'https://mywater-go-grpc-api-gateway.fly.dev/property';
  static String applicationApi({version = 'v1', environment = 'staging'}) =>
      'https://mywater-go-grpc-api-gateway.fly.dev/application';
  static String paymentApi({version = 'v1', environment = 'staging'}) =>
      'https://mywater-go-grpc-api-gateway.fly.dev/payment';

  static String networkApi({version = 'v1', environment = 'staging'}) => '';

  static getApi({required Services apiService, required String version}) {
    switch (apiService) {
      case Services.authentication:
        return authApi(version: version);
      case Services.property:
        return propertyApi(version: version);
      case Services.payment:
        return paymentApi(version: version);
      case Services.application:
        return applicationApi(version: version);
      case Services.network:
        return networkApi(version: version);

      default:
    }
  }

  ///Generic get request method, takes params [endpoint] : `String`, [tokenRequired] : `bool`, [apiVersion] : `String`
  ///and returns response if response body is not empty, and gracefully throws error statusCode 500 if any
  ///and catches any network exception that may result
  static Future<Map<String, dynamic>> getRequest(
      {required String endPoint,
      required Services service,
      bool tokenRequired = true,
      apiVersion = 'v1'}) async {
    try {
      // CustomOverlay.showLoaderOverlay(duration: 2);
      String? token = tokenRequired ? GetStorage().read('token') : '';
      // ignore: prefer_typing_uninitialized_variables
      var requestResponse;
      await http
          .get(
              Uri.parse(
                  getApi(apiService: service, version: apiVersion) + endPoint),
              headers: {'Authorization': 'Bearer $token'})
          .then((response) async => requestResponse = {
                'statusCode': response.statusCode,
                'payload':
                    response.body.isNotEmpty ? jsonDecode(response.body) : {},
              })
          .catchError((onError) => requestResponse = {
                'statusCode': 500,
                'payload': {'error': 'Something wrong happened'}
              });
      return requestResponse;
    } on Exception catch (exception) {
      // Errors.displayException(exception);
      return {
        'statusCode': 500,
        'payload': {'error': 'Something wrong happened'}
      };
    }
  }

  ///Generic post request method, takes params [endpoint] : `String`,  [body]: `Map<String, dynamic>`, [tokenRequired] : `bool`, [apiVersion] : `String`
  ///and returns response if response body is not empty, and gracefully throws error statusCode 500 if any
  ///and catches any network exception that may result
  static Future postRequest(
      {required String endPoint,
      required Services service,
      required Map<String?, dynamic>? body,
      bool tokenRequired = true,
      apiVersion = 'v1'}) async {
    try {
      // ScreenOverlay.showLoaderOverlay(duration: 2);
      String? token = tokenRequired ? GetStorage().read('token') : '';

      // ignore: prefer_typing_uninitialized_variables
      var requestResponse;
      await http
          .post(
              Uri.parse(
                  getApi(apiService: service, version: apiVersion) + endPoint),
              body: jsonEncode(body),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json'
              })
          .then((response) async => requestResponse = {
                'statusCode': response.statusCode,
                'payload':
                    response.body.isNotEmpty ? jsonDecode(response.body) : {},
              })
          .catchError((onError) => requestResponse = {
                'statusCode': 500,
                'payload': {'error': 'Something wrong happened'}
              });

      return requestResponse;
    } on Exception catch (exception) {
      // Errors.displayException(exception);
    }
  }

  ///Generic post request method, takes params [endpoint] : `String`,  [body]: `Map<String, dynamic>`, [tokenRequired] : `bool`, [apiVersion] : `String`
  ///and returns response if response body is not empty, and gracefully throws error statusCode 500 if any
  ///and catches any network exception that may result
  static Future putRequest(
      {required String endPoint,
      required Services service,
      required Map<String?, dynamic>? body,
      bool tokenRequired = true,
      apiVersion = 'v1'}) async {
    try {
      // ScreenOverlay.showLoaderOverlay(duration: 2);
      String? token = tokenRequired ? GetStorage().read('token') : '';

      // ignore: prefer_typing_uninitialized_variables
      var requestResponse;
      await http
          .put(
              Uri.parse(
                  getApi(apiService: service, version: apiVersion) + endPoint),
              body: jsonEncode(body),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json'
              })
          .then((response) async => requestResponse = {
                'statusCode': response.statusCode,
                'payload':
                    response.body.isNotEmpty ? jsonDecode(response.body) : {},
              })
          .catchError((onError) => requestResponse = {
                'statusCode': 500,
                'payload': {'error': 'Something wrong happened'}
              });
      print(requestResponse);
      return requestResponse;
    } on Exception catch (exception) {
      // Errors.displayException(exception);
    }
  }

  ///Generic patch request method, takes params [endpoint] : `String`,  [body]: `Map<String, dynamic>`, [tokenRequired] : `bool`, [apiVersion] : `String`
  ///and returns response if response body is not empty, and gracefully throws error statusCode 500 if any
  ///and catches any network exception that may result
  static Future patchRequest(
      {required String endPoint,
      required Services service,
      required Map<String, dynamic> body,
      bool tokenRequired = true,
      apiVersion = 'v1'}) async {
    try {
      // ScreenOverlay.showLoaderOverlay(duration: 3);
      String token = tokenRequired ? GetStorage().read('token') : '';
      // ignore: prefer_typing_uninitialized_variables
      var requestResponse;
      await http
          .patch(
              Uri.parse(
                  getApi(apiService: service, version: apiVersion) + endPoint),
              body: body,
              headers: {'Authorization': 'Bearer $token'})
          .then((response) async => requestResponse = {
                'statusCode': response.statusCode,
                'response':
                    response.body.isNotEmpty ? jsonDecode(response.body) : {},
              })
          .catchError((onError) => requestResponse = {
                'statusCode': 500,
                'response': {'errors': 'Something wrong happened'}
              });
      return requestResponse;
    } on Exception catch (exception) {
      // Errors.displayException(exception);
    }
  }

  ///Generic delete request method, takes params [endpoint] : `String`, [tokenRequired] : `bool`, [apiVersion] : `String`
  ///and returns response if response body is not empty, and gracefully throws error statusCode 500 if any
  ///and catches any network exception that may result
  static Future deleteRequest(
      {required String endPoint,
      required Services service,
      bool tokenRequired = true,
      apiVersion = 'v1'}) async {
    try {
      // ScreenOverlay.showLoaderOverlay(duration: 3);
      String? token = tokenRequired ? GetStorage().read('token') : '';
      // ignore: prefer_typing_uninitialized_variables
      var requestResponse;
      await http
          .delete(
              Uri.parse(
                  getApi(apiService: service, version: apiVersion) + endPoint),
              headers: {'Authorization': 'Bearer $token'})
          .then((response) async => requestResponse = {
                'statusCode': response.statusCode,
                'response':
                    response.body.isNotEmpty ? jsonDecode(response.body) : {},
              })
          .catchError((onError) => requestResponse = {
                'statusCode': 500,
                'response': {'errors': 'Something wrong happened'}
              });
      return requestResponse;
    } on Exception catch (exception) {
      // Errors.displayException(exception);
    }
  }

  static Stream<Map<String, dynamic>> getRequestStream(
      {required String endPoint,
      required Services service,
      bool tokenRequired = true,
      apiVersion = 'v1'}) {
    final StreamController<Map<String, dynamic>> _controller =
        StreamController<Map<String, dynamic>>();
    String token = tokenRequired ? GetStorage().read('token') : '';

    _getData(endPoint, token, service, apiVersion)
        .then((data) => _controller.add(data))
        .catchError((error) => _controller.addError(error))
        .whenComplete(() => _controller.close());

    return _controller.stream;
  }

  static Future<Map<String, dynamic>> _getData(String endPoint, String token,
      Services service, String apiVersion) async {
    try {
      var requestResponse;
      await http
          .get(
              Uri.parse(
                  getApi(apiService: service, version: apiVersion) + endPoint),
              headers: {'Authorization': 'Bearer $token'})
          .then((response) async => requestResponse = {
                'statusCode': response.statusCode,
                'response':
                    response.body.isNotEmpty ? jsonDecode(response.body) : {},
              })
          .catchError((onError) => requestResponse = {
                'statusCode': 500,
                'response': {'errors': 'Something wrong happened'}
              });
      return requestResponse;
    } on Exception catch (exception) {
      // Errors.displayException(exception);
      return {
        'statusCode': 500,
        'response': {'errors': 'Something wrong happened'}
      };
    }
  }

  //STEP2: Add this function in main function in main.dart file and add incoming data to the stream
  // static void connectAndListen({required bool envTesting, bool addData = false, data}) async {
  //   var userAccountID = '93790b76-3ea7-460b-a59f-56a60dc306d3';
  //   // GetStorage().read('account_id');
  //   final channel = IOWebSocketChannel.connect('ws://orca-app-3b3ou.ondigitalocean.app');

  //   channel.stream.listen((message) {
  //     print(message);
  //     // if (message.contains("daz")) {
  //     //   ScreenOverlay.showToast(context,context,jsonDecode(message)['status'], Colors.white, Colors.black);

  //     //   if (jsonDecode(message)['metadata']['account_id'] == userAccountID) {
  //     //     ScreenOverlay.showToast(context,context,jsonDecode(message)['status'], Colors.white, Colors.black);
  //     //   }
  //     // }
  //   });

  //   if (addData) {
  //     channel.sink.add(jsonEncode(data));
  //   }
  // }
}
