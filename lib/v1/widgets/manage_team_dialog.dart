import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mywater_dashboard_revamp/v1/services/team_member_service.dart';
import 'package:mywater_dashboard_revamp/v1/utils/screen_overlay.dart';
import 'package:mywater_dashboard_revamp/v1/utils/utils.dart';
import 'package:mywater_dashboard_revamp/v1/widgets/app_button.dart';
import 'package:mywater_dashboard_revamp/v1/widgets/text_box.dart';

class ManageTeamDialog extends StatefulWidget {
  const ManageTeamDialog({super.key});

  @override
  _ManageTeamDialogState createState() => _ManageTeamDialogState();
}

class _ManageTeamDialogState extends State<ManageTeamDialog> {
  final TeamService _teamService = TeamService();
  final TextEditingController _emailController = TextEditingController();
  String _selectedRole = 'viewer';
  final bool _isLoading = false;
  List<String> availableRoles = [
    'admin',
    'editor',
    'viewer',
  ];

  @override
  Widget build(BuildContext context) {
    final partnerId = GetStorage().read('partnerId');

    return Container(
      width: 600,
      height: 600,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTypography.titleLarge(text: 'Team Management'),
          16.ph,

          // Invite Form
          Row(
            crossAxisAlignment: fluent.CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: AppTextBox(
                  textEditingController: _emailController,
                  hintText: 'colleague@company.com',
                  icon: Icons.email,
                ),
              ),
              16.pw,
              Expanded(
                  child: fluent.SizedBox(
                height: 48,
                child: fluent.ComboBox<String>(
                  value: _selectedRole,
                  items: availableRoles.map<fluent.ComboBoxItem<String>>((e) {
                    return fluent.ComboBoxItem<String>(
                      value: e,
                      child: AppTypography.bodyMedium(text: e),
                    );
                  }).toList(),
                  onChanged: (selectedRole) {
                    setState(() => _selectedRole = selectedRole!);
                  },
                  placeholder: AppTypography.bodyMedium(text: 'Select a role'),
                ),
              )),
              14.pw,
              AppButton(
                action: () => _inviteMember(partnerId),
                buttonLabel: 'Invite',
                // isLoading: _isLoading,
              ),
            ],
          ),
          24.ph,

          // Team List
          Expanded(
            child: StreamBuilder<List<TeamMember>>(
              stream: _teamService.getTeamMembers(partnerId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final members = snapshot.data!;

                return ListView.separated(
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
                          fluent.ComboBox<String>(
                            placeholder: const Text('Actions'),
                            items: [
                              fluent.ComboBoxItem<String>(
                                value: 'change_role',
                                child: Row(
                                  children: [
                                    Icon(
                                      fluent.FluentIcons.user_sync,
                                      size: 16,
                                      color: Colors.grey[700],
                                    ),
                                    8.pw,
                                    const Text('Change Role'),
                                  ],
                                ),
                              ),
                              fluent.ComboBoxItem<String>(
                                value: 'remove',
                                child: Row(
                                  children: [
                                    Icon(
                                      fluent.FluentIcons.user_remove,
                                      size: 16,
                                      color: Colors.red[300],
                                    ),
                                    8.pw,
                                    Text(
                                      'Remove',
                                      style: TextStyle(
                                        color: Colors.red[300],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              switch (value) {
                                case 'change_role':
                                  _showChangeRoleDialog(partnerId, member);
                                  break;
                                case 'remove':
                                  _confirmRemoveMember(partnerId, member);
                                  break;
                              }
                            },
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showChangeRoleDialog(
    String partnerId,
    TeamMember member,
  ) async {
    String selectedRole = member.role;

    await fluent.showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return fluent.ContentDialog(
              title: AppTypography.titleMedium(
                text: 'Change Role',
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTypography.bodyMedium(
                    text: 'Change role for ${member.email}',
                    color: Colors.grey[600],
                  ),
                  20.ph,
                  fluent.ComboBox<String>(
                    value: selectedRole,
                    items: [
                      'admin',
                      'editor',
                      'viewer',
                    ]
                        .map((role) => fluent.ComboBoxItem(
                              value: role,
                              child: Row(
                                children: [
                                  Icon(
                                    _getRoleIcon(role),
                                    size: 16,
                                    color: Colors.grey[700],
                                  ),
                                  8.pw,
                                  Text(
                                    _getRoleDescription(role),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() => selectedRole = value!);
                    },
                  ),
                ],
              ),
              actions: [
                fluent.Button(
                  onPressed: () => Navigator.pop(context),
                  child: AppTypography.labelMedium(text: 'Cancel'),
                ),
                fluent.FilledButton(
                  onPressed: () async {
                    try {
                      await _teamService.updateMemberRole(
                        partnerId: partnerId,
                        memberId: member.id,
                        newRole: selectedRole,
                      );

                      if (mounted) {
                        Navigator.pop(context);
                        ScreenOverlay.showToast(
                          context,
                          title: 'Success',
                          message: 'Role updated successfully',
                        );
                      }
                    } catch (e) {
                      ScreenOverlay.showToast(
                        context,
                        title: 'Error',
                        message: 'Failed to update role',
                        isWarning: true,
                      );
                    }
                  },
                  child: AppTypography.labelMedium(
                    text: 'Update Role',
                    color: Colors.white,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _confirmRemoveMember(
    String partnerId,
    TeamMember member,
  ) async {
    await fluent.showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return fluent.ContentDialog(
          title: AppTypography.titleMedium(
            text: 'Remove Team Member',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTypography.bodyMedium(
                text: 'Are you sure you want to remove ${member.email}?',
                color: Colors.grey[600],
              ),
              16.ph,
              AppTypography.bodySmall(
                text: 'This action cannot be undone. The member will lose access to all resources.',
                color: Colors.red[300],
              ),
            ],
          ),
          actions: [
            fluent.Button(
              onPressed: () => Navigator.pop(context),
              child: AppTypography.labelMedium(text: 'Cancel'),
            ),
            fluent.FilledButton(
              // style: ButtonStyle(
              //   backgroundColor: MaterialStateProperty.all(Colors.red),
              // ),
              onPressed: () async {
                try {
                  await _teamService.removeMember(
                    partnerId: partnerId,
                    memberId: member.id,
                  );

                  if (mounted) {
                    Navigator.pop(context);
                    ScreenOverlay.showToast(
                      context,
                      title: 'Success',
                      message: '${member.email} has been removed',
                    );
                  }
                } catch (e) {
                  ScreenOverlay.showToast(
                    context,
                    title: 'Error',
                    message: 'Failed to remove member',
                    isWarning: true,
                  );
                }
              },
              child: AppTypography.labelMedium(
                text: 'Remove',
                color: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'admin':
        return fluent.FluentIcons.user_sync;
      case 'editor':
        return fluent.FluentIcons.edit;
      case 'viewer':
        return fluent.FluentIcons.glasses;
      default:
        return Icons.person;
    }
  }

  String _getRoleDescription(String role) {
    switch (role) {
      case 'admin':
        return 'Administrator (Full Access)';
      case 'editor':
        return 'Editor (Can Edit)';
      case 'viewer':
        return 'Viewer (Read Only)';
      default:
        return role.toUpperCase();
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      caseSensitive: false,
    ).hasMatch(email);
  }

  Future<void> _inviteMember(String partnerId) async {
    if (!_isValidEmail(_emailController.text)) {
      ScreenOverlay.showToast(
        context,
        title: 'Invalid Email',
        message: 'Please enter a valid email address',
        isWarning: true,
      );
      return;
    }

    // setState(() => _isLoading = true);
    try {
      await _teamService.inviteMember(
        partnerId: partnerId,
        email: _emailController.text.trim(),
        role: _selectedRole,
      );
      _emailController.clear();
      ScreenOverlay.showToast(
        context,
        title: 'Success',
        message: 'Invitation sent successfully',
      );
    } catch (e) {
      ScreenOverlay.showToast(
        context,
        title: 'Error',
        message: e.toString(),
        isWarning: true,
      );
    } finally {
      // setState(() => _isLoading = false);
    }
  }
}
