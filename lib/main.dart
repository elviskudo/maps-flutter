import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'City Map App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CityMapScreen(),
    );
  }
}

class CityMapScreen extends StatefulWidget {
  @override
  _CityMapScreenState createState() => _CityMapScreenState();
}

class _CityMapScreenState extends State<CityMapScreen> {
  GoogleMapController? _controller;

  // Center points for Jakarta and Bandung
  final LatLng _jakartaCenter = LatLng(-6.2088, 106.8456);
  final LatLng _bandungCenter = LatLng(-6.9175, 107.6191);

  // Polygons for Jakarta and Bandung
  final Set<Polygon> _polygons = {};
  final Set<Marker> _markers = {};
  final Polyline _polyline = Polyline(
    polylineId: PolylineId('jakarta_bandung'),
    points: [
      LatLng(-6.2088, 106.8456), // Jakarta
      LatLng(-6.2000, 106.8670),
      LatLng(-6.1800, 106.8850),
      LatLng(-6.1600, 106.9000),
      LatLng(-6.1400, 106.9100),
      LatLng(-6.1300, 106.9200),
      LatLng(-6.1200, 106.9300),
      LatLng(-6.1100, 106.9400),
      LatLng(-6.1000, 106.9500),
      LatLng(-6.1000, 107.0500), // Towards Bandung
      LatLng(-6.1100, 107.0600),
      LatLng(-6.1300, 107.0800),
      LatLng(-6.1500, 107.1000),
      LatLng(-6.1700, 107.1100),
      LatLng(-6.1900, 107.1200),
      LatLng(-6.2000, 107.6191), // Bandung
    ],
    color: Colors.blue,
    width: 5,
  );

  @override
  void initState() {
    super.initState();
    _createPolygons();
    _createMarkers();
  }

  void _createPolygons() {
    // Jakarta Polygon
    _polygons.add(Polygon(
      polygonId: PolygonId('jakarta'),
      points: [
        LatLng(-6.2500, 106.7500),
        LatLng(-6.2500, 107.0000),
        LatLng(-6.1500, 107.0000),
        LatLng(-6.1500, 106.7500),
        LatLng(-6.2400, 106.8500), // Adjust the shape of Jakarta
      ],
      strokeColor: Colors.red,
      fillColor: Colors.red.withOpacity(0.3),
      onTap: () {
        _showCityDetails('Jakarta', 'Luas: 662 km²');
      },
    ));

    // Bandung Polygon
    _polygons.add(Polygon(
      polygonId: PolygonId('bandung'),
      points: [
        LatLng(-6.9300, 107.5900),
        LatLng(-6.9300, 107.6700),
        LatLng(-6.8700, 107.6700),
        LatLng(-6.8700, 107.5900),
        LatLng(-6.9000, 107.6100), // Adjust the shape of Bandung
      ],
      strokeColor: Colors.green,
      fillColor: Colors.green.withOpacity(0.3),
      onTap: () {
        _showCityDetails('Bandung', 'Luas: 167 km²');
      },
    ));
  }

  void _createMarkers() {
    _markers.add(Marker(
      markerId: MarkerId('jakarta_marker'),
      position: _jakartaCenter,
      infoWindow: InfoWindow(title: 'Jakarta'),
    ));

    _markers.add(Marker(
      markerId: MarkerId('bandung_marker'),
      position: _bandungCenter,
      infoWindow: InfoWindow(title: 'Bandung'),
    ));
  }

  void _showCityDetails(String cityName, String details) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(cityName),
        content: Text(details),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('City Map')),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        initialCameraPosition: CameraPosition(
          target: _jakartaCenter,
          zoom: 7,
        ),
        polygons: _polygons,
        markers: _markers,
        polylines: {_polyline},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _calculateDistance,
        child: Icon(Icons.directions),
      ),
    );
  }

  void _calculateDistance() async {
    double distanceInMeters = await Geolocator.distanceBetween(
      _jakartaCenter.latitude,
      _jakartaCenter.longitude,
      _bandungCenter.latitude,
      _bandungCenter.longitude,
    );
    double distanceInKm = distanceInMeters / 1000;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Distance: ${distanceInKm.toStringAsFixed(2)} km')),
    );
  }
}
