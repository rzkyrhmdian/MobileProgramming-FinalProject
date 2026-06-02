import 'package:mobileprogramming_finalproject/domain/model/user_info.dart';

abstract class AuthRepository {
  Future<UserInfo?> signInWithEmailAndPassword(
    String email,
    String password,
  );

  Future<UserInfo?> registerWithEmailAndPassword(
    String fullName,
    String email,
    String password,
  );

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<void> signOut();

  Future<UserInfo?> getCurrentUser();
}