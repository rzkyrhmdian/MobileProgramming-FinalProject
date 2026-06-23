import 'package:flutter/foundation.dart';
import 'package:mobileprogramming_finalproject/data/repository/garage_repository_impl.dart';
import 'package:mobileprogramming_finalproject/domain/model/garage_vehicle.dart';
import 'package:mobileprogramming_finalproject/domain/repository/garage_repository.dart';
import 'package:mobileprogramming_finalproject/data/repository/notification_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailGarageViewModel extends ChangeNotifier {
  DetailGarageViewModel({
    required String plateNumber,
    GarageRepository? repository,
  }) : _plateNumber = plateNumber,
       _repository = repository ?? GarageRepositoryImpl();

  String _plateNumber;
  final GarageRepository _repository;
  final NotificationRepositoryImpl _notificationRepo = NotificationRepositoryImpl();

  void updatePlateNumber(String newPlate) {
    _plateNumber = newPlate;
  }

  GarageVehicle? vehicle;
  bool isLoading = false;
  String error = '';

  Future<void> loadVehicle() async {
    isLoading = true;
    error = '';
    notifyListeners();

    try {
      vehicle = await _repository.getVehicleByPlate(_plateNumber);
      if (vehicle == null) {
        error = 'Data kendaraan tidak ditemukan.';
      }
    } catch (e) {
      error = 'Gagal memuat detail kendaraan.';
      debugPrint('=== DETAIL ERROR GARAGE DETAIL ===');
      debugPrint(e.toString());
      debugPrint('==================================');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteVehicle() async {
    isLoading = true;
    error = '';
    notifyListeners();

    try {
      if (vehicle == null) {
        error = 'Data kendaraan tidak tersedia.';
        return false;
      }
      final success = await _repository.deleteVehicle(vehicle!.id);
      if (!success) {
        error = 'Gagal menghapus kendaraan.';
      }
      return success;
    } catch (e) {
      error = 'Terjadi kesalahan saat menghapus.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> renewAnnualTax() async {
    if (vehicle == null) return false;
    isLoading = true;
    error = '';
    notifyListeners();
    try {
      final success = await _repository.renewAnnualTax(vehicle!);
      if (success) {
        await _notificationRepo.cancelVehicleNotifications(vehicle!.id);
        
        final myUserId = FirebaseAuth.instance.currentUser?.uid;
        if (myUserId != null) {
          try {
            await _notificationRepo.saveNotificationToFirestore(
              userId: myUserId,
              title: 'Pajak Tahunan Diperbarui ✅',
              body: 'Masa berlaku pajak tahunan kendaraan ${vehicle!.plateNumber} berhasil diperbarui.',
            );
            await _notificationRepo.createNotification(
              id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
              title: 'Pajak Tahunan Diperbarui ✅',
              body: 'Masa berlaku pajak tahunan kendaraan ${vehicle!.plateNumber} berhasil diperbarui.',
            );
          } catch (e) {
            debugPrint('Gagal mengirim notif firestore: $e');
          }
        }

        await loadVehicle();
        
        if (vehicle != null) {
          await _notificationRepo.scheduleVehicleTaxNotifications(vehicle!);
        }
      } else {
        error = 'Gagal memperbarui pajak tahunan.';
      }
      return success;
    } catch (e) {
      error = 'Terjadi kesalahan.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> renewFiveYearTax() async {
    if (vehicle == null) return false;
    isLoading = true;
    error = '';
    notifyListeners();
    try {
      final success = await _repository.renewFiveYearTax(vehicle!);
      if (success) {
        await _notificationRepo.cancelVehicleNotifications(vehicle!.id);
        
        final myUserId = FirebaseAuth.instance.currentUser?.uid;
        if (myUserId != null) {
          try {
            await _notificationRepo.saveNotificationToFirestore(
              userId: myUserId,
              title: 'STNK Diperbarui ✅',
              body: 'Masa berlaku STNK kendaraan ${vehicle!.plateNumber} berhasil diperbarui.',
            );
            await _notificationRepo.createNotification(
              id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
              title: 'STNK Diperbarui ✅',
              body: 'Masa berlaku STNK kendaraan ${vehicle!.plateNumber} berhasil diperbarui.',
            );
          } catch (e) {
            debugPrint('Gagal mengirim notif firestore: $e');
          }
        }

        await loadVehicle();

        if (vehicle != null) {
          await _notificationRepo.scheduleVehicleTaxNotifications(vehicle!);
        }
      } else {
        error = 'Gagal memperbarui masa berlaku STNK.';
      }
      return success;
    } catch (e) {
      error = 'Terjadi kesalahan.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
