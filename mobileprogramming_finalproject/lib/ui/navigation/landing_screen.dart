import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobileprogramming_finalproject/ui/auth/login_screen.dart';
import 'package:mobileprogramming_finalproject/ui/auth/signup_screen.dart';
import 'package:mobileprogramming_finalproject/ui/shared_widgets/custom_link.dart';
import 'package:mobileprogramming_finalproject/utils/colors.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool _showIntro = true;

  void _hideIntroAfter(Duration duration) {
    Future.delayed(duration + const Duration(milliseconds: 50), () {
      if (!mounted || !_showIntro) return;
      setState(() => _showIntro = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final height = MediaQuery.sizeOf(context).height;
          return Stack(
            children: [
              Positioned.fill(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 350),
                  opacity: _showIntro ? 0.0 : 1.0,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/backgroundSiPatuh.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: height),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 450),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    child: _showIntro
                        ? SizedBox(
                            key: const ValueKey('intro'),
                            height: height,
                            child: Center(
                              child: Transform.scale(
                                scale: 1.25,
                                child: Lottie.asset(
                                  'assets/lottie/SiPatuh/a/MainScene.json',
                                  height: height * 0.72,
                                  fit: BoxFit.contain,
                                  repeat: false,
                                  onLoaded: (composition) {
                                    if (_showIntro) {
                                      _hideIntroAfter(composition.duration);
                                    }
                                  },
                                ),
                              ),
                            ),
                          )
                        : SizedBox(
                            key: const ValueKey('content'),
                            height: height,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 60),
                                Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(24),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            'SiPatuh',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'CalSans',
                                              fontSize: 45,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            'Bersama Warga,\nMembangun Kota Tertib.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontStyle: FontStyle.italic,
                                              fontSize: 14,
                                              height: 1.4,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SignupScreen(),
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          elevation: 2,
                                        ),
                                        child: const Text(
                                          'Mulai Sekarang',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      CustomLink(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen(),
                                            ),
                                          );
                                        },
                                        label: 'Sudah punya akun?',
                                        labelLink: 'Log In',
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
