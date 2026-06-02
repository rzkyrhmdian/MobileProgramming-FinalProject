import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobileprogramming_finalproject/utils/colors.dart';
import 'package:mobileprogramming_finalproject/screens/login_page.dart';
import 'package:mobileprogramming_finalproject/screens/signup_page.dart';
import 'package:mobileprogramming_finalproject/widgets/custom_link.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _showIntro = true;

  void _hideIntroAfter(Duration duration) {
    Future.delayed(duration + const Duration(milliseconds: 50), () {
      if (!mounted || !_showIntro) {
        return;
      }

      setState(() {
        _showIntro = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: _showIntro ? Colors.white : null,
              image: !_showIntro
                  ? DecorationImage(
                      image: AssetImage('assets/images/backgroundSiPatuh.png'),
                      fit: BoxFit.fill,
                    )
                  : null,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 450),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: _showIntro
                      ? SizedBox(
                          key: const ValueKey('intro'),
                          height: constraints.maxHeight,
                          child: Center(
                            child: Transform.scale(
                              scale: 1.35,
                              child: Lottie.asset(
                                'assets/lottie/SiPatuh/a/MainScene.json',
                                height: constraints.maxHeight * 0.72,
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
                      : Column(
                          key: const ValueKey('content'),
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
                                          fontSize: 16,
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ElevatedButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignupPage(),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    elevation: 4,
                                  ),
                                  child: Text(
                                    'Mulai Sekarang',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
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
                                        builder: (context) => LoginPage(),
                                      ),
                                    );
                                  },
                                  label: 'Sudah punya akun?',
                                  labelLink: 'Log In',
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                ),
                              ],
                            ),
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
}
