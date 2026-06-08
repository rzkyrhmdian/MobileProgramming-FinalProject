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
}
