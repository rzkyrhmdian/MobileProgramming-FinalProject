import 'package:flutter/material.dart';
import 'package:mobileprogramming_finalproject/data/repository/report_repository_impl.dart';
import 'package:mobileprogramming_finalproject/domain/model/report_info.dart';

class DashboardViewModel extends ChangeNotifier {
  final ReportRepositoryImpl _repository = ReportRepositoryImpl();

  List<ReportInfo> _reports = [];
  bool _isLoading = true;

  List<ReportInfo> get reports => _reports;
  bool get isLoading => _isLoading;

  // Menghitung total seluruh laporan yang dikirim
  int get totalAduan => _reports.length;

  // Menghitung laporan yang sudah diproses (Selesai/Terverifikasi)
  int get terverifikasi => _reports.where((r) {
    return r.status == ReportStatus.selesai;
  }).length;

  // Mengambil 1 laporan paling terbaru (indeks 0 karena sudah di-order by descending di repo)
  ReportInfo? get latestReport {
    if (_reports.isEmpty) return null;
    return _reports.first;
  }

  DashboardViewModel() {
    _listenToReports();
  }

  void _listenToReports() {
    _repository.getUserReports().listen(
      (reportList) {
        _reports = reportList;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        debugPrint("Gagal memuat statistik: $error");
        _isLoading = false;
        notifyListeners();
      },
    );
  }
}
