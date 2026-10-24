import 'dart:math';
import '../models/airspace_zone.dart';
import '../models/flight_assessment.dart';

class AirspaceEngine {
  // Built-in offline database of controlled airspaces, airports, and restricted zones
  static const List<AirspaceZone> _airspaces = [
    // --- CLASS B (Major Commercial) ---
    AirspaceZone(
      id: 'bos_class_b_surface',
      name: 'Boston Logan International (Surface Ring)',
      code: 'BOS',
      type: AirspaceType.classB,
      centerLat: 42.3656,
      centerLon: -71.0096,
      radiusMiles: 4.6, // ~4 Nautical Miles
      maxDroneCeilingFt: 0, // 0 ft surface grid - No fly without LAANC authorization
      description: 'Class B Controlled Airspace Surface Area. High-density commercial jet traffic.',
      isStrictNoFly: true,
    ),
    AirspaceZone(
      id: 'bos_class_b_shelf_1',
      name: 'Boston Logan (Inner Shelf 1500ft+)',
      code: 'BOS',
      type: AirspaceType.classB,
      centerLat: 42.3656,
      centerLon: -71.0096,
      radiusMiles: 8.0,
      maxDroneCeilingFt: 200, // Reduced ceiling buffer
      description: 'Class B 1500ft-7000ft Shelf. Drone ceiling capped at 200ft AGL for approach clearance.',
    ),

    // --- CLASS C (Regional Radar Controlled) ---
    AirspaceZone(
      id: 'pvd_class_c_surface',
      name: 'Rhode Island T.F. Green Airport',
      code: 'PVD',
      type: AirspaceType.classC,
      centerLat: 41.7240,
      centerLon: -71.4282,
      radiusMiles: 5.8,
      maxDroneCeilingFt: 0,
      description: 'Class C Controlled Airspace Surface Area. Commercial carrier traffic.',
      isStrictNoFly: true,
    ),
    AirspaceZone(
      id: 'mht_class_c_surface',
      name: 'Manchester-Boston Regional Airport',
      code: 'MHT',
      type: AirspaceType.classC,
      centerLat: 42.9345,
      centerLon: -71.4371,
      radiusMiles: 5.8,
      maxDroneCeilingFt: 0,
      description: 'Class C Controlled Airspace Surface Area. Commercial & cargo operations.',
      isStrictNoFly: true,
    ),
    AirspaceZone(
      id: 'bdl_class_c_surface',
      name: 'Bradley International Airport',
      code: 'BDL',
      type: AirspaceType.classC,
      centerLat: 41.9389,
      centerLon: -72.6832,
      radiusMiles: 5.8,
      maxDroneCeilingFt: 0,
      description: 'Class C Controlled Airspace Surface Area. High-volume regional jet arrivals.',
      isStrictNoFly: true,
    ),

    // --- CLASS D (Tower Controlled Airports) ---
    AirspaceZone(
      id: 'orh_class_d_surface',
      name: 'Worcester Regional Airport',
      code: 'ORH',
      type: AirspaceType.classD,
      centerLat: 42.2673,
      centerLon: -71.8757,
      radiusMiles: 4.8,
      maxDroneCeilingFt: 0,
      description: 'Class D Airspace Surface Area. Operating control tower & commercial flights.',
      isStrictNoFly: true,
    ),
    AirspaceZone(
      id: 'bed_class_d_surface',
      name: 'Hanscom Field',
      code: 'BED',
      type: AirspaceType.classD,
      centerLat: 42.4700,
      centerLon: -71.2890,
      radiusMiles: 5.0,
      maxDroneCeilingFt: 0,
      description: 'Class D Airspace. High-density corporate jet & military transient operations.',
      isStrictNoFly: true,
    ),
    AirspaceZone(
      id: 'owd_class_d_surface',
      name: 'Norwood Memorial Airport',
      code: 'OWD',
      type: AirspaceType.classD,
      centerLat: 42.1905,
      centerLon: -71.1730,
      radiusMiles: 4.6,
      maxDroneCeilingFt: 0,
      description: 'Class D Airspace Surface Area. Busy flight training and corporate aviation.',
      isStrictNoFly: true,
    ),
    AirspaceZone(
      id: 'bvy_class_d_surface',
      name: 'Beverly Regional Airport',
      code: 'BVY',
      type: AirspaceType.classD,
      centerLat: 42.5841,
      centerLon: -70.9161,
      radiusMiles: 4.6,
      maxDroneCeilingFt: 0,
      description: 'Class D Airspace Surface Area. North Shore aviation hub.',
      isStrictNoFly: true,
    ),
    AirspaceZone(
      id: 'baf_class_d_surface',
      name: 'Westfield-Barnes Regional Airport',
      code: 'BAF',
      type: AirspaceType.classD,
      centerLat: 42.1578,
      centerLon: -72.7111,
      radiusMiles: 5.0,
      maxDroneCeilingFt: 0,
      description: 'Class D Airspace Surface Area. Air National Guard Fighter Wing operations.',
      isStrictNoFly: true,
    ),

    // --- NATIONAL PARKS / RESTRICTED FEDERAL ZONES (36 CFR 1.5 DRONE BAN) ---
    AirspaceZone(
      id: 'cape_cod_national_seashore',
      name: 'Cape Cod National Seashore',
      code: 'NPS',
      type: AirspaceType.nationalPark,
      centerLat: 41.9773,
      centerLon: -69.9722,
      radiusMiles: 14.0,
      maxDroneCeilingFt: 0,
      description: 'National Park Service (36 CFR 1.5). Launching, landing, or operating drones is federally prohibited.',
      isStrictNoFly: true,
    ),
    AirspaceZone(
      id: 'minute_man_nps',
      name: 'Minute Man National Historical Park',
      code: 'NPS',
      type: AirspaceType.nationalPark,
      centerLat: 42.4580,
      centerLon: -71.3060,
      radiusMiles: 1.8,
      maxDroneCeilingFt: 0,
      description: 'National Historical Park. Operating unmanned aircraft prohibited by federal regulation.',
      isStrictNoFly: true,
    ),
    AirspaceZone(
      id: 'acadia_national_park',
      name: 'Acadia National Park',
      code: 'NPS',
      type: AirspaceType.nationalPark,
      centerLat: 44.3386,
      centerLon: -68.2733,
      radiusMiles: 12.0,
      maxDroneCeilingFt: 0,
      description: 'National Park boundary. Strict federal drone prohibition to protect wildlife and visitors.',
      isStrictNoFly: true,
    ),

    // --- HOSPITAL HELIPORTS (Critical Low-Altitude Life Flight Zones) ---
    AirspaceZone(
      id: 'umass_helipad',
      name: 'UMass Memorial Medical Center Helipad',
      code: 'HELI',
      type: AirspaceType.heliport,
      centerLat: 42.2745,
      centerLon: -71.7610,
      radiusMiles: 1.5,
      maxDroneCeilingFt: 150,
      description: 'Active LifeFlight emergency trauma helicopter corridor. Exercise extreme caution.',
    ),
    AirspaceZone(
      id: 'mgh_helipad',
      name: 'Mass General Hospital Helipad',
      code: 'HELI',
      type: AirspaceType.heliport,
      centerLat: 42.3628,
      centerLon: -71.0691,
      radiusMiles: 1.5,
      maxDroneCeilingFt: 0,
      description: 'High-frequency emergency medical helicopter landing zone.',
      isStrictNoFly: true,
    ),
  ];

  static FlightAssessment assessCoordinates({
    required double lat,
    required double lon,
  }) {
    AirspaceZone? limitingZone;
    double? minDistanceMiles;
    int maxCeiling = 400; // Standard FAA Class G legal limit
    FlightStatus status = FlightStatus.clearToFly;
    String headline = 'CLEAR FOR TAKEOFF';
    String explanation =
        'Class G Uncontrolled Airspace. Maximum legal altitude is 400 ft AGL. Maintain visual line-of-sight.';

    final List<MapEntry<AirspaceZone, double>> distanceList = [];

    for (final zone in _airspaces) {
      final distance = _calculateDistanceMiles(lat, lon, zone.centerLat, zone.centerLon);
      distanceList.add(MapEntry(zone, distance));

      // Check if user is currently inside the zone boundary
      if (distance <= zone.radiusMiles) {
        if (zone.isStrictNoFly || zone.maxDroneCeilingFt == 0) {
          status = FlightStatus.restrictedNoFly;
          limitingZone = zone;
          minDistanceMiles = distance;
          maxCeiling = 0;
          headline = 'RESTRICTED / NO-FLY ZONE';
          explanation =
              'You are within the active boundary of ${zone.name}. Ground operations and drone flight are legally prohibited without LAANC/FAA authorization.';
          break; // Hard restriction, cannot fly
        } else if (zone.maxDroneCeilingFt < maxCeiling) {
          status = FlightStatus.advisoryCaution;
          limitingZone = zone;
          minDistanceMiles = distance;
          maxCeiling = zone.maxDroneCeilingFt;
          headline = 'REDUCED CEILING ADVISORY';
          explanation =
              'You are within the proximity of ${zone.name}. Ceiling is restricted to $maxCeiling ft AGL.';
        }
      } else if (distance <= (zone.radiusMiles + 2.5) && status != FlightStatus.restrictedNoFly) {
        // Proximity advisory within 2.5 miles of boundary
        if (status != FlightStatus.advisoryCaution) {
          status = FlightStatus.advisoryCaution;
          limitingZone = zone;
          minDistanceMiles = distance;
          headline = 'CAUTION: ADJACENT AIRSPACE';
          explanation =
              'You are ${distance.toStringAsFixed(1)} miles from ${zone.name}. Watch for low-flying manned aircraft and maintain visual contact.';
        }
      }
    }

    // Sort nearby zones by distance
    distanceList.sort((a, b) => a.value.compareTo(b.value));
    final nearbyZones = distanceList.take(6).map((e) => e.key).toList();

    if (limitingZone == null && distanceList.isNotEmpty) {
      limitingZone = distanceList.first.key;
      minDistanceMiles = distanceList.first.value;
    }

    // Calculate approximate local sunset (FAA Part 107 daylight rule)
    final now = DateTime.now();
    final sunset = DateTime(now.year, now.month, now.day, 18, 15); // Approximate civil sunset

    return FlightAssessment(
      status: status,
      maxAllowedCeilingFt: maxCeiling,
      limitingZone: limitingZone,
      distanceToLimitingZoneMiles: minDistanceMiles,
      nearbyZones: nearbyZones,
      statusHeadline: headline,
      statusExplanation: explanation,
      localSunset: sunset,
    );
  }

  static double _calculateDistanceMiles(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadiusMiles = 3958.8;
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusMiles * c;
  }

  static double _degToRad(double deg) => deg * (pi / 180.0);

  static List<AirspaceZone> getAllAirspaces() => _airspaces;
}
