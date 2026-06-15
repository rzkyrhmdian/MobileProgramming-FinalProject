import 'package:mobileprogramming_finalproject/data/remote/notification_datasource.dart';
import 'package:mobileprogramming_finalproject/domain/repository/notification_repository.dart';
import 'package:mobileprogramming_finalproject/domain/model/notification_info.dart';
import 'package:mobileprogramming_finalproject/domain/model/garage_vehicle.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({NotificationDatasource? datasource})
      : _datasource = datasource ?? NotificationDatasource();

  final NotificationDatasource _datasource;

  @override
  Future<void> initializeNotification() {
    return _datasource.initializeNotification();
  }

  @override
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
    bool scheduled = false,
    Duration? interval,
  }) {
    return _datasource.createNotification(
      id: id,
      title: title,
      body: body,
      summary: summary,
      payload: payload,
      actionType: actionType,
      notificationLayout: notificationLayout,
      category: category,
      bigPicture: bigPicture,
      actionButtons: actionButtons?.cast(),
      scheduled: scheduled,
      interval: interval,
    );
  }

  @override
  Future<void> saveNotificationToFirestore({
    required String userId,
    required String title,
    required String body,
    String type = 'aktivitas',
  }) {
    return _datasource.saveNotificationToFirestore(
      userId: userId,
      title: title,
      body: body,
      type: type,
    );
  }

  @override
  Stream<List<NotificationInfo>> getUserNotificationsStream() {
    return _datasource.getUserNotificationsStream().map((snapshot) {
      final notifs = snapshot.docs.map((doc) {
        return NotificationInfo.fromMap(doc.data(), docId: doc.id);
      }).toList();

      // MENGURUTKAN NOTIFIKASI DARI YANG TERBARU (MENGGANTIKAN ORDERBY FIREBASE)
      notifs.sort((a, b) {
        if (a.createdAt == null && b.createdAt == null) return 0;
        if (a.createdAt == null) return 1;
        if (b.createdAt == null) return -1;
        return b.createdAt!.compareTo(a.createdAt!);
      });

      return notifs;
    });
  }

  @override
  Future<void> markAsRead(String docId) {
    return _datasource.markAsRead(docId);
  }

  @override
  Future<void> scheduleVehicleTaxNotifications(GarageVehicle vehicle) {
    return _datasource.scheduleVehicleTaxNotifications(vehicle);
  }

  @override
  Future<void> cancelVehicleNotifications(String vehicleId) {
    return _datasource.cancelVehicleNotifications(vehicleId);
  }
}