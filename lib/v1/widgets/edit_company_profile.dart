import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:mywater_dashboard_revamp/v1/constants/colors.dart';
import 'package:mywater_dashboard_revamp/v1/controller/auth_controller.dart';
import 'package:mywater_dashboard_revamp/v1/services/auth_service.dart';
import 'package:mywater_dashboard_revamp/v1/utils/screen_overlay.dart';
import 'package:mywater_dashboard_revamp/v1/utils/utils.dart';
import 'package:mywater_dashboard_revamp/v1/widgets/app_button.dart';
import 'package:mywater_dashboard_revamp/v1/widgets/text_box.dart';

class EditCompanyProfile extends fluent.StatefulWidget {
  const EditCompanyProfile({
    super.key,
    required this.authController,
  });

  final AuthController authController;

  @override
  fluent.State<EditCompanyProfile> createState() => _EditCompanyProfileState();
}

class _EditCompanyProfileState extends fluent.State<EditCompanyProfile> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  bool _validateInputs() {
    if (widget.authController.companyNameController.text.trim().isEmpty) {
      _showError('Company name is required');
      return false;
    }

    if (widget.authController.companyDescriptionController.text.trim().isEmpty) {
      _showError('Company description is required');
      return false;
    }

    if (!_isValidEmail(widget.authController.emailController.text.trim())) {
      _showError('Please enter a valid email address');
      return false;
    }

    if (!_isValidUrl(widget.authController.companyWebsiteController.text.trim())) {
      _showError('Please enter a valid website URL');
      return false;
    }

    return true;
  }

  void _showError(String message) {
    ScreenOverlay.showToast(
      context,
      title: 'Validation Error',
      message: message,
      isWarning: true,
    );
  }

  bool _isValidEmail(String email) {
    // This regex allows:
    // - Local part: letters, numbers, and common special characters
    // - Domain part: letters, numbers, dots, and hyphens
    // - TLD: can be any length (2 or more characters)
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      caseSensitive: false,
    ).hasMatch(email);
  }

  bool _isValidUrl(String url) {
    return url.isNotEmpty && (url.startsWith('http://') || url.startsWith('https://') || url.startsWith('www.'));
  }

  Future<void> _updateProfile() async {
    if (!_validateInputs()) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw 'User not authenticated';

      await _authService.updatePartnerProfile(
        partnerId: user.uid,
        data: {
          'companyName': widget.authController.companyNameController.text.trim(),
          'description': widget.authController.companyDescriptionController.text.trim(),
          'email': widget.authController.emailController.text.trim(),
          'website': widget.authController.companyWebsiteController.text.trim(),
        },
      );

      if (mounted) {
        Navigator.pop(context);
        ScreenOverlay.showToast(
          context,
          title: 'Success',
          message: 'Profile updated successfully',
        );
      }
    } catch (e) {
      ScreenOverlay.showToast(
        context,
        title: 'Error',
        message: e.toString(),
        isWarning: true,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 500,
        child: ListView(padding: const EdgeInsets.all(18), shrinkWrap: true, children: [
          AppTypography.titleMedium(text: 'Edit Company profile', color: baseColor),
          10.ph,
          AppTypography.titleSmall(text: 'Make changes to your public profile', color: Colors.black54),
          30.ph,
          AppTextBox(
            title: 'Company name',
            textEditingController: widget.authController.companyNameController,
            hintText: '',
            icon: fluent.FluentIcons.edit,
          ),
          20.ph,
          AppTextBox(
            title: 'Description',
            textEditingController: widget.authController.companyDescriptionController,
            hintText: '',
            icon: fluent.FluentIcons.edit,
          ),
          20.ph,
          AppTextBox(
            title: 'Email Address',
            textEditingController: widget.authController.emailController,
            hintText: '',
            icon: fluent.FluentIcons.edit,
          ),
          20.ph,
          AppTextBox(
            title: 'Website',
            textEditingController: widget.authController.companyWebsiteController,
            hintText: '',
            icon: fluent.FluentIcons.edit,
          ),
          30.ph,
          SizedBox(
            width: double.infinity,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : AppButton(
                    action: _updateProfile,
                    buttonLabel: 'Save Changes',
                  ),
          ),
        ]));
  }
}
