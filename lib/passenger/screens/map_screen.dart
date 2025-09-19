import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/route_model.dart';
import '../models/stop.dart';

class MapScreen extends StatefulWidget {
  final RouteModel route;
  const MapScreen({super.key, required this.route});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  List<LatLng> _pointsFromStops(List<Stop> stops) =>
      stops.map((s) => LatLng(s.lat, s.lon)).toList();

  LatLngBounds _boundsFromPoints(List<LatLng> pts) {
    assert(pts.isNotEmpty);
    double south = pts.first.latitude, north = pts.first.latitude;
    double west = pts.first.longitude, east = pts.first.longitude;
    for (final p in pts) {
      if (p.latitude < south) south = p.latitude;
      if (p.latitude > north) north = p.latitude;
      if (p.longitude < west) west = p.longitude;
      if (p.longitude > east) east = p.longitude;
    }
    return LatLngBounds(LatLng(south, west), LatLng(north, east));
  }

  @override
  void initState() {
    super.initState();
    // fit to bounds after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pts = _pointsFromStops(widget.route.fullRoute);
      if (pts.isNotEmpty) {
        final bounds = _boundsFromPoints(pts);
        _mapController.fitBounds(bounds, options: const FitBoundsOptions(padding: EdgeInsets.all(40)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final stops = widget.route.fullRoute;
    final points = _pointsFromStops(stops);

    final markers = stops.map((s) {
      return Marker(
        width: 40,
        height: 40,
        point: LatLng(s.lat, s.lon),
        builder: (ctx) => const Icon(Icons.location_on, size: 36),
      );
    }).toList();

    final polyline = Polyline(points: points, strokeWidth: 4.0);

    return Scaffold(
      appBar: AppBar(
        title: Text('Route ${widget.route.routeNo}'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: points.isNotEmpty ? points.first : LatLng(0, 0),
              zoom: 13.0,
              maxZoom: 19.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.bus_passenger_app', // polite
              ),
              PolylineLayer(polylines: [polyline]),
              MarkerLayer(markers: markers),
            ],
          ),
          // OSM attribution (required)
          Positioned(
            right: 8,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              color: Colors.white70,
              child: const Text(
                '© OpenStreetMap contributors',
                style: TextStyle(fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
