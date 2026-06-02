import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobileprogramming_finalproject/data/remote/firestore_datasource.dart';
import 'package:mobileprogramming_finalproject/domain/repository/database_repository.dart';

class DatabaseRepositoryImpl implements DatabaseRepository {
  DatabaseRepositoryImpl({FirestoreDatasource? datasource})
      : _datasource = datasource ?? FirestoreDatasource();

  final FirestoreDatasource _datasource;

  @override
  Future<String> createSnap({
    required String title,
    required String stegoImageUrl,
  }) {
    return _datasource.createSnap(
      title: title,
      stegoImageUrl: stegoImageUrl,
    );
  }

  @override
  Future<void> declineSharedFiles(String shareFileId) {
    return _datasource.declineSharedFiles(shareFileId);
  }

  @override
  Future<void> deleteSnap(String stegoFilesId) {
    return _datasource.deleteSnap(stegoFilesId);
  }

  @override
  Future<void> acceptShareFiles(String shareFileId) {
    return _datasource.acceptShareFiles(shareFileId);
  }

  @override
  Future<Map<String, dynamic>?> getLatestSnapForCurrentUser() {
    return _datasource.getLatestSnapForCurrentUser();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllSnap() {
    return _datasource.getAllSnap();
  }

  @override
  Future<String?> getCurrentUserStegoId() {
    return _datasource.getCurrentUserStegoId();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getPendingShareFiles(
    String recipientStegoId,
  ) {
    return _datasource.getPendingShareFiles(recipientStegoId);
  }

  @override
  Future<Map<String, dynamic>> loadShareNotificationData(
    Map<String, dynamic> notification,
  ) {
    return _datasource.loadShareNotificationData(notification);
  }

  @override
  Future<void> renameSnapById({
    required String stegoFileId,
    required String newTitle,
  }) {
    return _datasource.renameSnapById(
      stegoFileId: stegoFileId,
      newTitle: newTitle,
    );
  }

  @override
  Future<void> shareSnapToUserId({
    required String stegoFileId,
    required String toUserId,
  }) {
    return _datasource.shareSnapToUserId(
      stegoFileId: stegoFileId,
      toUserId: toUserId,
    );
  }

  @override
  Future<void> updateShareStatus(String shareFileId, String status) {
    return _datasource.updateShareStatus(shareFileId, status);
  }

  @override
  Future<void> updateSnap(
    String stegoFilesId,
    Map<String, dynamic> updatedData,
  ) {
    return _datasource.updateSnap(stegoFilesId, updatedData);
  }
}