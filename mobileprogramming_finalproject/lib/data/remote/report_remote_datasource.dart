import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SupabaseClient _supabase = Supabase.instance.client;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadReportImage(File file) async {
    final userId = _auth.currentUser?.uid ?? 'unknown';
    final fileName = 'reports/${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    
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
      'status': 'Pending',
      'createdAt': Timestamp.now(), 
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserReportsStream() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return const Stream.empty();

    return _firestore
        .collection('laporan')
        .where('userId', isEqualTo: userId)
        // PERHATIKAN: .orderBy kita hapus dari sini supaya Firebase tidak minta Index!
        .snapshots(includeMetadataChanges: true); 
  }
}