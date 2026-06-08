class ReportInfo {
  final String id;
  final String userId;
  final String platNomor;
  final String jenisInsiden;
  final String deskripsi;
  final double latitude;
  final double longitude;
  final String alamat;
  final String fotoUrl;
  final String status;
  final DateTime createdAt;

  ReportInfo({
    required this.id,
    required this.userId,
    required this.platNomor,
    required this.jenisInsiden,
    required this.deskripsi,
    required this.latitude,
    required this.longitude,
    required this.alamat,
    required this.fotoUrl,
    required this.status,
    required this.createdAt,
  });
}