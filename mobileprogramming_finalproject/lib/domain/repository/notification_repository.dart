abstract class NotificationRepository {
  Future<void> initializeNotification();

  Future<void> createNotification({
    required int id,
    required String title,
    required String body,
    String? summary,
    Map<String, String>? payload,
    dynamic actionType,
    dynamic notificationLayout,
    dynamic category,
    String? bigPicture,
    List<dynamic>? actionButtons,
    bool scheduled,
    Duration? interval,
  });
}