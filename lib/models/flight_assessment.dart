import 'airspace_zone.dart';

enum FlightStatus {
  clearToFly,      // 🟢 Uncontrolled Class G, up to 400 ft AGL
  advisoryCaution, // 🟡 Proximity advisory (within 3-5 miles of airport/helipad, or reduced ceiling)
  restrictedNoFly, // 🔴 Controlled Class B/C/D surface grid (0ft), National Park, or Prohibited
}

class FlightAssessment {
  final FlightStatus status;
  final int maxAllowedCeilingFt;
  final AirspaceZone? limitingZone;
  final double? distanceToLimitingZoneMiles;
  final List<AirspaceZone> nearbyZones;
  final String statusHeadline;
  final String statusExplanation;
  final DateTime? localSunset;

  const FlightAssessment({
    required this.status,
    required this.maxAllowedCeilingFt,
    this.limitingZone,
    this.distanceToLimitingZoneMiles,
    this.nearbyZones = const [],
    required this.statusHeadline,
    required this.statusExplanation,
    this.localSunset,
  });
}
