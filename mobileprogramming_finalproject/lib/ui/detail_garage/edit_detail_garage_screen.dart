import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileprogramming_finalproject/ui/shared_widgets/custom_textfield.dart';
import 'package:mobileprogramming_finalproject/ui/shared_widgets/custom_button.dart';
import 'package:mobileprogramming_finalproject/utils/colors.dart';

import 'package:mobileprogramming_finalproject/domain/model/garage_vehicle.dart';
import 'package:mobileprogramming_finalproject/data/repository/garage_repository_impl.dart';

class EditDetailGarageScreen extends StatefulWidget {
  final GarageVehicle vehicle;

  const EditDetailGarageScreen({super.key, required this.vehicle});

  @override
  State<EditDetailGarageScreen> createState() => _EditDetailGarageScreenState();
}

class _EditDetailGarageScreenState extends State<EditDetailGarageScreen> {
  late TextEditingController _plateController;
  late TextEditingController _brandController;
  late TextEditingController _regionController;
  late TextEditingController _colorController;
  late TextEditingController _annualTaxExpController;
  late TextEditingController _fiveYearTaxExpController;
  late TextEditingController _vinController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _plateController = TextEditingController(text: widget.vehicle.plateNumber);
    _brandController = TextEditingController(text: widget.vehicle.brand);
    _regionController = TextEditingController(text: widget.vehicle.region);
    _colorController = TextEditingController(text: widget.vehicle.color);
    _annualTaxExpController = TextEditingController(text: _formatDate(widget.vehicle.annualTaxExpiry));
    _fiveYearTaxExpController = TextEditingController(text: _formatDate(widget.vehicle.fiveYearTaxExpiry));
    _vinController = TextEditingController(text: 'MHRRU1870JKXXXXXX'); // Dummy
  }

  String _formatDate(DateTime date) {
    const months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  Future<void> _selectDate(BuildContext context, bool isAnnual) async {
    final DateTime initialDate = isAnnual ? widget.vehicle.annualTaxExpiry : widget.vehicle.fiveYearTaxExpiry;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isAnnual) {
          _annualTaxExpController.text = _formatDate(picked);
        } else {
          _fiveYearTaxExpController.text = _formatDate(picked);
        }
      });
    }
  }

  @override
  void dispose() {
    _plateController.dispose();
    _brandController.dispose();
    _regionController.dispose();
    _colorController.dispose();
    _annualTaxExpController.dispose();
    _fiveYearTaxExpController.dispose();
    _vinController.dispose();
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
            'Edit Data Kendaraan',
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
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Nomor Plat (TNKB)'),
                        CustomTextField(
                          controller: _plateController,
                          hint: 'Masukkan Nomor Plat',
                          icon: Icons.badge_outlined,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Merk & Tipe Kendaraan'),
                        CustomTextField(
                          controller: _brandController,
                          hint: 'Contoh: Honda CR-V 1.5 Turbo',
                          icon: Icons.directions_car_filled_outlined,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Region Kendaraan'),
                        CustomTextField(
                          controller: _regionController,
                          hint: 'Contoh: JAWA TIMUR',
                          icon: Icons.map_outlined,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Warna Kendaraan'),
                        CustomTextField(
                          controller: _colorController,
                          hint: 'Masukkan Warna Kendaraan',
                          icon: Icons.palette_outlined,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Jatuh Tempo Pajak Tahunan'),
                        CustomTextField(
                          controller: _annualTaxExpController,
                          hint: 'Pilih Masa Berlaku',
                          icon: Icons.calendar_today_outlined,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          readOnly: true,
                          onTap: () => _selectDate(context, true),
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Akhir Masa Berlaku STNK'),
                        CustomTextField(
                          controller: _fiveYearTaxExpController,
                          hint: 'Pilih Akhir Masa Berlaku STNK',
                          icon: Icons.calendar_month_outlined,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          readOnly: true,
                          onTap: () => _selectDate(context, false),
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : CustomButton(
                          onTap: () async {
                            setState(() {
                              _isLoading = true;
                            });

                            final updatedVehicle = widget.vehicle.copyWith(
                              plateNumber: _plateController.text,
                              brand: _brandController.text,
                              region: _regionController.text,
                              color: _colorController.text,
                              annualTaxExpiry: _parseDate(_annualTaxExpController.text),
                              fiveYearTaxExpiry: _parseDate(_fiveYearTaxExpController.text),
                              isAnnualPaid: widget.vehicle.isAnnualPaid,
                              isFiveYearPaid: widget.vehicle.isFiveYearPaid,
                            );

                            final repository = GarageRepositoryImpl();
                            final success = await repository.updateVehicle(updatedVehicle);

                            if (mounted) {
                              setState(() {
                                _isLoading = false;
                              });

                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Perubahan berhasil disimpan!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.pop(context, _plateController.text);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Gagal menyimpan perubahan.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          height: 65,
                          width: double.infinity,
                          borderRadius: 50.0,
                          label: "Simpan Perubahan",
                          fontSize: 16,
                          fontColor: Colors.white,
                          backgroundColor: AppColors.primary,
                        ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  DateTime _parseDate(String dateStr) {
    const months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    try {
      final parts = dateStr.split(' ');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = months.indexOf(parts[1]) + 1;
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (e) {
      // fallback
    }
    return DateTime.now();
  }
}
