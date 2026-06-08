import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileprogramming_finalproject/ui/shared_widgets/custom_textfield.dart';
import 'package:mobileprogramming_finalproject/ui/shared_widgets/custom_button.dart';
import 'package:mobileprogramming_finalproject/ui/change_password/change_password_viewmodel.dart';
import 'package:mobileprogramming_finalproject/utils/colors.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      child: ChangeNotifierProvider(
        create: (_) => ChangePasswordViewModel(),
        child: Consumer<ChangePasswordViewModel>(
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
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
                title: const Text(
                  'Ubah Kata Sandi',
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
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Password Saat Ini'),
                              CustomTextField(
                                controller: _currentPasswordController,
                                hint: 'Masukkan password saat ini',
                                icon: Icons.lock_outline,
                                obscureText: _obscureCurrent,
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black87,
                                onChanged: (value) {},
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureCurrent
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureCurrent = !_obscureCurrent;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildLabel('Password Baru'),
                              CustomTextField(
                                controller: _newPasswordController,
                                hint: 'Masukkan password baru',
                                icon: Icons.lock_reset_outlined,
                                obscureText: _obscureNew,
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black87,
                                onChanged: (value) {},
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureNew
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureNew = !_obscureNew;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildLabel('Konfirmasi Password Baru'),
                              CustomTextField(
                                controller: _confirmPasswordController,
                                hint: 'Ulangi password baru',
                                icon: Icons.gpp_good_outlined,
                                obscureText: _obscureConfirm,
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black87,
                                onChanged: (value) {},
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirm
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirm = !_obscureConfirm;
                                    });
                                  },
                                ),
                              ),
                              if (viewModel.error.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Text(
                                  viewModel.error,
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        viewModel.isLoading
                            ? const SizedBox(
                                height: 65,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : CustomButton(
                                onTap: () async {
                                  final success = await viewModel
                                      .changePassword(
                                        currentPassword:
                                            _currentPasswordController.text
                                                .trim(),
                                        newPassword: _newPasswordController.text
                                            .trim(),
                                        confirmPassword:
                                            _confirmPasswordController.text
                                                .trim(),
                                      );

                                  if (!context.mounted) return;

                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Password berhasil diperbarui',
                                        ),
                                      ),
                                    );
                                    Navigator.pop(context);
                                  } else if (viewModel.error.isNotEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(viewModel.error)),
                                    );
                                  }
                                },
                                height: 65,
                                width: double.infinity,
                                borderRadius: 50.0,
                                label: "Perbarui Password",
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
