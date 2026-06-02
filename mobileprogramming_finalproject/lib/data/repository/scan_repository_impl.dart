import 'dart:io';
import 'package:mobileprogramming_finalproject/domain/model/plate_info.dart';
import 'package:mobileprogramming_finalproject/domain/repository/scan_repository.dart';
import 'package:mobileprogramming_finalproject/data/remote/scan_remote_datasource.dart';

class ScanRepositoryImpl implements ScanRepository {
  final ScanRemoteDataSource _remoteDataSource;

  ScanRepositoryImpl({ScanRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? ScanRemoteDataSource();

  @override
  Future<PlateInfo> scanPlate(File imageFile) async {
    final apiModel = await _remoteDataSource.scanPlate(imageFile);
    return apiModel.toDomain();
  }
}
