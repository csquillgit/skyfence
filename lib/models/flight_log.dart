import 'dart:convert';

class FlightLog {
  final String id;
  final String title;
  final double latitude;
  final double longitude;
  final DateTime date;
  final String droneModel;
  final int durationMinutes;
  final int maxAltitudeFt;
  final String? notes;

  const FlightLog({
    required this.id,
    required this.title,
    required this.latitude,
    required this.longitude,
    required this.date,
    required this.droneModel,
    required this.durationMinutes,
    required this.maxAltitudeFt,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'latitude': latitude,
      'longitude': longitude,
      'date': date.toIso8601String(),
      'droneModel': droneModel,
      'durationMinutes': durationMinutes,
      'maxAltitudeFt': maxAltitudeFt,
      'notes': notes,
    };
  }

  factory FlightLog.fromMap(Map<String, dynamic> map) {
    return FlightLog(
      id: map['id'] as String,
      title: map['title'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
      droneModel: map['droneModel'] as String? ?? 'Drone',
      durationMinutes: (map['durationMinutes'] as num).toInt(),
      maxAltitudeFt: (map['maxAltitudeFt'] as num).toInt(),
      notes: map['notes'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory FlightLog.fromJson(String source) =>
      FlightLog.fromMap(json.decode(source) as Map<String, dynamic>);
}
