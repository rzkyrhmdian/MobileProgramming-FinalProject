import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobileprogramming_finalproject/domain/model/report_info.dart';

class ReportMapDetailScreen extends StatelessWidget {
  final ReportInfo report;

  const ReportMapDetailScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    // Menggunakan LatLng dari package latlong2
    final LatLng location = LatLng(report.latitude, report.longitude);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Lokasi"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Peta Full Screen menggunakan OpenStreetMap
          FlutterMap(
            options: MapOptions(
              initialCenter: location,
              initialZoom: 16.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.mobileprogramming_finalproject',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: location,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Box Info Alamat di bagian bawah
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.redAccent, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          report.platNomor,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      report.alamat,
                      style: const TextStyle(fontSize: 13, color: Colors.blueGrey),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Koordinat: ${report.latitude.toStringAsFixed(5)}, ${report.longitude.toStringAsFixed(5)}",
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}