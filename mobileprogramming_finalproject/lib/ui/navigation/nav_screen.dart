import 'package:flutter/material.dart';
import 'package:mobileprogramming_finalproject/ui/navigation/nav_viewmodel.dart';
import 'package:mobileprogramming_finalproject/ui/shared_widgets/buttom_sheet_container.dart';
import 'package:mobileprogramming_finalproject/ui/shared_widgets/buttom_sheet_header.dart';
import 'package:mobileprogramming_finalproject/ui/shared_widgets/custom_iconbutton.dart';
import 'package:mobileprogramming_finalproject/utils/colors.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  final NavViewModel _viewModel = NavViewModel();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/backgroundHome.png',
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildCustomNavBar(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomNavBar(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomIconButton(
            onTap: () => _showCreateModal(context),
            width: 65,
            height: 65,
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.center,
              end: Alignment.center,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(255, 148, 68, 162),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
            fontColor: Colors.white,
            icon: Icons.add,
            iconSize: 32,
          ),
        ],
      ),
    );
  }

  void _showCreateModal(BuildContext context) {
    _viewModel.setSelectedIndex(0);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return BottomSheetContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BottomSheetHeader(
                iconSize: 32,
                title: 'Start creating now',
                onClose: () => Navigator.pop(context),
              ),
              const SizedBox(height: 40),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
