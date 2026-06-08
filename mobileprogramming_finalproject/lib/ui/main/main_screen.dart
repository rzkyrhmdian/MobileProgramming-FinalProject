import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileprogramming_finalproject/ui/scan/scan_screen.dart';
import 'package:mobileprogramming_finalproject/utils/colors.dart';
import 'package:mobileprogramming_finalproject/ui/garage/garage_screen.dart';
import 'package:mobileprogramming_finalproject/ui/profile/profile_screen.dart';
import 'package:mobileprogramming_finalproject/ui/dashboard/dashboard_screen.dart';
import 'package:mobileprogramming_finalproject/ui/report/report_history_screen.dart'; // Diubah ke History Screen

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Index aktif saat ini. Default ke 0 (Dashboard)
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardScreen(),
    const ReportHistoryScreen(), // GANTI KE HALAMAN RIWAYAT LAPORAN DI SINI
    const ScanScreen(),
    const GarageScreen(),
    const ProfileScreen(),
  ];

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
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
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
            indicatorColor: AppColors.secondary.withValues(alpha: 0.16),
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.history_outlined),
                selectedIcon: Icon(Icons.history),
                label: 'Laporan',
              ),
              NavigationDestination(
                icon: Icon(Icons.document_scanner_outlined),
                selectedIcon: Icon(Icons.document_scanner),
                label: 'Scan Plat',
              ),
              NavigationDestination(
                icon: Icon(Icons.directions_car_outlined),
                selectedIcon: Icon(Icons.directions_car),
                label: 'Garasi',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}