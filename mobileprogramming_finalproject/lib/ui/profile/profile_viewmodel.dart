import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:mobileprogramming_finalproject/domain/model/user_info.dart';
import 'package:mobileprogramming_finalproject/data/repository/auth_repository_impl.dart';
import 'package:mobileprogramming_finalproject/domain/repository/auth_repository.dart';
import 'package:mobileprogramming_finalproject/domain/repository/profile_repository.dart';
import 'package:mobileprogramming_finalproject/data/repository/profile_repository_impl.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({
    AuthRepository? authRepository,
    ProfileRepository? profileRepository,
  }) : _authRepository = authRepository ?? AuthRepositoryImpl(),
       _profileRepository = profileRepository ?? ProfileRepositoryImpl();

  final AuthRepository _authRepository;
  final ProfileRepository _profileRepository;

  UserInfo? userInfo;
  bool isLoading = false;
  String profileUrl = '';
  String error = '';

  Future<void> loadUserInfo() async {
    isLoading = true;
    error = '';
    notifyListeners();

    try {
      userInfo = await _authRepository.getCurrentUser();
      if (userInfo == null) {
        error = 'User belum login atau data profil tidak ditemukan.';
      }
    } catch (e) {
      error = 'Failed to load user information.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateUserProfile({
    required String displayName,
    required String idSipatuh,
    String? phoneNumber,
    String? address,
    String? profileImageUrl,
  }) async {
    isLoading = true;
    error = '';
    notifyListeners();

    try {
      final success = await _authRepository.updateUserProfile(
        displayName: displayName,
        idSipatuh: idSipatuh,
        phoneNumber: phoneNumber,
        address: address,
        profileImageUrl: profileImageUrl,
      );
      if (success) {
        await loadUserInfo();
        return true;
      } else {
        error = 'Failed to update profile.';
        return false;
      }
    } catch (e) {
      error = 'An error occurred while updating profile.';
      debugPrint('=== DETAIL ERROR UPDATE PROFILE ===');
      debugPrint(e.toString());
      debugPrint('===================================');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String> updatePhoto(File file, String userId) async {
    isLoading = true;
    error = '';
    notifyListeners();

    try {
      final url = await _profileRepository.executeUpload(file, userId);
      profileUrl = url;
      return url;
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String> pickAndUploadImage() async {
    final currentUser = userInfo;
    final userId = currentUser?.uid ?? '';

    if (userId.isEmpty || currentUser == null) {
      error = 'User belum login atau data profil belum dimuat.';
      notifyListeners();
      throw StateError(error);
    }

    try {
      final newImageFile = await _profileRepository.pickImageFromGallery();
      final newImageUrl = await updatePhoto(newImageFile, userId);
      await _authRepository.updateUserProfile(
        displayName: currentUser.displayName,
        idSipatuh: currentUser.idSipatuh,
        phoneNumber: currentUser.phoneNumber,
        address: currentUser.address,
        profileImageUrl: newImageUrl,
      );
      await loadUserInfo();
      return newImageUrl;
    } catch (e) {
      debugPrint('=== DETAIL ERROR SIPATUH ===');
      debugPrint(e.toString());
      debugPrint('============================');

      error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
