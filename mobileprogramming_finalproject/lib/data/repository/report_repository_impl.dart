import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repository/report_repository.dart';
import '../remote/report_remote_datasource.dart';
import '../../domain/model/report_info.dart'; 

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource _remoteDataSource;

  ReportRepositoryImpl({ReportRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? ReportRemoteDataSource();

  @override
  Future<void> submitReport({
    required String platNomor,
    required String jenisInsiden,
    required String deskripsi,
    required double latitude,
    required double longitude,
    required String alamat,
    required File foto,
  }) async {
    final fotoUrl = await _remoteDataSource.uploadReportImage(foto);
    
    await _remoteDataSource.submitReportData(
      platNomor: platNomor,
      jenisInsiden: jenisInsiden,
      deskripsi: deskripsi,
      latitude: latitude,
      longitude: longitude,
      alamat: alamat,
      fotoUrl: fotoUrl,
    );
  }

  @override
  Future<void> updateReport({
    required String id,
    required String platNomor,
    required String jenisInsiden,
    required String deskripsi,
    required double latitude,
    required double longitude,
    required String alamat,
    File? fotoBaru,
    required String fotoUrlLama,
  }) async {
    String finalFotoUrl = fotoUrlLama;

    // Jika user memilih foto baru, upload yang baru dan hapus yang lama dari server
    if (fotoBaru != null) {
      finalFotoUrl = await _remoteDataSource.uploadReportImage(fotoBaru);
      await _remoteDataSource.deleteReportImage(fotoUrlLama);
    }

    await _remoteDataSource.updateReportData(
      id: id,
      platNomor: platNomor,
      jenisInsiden: jenisInsiden,
      deskripsi: deskripsi,
      latitude: latitude,
      longitude: longitude,
      alamat: alamat,
      fotoUrl: finalFotoUrl,
    );
  }

  @override
  Future<void> deleteReport(String id, String fotoUrl) async {
    await _remoteDataSource.deleteReportData(id); // Hapus Teks
    await _remoteDataSource.deleteReportImage(fotoUrl); // Hapus Foto
  }

  @override
  Stream<List<ReportInfo>> getUserReports() {
    return _remoteDataSource.getUserReportsStream().map((snapshot) {
      final reports = snapshot.docs.map((doc) {
        final data = doc.data();
        
        DateTime createdAtDateTime = DateTime.now();
        if (data['createdAt'] is Timestamp) {
          createdAtDateTime = (data['createdAt'] as Timestamp).toDate();
        }

        return ReportInfo(
          id: doc.id,
          userId: data['userId'] ?? '',
          platNomor: data['platNomor'] ?? '',
          jenisInsiden: data['jenisInsiden'] ?? '',
          deskripsi: data['deskripsi'] ?? '',
          latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
          longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
          alamat: data['alamat'] ?? '',
          fotoUrl: data['fotoUrl'] ?? '',
          status: data['status'] ?? 'Pending',
          createdAt: createdAtDateTime,
        );
      }).toList();

      reports.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return reports;
    });
  }
}