import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:get_storage/get_storage.dart';
import 'package:mywater_dashboard_revamp/v1/utils/utils.dart';
import 'package:octo_image/octo_image.dart';

class OctoBlurHashFix {
  static OctoPlaceholderBuilder placeHolder(String hash, {BoxFit? fit}) {
    return (context) => SizedBox.expand(
          child: Image(
            image: BlurHashImage(hash),
            fit: fit ?? BoxFit.cover,
          ),
        );
  }
}

class CompanyProfile extends StatefulWidget {
  const CompanyProfile({super.key});

  @override
  State<CompanyProfile> createState() => CompanyProfileState();
}

class CompanyProfileState extends State<CompanyProfile> {
  Map<String, dynamic> profileData = GetStorage().read('partnerData');

  final contextController = fluent.FlyoutController();
  final contextAttachKey = GlobalKey();
  Color? selectedDistrict;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20.h, right: 20.0, left: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headingBig(text: 'Company Profile'),
          6.ph,
          paragraphSmallItalic(
              text:
                  'This is a summary of your company profile and the services you offer.',
              color: Colors.grey),
          60.ph,
          SizedBox(
            height: 200.w,
            width: 200.w,
            child: OctoImage(
              placeholderBuilder:
                  OctoBlurHashFix.placeHolder('LEHV6nWB2yk8pyo0adR*.7kCMdnj'),
              errorBuilder: OctoError.icon(color: Colors.red),
              image: CachedNetworkImageProvider(
                profileData['company_logo'],
              ),
              fit: BoxFit.cover,
            ),
          ),
          20.ph,
          subHeading(text: '${profileData['company_name']}'),
          10.ph,
          paragraphSmall(
              text: profileData['company_description'], color: Colors.grey),
          20.ph,
          subHeading(text: 'Contact Information'),
          10.ph,
          paragraphSmallItalic(text: 'Email: ${profileData['company_email']}'),
          10.ph,
          paragraphSmallItalic(text: 'Phone: +${profileData['company_phone']}'),
          40.ph,
          SizedBox(
            height: 45.h,
            child: fluent.FilledButton(
              child: fluent.Center(
                  child: label(
                text: 'Get Support',
                color: Colors.white,
                fontSize: 10.sp,
              )),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
