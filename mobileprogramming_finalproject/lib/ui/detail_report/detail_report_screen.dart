import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobileprogramming_finalproject/domain/model/report_info.dart';
import 'package:mobileprogramming_finalproject/ui/report/report_map_detail_screen.dart';
import 'package:mobileprogramming_finalproject/utils/colors.dart';

class DetailReportScreen extends StatelessWidget {
  final ReportInfo report;
  const DetailReportScreen({super.key, required this.report});

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = AppColors.warning;
    Color statusBg = AppColors.bgWarning;

    if (report.status == ReportStatus.selesai) {
      statusColor = AppColors.success;
      statusBg = AppColors.bgSuccess;
    } else if (report.status == ReportStatus.ditolak) {
      statusColor = AppColors.errorRed;
      statusBg = AppColors.bgErrorRed;
    }

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
          title: const Text(
            'Detail Laporan Insiden',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: SizedBox.expand(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage('assets/images/backgroundGeneral.png'),
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.only(top: kToolbarHeight + 20),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroImage(
                    report.fotoUrl,
                    report.status == ReportStatus.dalamProses
                        ? 'DALAM PROSES'
                        : report.status == ReportStatus.selesai
                            ? 'SELESAI'
                            : 'DITOLAK',
                    statusColor,
                    statusBg,
                  ),
                  const SizedBox(height: 25),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F1A2C),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        report.platNomor,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  const Text(
                    'Status & Waktu Pelaporan',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(
                          Icons.campaign_outlined,
                          'Jenis Insiden / Pelanggaran',
                          report.jenisInsiden,
                        ),
                        const SizedBox(height: 24),
                        _buildDetailRow(
                          Icons.access_time_rounded,
                          'Waktu Kejadian',
                          _formatDateTime(report.createdAt),
                        ),
                        const SizedBox(height: 24),
                        _buildDetailRow(
                          Icons.verified_user_outlined,
                          'Status Verifikasi Laporan',
                          report.status == ReportStatus.dalamProses
                              ? 'DALAM PROSES'
                              : report.status == ReportStatus.selesai
                                  ? 'SELESAI'
                                  : 'DITOLAK',
                          valueColor: statusColor,
                        ),

                        // ========================================================
                        // TEMPAT MENAMPILKAN NOTE DARI ADMIN (EKSKLUSIF DI SINI)
                        // ========================================================
                        if (report.adminNotes != null && report.adminNotes!.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          _buildDetailRow(
                            Icons.rate_review_outlined,
                            'Catatan Tambahan dari Admin',
                            report.adminNotes!,
                            valueColor: Colors.blue.shade900,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Detail Kronologi & Lokasi',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          Icons.location_on_outlined,
                          'Alamat TKP',
                          report.alamat,
                        ),
                        const SizedBox(height: 24),
                        _buildDetailRow(
                          Icons.description_outlined,
                          'Deskripsi Kronologi',
                          report.deskripsi.isEmpty ? '-' : report.deskripsi,
                        ),
                        const SizedBox(height: 24),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ReportMapDetailScreen(report: report),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12), 
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F3F5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.map_outlined,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Koordinat GPS',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${report.latitude}, ${report.longitude}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.accent, 
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Ketuk untuk melihat peta digital live',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade400,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                    top: 12.0,
                                    right: 8.0,
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.black54,
                                    size: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroImage(
    String imageUrl,
    String status,
    Color statusColor,
    Color statusBg,
  ) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white, width: 4),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: statusColor.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Text(
                status.toUpperCase(),
                style: TextStyle(
                  color: statusColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F3F5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: valueColor ?? Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}