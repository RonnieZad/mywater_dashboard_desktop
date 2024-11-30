import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:mywater_dashboard_revamp/v1/utils/screen_overlay.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:mywater_dashboard_revamp/v1/utils/utils.dart';

Future<String?> uploadImageToImageKit(context, List<int> imageBytes, String fileName) async {
  fluent.showDialog(
      context: context,
      dismissWithEsc: false,
      builder: (context) {
        return fluent.Center(
          child: fluent.Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: fluent.Padding(
              padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [const fluent.ProgressBar(), 20.ph, paragraph(text: 'Loading...')],
              ),
            ),
          ),
        );
      });
  const String publicKey = 'public_CeoHvONj49GaXrgW7OmnViLIaKA=';
  const String privateKey = 'private_OKmciyIxtaflD94CjTWJc76vo9Q=';
  const String uploadEndpoint = 'https://upload.imagekit.io/api/v1/files/upload';

  final Uri uri = Uri.parse(uploadEndpoint);

  final http.MultipartRequest request = http.MultipartRequest('POST', uri);
  request.fields['publicKey'] = publicKey;

  final http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
    'file',
    imageBytes,
    filename: fileName,
  );

  request.files.add(multipartFile);

  final DateTime now = DateTime.now();
  final int expire = now.add(const Duration(minutes: 50)).millisecondsSinceEpoch ~/ 1000;
  final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  final String signature = generateSignature(
    privateKey,
    generateToken(publicKey, privateKey, timestamp),
    expire.toString(),
  );

  request.fields['fileName'] = fileName;
  request.fields['signature'] = signature;
  request.fields['timestamp'] = timestamp;
  request.fields['folder'] = fileName;
  request.fields['expire'] = expire.toString();
  request.fields['token'] = generateToken(publicKey, privateKey, timestamp);

  final http.StreamedResponse response = await request.send();

  final String responseBody = await response.stream.bytesToString();

  if (response.statusCode == 200) {
    ScreenOverlay.showToast(
      context,
      title: 'Success',
      message: 'Image added successfully',
    );
    await Future.delayed(const Duration(seconds: 2));
    print('Image uploaded successfully');
    print('Response: $responseBody');

    return jsonDecode(responseBody)['url'];
  } else {
    ScreenOverlay.showToast(context, title: 'Failed', message: 'Failed to attach image', isError: true);
    print('Error uploading image. Status code: ${response.statusCode}');
    print('Response: $responseBody');

    return null;
  }
}

String geneateSignature(String privateKey, String timestamp) {
  final String signatureRawData = 'timestamp=$timestamp';
  final List<int> privateKeyBytes = utf8.encode(privateKey);
  final Hmac hmacSha256 = Hmac(sha256, privateKeyBytes);
  final Digest hmacDigest = hmacSha256.convert(utf8.encode(signatureRawData));
  final String base64Signature = base64Encode(hmacDigest.bytes);
  return base64Signature;
}

String generateSignature(String apiKey, String token, String expire) {
  final String signatureRawData = '$token$expire';
  final List<int> apiKeyBytes = utf8.encode(apiKey);
  final Hmac hmacSha1 = Hmac(sha1, apiKeyBytes);
  final Digest hmacDigest = hmacSha1.convert(utf8.encode(signatureRawData));
  final String signature = hmacDigest.toString().toLowerCase();
  return signature;
}

String generateToken(String publicKey, String privateKey, String timestamp) {
  final String tokenRawData = '$timestamp:$privateKey';
  final List<int> publicKeyBytes = utf8.encode(publicKey);
  final Hmac hmacSha256 = Hmac(sha256, publicKeyBytes);
  final Digest hmacDigest = hmacSha256.convert(utf8.encode(tokenRawData));
  final String base64Token = base64Encode(hmacDigest.bytes);
  return base64Token;
}

class MediaPicker {
  MediaPicker._();

  static Future<List<String>> pickFile(
    context, {
    bool pickManyFiles = false,
    String? folderName,
  }) async {
    List<String> uploadedImageUrls = [];
    // ScreenOverlay.showLoaderOverlay(duration: 20);
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: pickManyFiles);

    if (result != null) {
      for (PlatformFile file in result.files) {
        String? uploadedImageUrl;
        if (!kIsWeb) {
          File pickedFile = File(file.path!);

          final List<int> imageBytes = await pickedFile.readAsBytes();
          uploadedImageUrl = await uploadImageToImageKit(context, imageBytes, folderName!);
        } else {
          // File pickedFile = File(file.bytes!);
          final imageBytes = file.bytes;

          // uploadedImageUrl =
          //     await uploadImageToImageKit(imageBytes, folderName!);
        }

        if (uploadedImageUrl != null) {
          uploadedImageUrls.add(uploadedImageUrl);
        }
      }
      return uploadedImageUrls;
    } else {
      return [];
    }
  }
}
