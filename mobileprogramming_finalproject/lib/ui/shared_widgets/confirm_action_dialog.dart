import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileprogramming_finalproject/utils/colors.dart';

class ConfirmationDialogActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;

  const ConfirmationDialogActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = AppColors.errorRed,
    this.foregroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

Future<void> showConfirmActionDialog({
  required BuildContext context,
  required String title,
  required String message,
  required Future<void> Function() onConfirm,
  String confirmLabel = 'Hapus',
  String cancelLabel = 'Kembali',
  Color confirmBackgroundColor = AppColors.errorRed,
  Color confirmForegroundColor = Colors.white,
  bool barrierDismissible = true,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (dialogContext) => Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              cancelLabel,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ConfirmationDialogActionButton(
            label: confirmLabel,
            backgroundColor: confirmBackgroundColor,
            foregroundColor: confirmForegroundColor,
            onPressed: () async {
              Navigator.pop(dialogContext);
              await onConfirm();
            },
          ),
        ],
      ),
    ),
  );
}
