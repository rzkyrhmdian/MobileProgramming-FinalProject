import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/model/report_info.dart';

class ReportRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SupabaseClient _supabase = Supabase.instance.client;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadReportImage(File file) async {
    final userId = _auth.currentUser?.uid ?? 'unknown';
    final fileName =
        'reports/${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    await _supabase.storage.from('reports').upload(fileName, file);
    return _supabase.storage.from('reports').getPublicUrl(fileName);
  }

  Future<void> submitReportData({
    required String platNomor,
    required String jenisInsiden,
    required String deskripsi,
    required double latitude,
    required double longitude,
    required String alamat,
    required String fotoUrl,
  }) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User tidak login');

    await _firestore.collection('laporan').add({
      'userId': userId,
      'platNomor': platNomor,
      'jenisInsiden': jenisInsiden,
      'deskripsi': deskripsi,
      'latitude': latitude,
      'longitude': longitude,
      'alamat': alamat,
      'fotoUrl': fotoUrl,
      'status': ReportStatus.dalamProses.firestoreValue,
      'createdAt': Timestamp.now(),
    });
  }

  // FUNGSI BARU: Update teks laporan di Firestore
  Future<void> updateReportData({
    required String id,
    required String platNomor,
    required String jenisInsiden,
    required String deskripsi,
    required double latitude,
    required double longitude,
    required String alamat,
    required String fotoUrl,
  }) async {
    await _firestore.collection('laporan').doc(id).update({
      'platNomor': platNomor,
      'jenisInsiden': jenisInsiden,
      'deskripsi': deskripsi,
      'latitude': latitude,
      'longitude': longitude,
      'alamat': alamat,
      'fotoUrl': fotoUrl,
      // Status dan createdAt tidak diubah
    });
  }

  Future<void> updateReportStatus({
    required String reportId,
    required ReportStatus status,
    required String adminNotes,
  }) async {
    await _firestore.collection('laporan').doc(reportId).update({
      'status': status.name,
      'adminNotes': adminNotes,
    });
  }

  // FUNGSI BARU: Hapus Data Laporan di Firestore
  Future<void> deleteReportData(String id) async {
    await _firestore.collection('laporan').doc(id).delete();
  }

  // FUNGSI BARU: Hapus Foto di Supabase (Agar tidak nyampah)
  Future<void> deleteReportImage(String fotoUrl) async {
    try {
      final uri = Uri.parse(fotoUrl);
      final fileName = uri.pathSegments.last;
      await _supabase.storage.from('reports').remove([fileName]);
    } catch (e) {
      // Abaikan jika foto gagal dihapus di Supabase
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserReportsStream() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return const Stream.empty();

    return _firestore
        .collection('laporan')
        .where('userId', isEqualTo: userId)
        .snapshots(includeMetadataChanges: true);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllReportsStream() {
    return _firestore
        .collection('laporan')
        .snapshots(includeMetadataChanges: true);
  }
}
