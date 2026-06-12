import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationInfo {
  final String id;
  final String title;
  final String body;
  final String? summary;
  final Map<String, String>? payload;
  final DateTime? createdAt;
  final String userId;
  final bool isRead;
  final String type;

  const NotificationInfo({
    required this.id,
    required this.title,
    required this.body,
    this.summary,
    this.payload,
    this.createdAt,
    this.userId = '',
    this.isRead = false,
    this.type = 'aktivitas',
  });

  factory NotificationInfo.fromMap(Map<String, dynamic> map, {String? docId}) {
    final payload = map['payload'];

    return NotificationInfo(
      id: docId ?? (map['id'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      body: (map['body'] ?? '').toString(),
      summary: map['summary']?.toString(),
      userId: (map['userId'] ?? '').toString(),
      isRead: map['isRead'] ?? false,
      type: (map['type'] ?? 'aktivitas').toString(),
      payload: payload is Map
          ? payload.map(
              (key, value) => MapEntry(key.toString(), value.toString()),
            )
          : null,
      createdAt: _toDateTime(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'summary': summary,
      'payload': payload,
      'userId': userId,
      'isRead': isRead,
      'type': type,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    try {
      return value.toDate() as DateTime;
    } catch (_) {
      return null;
    }
  }
}