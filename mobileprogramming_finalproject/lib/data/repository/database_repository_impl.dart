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
    required String siPatuhImageUrl,
  }) {
    return _datasource.createSnap(
      title: title,
      siPatuhImageUrl: siPatuhImageUrl,
    );
  }

  @override
  Future<void> declineSharedFiles(String shareFileId) {
    return _datasource.declineSharedFiles(shareFileId);
  }

  @override
  Future<void> deleteSnap(String siPatuhFilesId) {
    return _datasource.deleteSnap(siPatuhFilesId);
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
  Future<String?> getCurrentUserSiPatuhId() {
    return _datasource.getCurrentUserSiPatuhId();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getPendingShareFiles(
    String recipientSiPatuhId,
  ) {
    return _datasource.getPendingShareFiles(recipientSiPatuhId);
  }

  @override
  Future<Map<String, dynamic>> loadShareNotificationData(
    Map<String, dynamic> notification,
  ) {
    return _datasource.loadShareNotificationData(notification);
  }

  @override
  Future<void> renameSnapById({
    required String siPatuhFileId,
    required String newTitle,
  }) {
    return _datasource.renameSnapById(
      siPatuhFileId: siPatuhFileId,
      newTitle: newTitle,
    );
  }

  @override
  Future<void> shareSnapToUserId({
    required String siPatuhFileId,
    required String toUserId,
  }) {
    return _datasource.shareSnapToUserId(
      siPatuhFileId: siPatuhFileId,
      toUserId: toUserId,
    );
  }

  @override
  Future<void> updateShareStatus(String shareFileId, String status) {
    return _datasource.updateShareStatus(shareFileId, status);
  }

  @override
  Future<void> updateSnap(
    String siPatuhFilesId,
    Map<String, dynamic> updatedData,
  ) {
    return _datasource.updateSnap(siPatuhFilesId, updatedData);
  }
}
