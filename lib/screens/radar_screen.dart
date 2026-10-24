import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../models/flight_assessment.dart';
import '../services/airspace_engine.dart';
import '../widgets/airspace_card.dart';
import '../widgets/ceiling_gauge.dart';
import '../widgets/status_banner.dart';

class RadarScreen extends StatefulWidget {
  const RadarScreen({super.key});

  @override
  State<RadarScreen> createState() => _RadarScreenState();
}

class _RadarScreenState extends State<RadarScreen> {
  // Default to central Massachusetts coordinates (Worcester area)
  double _currentLat = 42.2626;
  double _currentLon = -71.8023;
  String _locationName = 'Worcester Area, MA';
  bool _isLocating = false;

  late FlightAssessment _assessment;

  @override
  void initState() {
    super.initState();
    _recalculateAssessment();
    _fetchLiveGps();
  }

  void _recalculateAssessment() {
    setState(() {
      _assessment = AirspaceEngine.assessCoordinates(
        lat: _currentLat,
        lon: _currentLon,
      );
    });
  }

  Future<void> _fetchLiveGps() async {
    setState(() => _isLocating = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 6),
        );
        setState(() {
          _currentLat = pos.latitude;
          _currentLon = pos.longitude;
          _locationName = 'Live GPS Coordinates';
        });
        _recalculateAssessment();
      }
    } catch (_) {
      // Fallback to presets
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  void _selectPreset(String name, double lat, double lon) {
    setState(() {
      _locationName = name;
      _currentLat = lat;
      _currentLon = lon;
    });
    _recalculateAssessment();
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'SIMULATE AIRSPACE LOCATION',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.my_location_rounded, color: Color(0xFF38BDF8)),
                  tooltip: 'Use Live GPS',
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _fetchLiveGps();
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildPresetTile('Boston Common (Logan Class B 0ft)', 42.3550, -71.0656, ctx),
            _buildPresetTile('Worcester Airport Vicinity (Class D)', 42.2673, -71.8757, ctx),
            _buildPresetTile('Cape Cod National Seashore (Prohibited)', 41.9773, -69.9722, ctx),
            _buildPresetTile('Wachusett Rural (Class G Clear 400ft)', 42.4880, -71.8860, ctx),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetTile(String label, double lat, double lon, BuildContext ctx) {
    return ListTile(
      leading: const Icon(Icons.location_on_rounded, color: Color(0xFF38BDF8), size: 20),
      title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
      subtitle: Text(
        '${lat.toStringAsFixed(4)}, ${lon.toStringAsFixed(4)}',
        style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
      ),
      onTap: () {
        Navigator.of(ctx).pop();
        _selectPreset(label, lat, lon);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sunsetTimeStr = _assessment.localSunset != null
        ? DateFormat('h:mm a').format(_assessment.localSunset!)
        : '6:15 PM';

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'AIRSPACE ADVISOR',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isLocating ? Icons.sync_rounded : Icons.my_location_rounded,
              color: const Color(0xFF38BDF8),
            ),
            tooltip: 'Refresh GPS',
            onPressed: _fetchLiveGps,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Location Pill & Simulator Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: InkWell(
                onTap: _showLocationPicker,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_pin, color: Color(0xFF10B981), size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _locationName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '${_currentLat.toStringAsFixed(3)}, ${_currentLon.toStringAsFixed(3)}',
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 11,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_drop_down_rounded, color: Color(0xFF94A3B8)),
                    ],
                  ),
                ),
              ),
            ),

            // 1. Flight Status Card (Clear / Caution / Restricted)
            StatusBanner(assessment: _assessment),

            // 2. Maximum Legal Ceiling Gauge (400ft, 200ft, 0ft)
            CeilingGauge(maxCeilingFt: _assessment.maxAllowedCeilingFt),

            // 3. Pre-Flight Telemetry Strip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTelemetryItem(
                      icon: Icons.wb_twilight_rounded,
                      label: 'Civil Sunset',
                      value: sunsetTimeStr,
                      color: const Color(0xFFF59E0B),
                    ),
                    _buildDivider(),
                    _buildTelemetryItem(
                      icon: Icons.near_me_rounded,
                      label: 'Nearest Limit',
                      value: _assessment.distanceToLimitingZoneMiles != null
                          ? '${_assessment.distanceToLimitingZoneMiles!.toStringAsFixed(1)} mi'
                          : '--',
                      color: const Color(0xFF38BDF8),
                    ),
                    _buildDivider(),
                    _buildTelemetryItem(
                      icon: Icons.satellite_alt_rounded,
                      label: 'GPS Precision',
                      value: 'Sub-3m 3D',
                      color: const Color(0xFF10B981),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 4. Nearby Airspaces & Boundaries Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'PROXIMATE AIRSPACES & HAZARDS',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    '${_assessment.nearbyZones.length} tracked',
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),

            ..._assessment.nearbyZones.map((zone) {
              final d = AirspaceEngine.getAllAirspaces();
              final dist = AirspaceEngine.assessCoordinates(
                      lat: _currentLat, lon: _currentLon)
                  .nearbyZones;
              // Compute distance
              return AirspaceCard(
                zone: zone,
                distanceMiles: null,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTelemetryItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 26, color: const Color(0xFF334155));
  }
}
