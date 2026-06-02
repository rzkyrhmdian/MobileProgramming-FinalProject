import 'package:flutter/material.dart';
import 'package:mobileprogramming_finalproject/utils/colors.dart';

class CustomLink extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final String labelLink;
  final double? fontSize;
  final String? fontFamily;

  const CustomLink({
    super.key,
    required this.label,
    required this.onPressed,
    required this.labelLink,
    this.fontSize = 16,
    this.fontFamily = "Poppins",
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: fontSize,
            color: AppColors.primary.withValues(alpha: 0.8),
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            labelLink,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
