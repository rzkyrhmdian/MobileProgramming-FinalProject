import 'dart:io';
import 'dart:math'; // Tambahan untuk random ID Notifikasi
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mobileprogramming_finalproject/data/repository/report_repository_impl.dart';
import 'package:mobileprogramming_finalproject/domain/model/report_info.dart';
import 'package:mobileprogramming_finalproject/data/repository/notification_repository_impl.dart'; // Import repo notifikasi

class ReportViewModel extends ChangeNotifier {
  final ReportRepositoryImpl _repository = ReportRepositoryImpl();
  // Inisialisasi Repo Notifikasi
  final NotificationRepositoryImpl _notificationRepo = NotificationRepositoryImpl(); 
  
  final platController = TextEditingController();
  final deskripsiController = TextEditingController();
  
  File? selectedImage;
  bool isLoading = false;
  String currentAddress = "Mencari lokasi...";
  
  double? currentLatitude;
  double? currentLongitude;
  String? selectedJenisInsiden;

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

  void initForm(ReportInfo? existingReport) {
    if (existingReport != null) {
      reportId = existingReport.id;
      platController.text = existingReport.platNomor;
      deskripsiController.text = existingReport.deskripsi;
      selectedJenisInsiden = existingReport.jenisInsiden;
      currentLatitude = existingReport.latitude;
      currentLongitude = existingReport.longitude;
      currentAddress = existingReport.alamat;
      existingFotoUrl = existingReport.fotoUrl;
    } else {
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

        // TRIGGER NOTIFIKASI LOKAL (EDIT)
        await _notificationRepo.createNotification(
          id: Random().nextInt(10000), 
          title: 'Laporan Diperbarui 📝', 
          body: 'Perubahan pada laporan Anda berhasil disimpan dan sedang menunggu review admin.',
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

        // TRIGGER NOTIFIKASI LOKAL (BARU)
        await _notificationRepo.createNotification(
          id: Random().nextInt(10000), 
          title: 'Laporan Diterima! 🚀', 
          body: 'Laporan insiden Anda berhasil dikirim dan sedang dalam proses peninjauan.',
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