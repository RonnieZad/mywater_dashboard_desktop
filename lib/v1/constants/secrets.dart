import 'package:get_storage/get_storage.dart';

String bearerToken = 'Bearer ${GetStorage().read('bearer_token')}';
