import 'dart:io';
import 'package:mobileprogramming_finalproject/domain/model/garage_vehicle.dart';

abstract class GarageRepository {
  Future<List<GarageVehicle>> getVehicles();

  Future<GarageVehicle?> getVehicleByPlate(String plateNumber);

  Future<bool> deleteVehicle(String id);

  Future<bool> addVehicle(GarageVehicle vehicle, {File? imageFile});

  Future<bool> updateVehicle(GarageVehicle vehicle);
}
