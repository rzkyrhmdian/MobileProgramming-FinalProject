import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DatabaseRepository {
  Future<String> createSnap({
    required String title,
    required String stegoImageUrl,
  });

  Future<void> renameSnapById({
    required String stegoFileId,
    required String newTitle,
  });

  Future<void> shareSnapToUserId({
    required String stegoFileId,
    required String toUserId,
  });

  Future<String?> getCurrentUserStegoId();

  Stream<QuerySnapshot<Map<String, dynamic>>> getPendingShareFiles(
    String recipientStegoId,
  );

  Future<void> declineSharedFiles(String shareFileId);

  Future<void> acceptShareFiles(String shareFileId);

  Future<Map<String, dynamic>> loadShareNotificationData(
    Map<String, dynamic> notification,
  );

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllSnap();

  Future<void> updateShareStatus(String shareFileId, String status);

  Future<Map<String, dynamic>?> getLatestSnapForCurrentUser();

  Future<void> deleteSnap(String stegoFilesId);

  Future<void> updateSnap(
    String stegoFilesId,
    Map<String, dynamic> updatedData,
  );
}