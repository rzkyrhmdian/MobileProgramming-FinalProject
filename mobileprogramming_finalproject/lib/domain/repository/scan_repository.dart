import 'dart:io';
import 'package:mobileprogramming_finalproject/domain/model/plate_info.dart';

abstract class ScanRepository {
  Future<PlateInfo> scanPlate(File imageFile);
}
