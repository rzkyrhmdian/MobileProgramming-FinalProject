import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:mobileprogramming_finalproject/data/remote/notification_datasource.dart';
import 'package:mobileprogramming_finalproject/data/remote/user_api_model.dart';

class AuthRemoteDatasource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationDatasource _notificationDatasource =
      NotificationDatasource();

  Future<void> _notify({required String title, required String body}) async {
    try {
      await _notificationDatasource.createNotification(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title: title,
        body: body,
      );
    } catch (_) {}
  }

  Future<void> _upsertUserDocument(
    User user, {
    String? displayName,
    String? idSipatuh,
    String? profileImageUrl,
    String? phoneNumber,
    String? address,
    bool isNewUser = false,
  }) async {
    final userRef = _firestore.collection('users').doc(user.uid);

    final data = <String, dynamic>{
      'uid': user.uid,
      'email': user.email,
      'updatedAt': FieldValue.serverTimestamp(),
      'lastLoginAt': FieldValue.serverTimestamp(),
    };

    if (isNewUser) {
      data['createdAt'] = FieldValue.serverTimestamp();
      data['displayName'] = displayName ?? user.displayName ?? '';
      data['idSipatuh'] = '';
      data['profileImage'] = '';
      data['phoneNumber'] = '';
      data['address'] = '';
      data['role'] = 'user';
    } else if (displayName != null) {
      data['displayName'] = displayName.trim();
    }

    if (idSipatuh != null) {
      data['idSipatuh'] = idSipatuh.trim();
    }

    if (profileImageUrl != null) {
      data['profileImage'] = profileImageUrl.trim();
    }

    if (phoneNumber != null) {
      data['phoneNumber'] = phoneNumber.trim();
    }

    if (address != null) {
      data['address'] = address.trim();
    }
    await userRef.set(data, SetOptions(merge: true));
  }

  Future<bool> _isSiPatuhIdAvailable(
    String idSipatuh,
    String currentUid,
  ) async {
    final normalized = idSipatuh.trim();
    if (normalized.isEmpty) {
      return false;
    }

    final query = await _firestore
        .collection('users')
        .where('idSipatuh', isEqualTo: normalized)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      return true;
    }

    return query.docs.first.id == currentUid;
  }

  Future<UserApiModel?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        try {
          await _upsertUserDocument(
            result.user!,
            displayName: result.user!.displayName,
          );
        } on MissingPluginException catch (e) {
          await _notify(
            title: 'Login Warning',
            body: 'Firestore plugin is not connected yet: $e',
          );
        } on FirebaseException catch (e) {
          await _notify(
            title: 'Login Warning',
            body: 'Firestore sync failed on sign-in: ${e.message}',
          );
        } catch (e) {
          await _notify(
            title: 'Login Warning',
            body: 'Unexpected Firestore sync error on sign-in: $e',
          );
        }
      }

      return result.user == null
          ? null
          : UserApiModel.fromMap({
              'uid': result.user!.uid,
              'email': result.user!.email ?? '',
              'displayName': result.user!.displayName ?? '',
              'idSipatuh': '',
              'profileImage': '',
              'phoneNumber': '',
              'address': '',
              'role': 'user',
            }, uid: result.user!.uid);
    } on FirebaseAuthException catch (e) {
      await _notify(
        title: 'Login Failed',
        body: e.message ?? 'Authentication failed. Please try again.',
      );
      return null;
    } on FirebaseException catch (e) {
      await _notify(
        title: 'Login Failed',
        body: e.message ?? 'Firebase error occurred during login.',
      );
      return null;
    } catch (e) {
      await _notify(title: 'Login Failed', body: e.toString());
      return null;
    }
  }

  Future<UserApiModel?> registerWithEmailAndPassword(
    String fullName,
    String email,
    String password,
  ) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        await user.updateDisplayName(fullName);
        await user.reload();
        user = _firebaseAuth.currentUser;
        if (user != null) {
          try {
            await _upsertUserDocument(
              user,
              displayName: fullName,
              isNewUser: true,
            );
          } on MissingPluginException catch (e) {
            await _notify(
              title: 'Sign Up Warning',
              body: 'Firestore plugin is not connected yet: $e',
            );
          } on FirebaseException catch (e) {
            await _notify(
              title: 'Sign Up Warning',
              body: 'Firestore sync failed on sign-up: ${e.message}',
            );
          } catch (e) {
            await _notify(
              title: 'Sign Up Warning',
              body: 'Unexpected Firestore sync error on sign-up: $e',
            );
          }
        }
      }

      if (user == null) {
        return null;
      }

      return UserApiModel(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? fullName,
        idSipatuh: '',
        profileImage: '',
        phoneNumber: '',
        address: '',
        role: 'user',
      );
    } on FirebaseAuthException catch (e) {
      await _notify(
        title: 'Sign Up Failed',
        body: e.message ?? 'Registration failed. Please try again.',
      );
      return null;
    } on FirebaseException catch (e) {
      await _notify(
        title: 'Sign Up Failed',
        body: e.message ?? 'Firebase error occurred during sign up.',
      );
      return null;
    } catch (e) {
      await _notify(title: 'Sign Up Failed', body: e.toString());
      return null;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        await _notify(
          title: 'Change Password Failed',
          body: 'No user is signed in.',
        );
        return false;
      }

      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);

      await _notify(
        title: 'Password Updated',
        body: 'Password updated successfully.',
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        await _notify(
          title: 'Change Password Failed',
          body: 'The current password you entered is incorrect.',
        );
      } else {
        await _notify(
          title: 'Change Password Failed',
          body: 'An error occurred. Please try again.',
        );
      }
      return false;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<UserApiModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }

    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    final userData = userDoc.data() ?? <String, dynamic>{};

    return UserApiModel.fromMap({
      ...userData,
      'uid': user.uid,
      'email': user.email ?? userData['email'] ?? '',
      'displayName': user.displayName ?? userData['displayName'] ?? '',
      'idSipatuh': userData['idSipatuh'] ?? '',
      'profileImage': userData['profileImage'] ?? '',
      'phoneNumber': userData['phoneNumber'] ?? '',
      'address': userData['address'] ?? '',
    }, uid: user.uid);
  }

  Future<bool> updateUserProfile({
    required String displayName,
    required String idSipatuh,
    String? profileImageUrl,
    String? phoneNumber,
    String? address,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        await _notify(
          title: 'Update Profile Failed',
          body: 'No user is signed in.',
        );
        return false;
      }

      final normalizedName = displayName.trim();
      final normalizedSiPatuhId = idSipatuh.trim();
      final normalizedProfileImage = profileImageUrl?.trim();

      if (normalizedName.isEmpty || normalizedSiPatuhId.isEmpty) {
        await _notify(
          title: 'Update Profile Failed',
          body:
              'Display name dan idSipatuh must be provided and cannot be empty.',
        );
        return false;
      }

      final isAvailable = await _isSiPatuhIdAvailable(
        normalizedSiPatuhId,
        user.uid,
      );
      if (!isAvailable) {
        await _notify(
          title: 'Update Profile Failed',
          body:
              'idSipatuh has already been taken by another user. Please choose a different one.',
        );
        return false;
      }

      await user.updateDisplayName(normalizedName);
      await user.reload();

      final latestUser = _firebaseAuth.currentUser ?? user;
      await _upsertUserDocument(
        latestUser,
        displayName: normalizedName,
        idSipatuh: normalizedSiPatuhId,
        profileImageUrl: normalizedProfileImage,
        phoneNumber: phoneNumber,
        address: address,
      );

      await _notify(
        title: 'Profile Updated',
        body: 'Profile updated successfully.',
      );
      return true;
    } on FirebaseAuthException catch (e) {
      await _notify(
        title: 'Update Profile Failed',
        body: e.message ?? 'Failed to update profile.',
      );
      return false;
    } on FirebaseException catch (e) {
      await _notify(
        title: 'Update Profile Failed',
        body: e.message ?? 'Failed to update Firestore profile.',
      );
      return false;
    } catch (e) {
      await _notify(
        title: 'Update Profile Failed',
        body: 'Unexpected error while updating profile.',
      );
      return false;
    }
  }
}
