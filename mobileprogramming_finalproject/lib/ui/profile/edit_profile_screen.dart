import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileprogramming_finalproject/ui/shared_widgets/custom_textfield.dart';
import 'package:mobileprogramming_finalproject/ui/shared_widgets/custom_button.dart';
import 'package:mobileprogramming_finalproject/ui/profile/profile_viewmodel.dart';
import 'package:mobileprogramming_finalproject/utils/colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _idSiPatuhController = TextEditingController();
  bool _isDataLoaded = false;
  String? _uploadedProfileImageUrl;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _idSiPatuhController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile(BuildContext context) async {
    final displayName = _nameController.text.trim();
    final idSipatuh = _idSiPatuhController.text.trim();

    if (displayName.isEmpty || idSipatuh.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan ID SiPatuh harus diisi')),
      );
      return;
    }

    final profileVm = Provider.of<ProfileViewModel>(context, listen: false);
    final success = await profileVm.updateUserProfile(
      displayName: displayName,
      idSipatuh: idSipatuh,
      phoneNumber: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      address: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      profileImageUrl: _uploadedProfileImageUrl,
    );

    if (!context.mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            profileVm.error.isNotEmpty
                ? profileVm.error
                : 'Gagal memperbarui profil',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      child: Consumer<ProfileViewModel>(
        builder: (context, viewModel, _) {
          final user = viewModel.userInfo;
          final avatar = _uploadedProfileImageUrl?.isNotEmpty == true
              ? _uploadedProfileImageUrl
              : user?.profileImage;
          final hasImage = avatar?.isNotEmpty == true;

          if (user != null && !_isDataLoaded) {
            _nameController.text = user.displayName;
            _phoneController.text = user.phoneNumber;
            _emailController.text = user.email;
            _addressController.text = user.address;
            _idSiPatuhController.text = user.idSipatuh;
            _isDataLoaded = true;
          }

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
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage: hasImage
                                    ? NetworkImage(avatar!)
                                    : null,
                                child: !hasImage
                                    ? Icon(
                                        Icons.person_rounded,
                                        size: 100,
                                        color: Colors.grey.shade500,
                                      )
                                    : null,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () async {
                                  final newUrl = await viewModel
                                      .pickAndUploadImage();
                                  if (!mounted) return;
                                  setState(() {
                                    _uploadedProfileImageUrl = newUrl;
                                  });
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

                      viewModel.isLoading
                          ? const SizedBox(
                              height: 65,
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : CustomButton(
                              onTap: () => _saveProfile(context),
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
          );
        },
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
