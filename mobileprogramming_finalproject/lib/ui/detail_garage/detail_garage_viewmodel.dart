import 'package:flutter/foundation.dart';
import 'package:mobileprogramming_finalproject/data/repository/garage_repository_impl.dart';
import 'package:mobileprogramming_finalproject/domain/model/garage_vehicle.dart';
import 'package:mobileprogramming_finalproject/domain/repository/garage_repository.dart';

class DetailGarageViewModel extends ChangeNotifier {
  DetailGarageViewModel({
    required String plateNumber,
    GarageRepository? repository,
  }) : _plateNumber = plateNumber,
       _repository = repository ?? GarageRepositoryImpl();

  final String _plateNumber;
  final GarageRepository _repository;

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

  Future<bool> deleteDetailVehicle() async {
    try {
      await _repository.deleteVehicle(_plateNumber);
      return true;
    } catch (e) {
      error = 'Gagal menghapus kendaraan.';
      debugPrint('=== DELETE ERROR GARAGE DETAIL ===');
      debugPrint(e.toString());
      debugPrint('==================================');
      notifyListeners();
      return false;
    }
  }

  Future<bool> handleVehicleAction({
    required String actionType,
    required GarageVehicle vehicle,
  }) async {
    isLoading = true;
    error = '';
    notifyListeners();

    try {
      if (actionType == 'edit') {
        error = 'Fitur edit belum tersedia.';
        return false;
      }

      if (actionType == 'delete') {
        final success = await deleteDetailVehicle();
        if (success) {
          await loadVehicle();
          return true;
        }
      } else {
        error = 'Aksi tidak dikenal.';
        notifyListeners();
      }
      return false;
    } catch (e) {
      error = 'Gagal melakukan aksi pada kendaraan.';
      debugPrint('=== ACTION ERROR GARAGE DETAIL ===');
      debugPrint(e.toString());
      debugPrint('==================================');
      notifyListeners();
      return false;
    }
  }
}
