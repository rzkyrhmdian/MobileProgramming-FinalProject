import 'package:mobileprogramming_finalproject/domain/model/user_info.dart';

class UserApiModel {
  final String uid;
  final String email;
  final String displayName;
  final String idSipatuh;
  final String profileImage;
  final String phoneNumber;
  final String address;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLoginAt;

  const UserApiModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.idSipatuh,
    required this.profileImage,
    this.phoneNumber = '',
    this.address = '',
    this.createdAt,
    this.updatedAt,
    this.lastLoginAt,
  });

  factory UserApiModel.fromMap(Map<String, dynamic> map, {String? uid}) {
    return UserApiModel(
      uid: uid ?? (map['uid'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      displayName: (map['displayName'] ?? '').toString(),
      idSipatuh: (map['idSipatuh'] ?? '').toString(),
      profileImage: (map['profileImage'] ?? '').toString(),
      phoneNumber: (map['phoneNumber'] ?? '').toString(),
      address: (map['address'] ?? '').toString(),
      createdAt: _toDateTime(map['createdAt']),
      updatedAt: _toDateTime(map['updatedAt']),
      lastLoginAt: _toDateTime(map['lastLoginAt']),
    );
  }

  UserInfo toEntity() {
    return UserInfo(
      uid: uid,
      email: email,
      displayName: displayName,
      idSipatuh: idSipatuh,
      profileImage: profileImage,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastLoginAt: lastLoginAt,
      phoneNumber: phoneNumber,
      address: address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'idSipatuh': idSipatuh,
      'profileImage': profileImage,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'lastLoginAt': lastLoginAt,
      'phoneNumber': phoneNumber,
      'address': address,
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
