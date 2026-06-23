import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileprogramming_finalproject/utils/colors.dart';
import 'package:mobileprogramming_finalproject/ui/garage/garage_screen.dart';
import 'package:mobileprogramming_finalproject/ui/profile/profile_screen.dart';
import 'package:mobileprogramming_finalproject/ui/dashboard/dashboard_screen.dart';
import 'package:mobileprogramming_finalproject/ui/admin_dashboard/admin_dashboard_screen.dart';
import 'package:mobileprogramming_finalproject/ui/report/report_history_screen.dart';
import 'package:mobileprogramming_finalproject/ui/profile/profile_viewmodel.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Index aktif saat ini. Default ke 0 (Dashboard)
  int _selectedIndex = 0;

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        navigationBarTheme: NavigationBarThemeData(
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      child: Consumer<ProfileViewModel>(
        builder: (context, profileVm, _) {
          final bool isAdmin =
              profileVm.userInfo?.role.toLowerCase() == 'admin';
          final List<Widget> pages = [
            isAdmin ? const AdminDashboardScreen() : const DashboardScreen(),
            const ReportHistoryScreen(),
            const GarageScreen(),
            const ProfileScreen(),
          ];

          return Scaffold(
            extendBodyBehindAppBar: true,
            body: IndexedStack(index: _selectedIndex, children: pages),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: NavigationBar(
                selectedIndex: _selectedIndex,
                onDestinationSelected: _onDestinationSelected,
                backgroundColor: Colors.white,
                indicatorColor: AppColors.accent,
                labelBehavior:
                    NavigationDestinationLabelBehavior.onlyShowSelected,
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.dashboard_outlined),
                    selectedIcon: Icon(Icons.dashboard, color: Colors.white),
                    label: 'Dashboard',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.history_outlined),
                    selectedIcon: Icon(Icons.history, color: Colors.white),
                    label: 'Laporan',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.directions_car_outlined),
                    selectedIcon: Icon(
                      Icons.directions_car,
                      color: Colors.white,
                    ),
                    label: 'Garasi',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person_outline),
                    selectedIcon: Icon(Icons.person, color: Colors.white),
                    label: 'Profil',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
