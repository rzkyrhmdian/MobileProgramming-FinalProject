class UserInfo {
  final String uid;
  final String email;
  final String displayName;
  final String idStegoSnap;
  final String profileImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLoginAt;

  const UserInfo({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.idStegoSnap,
    required this.profileImage,
    this.createdAt,
    this.updatedAt,
    this.lastLoginAt,
  });

  factory UserInfo.fromMap(
    Map<String, dynamic> map, {
    String? uid,
  }) {
    return UserInfo(
      uid: uid ?? (map['uid'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      displayName: (map['displayName'] ?? '').toString(),
      idStegoSnap: (map['idStegoSnap'] ?? '').toString(),
      profileImage: (map['profileImage'] ?? '').toString(),
      createdAt: _toDateTime(map['createdAt']),
      updatedAt: _toDateTime(map['updatedAt']),
      lastLoginAt: _toDateTime(map['lastLoginAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'idStegoSnap': idStegoSnap,
      'profileImage': profileImage,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'lastLoginAt': lastLoginAt,
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