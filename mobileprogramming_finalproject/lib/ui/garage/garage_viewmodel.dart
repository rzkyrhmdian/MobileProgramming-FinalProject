import 'package:flutter/foundation.dart';
import 'package:mobileprogramming_finalproject/data/repository/garage_repository_impl.dart';
import 'package:mobileprogramming_finalproject/domain/model/garage_vehicle.dart';
import 'package:mobileprogramming_finalproject/domain/repository/garage_repository.dart';

class GarageViewModel extends ChangeNotifier {
  GarageViewModel({GarageRepository? repository})
    : _repository = repository ?? GarageRepositoryImpl();

  final GarageRepository _repository;

  bool isLoading = false;
  String error = '';
  List<GarageVehicle> vehicles = const [];

  Future<void> loadVehicles() async {
    isLoading = true;
    error = '';
    notifyListeners();

    try {
      vehicles = await _repository.getVehicles();
    } catch (e) {
      error = 'Gagal memuat data garasi.';
      debugPrint('=== DETAIL ERROR GARAGE LOAD ===');
      debugPrint(e.toString());
      debugPrint('================================');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<GarageVehicle?> getVehicleByPlate(String plateNumber) {
    return _repository.getVehicleByPlate(plateNumber);
  }

  Future<bool> deleteVehicle(String id) async {
    error = '';
    notifyListeners();

    try {
      final success = await _repository.deleteVehicle(id);
      if (!success) {
        error = 'Kendaraan tidak ditemukan.';
        notifyListeners();
        return false;
      }

      vehicles = List<GarageVehicle>.from(
        vehicles.where((vehicle) => vehicle.id != id),
      );
      notifyListeners();
      return true;
    } catch (e) {
      error = 'Gagal menghapus kendaraan.';
      debugPrint('=== DETAIL ERROR GARAGE DELETE ===');
      debugPrint(e.toString());
      debugPrint('==================================');
      notifyListeners();
      return false;
    }
  }


}
