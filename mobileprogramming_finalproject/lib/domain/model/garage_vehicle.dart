enum GarageVehicleStatus { aman, mendekati, terlambat }

class GarageVehicle {
  final String id;
  final String brand;
  final String plateNumber;
  final String region;
  final String stnkExpiration;
  final GarageVehicleStatus status;
  final String statusText;
  final String badgeText;
  final String color;
  final String category;
  final String imageUrl;

  const GarageVehicle({
    required this.id,
    required this.brand,
    required this.plateNumber,
    required this.region,
    required this.stnkExpiration,
    required this.status,
    required this.statusText,
    required this.badgeText,
    required this.color,
    required this.category,
    required this.imageUrl,
  });

  GarageVehicle copyWith({
    String? id,
    String? brand,
    String? plateNumber,
    String? region,
    String? stnkExpiration,
    GarageVehicleStatus? status,
    String? statusText,
    String? badgeText,
    String? color,
    String? category,
    String? imageUrl,
  }) {
    return GarageVehicle(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      plateNumber: plateNumber ?? this.plateNumber,
      region: region ?? this.region,
      stnkExpiration: stnkExpiration ?? this.stnkExpiration,
      status: status ?? this.status,
      statusText: statusText ?? this.statusText,
      badgeText: badgeText ?? this.badgeText,
      color: color ?? this.color,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  String toString() {
    return 'GarageVehicle(id: $id, brand: $brand, plateNumber: $plateNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is GarageVehicle &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            brand == other.brand &&
            plateNumber == other.plateNumber &&
            region == other.region &&
            stnkExpiration == other.stnkExpiration &&
            status == other.status &&
            statusText == other.statusText &&
            badgeText == other.badgeText &&
            color == other.color &&
            category == other.category &&
            imageUrl == other.imageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        brand.hashCode ^
        plateNumber.hashCode ^
        region.hashCode ^
        stnkExpiration.hashCode ^
        status.hashCode ^
        statusText.hashCode ^
        badgeText.hashCode ^
        color.hashCode ^
        category.hashCode ^
        imageUrl.hashCode;
  }
}
