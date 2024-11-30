import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mywater_dashboard_revamp/v1/constants/colors.dart';
import 'package:mywater_dashboard_revamp/v1/controller/auth_controller.dart';
import 'package:mywater_dashboard_revamp/v1/utils/typography.dart';
import 'package:mywater_dashboard_revamp/v1/utils/utils.dart';
import 'package:mywater_dashboard_revamp/v1/widgets/app_button.dart';
import 'package:mywater_dashboard_revamp/v1/widgets/text_box.dart';

class EditCompanyProfile extends StatelessWidget {
  const EditCompanyProfile({
    super.key,
    required this.authController,
  });

  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 500.w,
        child: ListView(padding: EdgeInsets.all(18.w), shrinkWrap: true, children: [
          heading(text: 'Edit Company profile', color: baseColor),
          10.ph,
          paragraph(text: 'Make changes to your public profile', color: Colors.black54),
          30.ph,
          AppTextBox(
            title: 'Company name',
            textEditingController: authController.companyNameController,
            hintText: '',
            icon: fluent.FluentIcons.edit,
          ),
          20.ph,
          AppTextBox(
            title: 'Description',
            textEditingController: authController.companyDescriptionController,
            hintText: '',
            icon: fluent.FluentIcons.edit,
          ),
          20.ph,
          AppTextBox(
            title: 'Email Address',
            textEditingController: authController.emailController,
            hintText: '',
            icon: fluent.FluentIcons.edit,
          ),
          20.ph,
          AppTextBox(
            title: 'Website',
            textEditingController: authController.companyWebsiteController,
            hintText: '',
            icon: fluent.FluentIcons.edit,
          ),
          30.ph,
          AppButton(action: () {}, buttonLabel: 'Save changes')
        ]));
  }
}
