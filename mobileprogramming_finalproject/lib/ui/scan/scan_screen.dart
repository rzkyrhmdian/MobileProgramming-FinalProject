import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileprogramming_finalproject/ui/scan/scan_viewmodel.dart';
import 'package:mobileprogramming_finalproject/domain/model/plate_info.dart';
import 'package:mobileprogramming_finalproject/utils/colors.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      child: ChangeNotifierProvider(
        create: (_) => ScanViewModel(),
        child: const _ScanScreenContent(),
      ),
    );
  }
}

class _ScanScreenContent extends StatelessWidget {
  const _ScanScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.primary,
                ),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: const Text(
          'Smart Scan',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<ScanViewModel>(
          builder: (context, viewModel, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image Preview
                  _buildImagePreview(viewModel),
                  const SizedBox(height: 24),

                  // Action Buttons
                  if (viewModel.state != ScanState.loading)
                    _buildActionButtons(context, viewModel),

                  // Loading Indicator
                  if (viewModel.state == ScanState.loading)
                    _buildLoadingIndicator(),

                  const SizedBox(height: 24),

                  // Result Card
                  if (viewModel.state == ScanState.success &&
                      viewModel.plateInfo != null)
                    _buildResultCard(viewModel.plateInfo!),

                  // Error Message
                  if (viewModel.state == ScanState.error)
                    _buildErrorCard(
                      viewModel.errorMessage ?? 'Terjadi kesalahan',
                    ),

                  // Reset Button
                  if (viewModel.state == ScanState.success ||
                      viewModel.state == ScanState.error)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: TextButton.icon(
                        onPressed: viewModel.reset,
                        icon: const Icon(Icons.refresh, color: Colors.white70),
                        label: const Text(
                          'Scan Ulang',
                          style: TextStyle(
                            color: Colors.white70,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Area preview gambar dengan overlay kotak pembidik plat.
  Widget _buildImagePreview(ScanViewModel viewModel) {
    return Container(
      width: double.infinity,
      height: 280,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: viewModel.capturedImage != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(viewModel.capturedImage!, fit: BoxFit.cover),
                  // Overlay kotak pembidik
                  CustomPaint(painter: _PlateOverlayPainter()),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.document_scanner_outlined,
                      size: 64,
                      color: AppColors.secondary.withValues(alpha: 0.65),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Ambil foto plat kendaraan',
                      style: TextStyle(
                        color: AppColors.textPrimary.withValues(alpha: 0.72),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Gunakan kamera atau pilih dari galeri',
                      style: TextStyle(
                        color: AppColors.textSecondary.withValues(alpha: 0.82),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  /// Tombol aksi: Kamera dan Galeri.
  Widget _buildActionButtons(BuildContext context, ScanViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.camera_alt_rounded,
            label: 'Kamera',
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            onTap: () => viewModel.scanFromCamera(),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _ActionButton(
            icon: Icons.photo_library_rounded,
            label: 'Galeri',
            gradient: const LinearGradient(
              colors: [AppColors.secondary, AppColors.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            onTap: () => viewModel.scanFromGallery(),
          ),
        ),
      ],
    );
  }

  /// Indikator loading saat proses scan berlangsung.
  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        const SizedBox(height: 16),
        SizedBox(
          width: 48,
          height: 48,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Memproses gambar dengan AI...',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  /// Card yang menampilkan hasil scan (nomor plat & masa berlaku).
  Widget _buildResultCard(PlateInfo info) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.background, AppColors.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 24,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Hasil Scan',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: AppColors.border.withValues(alpha: 0.18), height: 1),
          const SizedBox(height: 20),

          // Nomor Plat
          _ResultRow(
            icon: Icons.directions_car_rounded,
            label: 'Nomor Plat',
            value: info.plat ?? 'Tidak terdeteksi',
            isDetected: info.isPlateFound,
          ),
          const SizedBox(height: 16),

          // Masa Berlaku
          _ResultRow(
            icon: Icons.calendar_month_rounded,
            label: 'Masa Berlaku',
            value: info.masaBerlaku ?? 'Tidak terdeteksi',
            isDetected: info.isExpirationFound,
          ),
        ],
      ),
    );
  }

  /// Card untuk menampilkan pesan error.
  Widget _buildErrorCard(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Widgets

/// Tombol aksi dengan gradient dan ikon.
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Gradient gradient;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.18),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.background, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.background,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Baris hasil scan individual (plat / masa berlaku).
class _ResultRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDetected;

  const _ResultRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDetected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: isDetected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontSize: isDetected ? 18 : 14,
                  fontWeight: isDetected ? FontWeight.w700 : FontWeight.w400,
                  fontFamily: 'Poppins',
                  fontStyle: isDetected ? FontStyle.normal : FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Custom Painter untuk Overlay Pembidik Plat

/// Menggambar overlay kotak pembidik transparan di atas preview gambar.
/// Membantu user memposisikan plat kendaraan di area yang benar.
class _PlateOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.secondary.withValues(alpha: 0.55)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    // Posisi kotak pembidik (centered, lebar 70% dari canvas)
    final double rectWidth = size.width * 0.7;
    final double rectHeight = size.height * 0.3;
    final double left = (size.width - rectWidth) / 2;
    final double top = (size.height - rectHeight) / 2;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, rectWidth, rectHeight),
      const Radius.circular(12),
    );

    // Gambar kotak pembidik
    canvas.drawRRect(rect, paint);

    // Corner accents (garis pendek di 4 sudut)
    final cornerPaint = Paint()
      ..color = AppColors.accent
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const double cornerLength = 24;
    final double right = left + rectWidth;
    final double bottom = top + rectHeight;
    const double r = 12; // radius

    // Top-left corner
    canvas.drawLine(
      Offset(left, top + r + cornerLength),
      Offset(left, top + r),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + r, top),
      Offset(left + r + cornerLength, top),
      cornerPaint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(right, top + r + cornerLength),
      Offset(right, top + r),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(right - r, top),
      Offset(right - r - cornerLength, top),
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(left, bottom - r - cornerLength),
      Offset(left, bottom - r),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + r, bottom),
      Offset(left + r + cornerLength, bottom),
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(right, bottom - r - cornerLength),
      Offset(right, bottom - r),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(right - r, bottom),
      Offset(right - r - cornerLength, bottom),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
