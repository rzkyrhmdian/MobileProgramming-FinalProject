import 'dart:io';
import '../model/report_info.dart';

abstract class ReportRepository {
  Future<void> submitReport({
    required String platNomor,
    required String jenisInsiden,
    required String deskripsi,
    required double latitude,
    required double longitude,
    required String alamat,
    required File foto,
  });

  // FUNGSI BARU: Untuk update laporan
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
  });

  // FUNGSI BARU: Untuk hapus laporan
  Future<void> deleteReport(String id, String fotoUrl);
  
  Stream<List<ReportInfo>> getUserReports();
}