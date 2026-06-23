import 'package:flutter/foundation.dart';
import 'package:mobileprogramming_finalproject/data/repository/auth_repository_impl.dart';
import 'package:mobileprogramming_finalproject/domain/repository/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel({AuthRepository? authRepository})
    : _authRepository = authRepository ?? AuthRepositoryImpl();

  final AuthRepository _authRepository;

  String fullName = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String error = '';
  bool isPasswordObscure = true;
  bool isConfirmPasswordObscure = true;
  bool isLoading = false;

  void updateFullName(String value) {
    fullName = value;
  }

  void updateEmail(String value) {
    email = value;
  }

  void updatePassword(String value) {
    password = value;
  }

  void updateConfirmPassword(String value) {
    confirmPassword = value;
  }

  void togglePasswordObscure() {
    isPasswordObscure = !isPasswordObscure;
    notifyListeners();
  }

  void toggleConfirmPasswordObscure() {
    isConfirmPasswordObscure = !isConfirmPasswordObscure;
    notifyListeners();
  }

  Future<bool> login() async {
    isLoading = true;
    error = '';
    notifyListeners();

    final user = await _authRepository.signInWithEmailAndPassword(
      email,
      password,
    );

    isLoading = false;
    if (user == null) {
      error = 'Gagal masuk. Pastikan email dan password benar.';
      notifyListeners();
      return false;
    }

    notifyListeners();
    return true;
  }

  Future<bool> register() async {
    isLoading = true;
    error = '';
    notifyListeners();

    if (password != confirmPassword) {
      isLoading = false;
      error =
          'Password tidak cocok. Pastikan password dan konfirmasi password sama.';
      notifyListeners();
      return false;
    }

    final user = await _authRepository.registerWithEmailAndPassword(
      fullName,
      email,
      password,
    );

    isLoading = false;
    if (user == null) {
      error =
          'Gagal mendaftar akun. Pastikan email belum terdaftar dan coba lagi.';
      notifyListeners();
      return false;
    }

    notifyListeners();
    return true;
  }
}
