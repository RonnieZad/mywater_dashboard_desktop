import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mywater_dashboard_revamp/v1/constants/colors.dart';
import 'package:mywater_dashboard_revamp/v1/controller/auth_controller.dart';
import 'package:mywater_dashboard_revamp/v1/services/auth_service.dart';
import 'package:mywater_dashboard_revamp/v1/services/team_member_service.dart';
import 'package:mywater_dashboard_revamp/v1/utils/utils.dart';
import 'package:mywater_dashboard_revamp/v1/widgets/app_button.dart';
import 'package:mywater_dashboard_revamp/v1/widgets/edit_company_profile.dart';
import 'package:mywater_dashboard_revamp/v1/widgets/manage_team_dialog.dart';
import 'package:mywater_dashboard_revamp/v1/widgets/screen_overlay.dart';
import 'package:mywater_dashboard_revamp/v1/widgets/ui_helpers.dart';
import 'package:octo_image/octo_image.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyProfile extends StatefulWidget {
  const CompanyProfile({super.key});

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  final AuthController authController = Get.put(AuthController());
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('partners').doc(GetStorage().read('partnerId')).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final partnerData = snapshot.data!.data() as Map<String, dynamic>;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            _buildProfileHeader(partnerData),
            10.ph,

            // Profile Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company Details Section
                  Expanded(
                    flex: 2,
                    child: _buildCompanyDetails(partnerData),
                  ),
                  10.pw,
                  // Team Members Section
                  Expanded(
                    child: _buildTeamSection(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          // Company Logo
          _buildCompanyLogo(data['logoUrl']),
          20.pw,
          // Company Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTypography.headlineMedium(
                  text: data['companyName'] ?? 'Company Name',
                ),
                8.ph,
                AppTypography.bodyMedium(
                  text: data['website'] ?? 'Website URL',
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyLogo(String? logoUrl) {
    return ClipOval(
      child: Container(
        height: 140,
        width: 140,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(
            color: Colors.grey[200]!,
            width: 2,
          ),
        ),
        child: logoUrl != null
            ? OctoImage(
                placeholderBuilder: OctoBlurHashFix.placeHolder('LEHV6nWB2yk8pyo0adR*.7kCMdnj'),
                errorBuilder: OctoError.icon(color: Colors.red),
                image: CachedNetworkImageProvider(logoUrl),
                fit: BoxFit.cover,
              )
            : Icon(
                fluent.FluentIcons.build,
                size: 40,
                color: Colors.grey[400],
              ),
      ),
    );
  }

  Widget _buildCompanyDetails(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: baseColorLight, width: 0.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTypography.titleLarge(
                    text: 'Company Profile',
                  ),
                  6.ph,
                  AppTypography.bodySmall(
                    text: 'Manage information about your business',
                    color: Colors.grey[600],
                  ),
                ],
              ),
              fluent.Button(
                child: AppTypography.labelMedium(text: 'Edit Profile'),
                onPressed: () => _showEditProfileDialog(data),
              ),
            ],
          ),
          24.ph,
          // Description
          _buildInfoSection(
            'Description',
            data['description'] ?? 'No description available',
          ),
          24.ph,
          // Contact Info
          AppTypography.titleMedium(text: 'Contact Information'),
          16.ph,
          _buildContactInfo(
            'Email',
            data['email'] ?? 'N/A',
            fluent.FluentIcons.mail,
          ),
          12.ph,
          _buildContactInfo(
            'Phone',
            data['phoneNumber'] ?? 'N/A',
            fluent.FluentIcons.phone,
          ),
          12.ph,
          _buildContactInfo(
            'Website',
            data['website'] ?? 'N/A',
            fluent.FluentIcons.globe,
          ),
          40.ph,
          // Support Button
          AppButton(
            action: _launchSupport,
            buttonLabel: 'Get Support',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTypography.titleMedium(text: title),
        12.ph,
        AppTypography.bodyMedium(
          text: content,
          color: Colors.grey[600],
        ),
      ],
    );
  }

  Widget _buildContactInfo(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        12.pw,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTypography.bodySmall(
              text: label,
              color: Colors.grey[600],
            ),
            4.ph,
            AppTypography.bodyMedium(text: value),
          ],
        ),
      ],
    );
  }

  final TeamService _teamService = TeamService();
  final partnerId = GetStorage().read('partnerId');

  Widget _buildTeamSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: baseColorLight, width: 0.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTypography.titleLarge(text: 'Team Members'),
                    6.ph,
                    AppTypography.bodySmall(
                      text: 'Manage your team members and their access',
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
              fluent.Button(
                  child: AppTypography.labelMedium(text: 'Manage'),
                  onPressed: () {
                    ScreenAppOverlay.showAppDialogWindow(
                      context,
                      body: const ManageTeamDialog(),
                    );
                  }),
            ],
          ),
          20.ph,
          StreamBuilder<List<TeamMember>>(
            stream: _teamService.getTeamMembers(partnerId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        fluent.FluentIcons.people,
                        size: 40,
                        color: Colors.grey[400],
                      ),
                      20.ph,
                      AppTypography.bodyMedium(
                        text: 'No team members yet',
                        color: Colors.grey[600],
                        textAlign: TextAlign.center,
                      ),
                      8.ph,
                      AppTypography.bodySmall(
                        text: 'Add team members to collaborate',
                        color: Colors.grey[400],
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              final members = snapshot.data!;

              return ListView.separated(
                shrinkWrap: true,
                itemCount: members.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final member = members[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      child: Text(member.email[0].toUpperCase()),
                    ),
                    title: Text(member.email),
                    subtitle: Text(member.role.toUpperCase()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (member.status == 'pending')
                          Chip(
                            label: const Text('Pending'),
                            backgroundColor: Colors.orange[100],
                          ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(Map<String, dynamic> currentData) {
    authController.companyDescriptionController.text = currentData['description'] ?? '';
    authController.emailController.text = currentData['email'] ?? '';
    authController.companyWebsiteController.text = currentData['website'] ?? '';
    authController.companyNameController.text = currentData['companyName'] ?? '';

    ScreenAppOverlay.showAppDialogWindow(
      context,
      body: EditCompanyProfile(authController: authController),
    );
  }

  void _launchSupport() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'info@mywater.agency',
    );
    await launchUrl(emailLaunchUri);
  }
}
