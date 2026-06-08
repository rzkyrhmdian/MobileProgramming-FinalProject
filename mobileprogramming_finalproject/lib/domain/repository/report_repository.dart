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
  
  Stream<List<ReportInfo>> getUserReports();
}