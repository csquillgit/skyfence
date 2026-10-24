import 'dart:math';
import 'package:flutter/material.dart';

class CeilingGauge extends StatelessWidget {
  final int maxCeilingFt;

  const CeilingGauge({
    super.key,
    required this.maxCeilingFt,
  });

  @override
  Widget build(BuildContext context) {
    final isGrounded = maxCeilingFt == 0;
    final color = isGrounded
        ? const Color(0xFFEF4444)
        : maxCeilingFt < 400
            ? const Color(0xFFF59E0B)
            : const Color(0xFF38BDF8);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        children: [
          // Tactical Arc Gauge
          SizedBox(
            width: 100,
            height: 100,
            child: CustomPaint(
              painter: _GaugePainter(
                ceilingFt: maxCeilingFt,
                gaugeColor: color,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$maxCeilingFt',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                      ),
                    ),
                    Text(
                      'FT AGL',
                      style: TextStyle(
                        color: color,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),

          // Details on right
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.height_rounded, color: Color(0xFF38BDF8), size: 16),
                    const SizedBox(width: 6),
                    const Text(
                      'LEGAL DRONE CEILING',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  isGrounded
                      ? 'GROUNDED • 0 FT'
                      : '$maxCeilingFt FEET MAXIMUM',
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isGrounded
                      ? 'No drone flight permitted without prior FAA Part 107 authorization.'
                      : maxCeilingFt == 400
                          ? 'Standard FAA maximum altitude for uncontrolled airspace.'
                          : 'Reduced altitude limit due to proximity to airport approach corridor.',
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final int ceilingFt;
  final Color gaugeColor;

  _GaugePainter({
    required this.ceilingFt,
    required this.gaugeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = size.width / 2 - 8;

    const startAngle = 135 * (pi / 180.0);
    const sweepTotalAngle = 270 * (pi / 180.0);

    // Background track
    final trackPaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: radius),
      startAngle,
      sweepTotalAngle,
      false,
      trackPaint,
    );

    // Active progress arc
    final progress = (ceilingFt / 400.0).clamp(0.0, 1.0);
    final activePaint = Paint()
      ..color = gaugeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;

    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: radius),
        startAngle,
        sweepTotalAngle * progress,
        false,
        activePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.ceilingFt != ceilingFt || oldDelegate.gaugeColor != gaugeColor;
  }
}
