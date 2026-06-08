import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobileprogramming_finalproject/ui/report/report_viewmodel.dart';
import 'package:mobileprogramming_finalproject/ui/shared_widgets/custom_button.dart';
import 'package:mobileprogramming_finalproject/ui/shared_widgets/custom_textfield.dart';
import 'package:mobileprogramming_finalproject/utils/colors.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReportViewModel()..getCurrentLocation(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Lapor Insiden")),
        body: Consumer<ReportViewModel>(
          builder: (context, viewModel, _) => SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ----- BOX MAPS (Baru ditambahkan di paling atas) -----
                if (viewModel.currentLatitude != null && viewModel.currentLongitude != null)
                  Container(
                    height: 150, // Tinggi box maps
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        )
                      ]
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(viewModel.currentLatitude!, viewModel.currentLongitude!),
                          initialZoom: 16.0,
                          interactionOptions: const InteractionOptions(
                            flags: InteractiveFlag.none, // Dibuat statis, tidak bisa di-scroll
                          ),
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
                                child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                // -----------------------------------------------------

                // 1. Header Lokasi GPS (Kotak Biru)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue[50], 
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.blue),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          viewModel.currentAddress, 
                          style: const TextStyle(fontSize: 12, color: Colors.blueGrey)
                        )
                      ),
                    ]
                  ),
                ),
                const SizedBox(height: 20),

                // 2. Area Pilih Foto
                GestureDetector(
                  onTap: () => viewModel.pickImage(),
                  child: Container(
                    height: 120, 
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: viewModel.selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(viewModel.selectedImage!, fit: BoxFit.cover),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt, size: 30, color: Colors.grey),
                              Text("Foto Bukti", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // 3. Dropdown Jenis Laporan
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Jenis Laporan",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  ),
                  value: viewModel.selectedJenisInsiden,
                  items: viewModel.jenisInsidenList.map((val) => 
                    DropdownMenuItem(value: val, child: Text(val))
                  ).toList(),
                  onChanged: viewModel.setJenisInsiden,
                ),
                const SizedBox(height: 15),

                // 4. Input Plat Nomor
                CustomTextField(
                  controller: viewModel.platController,
                  hint: "Nomor Plat (Contoh: B 1234 ABC)",
                  icon: Icons.badge_outlined,
                  onChanged: (v) {},
                ),
                const SizedBox(height: 15),
                
                // 5. Input Deskripsi
                CustomTextField(
                  controller: viewModel.deskripsiController,
                  hint: "Deskripsi kejadian...",
                  icon: Icons.description_outlined,
                  onChanged: (v) {},
                ),
                const SizedBox(height: 30),

                // 6. Tombol Kirim Laporan
                viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator()) 
                    : CustomButton(
                        onTap: () async {
                          final success = await viewModel.submitReport();
                          if (!context.mounted) return; 

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Laporan berhasil dikirim!"), backgroundColor: Colors.green),
                            );
                            
                            viewModel.resetForm();
                            Navigator.pop(context); // Kembali ke riwayat
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Gagal mengirim laporan. Pastikan form lengkap & GPS aktif."), backgroundColor: Colors.red),
                            );
                          }
                        },
                        height: 55,
                        width: double.infinity,
                        label: "Kirim Laporan",
                        fontColor: Colors.white,
                        backgroundColor: AppColors.primary,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}