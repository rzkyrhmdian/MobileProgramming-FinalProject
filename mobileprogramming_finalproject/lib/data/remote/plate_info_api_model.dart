import 'package:mobileprogramming_finalproject/domain/model/plate_info.dart';

class PlateInfoApiModel {
  final String? plat;
  final String? masaBerlaku;

  const PlateInfoApiModel({
    this.plat,
    this.masaBerlaku,
  });

  factory PlateInfoApiModel.fromJson(Map<String, dynamic> json) {
    return PlateInfoApiModel(
      plat: json['plat'] as String?,
      masaBerlaku: json['masa_berlaku'] as String?,
    );
  }

  /// Mengkonversi DTO menjadi domain entity.
  PlateInfo toDomain() {
    return PlateInfo(
      plat: plat,
      masaBerlaku: masaBerlaku,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plat': plat,
      'masa_berlaku': masaBerlaku,
    };
  }

  @override
  String toString() =>
      'PlateInfoApiModel(plat: $plat, masaBerlaku: $masaBerlaku)';
}
