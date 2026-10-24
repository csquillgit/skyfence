import 'package:flutter/material.dart';
import '../models/airspace_zone.dart';

class AirspaceCard extends StatelessWidget {
  final AirspaceZone zone;
  final double? distanceMiles;

  const AirspaceCard({
    super.key,
    required this.zone,
    this.distanceMiles,
  });

  @override
  Widget build(BuildContext context) {
    final Color tagColor;
    final String typeLabel;

    switch (zone.type) {
      case AirspaceType.classB:
        tagColor = const Color(0xFFEF4444); // Red
        typeLabel = 'CLASS B';
        break;
      case AirspaceType.classC:
        tagColor = const Color(0xFFF97316); // Orange
        typeLabel = 'CLASS C';
        break;
      case AirspaceType.classD:
        tagColor = const Color(0xFFF59E0B); // Amber
        typeLabel = 'CLASS D';
        break;
      case AirspaceType.nationalPark:
        tagColor = const Color(0xFF10B981); // Emerald
        typeLabel = 'NPS PARK';
        break;
      case AirspaceType.heliport:
        tagColor = const Color(0xFF38BDF8); // Cyan
        typeLabel = 'HELIPORT';
        break;
      case AirspaceType.militaryMOA:
        tagColor = const Color(0xFFA855F7); // Purple
        typeLabel = 'MILITARY';
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon badge
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: tagColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: tagColor.withOpacity(0.4)),
            ),
            child: Icon(
              zone.type == AirspaceType.heliport
                  ? Icons.local_hospital_rounded
                  : zone.type == AirspaceType.nationalPark
                      ? Icons.park_rounded
                      : Icons.flight_takeoff_rounded,
              color: tagColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Type Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: tagColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        typeLabel,
                        style: TextStyle(
                          color: tagColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),

                    // Distance
                    if (distanceMiles != null)
                      Text(
                        '${distanceMiles!.toStringAsFixed(1)} mi away',
                        style: const TextStyle(
                          color: Color(0xFF38BDF8),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 5),

                Text(
                  zone.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),

                Text(
                  zone.description,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),

                // Legal ceiling limit line
                Row(
                  children: [
                    Icon(
                      zone.maxDroneCeilingFt == 0
                          ? Icons.block_rounded
                          : Icons.arrow_upward_rounded,
                      color: zone.maxDroneCeilingFt == 0
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF10B981),
                      size: 13,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      zone.maxDroneCeilingFt == 0
                          ? 'Strict 0 FT (No-Fly Zone)'
                          : 'Max Drone Ceiling: ${zone.maxDroneCeilingFt} FT AGL',
                      style: TextStyle(
                        color: zone.maxDroneCeilingFt == 0
                            ? const Color(0xFFEF4444)
                            : const Color(0xFF10B981),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
