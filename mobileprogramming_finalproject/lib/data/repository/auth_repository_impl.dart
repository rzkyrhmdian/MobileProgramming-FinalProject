import 'package:mobileprogramming_finalproject/data/remote/auth_remote_datasource.dart';
import 'package:mobileprogramming_finalproject/domain/model/user_info.dart';
import 'package:mobileprogramming_finalproject/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({AuthRemoteDatasource? remoteDatasource})
    : _remoteDatasource = remoteDatasource ?? AuthRemoteDatasource();

  final AuthRemoteDatasource _remoteDatasource;

  @override
  Future<UserInfo?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final user = await _remoteDatasource.signInWithEmailAndPassword(
      email,
      password,
    );
    return user?.toEntity();
  }

  @override
  Future<UserInfo?> registerWithEmailAndPassword(
    String fullName,
    String email,
    String password,
  ) async {
    final user = await _remoteDatasource.registerWithEmailAndPassword(
      fullName,
      email,
      password,
    );
    return user?.toEntity();
  }

  @override
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return _remoteDatasource.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  @override
  Future<void> signOut() => _remoteDatasource.signOut();

  @override
  Future<UserInfo?> getCurrentUser() async {
    final user = await _remoteDatasource.getCurrentUser();
    return user?.toEntity();
  }

  @override
  Future<bool> updateUserProfile({
    required String displayName,
    required String idSipatuh,
    String? phoneNumber,
    String? address,
    String? profileImageUrl,
  }) {
    return _remoteDatasource.updateUserProfile(
      displayName: displayName,
      idSipatuh: idSipatuh,
      phoneNumber: phoneNumber,
      address: address,
      profileImageUrl: profileImageUrl,
    );
  }
}
