import 'package:flutter/foundation.dart';

class NotifikasiViewModel extends ChangeNotifier {
  String getTimeAgo(DateTime? date) {
    if (date == null) return 'Baru saja';

    final difference = DateTime.now().difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} Hari lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} Jam lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} Menit lalu';
    } else {
      return 'Baru saja';
    }
  }

  NotificationType getNotificationType(String title) {
    final cleanTitle = title.toLowerCase();
    if (cleanTitle.contains('selesai')) return NotificationType.selesai;
    if (cleanTitle.contains('tolak')) return NotificationType.tolak;
    if (cleanTitle.contains('terima')) return NotificationType.terima;
    return NotificationType.info;
  }
}

enum NotificationType { selesai, tolak, terima, info }
