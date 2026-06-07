import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileprogramming_finalproject/utils/colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        dividerColor: Colors.transparent,
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
            'Tentang Aplikasi',
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
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        const Text(
                          'SiPatuh',
                          style: TextStyle(
                            fontFamily: 'CalSans',
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Aplikasi Monitoring Kendaraan & Pelaporan Masyarakat Berbasis AI',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'v1.0.0',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildAboutCard(
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bersama Warga, Membangun Kota Tertib.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'SiPatuh merupakan aplikasi monitoring kendaraan dan pelaporan masyarakat berbasis AI yang dirancang untuk membantu pengguna dalam mengelola administrasi kendaraan sekaligus mendukung penataan lalu lintas dan lingkungan kota yang lebih tertib.\n\nAplikasi ini memanfaatkan teknologi YOLO Object Detection dan OCR (Optical Character Recognition) untuk mendeteksi serta membaca plat nomor kendaraan secara otomatis dari gambar.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildExpansionCard(
                    title: 'Latar Belakang & Tujuan',
                    icon: Icons.lightbulb_outline_rounded,
                    children: [
                      const Text(
                        'Masih banyak masyarakat yang lupa masa berlaku STNK/plat kendaraan, kesulitan melakukan pelaporan kendaraan bermasalah, serta kurang memiliki media pelaporan yang cepat. SiPatuh hadir sebagai solusi berbasis AI yang menggabungkan pengingat administrasi, pelaporan masyarakat, dan dashboard petugas.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildBulletItem(
                        'Membantu memantau masa berlaku kendaraan.',
                      ),
                      _buildBulletItem(
                        'Mengurangi keterlambatan administrasi.',
                      ),
                      _buildBulletItem(
                        'Mempermudah pelaporan kendaraan bermasalah.',
                      ),
                      _buildBulletItem(
                        'Mendukung konsep smart city partisipatif.',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildExpansionCard(
                    title: 'Fitur Utama Aplikasi',
                    icon: Icons.star_border_rounded,
                    children: [
                      _buildFeatureItem(
                        'Smart Plate Scanner',
                        'Deteksi area plat dengan YOLOv8 dan baca teks otomatis menggunakan OCR.',
                      ),
                      _buildFeatureItem(
                        'Smart Vehicle Reminder',
                        'Pengingat masa berlaku STNK, plat nomor, dan countdown jatuh tempo.',
                      ),
                      _buildFeatureItem(
                        'Vehicle Incident Reporting',
                        'Laporkan parkir liar, kendaraan terbengkalai, ganjil-genap dilengkapi GPS & foto.',
                      ),
                      _buildFeatureItem(
                        'Push Notification System',
                        'Notifikasi lokal real-time menggunakan Awesome Notifications.',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildExpansionCard(
                    title: 'Arsitektur & Teknologi',
                    icon: Icons.code_rounded,
                    children: [
                      _buildTechRow('Mobile & Web', 'Flutter, React'),
                      _buildTechRow('Backend API', 'FastAPI, REST API'),
                      _buildTechRow('AI & CV', 'YOLOv8, EasyOCR'),
                      _buildTechRow(
                        'Cloud & DB',
                        'Firebase Firestore, Storage, Supabase',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildExpansionCard(
                    title: 'Privasi, Etika & Pengembangan',
                    icon: Icons.gavel_rounded,
                    children: [
                      const Text(
                        'SiPatuh BUKAN sistem tilang otomatis. Aplikasi ini adalah AI-assisted civic reporting platform. AI membantu identifikasi dan masyarakat membantu dokumentasi, namun validasi akhir serta tindak lanjut mutlak dilakukan oleh petugas berwenang untuk menjaga privasi.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                      const Divider(height: 24),
                      const Text(
                        'Rencana Pengembangan Selanjutnya:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildBulletItem(
                        'Heatmap lokasi laporan kendaraan bermasalah.',
                      ),
                      _buildBulletItem(
                        'Integrasi dengan smart city dashboard pemerintah.',
                      ),
                      _buildBulletItem('Monitoring kendaraan real-time.'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // --- FOOTER SDG ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSDGChip('SDG 11', 'Sustainable Cities'),
                      const SizedBox(width: 10),
                      _buildSDGChip('SDG 16', 'Strong Institutions'),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAboutCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildExpansionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ExpansionTile(
          leading: Icon(icon, color: AppColors.primary),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          childrenPadding: const EdgeInsets.only(
            left: 18,
            right: 18,
            bottom: 18,
          ),
          expandedAlignment: Alignment.topLeft,
          children: children,
        ),
      ),
    );
  }

  Widget _buildBulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechRow(String category, String tech) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              category,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const Text(': ', style: TextStyle(color: Colors.black54)),
          Expanded(
            child: Text(
              tech,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSDGChip(String label, String desc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.black87,
              shape: BoxShape.circle,
            ),
            child: Text(
              label.split(' ')[1],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
