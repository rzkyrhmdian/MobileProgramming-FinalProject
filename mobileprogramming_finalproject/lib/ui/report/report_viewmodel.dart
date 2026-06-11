import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mobileprogramming_finalproject/data/repository/report_repository_impl.dart';
import 'package:mobileprogramming_finalproject/domain/model/report_info.dart';

class ReportViewModel extends ChangeNotifier {
  final ReportRepositoryImpl _repository = ReportRepositoryImpl();
  final platController = TextEditingController();
  final deskripsiController = TextEditingController();
  
  File? selectedImage;
  bool isLoading = false;
  String currentAddress = "Mencari lokasi...";
  
  double? currentLatitude;
  double? currentLongitude;
  String? selectedJenisInsiden;

  // Variabel untuk menyimpan data bawaan jika mode Edit
  String? reportId;
  String? existingFotoUrl;

  final List<String> jenisInsidenList = [
    'Parkir Liar', 'Ganjil Genap', 'Pelanggaran Rambu', 'Kecelakaan', 'Lainnya'
  ];
  final ImagePicker _picker = ImagePicker();

  void setJenisInsiden(String? value) {
    selectedJenisInsiden = value;
    notifyListeners();
  }

  // FUNGSI BARU: Mengecek apakah ini mode Edit atau Bikin Baru
  void initForm(ReportInfo? existingReport) {
    if (existingReport != null) {
      // Mode Edit: Isi form dengan data yang sudah ada
      reportId = existingReport.id;
      platController.text = existingReport.platNomor;
      deskripsiController.text = existingReport.deskripsi;
      selectedJenisInsiden = existingReport.jenisInsiden;
      currentLatitude = existingReport.latitude;
      currentLongitude = existingReport.longitude;
      currentAddress = existingReport.alamat;
      existingFotoUrl = existingReport.fotoUrl;
    } else {
      // Mode Baru: Cari lokasi GPS sekarang
      getCurrentLocation();
    }
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
    // Validasi Edit membolehkan selectedImage kosong (karena pakai foto lama)
    if ((selectedImage == null && existingFotoUrl == null) || 
        platController.text.isEmpty || 
        selectedJenisInsiden == null) {
      return false;
    }

    if (currentLatitude == null || currentLongitude == null) {
      debugPrint("Gagal kirim: Lokasi belum ditemukan");
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      if (reportId != null) {
        // Mode UPDATE (Edit Laporan)
        await _repository.updateReport(
          id: reportId!,
          platNomor: platController.text,
          jenisInsiden: selectedJenisInsiden!,
          deskripsi: deskripsiController.text,
          latitude: currentLatitude!,
          longitude: currentLongitude!,
          alamat: currentAddress,
          fotoBaru: selectedImage,
          fotoUrlLama: existingFotoUrl!,
        );
      } else {
        // Mode CREATE (Buat Baru)
        await _repository.submitReport(
          platNomor: platController.text,
          jenisInsiden: selectedJenisInsiden!,
          deskripsi: deskripsiController.text,
          latitude: currentLatitude!,
          longitude: currentLongitude!,
          alamat: currentAddress,
          foto: selectedImage!,
        );
      }
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