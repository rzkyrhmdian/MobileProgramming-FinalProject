import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:mobileprogramming_finalproject/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final Duration? interval,
  }) async {
    assert(!scheduled || (scheduled && interval != null));
    if (!_isInitialized) await initializeNotification();

    final isAllowed = await _ensurePermission(promptIfNeeded: false);
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout,
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
}