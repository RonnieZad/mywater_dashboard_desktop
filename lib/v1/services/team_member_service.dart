// models/team_member.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TeamMember {
  final String id;
  final String email;
  final String role; // admin, editor, viewer
  final String status; // pending, active, disabled
  final String invitedBy;
  final DateTime invitedAt;
  final DateTime? lastLogin;

  TeamMember({
    required this.id,
    required this.email,
    required this.role,
    required this.status,
    required this.invitedBy,
    required this.invitedAt,
    this.lastLogin,
  });

  factory TeamMember.fromMap(Map<String, dynamic> map, String docId) {
    return TeamMember(
      id: docId,
      email: map['email'],
      role: map['role'],
      status: map['status'],
      invitedBy: map['invitedBy'],
      invitedAt: DateTime.parse(map['invitedAt']),
      lastLogin: map['lastLogin'] != null ? DateTime.parse(map['lastLogin']) : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'role': role,
        'status': status,
        'invitedBy': invitedBy,
        'invitedAt': invitedAt.toIso8601String(),
        'lastLogin': lastLogin?.toIso8601String(),
      };
}

// services/team_service.dart
class TeamService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Invite new team member
  Future<void> inviteMember({
    required String partnerId,
    required String email,
    required String role,
  }) async {
    try {
      // Check if user already exists
      final existingUser = await _auth.fetchSignInMethodsForEmail(email);
      String userId;

      if (existingUser.isEmpty) {
        // Generate temporary password
        const tempPassword = 'jbnkmihjnnm';

        // Create Firebase auth user
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: tempPassword,
        );
        userId = userCredential.user!.uid;

        // Send invitation email with temp password
        // await sendInvitationEmail(email, tempPassword);
      } else {
        throw 'User already exists';
      }

      // Create team member record
      await _firestore.collection('partners').doc(partnerId).collection('team').doc(userId).set({
        'email': email,
        'role': role,
        'status': 'pending',
        'invitedBy': _auth.currentUser!.uid,
        'invitedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw 'Failed to invite member: ${e.toString()}';
    }
  }

  // Get team members stream
  Stream<List<TeamMember>> getTeamMembers(String partnerId) {
    return _firestore.collection('partners').doc(partnerId).collection('team').snapshots().map((snapshot) => snapshot.docs.map((doc) => TeamMember.fromMap(doc.data(), doc.id)).toList());
  }

  // Update member role
  Future<void> updateMemberRole({
    required String partnerId,
    required String memberId,
    required String newRole,
  }) async {
    await _firestore.collection('partners').doc(partnerId).collection('team').doc(memberId).update({'role': newRole});
  }

  // Remove team member
  Future<void> removeMember({
    required String partnerId,
    required String memberId,
  }) async {
    await _firestore.collection('partners').doc(partnerId).collection('team').doc(memberId).delete();
  }
}
