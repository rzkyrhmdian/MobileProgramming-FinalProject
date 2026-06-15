import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:mobileprogramming_finalproject/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobileprogramming_finalproject/domain/model/garage_vehicle.dart';

class NotificationDatasource {
  static bool _isInitialized = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> initializeNotification() async {
    if (_isInitialized) return;

    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: AppColors.accent,
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          playSound: true,
          criticalAlerts: true,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'basic_channel_group',
          channelGroupName: 'Basic notifications group',
        ),
      ],
      debug: true,
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: _onActionReceivedMethod,
      onNotificationCreatedMethod: _onNotificationCreateMethod,
      onNotificationDisplayedMethod: _onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: _onDismissActionReceivedMethod,
    );

    _isInitialized = true;
    await _ensurePermission(promptIfNeeded: true);
  }

  Future<bool> _ensurePermission({required bool promptIfNeeded}) async {
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (isAllowed) return true;
    if (!promptIfNeeded) return false;
    await AwesomeNotifications().requestPermissionToSendNotifications();
    return AwesomeNotifications().isNotificationAllowed();
  }

  static Future<void> _onNotificationCreateMethod(ReceivedNotification receivedNotification) async {}
  static Future<void> _onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {}
  static Future<void> _onDismissActionReceivedMethod(ReceivedNotification receivedNotification) async {}
  static Future<void> _onActionReceivedMethod(ReceivedNotification receivedNotification) async {}

  Future<void> createNotification({
    required final int id,
    required final String title,
    required final String body,
    final String? summary,
    final Map<String, String>? payload,
    final dynamic actionType,
    final dynamic notificationLayout,
    final dynamic category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final Duration? interval,
  }) async {
    assert(!scheduled || (scheduled && interval != null));
    if (!_isInitialized) await initializeNotification();

    final isAllowed = await _ensurePermission(promptIfNeeded: true);
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        actionType: actionType ?? ActionType.Default,
        notificationLayout: notificationLayout ?? NotificationLayout.Default,
        summary: summary,
        category: category,
        payload: payload,
        bigPicture: bigPicture,
      ),
      actionButtons: actionButtons,
      schedule: scheduled
          ? NotificationInterval(
              interval: interval,
              timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
              preciseAlarm: true,
            )
          : null,
    );
  }

  Future<void> saveNotificationToFirestore({
    required String userId,
    required String title,
    required String body,
    String type = 'aktivitas',
  }) async {
    await _firestore.collection('notifikasi').add({
      'userId': userId,
      'title': title,
      'body': body,
      'type': type,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserNotificationsStream() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return const Stream.empty();

    return _firestore
        .collection('notifikasi')
        .where('userId', isEqualTo: userId)
        // PERHATIKAN: .orderBy dihapus di sini agar tidak kena Index Error
        .snapshots();
  }

  Future<void> markAsRead(String docId) async {
    await _firestore.collection('notifikasi').doc(docId).update({'isRead': true});
  }

  Future<void> scheduleVehicleTaxNotifications(GarageVehicle vehicle) async {
    if (!_isInitialized) await initializeNotification();
    await cancelVehicleNotifications(vehicle.id);

    final now = DateTime.now();
    final timeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();

    void scheduleForDate(DateTime expiryDate, String taxType, bool isPaid) async {
      if (isPaid) return;

      final intervals = [30, 7, 3, 1, 0];
      for (int daysBefore in intervals) {
        final scheduleDate = expiryDate.subtract(Duration(days: daysBefore));
        if (scheduleDate.isAfter(now)) {
          final int notificationId = '${vehicle.id}_${taxType}_$daysBefore'.hashCode.abs();
          
          String title = 'Peringatan Pajak $taxType';
          String body = daysBefore == 0 
              ? 'Pajak $taxType kendaraan ${vehicle.plateNumber} jatuh tempo HARI INI!'
              : 'Pajak $taxType kendaraan ${vehicle.plateNumber} akan jatuh tempo dalam $daysBefore hari.';

          await AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: notificationId,
              channelKey: 'basic_channel',
              title: title,
              body: body,
              category: NotificationCategory.Reminder,
            ),
            schedule: NotificationCalendar(
              year: scheduleDate.year,
              month: scheduleDate.month,
              day: scheduleDate.day,
              hour: 9, 
              minute: 0,
              second: 0,
              timeZone: timeZone,
              preciseAlarm: true,
            ),
          );
        }
      }
    }

    scheduleForDate(vehicle.annualTaxExpiry, 'Tahunan', vehicle.isAnnualPaid);
    scheduleForDate(vehicle.fiveYearTaxExpiry, 'STNK', vehicle.isFiveYearPaid);
  }

  Future<void> cancelVehicleNotifications(String vehicleId) async {
    if (!_isInitialized) await initializeNotification();
    final intervals = [30, 7, 3, 1, 0];
    for (String taxType in ['Tahunan', 'STNK']) {
      for (int daysBefore in intervals) {
        final int notificationId = '${vehicleId}_${taxType}_$daysBefore'.hashCode.abs();
        await AwesomeNotifications().cancel(notificationId);
      }
    }
  }
}