import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DatabaseRepository {
  Future<String> createSnap({
    required String title,
    required String siPatuhImageUrl,
  });

  Future<void> renameSnapById({
    required String siPatuhFileId,
    required String newTitle,
  });

  Future<void> shareSnapToUserId({
    required String siPatuhFileId,
    required String toUserId,
  });

  Future<String?> getCurrentUserSiPatuhId();

  Stream<QuerySnapshot<Map<String, dynamic>>> getPendingShareFiles(
    String recipientSiPatuhId,
  );

  Future<void> declineSharedFiles(String shareFileId);

  Future<void> acceptShareFiles(String shareFileId);

  Future<Map<String, dynamic>> loadShareNotificationData(
    Map<String, dynamic> notification,
  );

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllSnap();

  Future<void> updateShareStatus(String shareFileId, String status);

  Future<Map<String, dynamic>?> getLatestSnapForCurrentUser();

  Future<void> deleteSnap(String siPatuhFilesId);

  Future<void> updateSnap(
    String siPatuhFilesId,
    Map<String, dynamic> updatedData,
  );
}
