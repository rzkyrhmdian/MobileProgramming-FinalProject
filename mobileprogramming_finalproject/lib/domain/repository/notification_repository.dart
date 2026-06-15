import 'package:mobileprogramming_finalproject/domain/model/notification_info.dart';
import 'package:mobileprogramming_finalproject/domain/model/garage_vehicle.dart';

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

  Future<void> saveNotificationToFirestore({
    required String userId,
    required String title,
    required String body,
    String type = 'aktivitas',
  });

  Stream<List<NotificationInfo>> getUserNotificationsStream();
  Future<void> markAsRead(String docId);

  Future<void> scheduleVehicleTaxNotifications(GarageVehicle vehicle);
  Future<void> cancelVehicleNotifications(String vehicleId);
}