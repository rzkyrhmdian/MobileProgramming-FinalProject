import 'package:flutter/material.dart';
import 'package:mobileprogramming_finalproject/data/repository/report_repository_impl.dart';
import 'package:mobileprogramming_finalproject/domain/model/report_info.dart';

class ReportHistoryViewModel extends ChangeNotifier {
  final ReportRepositoryImpl _repository = ReportRepositoryImpl();
  List<ReportInfo> _reports = [];
  bool _isLoading = true;

  List<ReportInfo> get reports => _reports;
  bool get isLoading => _isLoading;

  ReportHistoryViewModel() {
    _listenToReports();
  }

  void _listenToReports() {
    _repository.getUserReports().listen((reportList) {
      _reports = reportList;
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      debugPrint("Gagal memuat riwayat: $error");
      _isLoading = false;
      notifyListeners();
    });
  }
}