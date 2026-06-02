class NotificationInfo {
  final String id;
  final String title;
  final String body;
  final String? summary;
  final Map<String, String>? payload;
  final DateTime? createdAt;

  const NotificationInfo({
    required this.id,
    required this.title,
    required this.body,
    this.summary,
    this.payload,
    this.createdAt,
  });

  factory NotificationInfo.fromMap(Map<String, dynamic> map) {
    final payload = map['payload'];

    return NotificationInfo(
      id: (map['id'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      body: (map['body'] ?? '').toString(),
      summary: map['summary']?.toString(),
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
      'createdAt': createdAt,
    };
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    try {
      return value.toDate() as DateTime;
    } catch (_) {
      return null;
    }
  }
}