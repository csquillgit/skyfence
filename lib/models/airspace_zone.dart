enum AirspaceType {
  classB,        // Major commercial airport (e.g. Boston Logan BOS)
  classC,        // Regional airport with radar control (e.g. Manchester MHT, Providence PVD)
  classD,        // Controlled tower airport (e.g. Worcester ORH, Bedford BED, Norwood OWD)
  nationalPark,  // National Parks / Wildlife Refuges (NPS 36 CFR 1.5 drone ban)
  heliport,      // Hospital / Private Helipad
  militaryMOA,   // Military Operations Area / Restricted
}

class AirspaceZone {
  final String id;
  final String name;
  final String code; // e.g. "BOS", "ORH"
  final AirspaceType type;
  final double centerLat;
  final double centerLon;
  final double radiusMiles; // Controlled radius
  final int maxDroneCeilingFt; // Allowed drone ceiling (0 = No Fly, 100, 200, 400)
  final String description;
  final bool isStrictNoFly;

  const AirspaceZone({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    required this.centerLat,
    required this.centerLon,
    required this.radiusMiles,
    required this.maxDroneCeilingFt,
    required this.description,
    this.isStrictNoFly = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'type': type.name,
      'centerLat': centerLat,
      'centerLon': centerLon,
      'radiusMiles': radiusMiles,
      'maxDroneCeilingFt': maxDroneCeilingFt,
      'description': description,
      'isStrictNoFly': isStrictNoFly,
    };
  }

  factory AirspaceZone.fromMap(Map<String, dynamic> map) {
    return AirspaceZone(
      id: map['id'] as String,
      name: map['name'] as String,
      code: map['code'] as String,
      type: AirspaceType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => AirspaceType.classD,
      ),
      centerLat: (map['centerLat'] as num).toDouble(),
      centerLon: (map['centerLon'] as num).toDouble(),
      radiusMiles: (map['radiusMiles'] as num).toDouble(),
      maxDroneCeilingFt: (map['maxDroneCeilingFt'] as num).toInt(),
      description: map['description'] as String,
      isStrictNoFly: map['isStrictNoFly'] as bool? ?? false,
    );
  }
}
