import 'package:mobileprogramming_finalproject/domain/model/garage_vehicle.dart';

class GarageLocalDataSource {
  final List<GarageVehicle> _vehicles = [
    const GarageVehicle(
      id: 'garage-001',
      brand: 'Honda CR-V',
      plateNumber: 'B 1234 PAT',
      region: 'METRO JAYA',
      stnkExpiration: '12 Okt 2028',
      status: GarageVehicleStatus.aman,
      statusText: 'Pajak Aman',
      badgeText: 'Aman',
      color: 'Obsidian Black Metallic',
      category: 'SUV / Penumpang',
      imageUrl:
          'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&q=80&w=800',
    ),
    const GarageVehicle(
      id: 'garage-002',
      brand: 'Toyota Avanza',
      plateNumber: 'B 8899 XYZ',
      region: 'METRO JAYA',
      stnkExpiration: '15 Mar 2027',
      status: GarageVehicleStatus.mendekati,
      statusText: 'Pajak Mendekati Jatuh Tempo',
      badgeText: '7 Hari Lagi',
      color: 'Silver Metallic',
      category: 'MPV / Penumpang',
      imageUrl:
          'https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?auto=format&fit=crop&q=80&w=800',
    ),
    const GarageVehicle(
      id: 'garage-003',
      brand: 'Yamaha NMAX',
      plateNumber: 'B 5678 TUH',
      region: 'METRO JAYA',
      stnkExpiration: '20 Jan 2026',
      status: GarageVehicleStatus.terlambat,
      statusText: 'Pajak Terlambat / Kedaluwarsa',
      badgeText: 'Terlambat',
      color: 'Matte Grey',
      category: 'Sepeda Motor',
      imageUrl:
          'https://images.unsplash.com/photo-1517524008697-84bbe3c3fd98?auto=format&fit=crop&q=80&w=800',
    ),
  ];

  Future<List<GarageVehicle>> getVehicles() async {
    return List<GarageVehicle>.unmodifiable(_vehicles);
  }

  Future<bool> addVehicle(GarageVehicle vehicle) async {
    _vehicles.add(vehicle);
    return true;
  }

  Future<bool> updateVehicle(GarageVehicle vehicle) async {
    final index = _vehicles.indexWhere((v) => v.id == vehicle.id);
    if (index != -1) {
      _vehicles[index] = vehicle;
      return true;
    }
    return false;
  }

  Future<GarageVehicle?> getVehicleByPlate(String plateNumber) async {
    final normalizedPlate = plateNumber.trim().toUpperCase();
    for (final vehicle in _vehicles) {
      if (vehicle.plateNumber.toUpperCase() == normalizedPlate) {
        return vehicle;
      }
    }
    return null;
  }

  Future<bool> deleteVehicle(String id) async {
    final beforeCount = _vehicles.length;
    _vehicles.removeWhere((vehicle) => vehicle.id == id);
    return _vehicles.length < beforeCount;
  }
}
