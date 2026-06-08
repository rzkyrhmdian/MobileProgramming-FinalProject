import 'dart:io';

abstract class ProfileRepository {
  Future<String> executeUpload(File file, String userId);
}
