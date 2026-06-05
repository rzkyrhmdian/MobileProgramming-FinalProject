import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileprogramming_finalproject/ui/shared_widgets/custom_textfield.dart';
import 'package:mobileprogramming_finalproject/ui/shared_widgets/custom_button.dart';
import 'package:mobileprogramming_finalproject/utils/colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controller untuk menyimpan data awal profil
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _idSiPatuhController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _idSiPatuhController.dispose();
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
            'Edit Profil',
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
                image: AssetImage('assets/images/backgroundProfile.png'),
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
                  // --- SECTION FOTO PROFIL ---
                  Center(
                    child: Stack(
                      children: [
                        const CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=400',
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () {
                              // Aksi ganti foto
                            },
                            child: const CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.black,
                              child: Icon(
                                Icons.camera_alt_outlined,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // --- SECTION FORM INPUT (Menggunakan CustomTextField Kamu) ---
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Nama Lengkap'),
                        CustomTextField(
                          controller: _nameController,
                          hint: 'Masukkan Nama Lengkap',
                          icon: Icons.person_outline,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          keyboardType: TextInputType.name,
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Nomor Telepon'),
                        CustomTextField(
                          controller: _phoneController,
                          hint: 'Masukkan Nomor Telepon',
                          icon: Icons.phone_outlined,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Email'),
                        CustomTextField(
                          controller: _emailController,
                          hint: 'Masukkan Email',
                          icon: Icons.email_outlined,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Alamat'),
                        CustomTextField(
                          controller: _addressController,
                          hint: 'Masukkan Alamat',
                          icon: Icons.location_on_outlined,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          keyboardType: TextInputType.streetAddress,
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('ID SiPatuh'),
                        CustomTextField(
                          controller: _idSiPatuhController,
                          hint: 'Masukkan ID SiPatuh',
                          icon: Icons.badge_outlined,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  CustomButton(
                    onTap: () {},
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

  // Helper kecil untuk membuat judul label di atas CustomTextField
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
