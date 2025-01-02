import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mywater_dashboard_revamp/v1/models/authentication_model.dart';
import 'package:mywater_dashboard_revamp/v1/screens/auth.dart';
import 'package:mywater_dashboard_revamp/v1/screens/dashboard.dart';
import 'package:mywater_dashboard_revamp/v1/utils/screen_overlay.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> handleAuthentication({
    required BuildContext context,
    required AuthenticationModel authModel,
    required bool isLogin,
  }) async {
    try {
      if (isLogin) {
        await _signInPartner(
          context: context,
          email: authModel.email,
          password: authModel.password,
        );
      } else {
        await _createPartnerAccount(
          context: context,
          authModel: authModel,
        );
      }
    } catch (e) {
      ScreenOverlay.showToast(
        context,
        title: 'Error',
        message: e.toString(),
        isWarning: true,
      );
    }
  }

  Future<void> _signInPartner({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      // Sign in with Firebase Auth
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get partner profile
      final partnerDoc = await _firestore.collection('partners').doc(userCredential.user!.uid).get();

      if (!partnerDoc.exists) {
        throw 'Partner profile not found';
      }

      // Store partner data locally
      final partnerData = partnerDoc.data()!;
      await GetStorage().write('partnerId', userCredential.user!.uid);
      await GetStorage().write('partnerEmail', email);
      await GetStorage().write('partnerName', partnerData['companyName']);

      // Navigate to dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Dashboard(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No partner found with this email';
          break;
        case 'wrong-password':
          message = 'Invalid password';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        default:
          message = 'Authentication failed';
      }
      throw message;
    }
  }

  Future<void> _createPartnerAccount({
    required BuildContext context,
    required AuthenticationModel authModel,
  }) async {
    try {
      // Create user with Firebase Auth
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: authModel.email,
        password: authModel.password,
      );

      // Create partner profile in Firestore
      await _firestore.collection('partners').doc(userCredential.user!.uid).set({
        'companyName': authModel.companyName,
        'email': authModel.email,
        'phoneNumber': authModel.phoneNumber,
        'description': authModel.description,
        'website': authModel.website,
        'logoUrl': authModel.logoUrl,
        'role': authModel.role,
        'createdAt': DateTime.now().toIso8601String(),
        'status': 'active',
      });

      // Store partner data locally
      await GetStorage().write('partnerId', userCredential.user!.uid);
      await GetStorage().write('partnerEmail', authModel.email);
      await GetStorage().write('partnerName', authModel.companyName);

      // Navigate to dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Dashboard(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'Password should be at least 6 characters';
          break;
        case 'email-already-in-use':
          message = 'An account already exists with this email';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        default:
          message = 'Registration failed';
      }
      throw message;
    }
  }

  // Sign out
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      await GetStorage().erase();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AuthScreen(),
        ),
      );
    } catch (e) {
      ScreenOverlay.showToast(
        context,
        title: 'Error',
        message: 'Failed to sign out',
        isWarning: true,
      );
    }
  }

  // Get current partner data
  Future<Map<String, dynamic>?> getCurrentPartnerData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('partners').doc(user.uid).get();
        return doc.data();
      }
      return null;
    } catch (e) {
      return null;
    }
  }


  Stream<DocumentSnapshot> getPartnerProfile(String partnerId) {
    return _firestore
        .collection('partners')
        .doc(partnerId)
        .snapshots();
  }

  Future<void> updatePartnerProfile({
    required String partnerId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore
          .collection('partners')
          .doc(partnerId)
          .update({
        ...data,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      // Update local storage if needed
      if (data.containsKey('companyName')) {
        await GetStorage().write('partnerName', data['companyName']);
      }
      if (data.containsKey('email')) {
        await GetStorage().write('partnerEmail', data['email']);
      }
    } catch (e) {
      throw 'Failed to update profile: ${e.toString()}';
    }
  }

  Future<Map<String, dynamic>> getPartnerData(String partnerId) async {
    try {
      final doc = await _firestore
          .collection('partners')
          .doc(partnerId)
          .get();
          
      if (!doc.exists) {
        throw 'Partner profile not found';
      }
      
      return doc.data() ?? {};
    } catch (e) {
      throw 'Failed to fetch partner data: ${e.toString()}';
    }
  }

  // Team Management Methods
  Future<void> addTeamMember({
    required String partnerId,
    required Map<String, dynamic> memberData,
  }) async {
    try {
      await _firestore
          .collection('partners')
          .doc(partnerId)
          .collection('team')
          .add({
        ...memberData,
        'addedAt': DateTime.now().toIso8601String(),
        'status': 'active',
      });
    } catch (e) {
      throw 'Failed to add team member: ${e.toString()}';
    }
  }

  Stream<QuerySnapshot> getTeamMembers(String partnerId) {
    return _firestore
        .collection('partners')
        .doc(partnerId)
        .collection('team')
        .snapshots();
  }

  // Campaign Methods
  Future<void> createCampaign({
    required String partnerId,
    required Map<String, dynamic> campaignData,
  }) async {
    try {
      await _firestore.collection('campaigns').add({
        ...campaignData,
        'partnerId': partnerId,
        'createdAt': DateTime.now().toIso8601String(),
        'status': 'active',
      });
    } catch (e) {
      throw 'Failed to create campaign: ${e.toString()}';
    }
  }

  Stream<QuerySnapshot> getPartnerCampaigns(String partnerId) {
    return _firestore
        .collection('campaigns')
        .where('partnerId', isEqualTo: partnerId)
        .snapshots();
  }
}
