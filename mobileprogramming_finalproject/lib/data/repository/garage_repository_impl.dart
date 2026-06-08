import 'package:mobileprogramming_finalproject/data/remote/garage_local_datasource.dart';
import 'package:mobileprogramming_finalproject/domain/model/garage_vehicle.dart';
import 'package:mobileprogramming_finalproject/domain/repository/garage_repository.dart';

class GarageRepositoryImpl implements GarageRepository {
  GarageRepositoryImpl({GarageLocalDataSource? localDataSource})
    : _localDataSource = localDataSource ?? GarageLocalDataSource();

  final GarageLocalDataSource _localDataSource;

  @override
  Future<List<GarageVehicle>> getVehicles() {
    return _localDataSource.getVehicles();
  }

  @override
  Future<GarageVehicle?> getVehicleByPlate(String plateNumber) {
    return _localDataSource.getVehicleByPlate(plateNumber);
  }

  @override
  Future<bool> deleteVehicle(String plateNumber) {
    return _localDataSource.deleteVehicle(plateNumber);
  }
}
