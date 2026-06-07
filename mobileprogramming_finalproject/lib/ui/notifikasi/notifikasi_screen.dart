import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileprogramming_finalproject/utils/colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            'Notifikasi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3F5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black54,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                tabs: const [
                  Tab(text: 'Aktivitas'),
                  Tab(text: 'Pengingat'),
                ],
              ),
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
            padding: const EdgeInsets.only(top: kToolbarHeight + 80),
            child: TabBarView(
              controller: _tabController,
              children: [
                // 1. Konten Tab Aktivitas (Laporan)
                _buildAktivitasTab(),
                // 2. Konten Tab Pengingat (STNK/Garasi)
                _buildPengingatTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAktivitasTab() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      children: [
        _buildNotificationCard(
          icon: Icons.check_circle_outline_rounded,
          iconColor: const Color(0xFF2E7D32),
          iconBgColor: const Color(0xFFE8F5E9),
          title: 'Laporan Selesai Ditindak',
          description:
              'Aduan Parkir Liar Anda di Jl. Sudirman telah diverifikasi dan diselesaikan oleh petugas di lapangan. Terima kasih!',
          time: '1 Jam yang lalu',
          isUnread: false,
        ),
        _buildNotificationCard(
          icon: Icons.hourglass_bottom_rounded,
          iconColor: const Color(0xFFEF6C00),
          iconBgColor: const Color(0xFFFFF3E0),
          title: 'Laporan Sedang Diproses',
          description:
              'Laporan Kendaraan Terbengkalai di area Tunjungan saat ini berstatus "Diproses" dan masuk tahap validasi petugas.',
          time: 'Kemarin',
          isUnread: false,
        ),
        _buildNotificationCard(
          icon: Icons.cancel_outlined,
          iconColor: const Color(0xFFC62828),
          iconBgColor: const Color(0xFFFFEBEE),
          title: 'Laporan Ditolak',
          description:
              'Aduan plat nomor rusak tidak dapat diproses karena foto lampiran buram dan tidak memenuhi standar validasi AI OCR.',
          time: '3 Hari yang lalu',
          isUnread: false,
        ),
      ],
    );
  }

  Widget _buildPengingatTab() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      children: [
        _buildNotificationCard(
          icon: Icons.warning_amber_rounded,
          iconColor: const Color(0xFFFF7A45),
          iconBgColor: const Color(0xFFFFEBE3),
          title: 'Masa Berlaku STNK Hampir Habis!',
          description:
              'Kendaraan Honda Vario (L 1899 FZ) Anda akan segera kedaluwarsa dalam 12 hari lagi. Segera urus administrasi Anda.',
          time: 'Baru saja',
          isUnread: false,
        ),
        _buildNotificationCard(
          icon: Icons.verified_user_outlined,
          iconColor: AppColors.primary,
          iconBgColor: AppColors.primary.withValues(alpha: 0.08),
          title: 'Reminder Selesai Diatur',
          description:
              'Notifikasi otomatis untuk Toyota Avanza (B 8899 XYZ) berhasil disinkronkan dengan sistem Awesome Notifications aplikasi.',
          time: '2 Hari yang lalu',
          isUnread: false,
        ),
      ],
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String description,
    required String time,
    required bool isUnread,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnread
            ? AppColors.primary.withValues(alpha: 0.03)
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isUnread
                              ? FontWeight.bold
                              : FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
