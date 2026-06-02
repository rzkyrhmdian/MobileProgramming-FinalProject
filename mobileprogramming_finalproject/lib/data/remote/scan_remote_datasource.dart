import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mobileprogramming_finalproject/data/remote/plate_info_api_model.dart';

class ScanRemoteDataSource {
  final Dio _dio;

  /// Base URL dari FastAPI backend.
  /// - emulator Android: http://10.0.2.2:8000
  /// - device fisik: gunakan IP lokal komputer, misal http://192.168.x.x:8000
  static const String _baseUrl = 'http://10.0.2.2:8000';

  ScanRemoteDataSource({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: _baseUrl,
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
            ));

  /// Mengirim file gambar ke endpoint `/api/v1/scan-plate` via POST.
  Future<PlateInfoApiModel> scanPlate(File imageFile) async {
    try {
      final String fileName = imageFile.path.split('/').last;

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final response = await _dio.post(
        '/api/v1/scan-plate',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return PlateInfoApiModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw FormatException(
          'Unexpected response: status=${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      // Re-throw dengan pesan yang lebih informatif
      throw Exception(
        'Gagal menghubungi server: ${e.message ?? 'Unknown error'}',
      );
    }
  }
}
