import 'stop.dart';

class RouteModel {
  final String routeNo;
  final List<Stop> fullRoute;

  RouteModel({required this.routeNo, required this.fullRoute});

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    final stopsJson = json['fullRoute'] as List<dynamic>? ?? [];
    final stops = stopsJson.map((s) => Stop.fromJson(s as Map<String, dynamic>)).toList();
    return RouteModel(
      routeNo: json['routeNo']?.toString() ?? '',
      fullRoute: stops,
    );
  }
}
