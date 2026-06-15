import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:mobileprogramming_finalproject/domain/model/garage_vehicle.dart';
import 'package:mobileprogramming_finalproject/ui/detail_garage/detail_garage_screen.dart';
import 'package:mobileprogramming_finalproject/ui/garage/add_garage_screen.dart';
import 'package:mobileprogramming_finalproject/ui/detail_garage/edit_detail_garage_screen.dart';
import 'package:mobileprogramming_finalproject/ui/garage/garage_viewmodel.dart';
import 'package:mobileprogramming_finalproject/ui/shared_widgets/confirm_action_dialog.dart';
import 'package:mobileprogramming_finalproject/utils/colors.dart';
import 'package:mobileprogramming_finalproject/ui/main/main_screen.dart';
class GarageScreen extends StatefulWidget {
  const GarageScreen({super.key});

  @override
  State<GarageScreen> createState() => _GarageScreenState();
}

class _GarageScreenState extends State<GarageScreen> {
  Future<void> _showPopUpActions(
    BuildContext context,
    TapDownDetails details,
    GarageVehicle vehicle,
    GarageViewModel viewModel,
  ) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(details.globalPosition, details.globalPosition),
      Offset.zero & overlay.size,
    );

    final String? selectedAction = await showMenu<String>(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      items: [
        PopupMenuItem<String>(
          value: 'edit',
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: const [
              Icon(Icons.edit_outlined, size: 20),
              SizedBox(width: 12),
              Text('Edit Kendaraan', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: const [
              Icon(Icons.delete_outline_rounded, size: 20),
              SizedBox(width: 12),
              Text('Hapus Kendaraan', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    );

    if (!context.mounted || selectedAction == null) return;

    if (selectedAction == 'edit') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditDetailGarageScreen(vehicle: vehicle),
        ),
      ).then((_) {
        if (context.mounted) {
          viewModel.loadVehicles();
        }
      });
    } else if (selectedAction == 'delete') {
      showConfirmActionDialog(
        context: context,
        title: 'Hapus Kendaraan?',
        message: 'Data kendaraan ${vehicle.plateNumber} akan dihapus secara permanen dari garasi SiPatuh Anda.',
        confirmLabel: 'Hapus',
        cancelLabel: 'Batal',
        onConfirm: () async {
          final success = await viewModel.deleteVehicle(vehicle.id);
          if (success && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${vehicle.brand} berhasil dihapus dari garasi.'),
                backgroundColor: Colors.green,
              ),
            );
            viewModel.loadVehicles();
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
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      child: ChangeNotifierProvider(
        create: (_) => GarageViewModel()..loadVehicles(),
        child: Consumer<GarageViewModel>(
          builder: (context, viewModel, _) {
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainScreen(),
                      ),
                    ),
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
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddGarageScreen(),
                                ),
                              ).then((_) {
                                if (context.mounted) {
                                  context.read<GarageViewModel>().loadVehicles();
                                }
                              });
                            },
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
                              side: BorderSide(
                                color: AppColors.primary,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        if (viewModel.isLoading && viewModel.vehicles.isEmpty)
                          const Center(child: CircularProgressIndicator())
                        else if (viewModel.error.isNotEmpty)
                          _buildMessageCard(
                            icon: Icons.error_outline_rounded,
                            title: 'Gagal memuat data',
                            message: viewModel.error,
                            color: AppColors.errorRed,
                          )
                        else if (viewModel.vehicles.isEmpty)
                          _buildMessageCard(
                            icon: Icons.directions_car_outlined,
                            title: 'Belum ada kendaraan',
                            message:
                                'Tambahkan kendaraan ke garasi untuk mulai memantau STNK dan status pajaknya.',
                            color: AppColors.primary,
                          )
                        else
                          ...viewModel.vehicles.expand(
                            (vehicle) => [
                              _buildVehicleCard(
                                context: context,
                                viewModel: viewModel,
                                vehicle: vehicle,
                              ),
                              const SizedBox(height: 18),
                            ],
                          ),
                        const SizedBox(height: 7),
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

  Widget _buildMessageCard({
    required IconData icon,
    required String title,
    required String message,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[800],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard({
    required BuildContext context,
    required GarageViewModel viewModel,
    required GarageVehicle vehicle,
  }) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DetailGarageScreen(plateNumber: vehicle.plateNumber),
        ),
      ).then((_) {
        if (context.mounted) {
          viewModel.loadVehicles();
        }
      }),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle.brand,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      vehicle.category,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                GestureDetector(
                  onTapDown: (details) =>
                      _showPopUpActions(context, details, vehicle, viewModel),
                  child: const Icon(Icons.more_vert, color: Colors.grey),
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
                  vehicle.plateNumber,
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
            _buildTaxStatusRow(
              'Tahunan',
              vehicle.annualTaxStatus,
              vehicle.annualTaxStatusText,
              vehicle.annualTaxBadgeText,
            ),
            const SizedBox(height: 8),
            _buildTaxStatusRow(
              '5 Tahunan',
              vehicle.fiveYearTaxStatus,
              vehicle.fiveYearTaxStatusText,
              vehicle.fiveYearTaxBadgeText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaxStatusRow(String title, GarageVehicleStatus status, String statusText, String badgeText) {
    Color statusColor;
    Color statusBg;
    IconData statusIcon;

    switch (status) {
      case GarageVehicleStatus.aman:
        statusColor = AppColors.success;
        statusBg = AppColors.bgSuccess;
        statusIcon = Icons.check_circle_outline_rounded;
        break;
      case GarageVehicleStatus.mendekati:
        statusColor = AppColors.warning;
        statusBg = AppColors.bgWarning;
        statusIcon = Icons.warning_amber_rounded;
        break;
      case GarageVehicleStatus.terlambat:
        statusColor = AppColors.errorRed;
        statusBg = AppColors.bgErrorRed;
        statusIcon = Icons.error_outline_rounded;
        break;
    }

    return Container(
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
    );
  }
}
