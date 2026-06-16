import 'package:flutter/material.dart';
import 'package:mobileprogramming_finalproject/domain/model/report_info.dart';
import 'package:mobileprogramming_finalproject/data/repository/report_repository_impl.dart';
import 'package:mobileprogramming_finalproject/data/repository/notification_repository_impl.dart';

class AdminDashboardViewModel extends ChangeNotifier {
  final ReportRepositoryImpl _reportRepository = ReportRepositoryImpl();
  final NotificationRepositoryImpl _notificationRepository =
      NotificationRepositoryImpl();

  String _searchQuery = '';
  ReportStatus? _selectedStatusFilter;

  String get searchQuery => _searchQuery;
  ReportStatus? get selectedStatusFilter => _selectedStatusFilter;
  Stream<List<ReportInfo>> get reportStream =>
      _reportRepository.getAllReports();

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedStatusFilter(ReportStatus? status) {
    _selectedStatusFilter = status;
    notifyListeners();
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Pagi,';
    if (hour < 17) return 'Siang,';
    return 'Malam,';
  }

  String getTimeAgo(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 0) return '${difference.inDays} Hari lalu';
    if (difference.inHours > 0) return '${difference.inHours} Jam lalu';
    if (difference.inMinutes > 0) return '${difference.inMinutes} Menit lalu';
    return 'Baru saja';
  }

  List<ReportInfo> filterReports(List<ReportInfo> allReports) {
    return allReports.where((report) {
      final matchesSearch = report.platNomor.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final matchesFilter =
          _selectedStatusFilter == null ||
          report.status == _selectedStatusFilter;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  Future<void> rejectReport(ReportInfo report, String adminNotes) async {
    await _reportRepository.updateReportStatus(
      reportId: report.id,
      status: ReportStatus.ditolak,
      adminNotes: adminNotes,
    );
    await _notificationRepository.saveNotificationToFirestore(
      userId: report.userId,
      title: 'Laporan Ditolak ❌',
      body: 'Laporan plat ${report.platNomor} ditolak. Alasan: $adminNotes',
    );
  }

  Future<void> resolveReport(ReportInfo report, String adminNotes) async {
    await _reportRepository.updateReportStatus(
      reportId: report.id,
      status: ReportStatus.selesai,
      adminNotes: adminNotes,
    );
    await _notificationRepository.saveNotificationToFirestore(
      userId: report.userId,
      title: 'Laporan Selesai ✅',
      body:
          'Laporan plat ${report.platNomor} telah diverifikasi. Catatan: $adminNotes',
    );
  }
}
