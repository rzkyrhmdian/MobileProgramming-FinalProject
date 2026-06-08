import 'dart:io';
import 'package:mobileprogramming_finalproject/data/remote/profile_remote_datasource.dart';
import 'package:mobileprogramming_finalproject/domain/repository/profile_repository.dart';
import 'package:mobileprogramming_finalproject/data/remote/profile_local_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final ProfileLocalDataSource _localDataSource = ProfileLocalDataSource();

  ProfileRepositoryImpl({ProfileRemoteDataSource? remoteDataSource})
    : _remoteDataSource = remoteDataSource ?? ProfileRemoteDataSource();

  @override
  Future<String> executeUpload(File file, String userId) async {
    return await _remoteDataSource.uploadImage(file, userId);
  }

  @override
  Future<File> pickImageFromGallery() async {
    return await _localDataSource.pickImageFromGallery();
  }
}
