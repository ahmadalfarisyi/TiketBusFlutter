import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapsPage extends StatelessWidget {
  const MapsPage({Key? key}) : super(key: key);

  // Data terminal bus di Aceh
  final List<Map<String, dynamic>> terminalBus = const [
    {"name": "Terminal Batoh", "lat": 5.549398, "lng": 95.319295},
    {"name": "Terminal Lueng Bata", "lat": 5.534365, "lng": 95.314247},
    {"name": "Terminal Keudah", "lat": 5.558170, "lng": 95.329851},
    {"name": "Terminal Lhoknga", "lat": 5.528347, "lng": 95.243683},
    {"name": "Terminal Ulee Kareng", "lat": 5.529873, "lng": 95.349695},
    {"name": "Terminal Simpang Surabaya", "lat": 5.543674, "lng": 95.332897}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Titik Terminal Bus Aceh'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Deskripsi peta di bagian atas
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.blueAccent,
            child: const Text(
              'Peta ini menampilkan titik-titik terminal bus utama di Aceh. Klik pada ikon untuk informasi lebih lanjut.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Expanded untuk peta agar mengisi sisa layar
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(5.5483, 95.3238), // Aceh
                    initialZoom: 12.0,
                    maxZoom: 18.0,
                    minZoom: 5.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: terminalBus.map((terminal) {
                        return Marker(
                          point: LatLng(terminal['lat'], terminal['lng']),
                          width: 80.0,
                          height: 80.0,
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(terminal['name']),
                                    content: Text(
                                      'Koordinat: ${terminal['lat']}, ${terminal['lng']}',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text('Tutup'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 40.0,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Peta diperbarui ke posisi saat ini.'),
            ),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
