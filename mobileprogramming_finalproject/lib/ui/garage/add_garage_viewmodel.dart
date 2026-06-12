import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobileprogramming_finalproject/domain/repository/garage_repository.dart';
import 'package:mobileprogramming_finalproject/data/repository/garage_repository_impl.dart';
import 'package:mobileprogramming_finalproject/domain/model/garage_vehicle.dart';

class AddGarageViewModel extends ChangeNotifier {
  final GarageRepository _garageRepository;
  final ImagePicker _imagePicker;

  AddGarageViewModel({GarageRepository? garageRepository, ImagePicker? imagePicker})
      : _garageRepository = garageRepository ?? GarageRepositoryImpl(),
        _imagePicker = imagePicker ?? ImagePicker();

  String _brand = '';
  String _category = '';
  String _plateNumber = '';
  String _stnkExp = '';
  String _color = '';
  File? _imageFile;

  bool _isLoading = false;
  String _error = '';

  bool get isLoading => _isLoading;
  String get error => _error;
  File? get imageFile => _imageFile;

  void updateBrand(String val) => _brand = val;
  void updateCategory(String val) => _category = val;
  void updatePlateNumber(String val) => _plateNumber = val;
  void updateStnkExp(String val) => _stnkExp = val;
  void updateColor(String val) => _color = val;

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        notifyListeners();
      }
    } catch (e) {
      _error = 'Gagal mengambil gambar: $e';
      notifyListeners();
    }
  }

  Future<bool> addVehicle() async {
    if (_imageFile == null) {
      _error = 'Pilih foto kendaraan terlebih dahulu';
      notifyListeners();
      return false;
    }

    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      // Panggil repository untuk menyimpan data (termasuk upload foto)
      final newVehicle = GarageVehicle(
        id: 'vehicle_${DateTime.now().millisecondsSinceEpoch}',
        brand: _brand,
        plateNumber: _plateNumber,
        stnkExpiration: _stnkExp,
        color: _color,
        region: 'METRO JAYA', // Default value for now
        status: GarageVehicleStatus.aman, // Default value for now
        statusText: 'Pajak Aman', // Default value for now
        badgeText: 'Aman', // Default value for now
        category: _category,
        imageUrl: '', // Will be updated in repository after upload
      );

      await _garageRepository.addVehicle(newVehicle, imageFile: _imageFile);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
