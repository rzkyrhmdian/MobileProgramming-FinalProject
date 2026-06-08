import 'dart:io';
import 'package:mobileprogramming_finalproject/data/remote/profile_remote_datasource.dart';
import 'package:mobileprogramming_finalproject/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl({ProfileRemoteDataSource? remoteDataSource})
    : _remoteDataSource = remoteDataSource ?? ProfileRemoteDataSource();

  @override
  Future<String> executeUpload(File file, String userId) async {
    return await _remoteDataSource.uploadImage(file, userId);
  }
}
