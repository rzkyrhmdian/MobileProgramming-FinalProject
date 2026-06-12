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
  Future<List<GarageVehicle>> getVehicles() async {
    final dataList = await _firestoreDatasource.getGarageVehicles();
    return dataList.map((data) => _mapToGarageVehicle(data)).toList();
  }

  @override
  Future<GarageVehicle?> getVehicleByPlate(String plateNumber) async {
    final dataList = await _firestoreDatasource.getGarageVehicles();
    final normalizedPlate = plateNumber.trim().toUpperCase();
    try {
      final data = dataList.firstWhere(
        (v) => (v['plateNumber'] as String).trim().toUpperCase() == normalizedPlate,
      );
      return _mapToGarageVehicle(data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> deleteVehicle(String id) async {
    try {
      await _firestoreDatasource.deleteGarageVehicle(id);
      _localDataSource.deleteVehicle(id);
      return true;
    } catch (e) {
      return false;
    }
  }

  GarageVehicle _mapToGarageVehicle(Map<String, dynamic> data) {
    return GarageVehicle(
      id: data['id']?.toString() ?? '',
      brand: data['brand']?.toString() ?? '',
      plateNumber: data['plateNumber']?.toString() ?? '',
      region: data['region']?.toString() ?? '',
      stnkExpiration: data['stnkExpiration']?.toString() ?? '',
      status: GarageVehicleStatus.values.firstWhere(
        (e) => e.toString() == data['status'],
        orElse: () => GarageVehicleStatus.aman,
      ),
      statusText: data['statusText']?.toString() ?? '',
      badgeText: data['badgeText']?.toString() ?? '',
      color: data['color']?.toString() ?? '',
      category: data['category']?.toString() ?? '',
      imageUrl: data['imageUrl']?.toString() ?? '',
    );
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

  @override
  Future<bool> updateVehicle(GarageVehicle vehicle) async {
    try {
      final vehicleData = {
        'id': vehicle.id,
        'brand': vehicle.brand,
        'plateNumber': vehicle.plateNumber,
        'region': vehicle.region,
        'stnkExpiration': vehicle.stnkExpiration,
        'status': vehicle.status.toString(),
        'statusText': vehicle.statusText,
        'badgeText': vehicle.badgeText,
        'color': vehicle.color,
        'category': vehicle.category,
        'imageUrl': vehicle.imageUrl,
      };
      await _firestoreDatasource.updateGarageVehicle(vehicleData);
      _localDataSource.updateVehicle(vehicle);
      return true;
    } catch (e) {
      return false;
    }
  }
}
