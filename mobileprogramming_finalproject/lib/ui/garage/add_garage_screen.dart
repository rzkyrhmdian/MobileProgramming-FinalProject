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
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme,
            ),
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.primary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final formattedDate =
          "${picked.day} ${_getMonthName(picked.month)} ${picked.year}";
      _stnkExpController.text = formattedDate;
      _viewModel.updateStnkExp(formattedDate);
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[month - 1];
  }

  Future<void> _tryAddVehicle() async {
    if (_formKey.currentState!.validate()) {
      final success = await _viewModel.addVehicle();

      if (!mounted) return;

      if (!success) {
        if (_viewModel.error.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(_viewModel.error)));
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
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      child: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, _) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
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
            body: SizedBox.expand(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage('assets/images/backgroundGeneral.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(
                  20,
                  kToolbarHeight + 25,
                  20,
                  20,
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'Informasi Kendaraan',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          hint:
                              'Brand Kendaraan (Contoh: Honda CR-V 1.5 Turbo)',
                          icon: Icons.directions_car_outlined,
                          onChanged: _viewModel.updateBrand,
                          validator: (val) =>
                              val!.isEmpty ? 'Masukkan brand kendaraan' : null,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          dropdownColor: Colors.white,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(
                                left: 16.0,
                                right: 8.0,
                              ),
                              child: Icon(
                                Icons.category_outlined,
                                color: AppColors.primary,
                              ),
                            ),
                            hintText: 'Pilih Tipe Kendaraan',
                            hintStyle: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppColors.primary.withValues(alpha: 0.8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                          ),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.primary,
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.primary,
                          ),
                          items:
                              [
                                'Motor',
                                'Mobil (SUV/MPV/Sedan)',
                                'Truk/Pikap',
                                'Lainnya',
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              _viewModel.updateType(val);
                            }
                          },
                          validator: (val) => val == null || val.isEmpty
                              ? 'Pilih tipe kendaraan'
                              : null,
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
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(28),
                                      topRight: Radius.circular(28),
                                    ),
                                  ),
                                  child: SafeArea(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Container(
                                            width: 40,
                                            height: 4,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        const Text(
                                          'Pilih Sumber Foto',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                  _viewModel.pickImage(
                                                    ImageSource.camera,
                                                  );
                                                },
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 20,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                      0xFFF8F9FA,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                    border: Border.all(
                                                      color: AppColors.primary
                                                          .withValues(
                                                            alpha: 0.8,
                                                          ),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .camera_enhance_outlined,
                                                        color: AppColors.primary
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        size: 28,
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Text(
                                                        'Kamera',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AppColors
                                                              .primary
                                                              .withValues(
                                                                alpha: 0.8,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                  _viewModel.pickImage(
                                                    ImageSource.gallery,
                                                  );
                                                },
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 20,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                      0xFFF8F9FA,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                    border: Border.all(
                                                      color: AppColors.primary
                                                          .withValues(
                                                            alpha: 0.8,
                                                          ),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .photo_library_outlined,
                                                        color: AppColors.primary
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        size: 28,
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Text(
                                                        'Galeri',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AppColors
                                                              .primary
                                                              .withValues(
                                                                alpha: 0.8,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.8),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white.withValues(alpha: 0.8),
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
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_a_photo_outlined,
                                        size: 40,
                                        color: AppColors.primary.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Tap untuk menambahkan foto',
                                        style: TextStyle(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.8,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        CustomButton(
                          onTap: _tryAddVehicle,
                          height: 55,
                          width: double.infinity,
                          borderRadius: 50.0,
                          label: _viewModel.isLoading
                              ? 'Menyimpan...'
                              : 'Simpan Data',
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
      ),
    );
  }
}
