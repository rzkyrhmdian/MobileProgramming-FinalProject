import 'package:flutter/material.dart';
import 'package:mobileprogramming_finalproject/ui/auth/auth_viewmodel.dart';
import 'package:mobileprogramming_finalproject/ui/auth/signup_screen.dart';
import 'package:mobileprogramming_finalproject/ui/navigation/landing_screen.dart';
import 'package:mobileprogramming_finalproject/ui/navigation/nav_screen.dart';
import 'package:mobileprogramming_finalproject/ui/shared_widgets/custom_button.dart';
import 'package:mobileprogramming_finalproject/ui/shared_widgets/custom_link.dart';
import 'package:mobileprogramming_finalproject/ui/shared_widgets/custom_textfield.dart';
import 'package:mobileprogramming_finalproject/utils/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthViewModel _viewModel = AuthViewModel();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _tryLogin() async {
    if (_formKey.currentState!.validate()) {
      final success = await _viewModel.login();

      if (!mounted || !success) {
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NavScreen()),
      );
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
                MaterialPageRoute(
                  builder: (context) => const LandingScreen(),
                ),
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
                image: AssetImage('assets/images/backgroundAuth.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Log In',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        hint: 'Enter your email',
                        icon: Icons.email_outlined,
                        onChanged: _viewModel.updateEmail,
                        validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        hint: 'Enter password',
                        icon: Icons.lock_outline,
                        obscureText: _viewModel.isPasswordObscure,
                        onChanged: _viewModel.updatePassword,
                        validator: (val) => val!.length < 6
                            ? 'Password must be 6+ characters'
                            : null,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: IconButton(
                            icon: Icon(
                              _viewModel.isPasswordObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white,
                            ),
                            onPressed: _viewModel.togglePasswordObscure,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      CustomButton(
                        onTap: _tryLogin,
                        height: 65,
                        width: double.infinity,
                        borderRadius: 50.0,
                        label: _viewModel.isLoading ? 'Loading...' : 'Log In',
                        fontSize: 18,
                        fontColor: AppColors.darkPurpleText,
                        gradient: const LinearGradient(
                          colors: [Colors.white, AppColors.purpleButton],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      const SizedBox(height: 32),
                      CustomLink(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                        label: "Don't have an account?",
                        labelLink: 'Sign Up',
                        fontSize: 16,
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