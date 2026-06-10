import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobileprogramming_finalproject/domain/model/report_info.dart';
import 'package:mobileprogramming_finalproject/ui/report/report_viewmodel.dart';
import 'package:mobileprogramming_finalproject/ui/shared_widgets/custom_button.dart';
import 'package:mobileprogramming_finalproject/ui/shared_widgets/custom_textfield.dart';
import 'package:mobileprogramming_finalproject/utils/colors.dart';

class ReportScreen extends StatelessWidget {
  final ReportInfo? existingReport;

  const ReportScreen({super.key, this.existingReport});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReportViewModel()..initForm(existingReport),
      child: Theme(
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
                icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black, size: 20),
              ),
            ),
            title: Text(
              existingReport != null ? "Edit Laporan" : "Lapor Insiden",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          body: Consumer<ReportViewModel>(
            builder: (context, viewModel, _) {
              return SizedBox.expand(
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
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (viewModel.currentLatitude != null && viewModel.currentLongitude != null)
                          Container(
                            height: 160,
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 4)),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: FlutterMap(
                                // TRIK MAPS: Gunakan ValueKey agar map otomatis me-refresh posisi saat tombol Perbarui ditekan
                                key: ValueKey('${viewModel.currentLatitude}_${viewModel.currentLongitude}'),
                                options: MapOptions(
                                  initialCenter: LatLng(viewModel.currentLatitude!, viewModel.currentLongitude!),
                                  initialZoom: 16.0,
                                  interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName: 'com.example.mobileprogramming_finalproject',
                                  ),
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: LatLng(viewModel.currentLatitude!, viewModel.currentLongitude!),
                                        width: 40,
                                        height: 40,
                                        child: const Icon(Icons.location_on_rounded, color: Colors.red, size: 36),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.my_location_rounded, size: 16, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  viewModel.currentAddress.isEmpty ? "Mencari lokasi GPS..." : viewModel.currentAddress,
                                  style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w500),
                                ),
                              ),
                              // TOMBOL PERBARUI KHUSUS MODE EDIT
                              if (existingReport != null) ...[
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Memperbarui lokasi ke titik saat ini..."), 
                                        duration: Duration(seconds: 2)
                                      ),
                                    );
                                    viewModel.getCurrentLocation(); // Panggil ulang GPS
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      "Perbarui",
                                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        _buildSectionLabel("Foto Bukti Kejadian"),
                        GestureDetector(
                          onTap: () => viewModel.pickImage(),
                          child: Container(
                            height: 160,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4)),
                              ],
                            ),
                            child: viewModel.selectedImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: Image.file(viewModel.selectedImage!, fit: BoxFit.cover),
                                  )
                                : (viewModel.existingFotoUrl != null)
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(18),
                                        child: Image.network(viewModel.existingFotoUrl!, fit: BoxFit.cover),
                                      )
                                    : Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_a_photo_outlined, size: 32, color: Colors.grey.shade400),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Ketuk untuk mengambil/memilih foto",
                                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildSectionLabel("Jenis Laporan"),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          dropdownColor: Colors.white,
                          style: GoogleFonts.poppins(color: Colors.black87, fontSize: 14),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
                          decoration: InputDecoration(
                            hintText: "Pilih Jenis Insiden",
                            hintStyle: TextStyle(color: AppColors.primary.withOpacity(0.8), fontSize: 14),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: AppColors.primary.withOpacity(0.5), width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                            ),
                          ),
                          value: viewModel.selectedJenisInsiden,
                          items: viewModel.jenisInsidenList
                              .map((val) => DropdownMenuItem(value: val, child: Padding(padding: const EdgeInsets.only(left: 4), child: Text(val))))
                              .toList(),
                          onChanged: viewModel.setJenisInsiden,
                        ),
                        const SizedBox(height: 20),

                        _buildSectionLabel("Nomor Plat Kendaraan"),
                        CustomTextField(
                          controller: viewModel.platController,
                          hint: "Contoh: B 1234 ABC",
                          icon: Icons.pin_outlined,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          onChanged: (v) {},
                        ),
                        const SizedBox(height: 20),

                        _buildSectionLabel("Deskripsi Kejadian"),
                        CustomTextField(
                          controller: viewModel.deskripsiController,
                          hint: "Ceritakan kronologi singkat insiden...",
                          icon: Icons.notes_rounded,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          onChanged: (v) {},
                        ),
                        const SizedBox(height: 35),

                        viewModel.isLoading
                            ? const SizedBox(height: 55, child: Center(child: CircularProgressIndicator()))
                            : CustomButton(
                                onTap: () async {
                                  final success = await viewModel.submitReport();
                                  if (!context.mounted) return;

                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(existingReport != null ? "Perubahan disimpan!" : "Laporan berhasil dikirim!"),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    viewModel.resetForm();
                                    Navigator.pop(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Gagal menyimpan. Pastikan form lengkap & GPS aktif."),
                                        backgroundColor: AppColors.errorRed,
                                      ),
                                    );
                                  }
                                },
                                height: 55,
                                width: double.infinity,
                                borderRadius: 50.0,
                                label: existingReport != null ? "Simpan Perubahan" : "Kirim Laporan",
                                fontSize: 16,
                                fontColor: Colors.white,
                                backgroundColor: AppColors.primary,
                              ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }
}