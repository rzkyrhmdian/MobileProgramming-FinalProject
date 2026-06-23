import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobileprogramming_finalproject/data/remote/notification_datasource.dart';

class FirestoreDatasource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final NotificationDatasource _notificationDatasource =
      NotificationDatasource();

  User? get _currentUser => FirebaseAuth.instance.currentUser;

  Future<void> _notify({required String title, required String body}) async {
    await _notificationDatasource.createNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: title,
      body: body,
    );
  }

  Future<String> createSnap({
    required String title,
    required String siPatuhImageUrl,
  }) async {
    final user = _currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final siPatuhFilesRef = _db.collection('siPatuh_files').doc();
    final userRef = _db.collection('users').doc(user.uid);

    await siPatuhFilesRef.set({
      'ownerId': user.uid,
      'userId': user.uid,
      'ownerRef': userRef,
      'title': title.trim(),
      'siPatuhImageUrl': siPatuhImageUrl.trim(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await _notify(
      title: 'Snap Saved',
      body:
          'Snap saved to collection siPatuhFiles with id: ${siPatuhFilesRef.id}',
    );

    return siPatuhFilesRef.id;
  }

  Future<void> addGarageVehicle(Map<String, dynamic> vehicleData) async {
    final user = _currentUser;
    if (user == null) throw Exception('User not logged in');

    final vehicleRef = _db.collection('vehicles').doc(vehicleData['id']);

    // override ownerId to ensure it matches current user
    final dataToSave = {
      ...vehicleData,
      'ownerId': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await vehicleRef.set(dataToSave);
  }

  Future<void> updateGarageVehicle(Map<String, dynamic> vehicleData) async {
    final vehicleRef = _db.collection('vehicles').doc(vehicleData['id']);
    await vehicleRef.update({
      ...vehicleData,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Map<String, dynamic>>> getGarageVehicles() async {
    final user = _currentUser;
    if (user == null) return [];

    final querySnapshot = await _db
        .collection('vehicles')
        .where('ownerId', isEqualTo: user.uid)
        .get();

    final docs = querySnapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data()})
        .toList();

    // Sort locally to avoid Firestore composite index requirement
    docs.sort((a, b) {
      final aTime = a['createdAt'] as Timestamp?;
      final bTime = b['createdAt'] as Timestamp?;
      if (aTime == null && bTime == null) return 0;
      if (aTime == null) return 1;
      if (bTime == null) return -1;
      return bTime.compareTo(aTime); // descending
    });

    return docs;
  }

  Future<void> deleteGarageVehicle(String id) async {
    final user = _currentUser;
    if (user == null) return;
    
    await _db.collection('vehicles').doc(id).delete();
  }

  Future<void> renameSnapById({
    required String siPatuhFileId,
    required String newTitle,
  }) async {
    if (siPatuhFileId.trim().isEmpty) {
      throw Exception('Snap id is required');
    }

    final docRef = _db.collection('siPatuh_files').doc(siPatuhFileId);

    await docRef.update({
      'title': newTitle.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> shareSnapToUserId({
    required String siPatuhFileId,
    required String toUserId,
  }) async {
    if (siPatuhFileId.trim().isEmpty) {
      throw Exception('SiPatuh file id is required');
    }

    final targetUserId = toUserId.trim();
    if (targetUserId.isEmpty) {
      throw Exception('User id is required');
    }

    final sender = _currentUser;
    if (sender == null) {
      throw Exception('User not logged in');
    }

    if (targetUserId == sender.uid) {
      throw Exception('Cannot share snap to yourself');
    }

    final snapDoc = await _db
        .collection('siPatuh_files')
        .doc(siPatuhFileId)
        .get();
    if (!snapDoc.exists) {
      throw Exception('Snap not found');
    }

    final snapData = snapDoc.data() ?? <String, dynamic>{};

    final sharedFilesRef = _db.collection('shared_files').doc();

    await sharedFilesRef.set({
      'toUserID': targetUserId,
      'fromUserId': sender.uid,
      'siPatuhFileId': siPatuhFileId,
      'siPatuhTitle': snapData['title'],
      'siPatuhImageUrl':
          snapData['siPatuhImage'] ?? snapData['siPatuhImageUrl'],
      'status': 'dalam proses',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<String?> getCurrentUserSiPatuhId() async {
    final user = _currentUser;
    if (user == null) {
      return null;
    }

    final userDoc = await _db.collection('users').doc(user.uid).get();
    final userData = userDoc.data();
    return (userData?['idSipatuh'] ?? '').toString().trim();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getPendingShareFiles(
    String recipientSiPatuhId,
  ) {
    final normalizedRecipientSiPatuhId = recipientSiPatuhId.trim();
    if (normalizedRecipientSiPatuhId.isEmpty) {
      return const Stream<QuerySnapshot<Map<String, dynamic>>>.empty();
    }

    return _db
        .collection('shared_files')
        .where('toUserID', isEqualTo: normalizedRecipientSiPatuhId)
        .where('status', isEqualTo: 'dalam proses')
        .snapshots();
  }

  Future<void> declineSharedFiles(String shareFileId) async {
    final user = _currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    await _db.collection('shared_files').doc(shareFileId).update({
      'status': 'declined',
      'updatedAt': FieldValue.serverTimestamp(),
      'disabledAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> acceptShareFiles(String shareFileId) async {
    final user = _currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final sharedFilesRef = _db.collection('shared_files').doc(shareFileId);

    final shareFileDoc = await sharedFilesRef.get();
    if (!shareFileDoc.exists) {
      throw Exception('Share file not found');
    }

    final shareData = shareFileDoc.data() ?? <String, dynamic>{};
    final siPatuhFileId = (shareData['siPatuhFileId'] ?? '').toString();
    if (siPatuhFileId.isEmpty) {
      throw Exception('SiPatuh file id is missing');
    }

    final siPatuhFileRef = _db.collection('siPatuh_files').doc(siPatuhFileId);
    final siPatuhFileDoc = await siPatuhFileRef.get();
    if (!siPatuhFileDoc.exists) {
      throw Exception('SiPatuh file not found');
    }

    await sharedFilesRef.update({
      'status': 'accepted',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>> loadShareNotificationData(
    Map<String, dynamic> notification,
  ) async {
    final senderId = (notification['fromUserId'] ?? '').toString();
    final siPatuhFileId = (notification['siPatuhFileId'] ?? '').toString();

    final senderDoc = senderId.isEmpty
        ? null
        : await _db.collection('users').doc(senderId).get();
    final siPatuhDoc = siPatuhFileId.isEmpty
        ? null
        : await _db.collection('siPatuh_files').doc(siPatuhFileId).get();

    final senderData = senderDoc?.data() ?? <String, dynamic>{};
    final siPatuhData = siPatuhDoc?.data() ?? <String, dynamic>{};

    final senderName = (senderData['displayName'] ?? senderId).toString();

    return {
      ...notification,
      'senderName': senderName.isNotEmpty ? senderName : 'Unknown User',
      'senderProfileImage': senderData['profileImage'] ?? '',
      'siPatuhImage': siPatuhData['siPatuhImage'] ?? '',
    };
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllSnap() {
    final currentUserId = _currentUser?.uid;
    if (currentUserId == null) {
      return const Stream<QuerySnapshot<Map<String, dynamic>>>.empty();
    }

    return _db
        .collection('siPatuh_files')
        .where('ownerId', isEqualTo: currentUserId)
        .snapshots();
  }

  Future<void> updateShareStatus(String shareFileId, String status) async {
    final user = _currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    await _db.collection('shared_files').doc(shareFileId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
      if (status == 'declined') 'disabledAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>?> getLatestSnapForCurrentUser() async {
    final user = _currentUser;
    if (user == null) {
      return null;
    }

    final query = await _db.collection('siPatuh_files').get();

    for (final doc in query.docs) {
      final data = doc.data();
      final ownerId = (data['ownerId'] ?? data['userId'] ?? '').toString();
      if (ownerId == user.uid) {
        return {...data, 'id': doc.id};
      }
    }

    return null;
  }

  Future<void> deleteSnap(String siPatuhFilesId) async {
    if (siPatuhFilesId.trim().isEmpty) {
      throw Exception('Snap id is required');
    }

    final docRef = _db.collection('siPatuh_files').doc(siPatuhFilesId);
    await docRef.delete();
  }

  Future<void> updateSnap(
    String siPatuhFilesId,
    Map<String, dynamic> updatedData,
  ) async {
    if (siPatuhFilesId.trim().isEmpty) {
      throw Exception('Snap id is required');
    }

    await _db.collection('siPatuh_files').doc(siPatuhFilesId).update({
      ...updatedData,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
