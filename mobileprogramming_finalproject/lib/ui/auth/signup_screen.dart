import 'package:flutter/material.dart';
import 'package:mobileprogramming_finalproject/ui/auth/auth_viewmodel.dart';
import 'package:mobileprogramming_finalproject/ui/auth/login_screen.dart';
import 'package:mobileprogramming_finalproject/ui/navigation/landing_screen.dart';
import 'package:mobileprogramming_finalproject/ui/shared_widgets/custom_button.dart';
import 'package:mobileprogramming_finalproject/ui/shared_widgets/custom_link.dart';
import 'package:mobileprogramming_finalproject/ui/shared_widgets/custom_textfield.dart';
import 'package:mobileprogramming_finalproject/utils/colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthViewModel _viewModel = AuthViewModel();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _tryRegister() async {
    if (_formKey.currentState!.validate()) {
      final success = await _viewModel.register();

      if (!mounted) return;

      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _viewModel.error,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
            ),
            backgroundColor: AppColors.errorRed,
          ),
        );
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LandingScreen()),
              ),
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.all(32.0),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/backgroundSiPatuh.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        hint: 'Nama Lengkap',
                        icon: Icons.person_outline,
                        onChanged: _viewModel.updateFullName,
                        validator: (val) =>
                            val!.isEmpty ? 'Masukkan nama lengkap' : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        hint: 'Masukkan email',
                        icon: Icons.email_outlined,
                        onChanged: _viewModel.updateEmail,
                        validator: (val) =>
                            val!.isEmpty ? 'Masukkan email' : null,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        hint: 'Masukkan password',
                        icon: Icons.lock_outline,
                        obscureText: _viewModel.isPasswordObscure,
                        onChanged: _viewModel.updatePassword,
                        validator: (val) => val!.length < 6
                            ? 'Password harus minimal 6 karakter'
                            : null,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: IconButton(
                            icon: Icon(
                              _viewModel.isPasswordObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: _viewModel.togglePasswordObscure,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        hint: 'Konfirmasi password',
                        icon: Icons.lock_outline,
                        obscureText: _viewModel.isConfirmPasswordObscure,
                        onChanged: _viewModel.updateConfirmPassword,
                        validator: (val) =>
                            val!.isEmpty ? 'Konfirmasi password Anda' : null,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: IconButton(
                            icon: Icon(
                              _viewModel.isConfirmPasswordObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: _viewModel.toggleConfirmPasswordObscure,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      CustomButton(
                        onTap: _tryRegister,
                        height: 65,
                        width: double.infinity,
                        borderRadius: 50.0,
                        label: _viewModel.isLoading ? 'Loading...' : 'Sign Up',
                        fontSize: 18,
                        fontColor: Colors.white,
                        backgroundColor: AppColors.primary,
                      ),
                      const SizedBox(height: 32),
                      CustomLink(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        label: 'Sudah punya akun?',
                        labelLink: 'Log In',
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                      if (_viewModel.error.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          _viewModel.error,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
