import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OSM 예제',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MapPage(),
    );
  }
}

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('OpenStreetMap 예제')),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(37.5665, 126.9780), // 서울 중심
          initialZoom: 13,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.sample1', // 앱 식별자 필수
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(37.5665, 126.9780),
                width: 80,
                height: 80,
                alignment: Alignment.topCenter,
                child: Icon(Icons.location_on, color: Colors.red, size: 40),
              ),
            ],
          ),

        ],
      ),
    );
  }
}