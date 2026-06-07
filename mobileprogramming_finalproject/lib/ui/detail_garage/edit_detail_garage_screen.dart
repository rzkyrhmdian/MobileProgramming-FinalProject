import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileprogramming_finalproject/ui/shared_widgets/custom_textfield.dart';
import 'package:mobileprogramming_finalproject/ui/shared_widgets/custom_button.dart';
import 'package:mobileprogramming_finalproject/utils/colors.dart';

class EditDetailGarageScreen extends StatefulWidget {
  final String initialPlate;

  const EditDetailGarageScreen({super.key, required this.initialPlate});

  @override
  State<EditDetailGarageScreen> createState() => _EditDetailGarageScreenState();
}

class _EditDetailGarageScreenState extends State<EditDetailGarageScreen> {
  late TextEditingController _plateController;
  final _brandController = TextEditingController(text: 'Honda CR-V 1.5 Turbo');
  final _colorController = TextEditingController(
    text: 'Obsidian Black Metallic',
  );
  final _stnkController = TextEditingController(text: '12 Oktober 2028');
  final _vinController = TextEditingController(text: 'MHRRU1870JKXXXXXX');

  @override
  void initState() {
    super.initState();
    _plateController = TextEditingController(text: widget.initialPlate);
  }

  @override
  void dispose() {
    _plateController.dispose();
    _brandController.dispose();
    _colorController.dispose();
    _stnkController.dispose();
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

                        _buildLabel('Masa Berlaku STNK'),
                        CustomTextField(
                          controller: _stnkController,
                          hint: 'Masukkan Masa Berlaku STNK',
                          icon: Icons.calendar_today_outlined,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          keyboardType: TextInputType.datetime,
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    onTap: () {
                      Navigator.pop(context);
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
}
