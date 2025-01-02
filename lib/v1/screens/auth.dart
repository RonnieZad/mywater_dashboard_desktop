import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mywater_dashboard_revamp/v1/constants/colors.dart';
import 'package:mywater_dashboard_revamp/v1/controller/auth_controller.dart';
import 'package:mywater_dashboard_revamp/v1/models/authentication_model.dart';
import 'package:mywater_dashboard_revamp/v1/services/auth_service.dart';
import 'package:mywater_dashboard_revamp/v1/utils/file_picker.dart';
import 'package:mywater_dashboard_revamp/v1/utils/screen_overlay.dart';
import 'package:mywater_dashboard_revamp/v1/utils/utils.dart';
import 'package:mywater_dashboard_revamp/v1/widgets/app_button.dart';
import 'package:mywater_dashboard_revamp/v1/widgets/text_box.dart';
import 'package:mywater_dashboard_revamp/v1/widgets/ui_helpers.dart';
import 'package:octo_image/octo_image.dart';

// class AuthScreen extends StatefulWidget {
//   const AuthScreen({super.key});

//   @override
//   State<AuthScreen> createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen> {
//   AuthController authController = Get.put(AuthController());
//   bool oldUser = true;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const fluent.Color.fromARGB(255, 240, 239, 239),
//       body: Row(
//         children: [
//           Container(
//             margin: const EdgeInsets.symmetric(vertical: 100),
//             padding: const EdgeInsets.symmetric(horizontal: 70),
//             height: double.infinity,
//             width: 0.5,
//             child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
//               SvgPicture.asset(
//                 'assets/images/app_logo.svg',
//                 width: 180,
//                 color: const Color.fromRGBO(14, 74, 111, 1),
//               ),
//               20.ph,
//               AppTypography.bodyMedium(text: 'Reinventing Advertising With Purpose'),
//               const Spacer(),
//               if (oldUser) ...[
//                 AppTextBox(title: 'Enter company mail', textEditingController: authController.emailController, hintText: 'eg info@example.com', icon: fluent.FluentIcons.mail),
//                 20.ph,
//                 fluent.InfoLabel(
//                   label: 'Enter Password',
//                   labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
//                   child: fluent.PasswordBox(
//                     controller: authController.passwordController,
//                     leadingIcon: const fluent.Padding(
//                       padding: EdgeInsets.only(left: 20),
//                       child: Icon(
//                         fluent.FluentIcons.password_field,
//                         color: Colors.black54,
//                         size: 13,
//                       ),
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//                     placeholder: 'Password',
//                     revealMode: fluent.PasswordRevealMode.peek,
//                     style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.black54),
//                   ),
//                 ),
//               ] else ...[
//                 // 20.ph,
//                 Obx(() {
//                   return fluent.SizedBox(
//                     height: 500,
//                     child: fluent.Scrollbar(
//                       thumbVisibility: true,
//                       child: ListView(
//                         padding: const EdgeInsets.only(right: 15),
//                         children: [
//                           if (authController.artworkFile.value!.files.isNotEmpty) ...[
//                             CircleAvatar(
//                               radius: 60,
//                               child: kIsWeb
//                                   ? Image.memory(
//                                       authController.artworkFile.value!.files.first.bytes!,
//                                       fit: BoxFit.cover,
//                                     )
//                                   : Image.file(
//                                       File(authController.artworkFile.value!.files.first.path!),
//                                       fit: BoxFit.cover,
//                                     ),
//                             ),
//                             20.ph,
//                           ],
//                           SizedBox(
//                             height: 45,
//                             child: fluent.Button(
//                               child: fluent.Center(
//                                   child: AppTypography.labelMedium(
//                                 text: 'Attach Company Logo',
//                                 color: Colors.black54,
//                               )),
//                               onPressed: () async {
//                                 authController.artworkFile.value = await FilePicker.platform.pickFiles();
//                               },
//                             ),
//                           ),
//                           20.ph,
//                           AppTextBox(title: 'Enter company mail', textEditingController: authController.emailController, hintText: 'eg info@example.com', icon: fluent.FluentIcons.mail),
//                           20.ph,
//                           AppTextBox(title: 'Enter company name', textEditingController: authController.companyNameController, hintText: 'eg Acme Ltd', icon: fluent.FluentIcons.text_field),
//                           20.ph,
//                           AppTextBox(title: 'Enter company description', textEditingController: authController.companyDescriptionController, hintText: 'eg We are a leading company in the region', icon: fluent.FluentIcons.text_field),
//                           20.ph,
//                           AppTextBox(title: 'Enter company phone number', textEditingController: authController.phoneNumberController, hintText: 'eg +256 700 000 000', icon: fluent.FluentIcons.phone),
//                           20.ph,
//                           AppTextBox(title: 'Enter company website', textEditingController: authController.companyWebsiteController, hintText: 'eg www.acme.com', icon: fluent.FluentIcons.globe),
//                           20.ph,
//                           fluent.InfoLabel(
//                             label: 'Enter Password',
//                             labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
//                             child: fluent.PasswordBox(
//                               controller: authController.passwordController,
//                               leadingIcon: const fluent.Padding(
//                                 padding: EdgeInsets.only(left: 20),
//                                 child: Icon(
//                                   fluent.FluentIcons.password_field,
//                                   color: Colors.black54,
//                                   size: 13,
//                                 ),
//                               ),
//                               padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//                               placeholder: 'Password',
//                               revealMode: fluent.PasswordRevealMode.peek,
//                               style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.black54),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 })
//               ],
//               20.ph,
//               AppButton(
//                 action: () async {
//                   String? uploadedImageUrl;

//                   if (!oldUser) {
//                     if (authController.artworkFile.value!.files.isNotEmpty) {
//                       for (PlatformFile file in authController.artworkFile.value!.files) {
//                         if (!kIsWeb) {
//                           File pickedFile = File(file.path!);

//                           final List<int> imageBytes = await pickedFile.readAsBytes();
//                           uploadedImageUrl = await uploadImageToImageKit(context, imageBytes, 'myWaterCompanyLogos');
//                         } else {
//                           Uint8List? pickedFile = file.bytes;

//                           uploadedImageUrl = await uploadImageToImageKit(context, pickedFile!.toList(), 'myWaterCompanyLogos');
//                         }
//                       }
//                     }
//                   }
//                   AuthenticationModel authenticationModel = AuthenticationModel(
//                     logoUrl: uploadedImageUrl,
//                     role: 'advertiser',
//                     email: authController.emailController.text,
//                     password: authController.passwordController.text,
//                     phoneNumber: authController.phoneNumberController.text,
//                     companyName: authController.companyNameController.text,
//                     description: authController.companyDescriptionController.text,
//                     website: authController.companyWebsiteController.text,
//                   );

//                   if (oldUser) {
//                     if (authController.emailController.text.isEmpty) {
//                       ScreenOverlay.showToast(context, title: 'Missing Field', message: 'Email is required', isWarning: true);
//                     } else if (authController.passwordController.text.isEmpty) {
//                       ScreenOverlay.showToast(context, title: 'Missing Field', message: 'Password is required', isWarning: true);
//                     } else {
//                       authController.loginPartnerAccount(context, authModel: authenticationModel);
//                     }
//                   } else {
//                     if (authController.emailController.text.isEmpty) {
//                       ScreenOverlay.showToast(context, title: 'Missing Field', message: 'Email is required', isWarning: true);
//                     } else if (authController.companyNameController.text.isEmpty) {
//                       ScreenOverlay.showToast(context, title: 'Missing Field', message: 'Company Name is required', isWarning: true);
//                     } else if (authController.companyDescriptionController.text.isEmpty) {
//                       ScreenOverlay.showToast(context, title: 'Missing Field', message: 'Company Description is required', isWarning: true);
//                     } else if (authController.phoneNumberController.text.isEmpty) {
//                       ScreenOverlay.showToast(context, title: 'Missing Field', message: 'Phone Number is required', isWarning: true);
//                     } else if (authController.companyWebsiteController.text.isEmpty) {
//                       ScreenOverlay.showToast(context, title: 'Missing Field', message: 'Company Website is required', isWarning: true);
//                     } else if (authController.passwordController.text.isEmpty) {
//                       ScreenOverlay.showToast(context, title: 'Missing Field', message: 'Password is required', isWarning: true);
//                     } else {
//                       authController.createPartnerAccount(context, authModel: authenticationModel);
//                     }
//                   }
//                 },
//                 buttonLabel: oldUser ? 'Sign in' : 'Create Account',
//               ),
//               20.ph,
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   fluent.HyperlinkButton(
//                     onPressed: () {
//                       setState(() {
//                         oldUser = !oldUser;
//                       });
//                     },
//                     child: AppTypography.labelMedium(
//                       text: oldUser ? 'Create Account' : 'Already have an account?',
//                       color: Colors.black,
//                     ),
//                   ),
//                   if (oldUser) ...[
//                     20.pw,
//                     fluent.HyperlinkButton(
//                       onPressed: () {},
//                       child: AppTypography.labelMedium(
//                         text: 'Forgot Password?',
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//               if (oldUser) ...[
//                 const Spacer(),
//                 AppTypography.bodySmall(text: '2024 All rights reserved, MyWater Agency', color: Colors.black54
//                     // color: baseColor,
//                     ),
//               ],
//             ]),
//           ),
//           Container(
//               decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, stops: const [0.1, 0.9], colors: [baseColor, baseColorLight])),
//               height: double.infinity,
//               width: 0.5,
//               child: Stack(children: [
//                 Positioned(
//                   bottom: 0,
//                   right: -100,
//                   left: 100.0,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(2),
//                     child: SizedBox(
//                       width: 900,
//                       height: 600,
//                       child: OctoImage(
//                         placeholderBuilder: OctoBlurHashFix.placeHolder('LEHV6nWB2yk8pyo0adR*.7kCMdnj'),
//                         errorBuilder: OctoError.icon(color: Colors.red),
//                         image: const CachedNetworkImageProvider(
//                           'https://ik.imagekit.io/ecjzuksxj/man-holding-mywater-bottle.JPG?updatedAt=1703765623937',
//                         ),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 100,
//                   right: 100,
//                   left: 100.0,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       AppTypography.labelMedium(
//                         text: 'My Water is a pioneering Ad-Tech startup in Uganda, revolutionizing advertising solutions for companies',
//                         color: Colors.white,
//                       ),
//                       20.ph,
//                       AppTypography.bodyMedium(
//                         text: ' - Don Casey, CEO MyWater',
//                         color: Colors.white54,
//                         // fontSize: 14,
//                       ),
//                     ],
//                   ),
//                 ),
//               ])),
//         ],
//       ),
//     );
//   }
// }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  final AuthController authController = Get.put(AuthController());
  bool isLogin = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void dispose() {
    _clearForm();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  // ... [Rest of the implementation would include the helper methods and marketing panel widgets]

  Widget _buildAuthPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(4, 0),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          70.ph,
          // Logo and Tagline
          _buildHeaderSection(),
          const SizedBox(height: 60),

          // Welcome Text
          FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTypography.headlineMedium(
                  text: isLogin ? 'Welcome back' : 'Get started',
                  color: Colors.black87,
                ),
                const SizedBox(height: 8),
                AppTypography.bodyMedium(
                  text: isLogin ? 'Enter your details to access your account' : 'Create your account to start advertising',
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Auth Form
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isLogin ? _buildLoginForm() : _buildSignupForm(),
            ),
          ),

          // Auth Actions
          _buildAuthActions(),
          const SizedBox(height: 40),

          if (isLogin) _buildFooter(),
          70.ph,
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: SvgPicture.asset(
            'assets/images/app_logo.svg',
            width: 190,
            color: const Color(0xFF0E4A6F),
          ),
        ),
        const SizedBox(height: 16),
        AppTypography.bodyMedium(
          text: 'Reinventing Advertising With Purpose',
          color: Colors.grey[600],
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField(
          controller: authController.emailController,
          label: 'Company Email',
          hint: 'your@company.com',
          icon: fluent.FluentIcons.mail,
          validator: _validateEmail,
        ),
        const SizedBox(height: 24),
        _buildPasswordField(),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTypography.labelLarge(
          text: label,
          color: Colors.grey[800],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400], fontFamily: 'Poppins', fontSize: 14),
              prefixIcon: Icon(icon, size: 20, color: Colors.grey[400]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMarketingPanel() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0E4A6F),
            const Color(0xFF0E4A6F).withOpacity(0.8),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background Pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: CustomPaint(
                painter: GridPatternPainter(),
              ),
            ),
          ),
          // Marketing Content
          _buildMarketingContent(),
          // Bottom Image
          _buildMarketingImage(),
        ],
      ),
    );
  }

  Future<void> _pickCompanyLogo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      authController.artworkFile.value = result;
    }
  }

  // Marketing Panel Components
  Widget _buildMarketingImage() {
    return Positioned(
      bottom: 0,
      right: -100,
      left: 100,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: SizedBox(
          width: 900,
          height: 800,
          child: OctoImage(
            placeholderBuilder: OctoBlurHashFix.placeHolder('LEHV6nWB2yk8pyo0adR*.7kCMdnj'),
            errorBuilder: OctoError.icon(color: Colors.red),
            image: const CachedNetworkImageProvider(
              'https://ik.imagekit.io/ecjzuksxj/man-holding-mywater-bottle.JPG?updatedAt=1703765623937',
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildMarketingContent() {
    return Positioned(
      top: 70,
      right: 100,
      left: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTypography.labelLarge(
            text: 'My Water is a pioneering Ad-Tech startup in Uganda, '
                'revolutionizing advertising solutions for companies',
            color: Colors.white,
          ),
          const SizedBox(height: 20),
          AppTypography.bodyLarge(
            text: ' - Don Casey, CEO MyWater',
            color: Colors.white54,
          ),
        ],
      ),
    );
  }

  // Authentication Handling
Future<void> _handleAuthSubmit() async {
  if (!_validateForm()) return;

  String? uploadedImageUrl;
  if (!isLogin) {
    uploadedImageUrl = await _uploadCompanyLogo();
  }

  final authModel = AuthenticationModel(
    logoUrl: uploadedImageUrl,
    role: 'advertiser',
    email: authController.emailController.text,
    password: authController.passwordController.text,
    phoneNumber: authController.phoneNumberController.text,
    companyName: authController.companyNameController.text,
    description: authController.companyDescriptionController.text,
    website: authController.companyWebsiteController.text,
  );

  await AuthService().handleAuthentication(
    context: context,
    authModel: authModel,
    isLogin: isLogin,
  );
}

  bool _validateForm() {
    if (authController.emailController.text.isEmpty) {
      _showError('Email is required');
      return false;
    }

    if (authController.passwordController.text.isEmpty) {
      _showError('Password is required');
      return false;
    }

    if (!isLogin) {
      if (authController.companyNameController.text.isEmpty) {
        _showError('Company Name is required');
        return false;
      }
      if (authController.companyDescriptionController.text.isEmpty) {
        _showError('Company Description is required');
        return false;
      }
      if (authController.phoneNumberController.text.isEmpty) {
        _showError('Phone Number is required');
        return false;
      }
      if (authController.companyWebsiteController.text.isEmpty) {
        _showError('Company Website is required');
        return false;
      }
    }

    return true;
  }

  Future<String?> _uploadCompanyLogo() async {
    if (authController.artworkFile.value?.files.isEmpty ?? true) return null;

    final file = authController.artworkFile.value!.files.first;
    try {
      if (!kIsWeb) {
        final pickedFile = File(file.path!);
        final imageBytes = await pickedFile.readAsBytes();
        return await uploadImageToImageKit(
          context,
          imageBytes,
          'myWaterCompanyLogos',
        );
      } else {
        return await uploadImageToImageKit(
          context,
          file.bytes!.toList(),
          'myWaterCompanyLogos',
        );
      }
    } catch (e) {
      _showError('Failed to upload company logo');
      return null;
    }
  }

  void _showError(String message) {
    ScreenOverlay.showToast(
      context,
      title: 'Missing Field',
      message: message,
      isWarning: true,
    );
  }

  Future<void> _handleForgotPassword() async {
    // Implement forgot password logic
    ScreenOverlay.showToast(
      context,
      title: 'Coming Soon',
      message: 'Password reset functionality will be available soon',
    );
  }

  // Form field validation helpers
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    // Add your phone validation logic
    return null;
  }

  String? _validateWebsite(String? value) {
    if (value == null || value.isEmpty) {
      return 'Website is required';
    }
    if (!value.contains('.')) {
      return 'Please enter a valid website';
    }
    return null;
  }

  // Clear form fields
  void _clearForm() {
    authController.emailController.clear();
    authController.passwordController.clear();
    authController.companyNameController.clear();
    authController.companyDescriptionController.clear();
    authController.phoneNumberController.clear();
    authController.companyWebsiteController.clear();
    authController.artworkFile.value = null;
  }

  Widget _buildSignupForm() {
    return Obx(() => SizedBox(
          height: 500,
          child: fluent.Scrollbar(
            thumbVisibility: true,
            child: ListView(
              padding: const EdgeInsets.only(right: 15),
              children: [
                _buildCompanyLogoUpload(),
                const SizedBox(height: 20),
                _buildSignupFields(),
              ],
            ),
          ),
        ));
  }

  Widget _buildCompanyLogoUpload() {
    if (authController.artworkFile.value?.files.isEmpty ?? true) {
      return _buildLogoUploadButton();
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey[100],
          child: _buildLogoPreview(),
        ),
        const SizedBox(height: 20),
        _buildLogoUploadButton(),
      ],
    );
  }

  Widget _buildLogoPreview() {
    final file = authController.artworkFile.value!.files.first;
    return ClipOval(
      child: kIsWeb ? Image.memory(file.bytes!, fit: BoxFit.cover) : Image.file(File(file.path!), fit: BoxFit.cover),
    );
  }

  Widget _buildLogoUploadButton() {
    return SizedBox(
      height: 45,
      child: fluent.Button(
        onPressed: _pickCompanyLogo,
        child: Center(
          child: AppTypography.labelLarge(
            text: 'Upload Company Logo',
            color: Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget _buildSignupFields() {
    return Column(
      children: [
        AppTextBox(
          title: 'Company Email',
          textEditingController: authController.emailController,
          hintText: 'eg info@example.com',
          icon: fluent.FluentIcons.mail,
        ),
        const SizedBox(height: 20),
        AppTextBox(
          title: 'Company Name',
          textEditingController: authController.companyNameController,
          hintText: 'eg Acme Ltd',
          icon: fluent.FluentIcons.build,
        ),
        const SizedBox(height: 20),
        AppTextBox(
          title: 'Company Description',
          textEditingController: authController.companyDescriptionController,
          hintText: 'Brief description of your company',
          icon: fluent.FluentIcons.open_with_mirrored,
        ),
        const SizedBox(height: 20),
        AppTextBox(
          title: 'Phone Number',
          textEditingController: authController.phoneNumberController,
          hintText: '+256 700 000 000',
          icon: fluent.FluentIcons.phone,
        ),
        const SizedBox(height: 20),
        AppTextBox(
          title: 'Website',
          textEditingController: authController.companyWebsiteController,
          hintText: 'www.example.com',
          icon: fluent.FluentIcons.globe,
        ),
        const SizedBox(height: 20),
        _buildPasswordField(),
      ],
    );
  }

  Widget _buildPasswordField() {
    return fluent.InfoLabel(
      label: 'Enter Password',
      labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500),
      child: fluent.PasswordBox(
        controller: authController.passwordController,
        leadingIcon: const fluent.Padding(
          padding: EdgeInsets.only(left: 20),
          child: Icon(
            fluent.FluentIcons.password_field,
            color: Colors.black54,
            size: 13,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 20,
        ),
        placeholder: 'Password',
        revealMode: fluent.PasswordRevealMode.peek,
        style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.black54),
      ),
    );
  }

  Widget _buildAuthActions() {
    return Column(
      children: [
        AppButton(
          action: _handleAuthSubmit,
          buttonLabel: isLogin ? 'Sign in' : 'Create Account',
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            fluent.HyperlinkButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: AppTypography.labelLarge(
                text: isLogin ? 'Create Account' : 'Already have an account?',
                color: Colors.black,
              ),
            ),
            if (isLogin) ...[
              const SizedBox(width: 20),
              fluent.HyperlinkButton(
                onPressed: _handleForgotPassword,
                child: AppTypography.labelLarge(
                  text: 'Forgot Password?',
                  color: Colors.black,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return AppTypography.bodySmall(
      text: '2024 All rights reserved, MyWater Agency',
      color: Colors.black54,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Light gray background
      body: Row(
        children: [
          // Left Panel - Auth Form
          Expanded(
            flex: 6,
            child: _buildAuthPanel(),
          ),
          // Right Panel - Marketing Content
          Expanded(
            flex: 5,
            child: _buildMarketingPanel(),
          ),
        ],
      ),
    );
  }
}

class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.5;

    const double spacing = 30.0;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Optional: Add dots at intersections
class GridPatternWithDotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 0.5;

    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    const double spacing = 30.0;
    const double dotRadius = 1.5;

    // Draw grid lines
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        // Draw dot at intersection
        canvas.drawCircle(
          Offset(x, y),
          dotRadius,
          dotPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
