import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobileprogramming_finalproject/ui/garage/add_garage_viewmodel.dart';
import 'package:mobileprogramming_finalproject/ui/shared_widgets/custom_button.dart';
import 'package:mobileprogramming_finalproject/ui/shared_widgets/custom_textfield.dart';
import 'package:mobileprogramming_finalproject/utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AddGarageScreen extends StatefulWidget {
  const AddGarageScreen({super.key});

  @override
  State<AddGarageScreen> createState() => _AddGarageScreenState();
}

class _AddGarageScreenState extends State<AddGarageScreen> {
  final AddGarageViewModel _viewModel = AddGarageViewModel();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _stnkExpController = TextEditingController();

  @override
  void dispose() {
    _viewModel.dispose();
    _stnkExpController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final formattedDate = "${picked.day} ${_getMonthName(picked.month)} ${picked.year}";
      _stnkExpController.text = formattedDate;
      _viewModel.updateStnkExp(formattedDate);
    }
  }

  String _getMonthName(int month) {
    const months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    return months[month - 1];
  }

  Future<void> _tryAddVehicle() async {
    if (_formKey.currentState!.validate()) {
      final success = await _viewModel.addVehicle();

      if (!mounted) return;

      if (!success) {
        if (_viewModel.error.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_viewModel.error)),
          );
        }
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kendaraan berhasil ditambahkan')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          ),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.black,
                  size: 20,
                ),
              ),
              title: const Text(
                'Tambah Kendaraan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            body: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informasi Kendaraan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        hint: 'Brand Kendaraan (Contoh: Honda CR-V 1.5 Turbo)',
                        icon: Icons.directions_car_outlined,
                        onChanged: _viewModel.updateBrand,
                        validator: (val) =>
                            val!.isEmpty ? 'Masukkan brand kendaraan' : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                            child: Icon(Icons.category_outlined, color: AppColors.primary),
                          ),
                          hintText: 'Pilih Kategori Kendaraan',
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.primary.withAlpha(179),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
                        ),
                        style: GoogleFonts.poppins(fontSize: 14, color: AppColors.primary),
                        icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
                        items: [
                          'Motor',
                          'Mobil (SUV/MPV/Sedan)',
                          'Truk/Pikap',
                          'Lainnya'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            _viewModel.updateCategory(val);
                          }
                        },
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Pilih kategori kendaraan' : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        hint: 'Plat Nomor (Contoh: M 1234 SNP)',
                        icon: Icons.pin_outlined,
                        onChanged: _viewModel.updatePlateNumber,
                        validator: (val) =>
                            val!.isEmpty ? 'Masukkan plat nomor' : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _stnkExpController,
                        hint: 'Masa Berlaku STNK (Pilih Tanggal)',
                        icon: Icons.calendar_month_outlined,
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        onChanged: (val) {}, // ditangani oleh controller
                        validator: (val) =>
                            val!.isEmpty ? 'Pilih masa berlaku STNK' : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        hint: 'Warna (Contoh: Obsidian Black Metallic)',
                        icon: Icons.color_lens_outlined,
                        onChanged: _viewModel.updateColor,
                        validator: (val) =>
                            val!.isEmpty ? 'Masukkan warna kendaraan' : null,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Foto Kendaraan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => SafeArea(
                              child: Wrap(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.camera_alt),
                                    title: const Text('Kamera'),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      _viewModel.pickImage(ImageSource.camera);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text('Galeri'),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      _viewModel.pickImage(ImageSource.gallery);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400, width: 1),
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey.shade100,
                          ),
                          child: _viewModel.imageFile != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.file(
                                    _viewModel.imageFile!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                )
                              : const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_a_photo_outlined, size: 40, color: Colors.grey),
                                    SizedBox(height: 8),
                                    Text('Tap untuk menambahkan foto', style: TextStyle(color: Colors.grey)),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      CustomButton(
                        onTap: _tryAddVehicle,
                        height: 55,
                        width: double.infinity,
                        borderRadius: 15.0,
                        label: _viewModel.isLoading ? 'Menyimpan...' : 'Simpan Data',
                        fontSize: 16,
                        fontColor: Colors.white,
                        backgroundColor: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
