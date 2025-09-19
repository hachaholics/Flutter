class Stop {
  final String id;
  final String name;
  final double lat;
  final double lon;

  Stop({required this.id, required this.name, required this.lat, required this.lon});

  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
    );
  }
}
