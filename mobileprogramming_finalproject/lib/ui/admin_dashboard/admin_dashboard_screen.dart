import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileprogramming_finalproject/utils/colors.dart';
import 'package:mobileprogramming_finalproject/domain/model/report_info.dart';
import 'package:mobileprogramming_finalproject/data/repository/report_repository_impl.dart';
import 'package:mobileprogramming_finalproject/data/repository/notification_repository_impl.dart';
import 'package:mobileprogramming_finalproject/ui/profile/profile_viewmodel.dart';
import 'package:mobileprogramming_finalproject/ui/detail_report/detail_report_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Stream<List<ReportInfo>> _reportStream;
  String _searchQuery = '';
  ReportStatus? _selectedStatusFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _reportStream = ReportRepositoryImpl().getAllReports();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Pagi,';
    if (hour < 17) return 'Siang,';
    return 'Malam,';
  }

  String _getTimeAgo(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 0) return '${difference.inDays} Hari lalu';
    if (difference.inHours > 0) return '${difference.inHours} Jam lalu';
    if (difference.inMinutes > 0) return '${difference.inMinutes} Menit lalu';
    return 'Baru saja';
  }

  void _openReviewBottomSheet(BuildContext context, ReportInfo report) {
    final notesController = TextEditingController(
      text: report.adminNotes ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Review Laporan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        report.platNomor,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Jenis Pelanggaran:',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade400,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  report.jenisInsiden,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Catatan Peninjauan Admin',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: notesController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.black87, fontSize: 13),
                  decoration: InputDecoration(
                    hintText:
                        'Masukkan alasan penolakan atau keterangan penyelesaian...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 13,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.all(16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: Colors.grey.shade200,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    // AKSI 1: TOLAK LAPORAN
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                          await ReportRepositoryImpl().updateReportStatus(
                            reportId: report.id,
                            status: ReportStatus.ditolak,
                            adminNotes: notesController.text.trim(),
                          );
                          await NotificationRepositoryImpl().saveNotificationToFirestore(
                            userId: report.userId,
                            title: 'Laporan Ditolak ❌',
                            body: 'Laporan plat ${report.platNomor} ditolak. Alasan: ${notesController.text.trim()}',
                          );
                        },
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: AppColors.bgErrorRed,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: AppColors.errorRed.withValues(alpha: 0.3),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Tolak Laporan',
                              style: TextStyle(
                                color: AppColors.errorRed,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // AKSI 2: SELESAI
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                          await ReportRepositoryImpl().updateReportStatus(
                            reportId: report.id,
                            status: ReportStatus.selesai,
                            adminNotes: notesController.text.trim(),
                          );
                          await NotificationRepositoryImpl().saveNotificationToFirestore(
                            userId: report.userId,
                            title: 'Laporan Selesai ✅',
                            body: 'Laporan plat ${report.platNomor} telah diverifikasi. Catatan: ${notesController.text.trim()}',
                          );
                        },
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Center(
                            child: Text(
                              'Selesai',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Consumer<ProfileViewModel>(
          builder: (context, viewModel, _) {
            final user = viewModel.userInfo;
            final avatar = user?.profileImage;
            final hasImage = user?.profileImage?.isNotEmpty == true;
            final displayName = user?.displayName.isNotEmpty == true
                ? user!.displayName
                : 'Pengguna';

            return SizedBox.expand(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage('assets/images/backgroundGeneral.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                padding: const EdgeInsets.only(top: 20),
                child: StreamBuilder<List<ReportInfo>>(
                  stream: _reportStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Gagal memuat aduan: ${snapshot.error}'),
                      );
                    }

                    final allReports = snapshot.data ?? [];

                    final int totalReports = allReports.length;
                    final int pendingCount = allReports
                        .where((r) => r.status == ReportStatus.dalamProses)
                        .length;
                    final int resolvedCount = allReports
                        .where((r) => r.status == ReportStatus.selesai)
                        .length;
                    final int rejectedCount = allReports
                        .where((r) => r.status == ReportStatus.ditolak)
                        .length;

                    final filteredReports = allReports.where((report) {
                      final matchesSearch = report.platNomor
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase());
                      final matchesFilter =
                          _selectedStatusFilter == null ||
                          report.status == _selectedStatusFilter;
                      return matchesSearch && matchesFilter;
                    }).toList();

                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.1,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 28,
                                    backgroundColor: Colors.grey.shade200,
                                    backgroundImage: hasImage
                                        ? NetworkImage(avatar!)
                                        : null,
                                    child: !hasImage
                                        ? Icon(
                                            Icons.person_rounded,
                                            size: 35,
                                            color: Colors.grey.shade500,
                                          )
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 140,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            _getGreeting(),
                                            style: const TextStyle(
                                              fontSize: 24,
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: -0.5,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              'Admin $displayName!',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primary,
                                                letterSpacing: -0.5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Berikut laporan pelanggaran yang masuk.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.primary.withValues(
                                            alpha: 0.8,
                                          ),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),

                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Statistik Lalu Lintas',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    Icon(
                                      Icons.analytics_outlined,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildStatBox(
                                        value: totalReports.toString(),
                                        label: 'Total Aduan',
                                        color: AppColors.primary,
                                        bgColor: AppColors.primary.withValues(
                                          alpha: 0.06,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _buildStatBox(
                                        value: pendingCount.toString(),
                                        label: 'Dalam Proses',
                                        color: AppColors.warning,
                                        bgColor: AppColors.bgWarning,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildStatBox(
                                        value: rejectedCount.toString(),
                                        label: 'Ditolak',
                                        color: AppColors.errorRed,
                                        bgColor: AppColors.bgErrorRed,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _buildStatBox(
                                        value: resolvedCount.toString(),
                                        label: 'Selesai',
                                        color: AppColors.success,
                                        bgColor: AppColors.bgSuccess,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),

                          TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Cari plat nomor (cth: B 1234 PAT)...',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 14,
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: Colors.grey.shade400,
                                size: 22,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.8,
                                  ),
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              children: [
                                _buildFilterChip(
                                  label: 'Semua',
                                  targetFilter: null,
                                ),
                                const SizedBox(width: 8),
                                _buildFilterChip(
                                  label: 'Dalam Proses',
                                  targetFilter: ReportStatus.dalamProses,
                                ),
                                const SizedBox(width: 8),
                                _buildFilterChip(
                                  label: 'Selesai',
                                  targetFilter: ReportStatus.selesai,
                                ),
                                const SizedBox(width: 8),
                                _buildFilterChip(
                                  label: 'Ditolak',
                                  targetFilter: ReportStatus.ditolak,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          filteredReports.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 40.0,
                                    ),
                                    child: Text(
                                      'Tidak ada data laporan yang cocok.',
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                )
                              : Column(
                                  children: filteredReports
                                      .map(
                                        (report) =>
                                            _buildReportCard(report, context),
                                      )
                                      .toList(),
                                ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required ReportStatus? targetFilter,
  }) {
    final bool isSelected = _selectedStatusFilter == targetFilter;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          _selectedStatusFilter = targetFilter;
        });
      },
      selectedColor: AppColors.primary,
      backgroundColor: Colors.grey.shade50,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? Colors.white : Colors.grey.shade700,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.grey.shade200,
        ),
      ),
      showCheckmark: false,
    );
  }

  Widget _buildStatBox({
    required String value,
    required String label,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(ReportInfo report, BuildContext context) {
    Color statusColor = AppColors.warning;
    Color statusBg = AppColors.bgWarning;
    String displayStatusText = 'DALAM PROSES';

    if (report.status == ReportStatus.selesai) {
      statusColor = AppColors.success;
      statusBg = AppColors.bgSuccess;
      displayStatusText = 'SELESAI';
    } else if (report.status == ReportStatus.ditolak) {
      statusColor = AppColors.errorRed;
      statusBg = AppColors.bgErrorRed;
      displayStatusText = 'DITOLAK';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                report.fotoUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.image_outlined,
                  color: Colors.grey,
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        report.platNomor,
                        style: GoogleFonts.jetBrainsMono(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        displayStatusText,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  report.jenisInsiden,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Lokasi: ${report.alamat.split(',').first} • ${_getTimeAgo(report.createdAt)}',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
                if (report.adminNotes != null &&
                    report.adminNotes!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Catatan Admin: ${report.adminNotes}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                Row(
                  children: [
                    if (report.status == ReportStatus.dalamProses) ...[
                      SizedBox(
                        height: 36,
                        child: OutlinedButton(
                          onPressed: () =>
                              _openReviewBottomSheet(context, report),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Review',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailReportScreen(report: report),
                          ),
                        );
                      },
                      child: const Text(
                        'Detail Kejadian',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black38,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}