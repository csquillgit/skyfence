import 'package:flutter/material.dart';
import '../models/flight_assessment.dart';

class StatusBanner extends StatelessWidget {
  final FlightAssessment assessment;

  const StatusBanner({
    super.key,
    required this.assessment,
  });

  @override
  Widget build(BuildContext context) {
    final Color color;
    final IconData icon;

    switch (assessment.status) {
      case FlightStatus.clearToFly:
        color = const Color(0xFF10B981); // Emerald Green
        icon = Icons.check_circle_rounded;
        break;
      case FlightStatus.advisoryCaution:
        color = const Color(0xFFF59E0B); // Amber
        icon = Icons.warning_amber_rounded;
        break;
      case FlightStatus.restrictedNoFly:
      default:
        color = const Color(0xFFEF4444); // Crimson Red
        icon = Icons.do_not_disturb_on_rounded;
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          assessment.status == FlightStatus.clearToFly
                              ? 'FAA ADVISOR: CLEAR'
                              : assessment.status == FlightStatus.advisoryCaution
                                  ? 'FAA ADVISOR: CAUTION'
                                  : 'FAA ADVISOR: RESTRICTED',
                          style: TextStyle(
                            color: color,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      assessment.statusHeadline,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            assessment.statusExplanation,
            style: const TextStyle(
              color: Color(0xFFCBD5E1),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
