import 'package:mobileprogramming_finalproject/data/remote/notification_datasource.dart';
import 'package:mobileprogramming_finalproject/domain/repository/notification_repository.dart';

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
}