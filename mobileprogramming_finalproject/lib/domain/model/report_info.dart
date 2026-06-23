import 'package:cloud_firestore/cloud_firestore.dart';

enum ReportStatus { dalamProses, selesai, ditolak }

class ReportInfo {
  final String id;
  final String userId;
  final String platNomor;
  final String jenisInsiden;
  final String deskripsi;
  final double latitude;
  final double longitude;
  final String alamat;
  final String fotoUrl;
  final ReportStatus status;
  final String? adminNotes;
  final DateTime createdAt;

  ReportInfo({
    required this.id,
    required this.userId,
    required this.platNomor,
    required this.jenisInsiden,
    required this.deskripsi,
    required this.latitude,
    required this.longitude,
    required this.alamat,
    required this.fotoUrl,
    required this.status,
    required this.createdAt,
    this.adminNotes,
  });

  factory ReportInfo.fromMap({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return ReportInfo(
      id: id,
      userId: data['userId'] ?? '',
      platNomor: data['platNomor'] ?? '',
      jenisInsiden: data['jenisInsiden'] ?? '',
      deskripsi: data['deskripsi'] ?? '',
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
      alamat: data['alamat'] ?? '',
      fotoUrl: data['fotoUrl'] ?? '',
      status: reportStatusFromValue(data['status']),
      adminNotes: data['adminNotes'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'platNomor': platNomor,
      'jenisInsiden': jenisInsiden,
      'deskripsi': deskripsi,
      'latitude': latitude,
      'longitude': longitude,
      'alamat': alamat,
      'fotoUrl': fotoUrl,
      'status': status.firestoreValue,
      'adminNotes': adminNotes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

String reportStatusToFirestoreValue(ReportStatus status) {
  return status.name;
}

String reportStatusDisplayText(ReportStatus status) {
  switch (status) {
    case ReportStatus.dalamProses:
      return 'DALAM PROSES';
    case ReportStatus.selesai:
      return 'SELESAI';
    case ReportStatus.ditolak:
      return 'DITOLAK';
  }
}

ReportStatus reportStatusFromValue(Object? value) {
  if (value is ReportStatus) {
    return value;
  }

  if (value is String) {
    final normalizedValue = value.trim().toLowerCase().replaceAll(
      RegExp(r'[\s_-]+'),
      '',
    );

    switch (normalizedValue) {
      case 'dalamproses':
      case 'pending':
      case 'proses':
        return ReportStatus.dalamProses;
      case 'selesai':
      case 'approved':
      case 'resolved':
      case 'completed':
        return ReportStatus.selesai;
      case 'ditolak':
      case 'declined':
      case 'rejected':
        return ReportStatus.ditolak;
    }
  }

  return ReportStatus.dalamProses;
}

extension ReportStatusX on ReportStatus {
  String get firestoreValue => reportStatusToFirestoreValue(this);
  String get displayText => reportStatusDisplayText(this);
}
