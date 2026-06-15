import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:mobileprogramming_finalproject/domain/model/garage_vehicle.dart';
import 'package:mobileprogramming_finalproject/ui/detail_garage/detail_garage_viewmodel.dart';
import 'package:mobileprogramming_finalproject/ui/detail_garage/edit_detail_garage_screen.dart';
import 'package:mobileprogramming_finalproject/ui/shared_widgets/confirm_action_dialog.dart';
import 'package:mobileprogramming_finalproject/utils/colors.dart';

class DetailGarageScreen extends StatelessWidget {
  final String plateNumber;

  const DetailGarageScreen({super.key, required this.plateNumber});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      child: ChangeNotifierProvider(
        create: (_) =>
            DetailGarageViewModel(plateNumber: plateNumber)..loadVehicle(),
        child: Consumer<DetailGarageViewModel>(
          builder: (context, viewModel, _) {
            final vehicle = viewModel.vehicle;

            return Scaffold(
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
                  'Detail Kendaraan',
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
                    child: viewModel.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : viewModel.error.isNotEmpty || vehicle == null
                        ? _buildErrorState(
                            context,
                            viewModel.error.isNotEmpty
                                ? viewModel.error
                                : 'Kendaraan tidak ditemukan.',
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHeroImage(vehicle),
                              const SizedBox(height: 25),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F1A2C),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    vehicle.plateNumber,
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 5,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 25),
                              const Text(
                                'Masa Berlaku & Legalitas',
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
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    _buildDetailRow(
                                      Icons.badge_outlined,
                                      'Nomor Plat (TNKB)',
                                      vehicle.plateNumber,
                                    ),
                                    const SizedBox(height: 30),
                                    _buildDetailRow(
                                      Icons.calendar_today_outlined,
                                      'Jatuh Tempo Pajak Tahunan',
                                      _formatDate(vehicle.annualTaxExpiry),
                                    ),
                                    const SizedBox(height: 15),
                                    _buildDetailRow(
                                      Icons.verified_user_outlined,
                                      'Status Pajak Tahunan',
                                      vehicle.annualTaxStatusText,
                                    ),
                                    const SizedBox(height: 30),
                                    _buildDetailRow(
                                      Icons.calendar_month_outlined,
                                      'Jatuh Tempo Pajak 5 Tahunan',
                                      _formatDate(vehicle.fiveYearTaxExpiry),
                                    ),
                                    const SizedBox(height: 15),
                                    _buildDetailRow(
                                      Icons.verified_outlined,
                                      'Status Pajak 5 Tahunan',
                                      vehicle.fiveYearTaxStatusText,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Informasi Kendaraan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    _buildDetailRow(
                                      Icons.directions_car_filled_outlined,
                                      'Merk & Tipe',
                                      vehicle.brand,
                                    ),
                                    const SizedBox(height: 30),
                                    _buildDetailRow(
                                      Icons.palette_outlined,
                                      'Warna Kendaraan',
                                      vehicle.color,
                                    ),
                                    const SizedBox(height: 30),
                                    _buildDetailRow(
                                      Icons.category_outlined,
                                      'Jenis Kendaraan',
                                      vehicle.category,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditDetailGarageScreen(
                                                  vehicle: vehicle,
                                                ),
                                          ),
                                        ).then((newPlate) {
                                          if (newPlate != null && newPlate is String) {
                                            viewModel.updatePlateNumber(newPlate);
                                          }
                                          viewModel.loadVehicle();
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.edit_note_rounded,
                                        size: 22,
                                      ),
                                      label: const Text(
                                        'Edit Kendaraan',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        elevation: 0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: OutlinedButton.icon(
                                      onPressed: () => _showDeleteConfirmation(
                                        context,
                                        vehicle,
                                        viewModel,
                                      ),
                                      icon: const Icon(
                                        Icons.delete_outline_rounded,
                                        size: 20,
                                      ),
                                      label: const Text(
                                        'Hapus Kendaraan',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.red.shade700,
                                        side: BorderSide(
                                          color: Colors.red.shade700,
                                          width: 1.5,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  Widget _buildHeroImage(GarageVehicle vehicle) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white, width: 4),
        image: DecorationImage(
          image: NetworkImage(vehicle.imageUrl),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
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
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, GarageVehicle vehicle, DetailGarageViewModel viewModel) {
    showConfirmActionDialog(
      context: context,
      title: 'Hapus Kendaraan?',
      message: 'Data kendaraan ${vehicle.plateNumber} akan dihapus secara permanen dari garasi SiPatuh Anda.',
      confirmLabel: 'Hapus',
      cancelLabel: 'Batal',
      onConfirm: () async {
        final success = await viewModel.deleteVehicle();
        if (success && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kendaraan berhasil dihapus'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Go back to garage screen
        } else if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(viewModel.error.isNotEmpty ? viewModel.error : 'Gagal menghapus kendaraan'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 44),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Kembali'),
            ),
          ),
        ],
      ),
    );
  }
}
