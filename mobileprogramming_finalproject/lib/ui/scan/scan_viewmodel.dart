import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobileprogramming_finalproject/domain/model/plate_info.dart';
import 'package:mobileprogramming_finalproject/domain/repository/scan_repository.dart';
import 'package:mobileprogramming_finalproject/data/repository/scan_repository_impl.dart';

/// State yang merepresentasikan status proses scan.
enum ScanState {
  /// Belum ada aksi scan.
  idle,

  /// Sedang memproses gambar (upload + AI processing).
  loading,

  /// Scan berhasil, data tersedia.
  success,

  /// Terjadi error saat proses scan.
  error,
}

class ScanViewModel extends ChangeNotifier {
  final ScanRepository _repository;
  final ImagePicker _imagePicker;

  ScanViewModel({ScanRepository? repository, ImagePicker? imagePicker})
      : _repository = repository ?? ScanRepositoryImpl(),
        _imagePicker = imagePicker ?? ImagePicker();

  // ─── State ─────────────────────────────────────────────
  ScanState _state = ScanState.idle;
  ScanState get state => _state;

  PlateInfo? _plateInfo;
  PlateInfo? get plateInfo => _plateInfo;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  File? _capturedImage;
  File? get capturedImage => _capturedImage;

  // ─── Actions ───────────────────────────────────────────

  /// Mengambil gambar dari kamera lalu langsung memproses scan.
  Future<void> scanFromCamera() async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 1920,
      maxHeight: 1080,
    );

    if (pickedFile != null) {
      _capturedImage = File(pickedFile.path);
      await _processImage(_capturedImage!);
    }
  }

  /// Mengambil gambar dari galeri lalu langsung memproses scan.
  Future<void> scanFromGallery() async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1920,
      maxHeight: 1080,
    );

    if (pickedFile != null) {
      _capturedImage = File(pickedFile.path);
      await _processImage(_capturedImage!);
    }
  }

  /// Memproses file gambar: upload ke server dan parsing hasilnya.
  Future<void> _processImage(File imageFile) async {
    _state = ScanState.loading;
    _errorMessage = null;
    _plateInfo = null;
    notifyListeners();

    try {
      final result = await _repository.scanPlate(imageFile);
      _plateInfo = result;
      _state = ScanState.success;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _state = ScanState.error;
    }

    notifyListeners();
  }

  /// Reset state ke kondisi awal.
  void reset() {
    _state = ScanState.idle;
    _plateInfo = null;
    _errorMessage = null;
    _capturedImage = null;
    notifyListeners();
  }
}
