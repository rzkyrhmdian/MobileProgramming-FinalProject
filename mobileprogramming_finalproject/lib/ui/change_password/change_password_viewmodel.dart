import 'package:flutter/foundation.dart';
import 'package:mobileprogramming_finalproject/data/repository/auth_repository_impl.dart';
import 'package:mobileprogramming_finalproject/domain/repository/auth_repository.dart';

class ChangePasswordViewModel extends ChangeNotifier {
  ChangePasswordViewModel({AuthRepository? authRepository})
    : _authRepository = authRepository ?? AuthRepositoryImpl();

  final AuthRepository _authRepository;

  bool isLoading = false;
  String error = '';

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    error = '';

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      error = 'Semua field password harus diisi.';
      notifyListeners();
      return false;
    }

    if (newPassword != confirmPassword) {
      error = 'Password baru dan konfirmasi password tidak sama.';
      notifyListeners();
      return false;
    }

    if (newPassword.length < 6) {
      error = 'Password baru minimal 6 karakter.';
      notifyListeners();
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      final success = await _authRepository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      if (!success) {
        error = 'Gagal memperbarui password. Periksa password saat ini.';
      }

      return success;
    } catch (e) {
      error = 'Terjadi kesalahan saat mengubah password.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
