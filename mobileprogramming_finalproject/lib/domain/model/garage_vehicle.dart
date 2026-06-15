enum GarageVehicleStatus { aman, mendekati, terlambat }

class GarageVehicle {
  final String id;
  final String brand;
  final String plateNumber;
  final String region;
  final DateTime annualTaxExpiry;
  final DateTime fiveYearTaxExpiry;
  final bool isAnnualPaid;
  final bool isFiveYearPaid;
  final String color;
  final String category;
  final String imageUrl;

  const GarageVehicle({
    required this.id,
    required this.brand,
    required this.plateNumber,
    required this.region,
    required this.annualTaxExpiry,
    required this.fiveYearTaxExpiry,
    required this.isAnnualPaid,
    required this.isFiveYearPaid,
    required this.color,
    required this.category,
    required this.imageUrl,
  });

  GarageVehicleStatus _calculateStatus(DateTime expiry, bool isPaid) {
    if (isPaid) return GarageVehicleStatus.aman;
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final expiryDate = DateTime(expiry.year, expiry.month, expiry.day);
    
    if (todayDate.isAfter(expiryDate)) {
      return GarageVehicleStatus.terlambat;
    }
    
    final difference = expiryDate.difference(todayDate).inDays;
    if (difference <= 30) {
      return GarageVehicleStatus.mendekati;
    }
    
    return GarageVehicleStatus.aman;
  }

  GarageVehicleStatus get annualTaxStatus => _calculateStatus(annualTaxExpiry, isAnnualPaid);
  GarageVehicleStatus get fiveYearTaxStatus => _calculateStatus(fiveYearTaxExpiry, isFiveYearPaid);

  String _getStatusText(GarageVehicleStatus status, String type) {
    switch (status) {
      case GarageVehicleStatus.aman:
        return 'Pajak $type Aman';
      case GarageVehicleStatus.mendekati:
        return 'Pajak $type Mendekati Jatuh Tempo';
      case GarageVehicleStatus.terlambat:
        return 'Pajak $type Terlambat';
    }
  }

  String get annualTaxStatusText => _getStatusText(annualTaxStatus, 'Tahunan');
  String get fiveYearTaxStatusText => _getStatusText(fiveYearTaxStatus, 'STNK');

  String _getBadgeText(GarageVehicleStatus status) {
    switch (status) {
      case GarageVehicleStatus.aman:
        return 'Aman';
      case GarageVehicleStatus.mendekati:
        return 'Mendekati';
      case GarageVehicleStatus.terlambat:
        return 'Terlambat';
    }
  }

  String get annualTaxBadgeText => _getBadgeText(annualTaxStatus);
  String get fiveYearTaxBadgeText => _getBadgeText(fiveYearTaxStatus);

  GarageVehicle copyWith({
    String? id,
    String? brand,
    String? plateNumber,
    String? region,
    DateTime? annualTaxExpiry,
    DateTime? fiveYearTaxExpiry,
    bool? isAnnualPaid,
    bool? isFiveYearPaid,
    String? color,
    String? category,
    String? imageUrl,
  }) {
    return GarageVehicle(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      plateNumber: plateNumber ?? this.plateNumber,
      region: region ?? this.region,
      annualTaxExpiry: annualTaxExpiry ?? this.annualTaxExpiry,
      fiveYearTaxExpiry: fiveYearTaxExpiry ?? this.fiveYearTaxExpiry,
      isAnnualPaid: isAnnualPaid ?? this.isAnnualPaid,
      isFiveYearPaid: isFiveYearPaid ?? this.isFiveYearPaid,
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
            annualTaxExpiry == other.annualTaxExpiry &&
            fiveYearTaxExpiry == other.fiveYearTaxExpiry &&
            isAnnualPaid == other.isAnnualPaid &&
            isFiveYearPaid == other.isFiveYearPaid &&
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
        annualTaxExpiry.hashCode ^
        fiveYearTaxExpiry.hashCode ^
        isAnnualPaid.hashCode ^
        isFiveYearPaid.hashCode ^
        color.hashCode ^
        category.hashCode ^
        imageUrl.hashCode;
  }
}
