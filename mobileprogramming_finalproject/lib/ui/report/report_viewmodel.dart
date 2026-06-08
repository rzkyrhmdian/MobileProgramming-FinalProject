import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mobileprogramming_finalproject/data/repository/report_repository_impl.dart';

class ReportViewModel extends ChangeNotifier {
  final ReportRepositoryImpl _repository = ReportRepositoryImpl();
  final platController = TextEditingController();
  final deskripsiController = TextEditingController();
  
  File? selectedImage;
  bool isLoading = false;
  String currentAddress = "Mencari lokasi...";
  
  // Koordinat untuk map
  double? currentLatitude;
  double? currentLongitude;
  
  String? selectedJenisInsiden;

  final List<String> jenisInsidenList = [
    'Parkir Liar', 'Ganjil Genap', 'Pelanggaran Rambu', 'Kecelakaan', 'Lainnya'
  ];
  final ImagePicker _picker = ImagePicker();

  void setJenisInsiden(String? value) {
    selectedJenisInsiden = value;
    notifyListeners();
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      selectedImage = File(image.path);
      notifyListeners();
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;

      Position position = await Geolocator.getCurrentPosition();
      currentLatitude = position.latitude;
      currentLongitude = position.longitude;

      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        currentAddress = "${placemarks.first.street}, ${placemarks.first.subAdministrativeArea}";
      }
      notifyListeners();
    } catch (e) {
      currentAddress = "Gagal memuat lokasi";
      notifyListeners();
    }
  }

  Future<bool> submitReport() async {
    if (selectedImage == null || platController.text.isEmpty || selectedJenisInsiden == null) {
      return false;
    }

    if (currentLatitude == null || currentLongitude == null) {
      debugPrint("Gagal kirim: Lokasi belum ditemukan");
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      await _repository.submitReport(
        platNomor: platController.text,
        jenisInsiden: selectedJenisInsiden!,
        deskripsi: deskripsiController.text,
        latitude: currentLatitude!,
        longitude: currentLongitude!,
        alamat: currentAddress,
        foto: selectedImage!,
      );
      
      return true; 
    } catch (e) {
      debugPrint("Error saat kirim laporan: $e");
      return false; 
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void resetForm() {
    platController.clear();
    deskripsiController.clear();
    selectedImage = null;
    selectedJenisInsiden = null;
    notifyListeners();
  }

  @override
  void dispose() {
    platController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }
}