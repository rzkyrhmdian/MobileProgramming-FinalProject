import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobileprogramming_finalproject/data/remote/garage_local_datasource.dart';
import 'package:mobileprogramming_finalproject/domain/model/garage_vehicle.dart';
import 'package:mobileprogramming_finalproject/domain/repository/garage_repository.dart';

import 'package:mobileprogramming_finalproject/data/remote/firestore_datasource.dart';

class GarageRepositoryImpl implements GarageRepository {
  GarageRepositoryImpl({GarageLocalDataSource? localDataSource, FirestoreDatasource? firestoreDatasource})
    : _localDataSource = localDataSource ?? GarageLocalDataSource(),
      _firestoreDatasource = firestoreDatasource ?? FirestoreDatasource();

  final GarageLocalDataSource _localDataSource;
  final FirestoreDatasource _firestoreDatasource;

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

  @override
  Future<bool> addVehicle(GarageVehicle vehicle, {File? imageFile}) async {
    GarageVehicle updatedVehicle = vehicle;
    
    if (imageFile != null) {
      final String fileName = 'vehicle_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final supabase = Supabase.instance.client;
      await supabase.storage.from('vehicles').upload(
            fileName,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
      final String photoUrl = supabase.storage.from('vehicles').getPublicUrl(fileName);
      updatedVehicle = vehicle.copyWith(imageUrl: photoUrl);
    }

    // Convert to map for Firestore
    final vehicleData = {
      'id': updatedVehicle.id,
      'brand': updatedVehicle.brand,
      'type': updatedVehicle.type,
      'plateNumber': updatedVehicle.plateNumber,
      'region': updatedVehicle.region,
      'stnkExpiration': updatedVehicle.stnkExpiration,
      'status': updatedVehicle.status.toString(),
      'statusText': updatedVehicle.statusText,
      'badgeText': updatedVehicle.badgeText,
      'color': updatedVehicle.color,
      'category': updatedVehicle.category,
      'imageUrl': updatedVehicle.imageUrl,
    };

    // Save to Firestore
    await _firestoreDatasource.addGarageVehicle(vehicleData);

    // Save to local cache
    return _localDataSource.addVehicle(updatedVehicle);
  }
}
