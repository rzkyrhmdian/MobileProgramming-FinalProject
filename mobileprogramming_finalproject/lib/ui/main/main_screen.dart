import 'package:flutter/material.dart';

import 'package:mobileprogramming_finalproject/ui/scan/scan_screen.dart';
import 'package:mobileprogramming_finalproject/utils/colors.dart';
// import 'package:sipatuh/ui/history/history_screen.dart';
// import 'package:sipatuh/ui/profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Index aktif saat ini. Default ke 1 (Tengah/Scan) atau 0 (Riwayat)
  int _selectedIndex = 1; 

  // Daftar halaman dari masing-masing developer
  final List<Widget> _pages = [
    const Center(child: Text('Halaman Riwayat (Orang 3)')), // Ganti dengan HistoryScreen()
    const ScanScreen(),                                     // Ganti dengan ScanScreen()
    const Center(child: Text('Halaman Profil (Orang 1)')),  // Ganti dengan ProfileScreen()
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // IndexedStack digunakan agar state (data) di setiap halaman 
      // tidak hilang/ter-reset saat user berpindah tab.
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        backgroundColor: AppColors.border.withValues(alpha: 0.08),
        indicatorColor: AppColors.secondary.withValues(alpha: 0.16),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          NavigationDestination(
            icon: Icon(Icons.document_scanner_outlined),
            selectedIcon: Icon(Icons.document_scanner),
            label: 'Scan Plat',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}