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
      annualTaxExpiry: data['annualTaxExpiry'] != null 
          ? DateTime.tryParse(data['annualTaxExpiry'].toString()) ?? DateTime.now() 
          : DateTime.now(),
      fiveYearTaxExpiry: data['fiveYearTaxExpiry'] != null 
          ? DateTime.tryParse(data['fiveYearTaxExpiry'].toString()) ?? DateTime.now() 
          : DateTime.now(),
      isAnnualPaid: data['isAnnualPaid'] == true,
      isFiveYearPaid: data['isFiveYearPaid'] == true,
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
      'annualTaxExpiry': updatedVehicle.annualTaxExpiry.toIso8601String(),
      'fiveYearTaxExpiry': updatedVehicle.fiveYearTaxExpiry.toIso8601String(),
      'isAnnualPaid': updatedVehicle.isAnnualPaid,
      'isFiveYearPaid': updatedVehicle.isFiveYearPaid,
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
        'annualTaxExpiry': vehicle.annualTaxExpiry.toIso8601String(),
        'fiveYearTaxExpiry': vehicle.fiveYearTaxExpiry.toIso8601String(),
        'isAnnualPaid': vehicle.isAnnualPaid,
        'isFiveYearPaid': vehicle.isFiveYearPaid,
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

  @override
  Future<bool> renewAnnualTax(GarageVehicle vehicle) async {
    final updatedVehicle = vehicle.copyWith(
      annualTaxExpiry: DateTime(
        vehicle.annualTaxExpiry.year + 1,
        vehicle.annualTaxExpiry.month,
        vehicle.annualTaxExpiry.day,
      ),
      isAnnualPaid: false,
    );
    return updateVehicle(updatedVehicle);
  }

  @override
  Future<bool> renewFiveYearTax(GarageVehicle vehicle) async {
    final updatedVehicle = vehicle.copyWith(
      fiveYearTaxExpiry: DateTime(
        vehicle.fiveYearTaxExpiry.year + 5,
        vehicle.fiveYearTaxExpiry.month,
        vehicle.fiveYearTaxExpiry.day,
      ),
      annualTaxExpiry: DateTime(
        vehicle.annualTaxExpiry.year + 1,
        vehicle.annualTaxExpiry.month,
        vehicle.annualTaxExpiry.day,
      ),
      isAnnualPaid: false,
      isFiveYearPaid: false,
    );
    return updateVehicle(updatedVehicle);
  }
}
