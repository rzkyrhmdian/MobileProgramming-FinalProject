class PlateInfo {
  final String? plat;
  final String? masaBerlaku;

  const PlateInfo({
    this.plat,
    this.masaBerlaku,
  });

  /// Mengecek apakah data plat berhasil ditemukan.
  bool get isPlateFound => plat != null;

  /// Mengecek apakah data masa berlaku berhasil ditemukan.
  bool get isExpirationFound => masaBerlaku != null;

  /// Mengecek apakah semua informasi berhasil diekstrak.
  bool get isComplete => isPlateFound && isExpirationFound;

  @override
  String toString() => 'PlateInfo(plat: $plat, masaBerlaku: $masaBerlaku)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlateInfo &&
          runtimeType == other.runtimeType &&
          plat == other.plat &&
          masaBerlaku == other.masaBerlaku;

  @override
  int get hashCode => plat.hashCode ^ masaBerlaku.hashCode;
}
