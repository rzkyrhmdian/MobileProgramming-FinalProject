import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRemoteDataSource {
  final _supabase = Supabase.instance.client;

  Future<String> uploadImage(File file, String path) async {
    await _supabase.storage
        .from('profile-images')
        .upload(path, file, fileOptions: const FileOptions(upsert: true));
    return _supabase.storage.from('profile-images').getPublicUrl(path);
  }
}
