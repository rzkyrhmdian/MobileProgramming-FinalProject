import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileprogramming_finalproject/utils/colors.dart';
import 'package:mobileprogramming_finalproject/ui/detail_garage/detail_garage_screen.dart';

class GarageScreen extends StatefulWidget {
  const GarageScreen({super.key});

  @override
  State<GarageScreen> createState() => _GarageScreenState();
}

class _GarageScreenState extends State<GarageScreen> {
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
              onPressed: () {},
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
          title: const Text(
            'Garasi',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Garasi Anda',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kelola aset kendaraan pribadi dengan aman. Pantau status pajak dan masa berlaku STNK.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[800],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.add_circle_outline_rounded,
                        size: 20,
                      ),
                      label: const Text(
                        'Tambah Kendaraan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(color: AppColors.primary, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  _buildVehicleCard(
                    brand: 'Honda CR-V',
                    type: 'SUV • Obsidian Black',
                    plateNumber: 'B 1234 PAT',
                    region: 'METRO JAYA',
                    stnkExp: '12 Okt 2028',
                    status: VehicleStatus.aman,
                    statusText: 'Pajak Aman',
                    badgeText: 'Aman',
                  ),
                  const SizedBox(height: 18),
                  _buildVehicleCard(
                    brand: 'Toyota Avanza',
                    type: 'MPV • Silver Metallic',
                    plateNumber: 'B 8899 XYZ',
                    region: 'METRO JAYA',
                    stnkExp: '15 Mar 2027',
                    status: VehicleStatus.mendekati,
                    statusText: 'Pajak Mendekati Jatuh Tempo',
                    badgeText: '7 Hari Lagi',
                  ),
                  const SizedBox(height: 18),
                  _buildVehicleCard(
                    brand: 'Yamaha NMAX',
                    type: 'Motorcycle • Matte Grey',
                    plateNumber: 'B 5678 TUH',
                    region: 'METRO JAYA',
                    stnkExp: '20 Jan 2026',
                    status: VehicleStatus.terlambat,
                    statusText: 'Pajak Terlambat / Kedaluwarsa',
                    badgeText: 'Terlambat',
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleCard({
    required String brand,
    required String type,
    required String plateNumber,
    required String stnkExp,
    required String region,
    required VehicleStatus status,
    required String statusText,
    required String badgeText,
  }) {
    Color statusColor;
    Color statusBg;
    IconData statusIcon;

    switch (status) {
      case VehicleStatus.aman:
        statusColor = AppColors.success;
        statusBg = AppColors.bgSuccess;
        statusIcon = Icons.check_circle_outline_rounded;
        break;
      case VehicleStatus.mendekati:
        statusColor = AppColors.warning;
        statusBg = AppColors.bgWarning;
        statusIcon = Icons.warning_amber_rounded;
        break;
      case VehicleStatus.terlambat:
        statusColor = AppColors.errorRed;
        statusBg = AppColors.bgErrorRed;
        statusIcon = Icons.error_outline_rounded;
        break;
    }

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailGarageScreen(plateNumber: plateNumber),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row Atas: Nama Kendaraan & Icon Aksi Menu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      brand,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      type,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                GestureDetector(
                  onTapDown: (details) => _showPopUpActions(context, details),
                  child: Icon(Icons.more_vert, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  plateNumber,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(statusIcon, color: statusColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      badgeText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  size: 16,
                  color: AppColors.primary.withValues(alpha: 0.9),
                ),
                const SizedBox(width: 6),
                Text(
                  'Masa Berlaku STNK:',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primary.withValues(alpha: 0.9),
                  ),
                ),
                const Spacer(),
                Text(
                  stnkExp,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPopUpActions(BuildContext context, TapDownDetails details) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(details.globalPosition, details.globalPosition),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position, // Posisi menu melayang muncul
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      items: [
        PopupMenuItem<String>(
          value: 'edit',
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Icon(Icons.edit_outlined, size: 20),
              const SizedBox(width: 12),
              const Text('Edit Kendaraan', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Icon(Icons.delete_outline_rounded, size: 20),
              const SizedBox(width: 12),
              const Text('Hapus Kendaraan', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    ).then((String? value) {
      if (value == 'edit') {
        // Logika edit kendaraan kamu di sini
      } else if (value == 'delete') {
        // Logika hapus kendaraan kamu di sini
      }
    });
  }
}

// Enum untuk mempermudah pengaturan status visual
enum VehicleStatus { aman, mendekati, terlambat }
