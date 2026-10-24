import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/flight_log.dart';

class FlightLogService extends ChangeNotifier {
  static const String _logKey = 'skyfence_flight_logs_v1';
  final SharedPreferences _prefs;

  FlightLogService(this._prefs) {
    _ensureInitialSamples();
  }

  static Future<FlightLogService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return FlightLogService(prefs);
  }

  List<FlightLog> getLogs() {
    final raw = _prefs.getString(_logKey);
    if (raw == null || raw.isEmpty) return [];

    try {
      final List<dynamic> decoded = json.decode(raw) as List<dynamic>;
      final list = decoded
          .map((item) => FlightLog.fromMap(item as Map<String, dynamic>))
          .toList();
      list.sort((a, b) => b.date.compareTo(a.date));
      return list;
    } catch (_) {
      return [];
    }
  }

  Future<void> addLog(FlightLog log) async {
    final list = getLogs();
    list.removeWhere((item) => item.id == log.id);
    list.insert(0, log);
    await _save(list);
    notifyListeners();
  }

  Future<void> deleteLog(String id) async {
    final list = getLogs();
    list.removeWhere((item) => item.id == id);
    await _save(list);
    notifyListeners();
  }

  Future<void> _save(List<FlightLog> list) async {
    final jsonList = list.map((e) => e.toMap()).toList();
    await _prefs.setString(_logKey, json.encode(jsonList));
  }

  void _ensureInitialSamples() {
    if (_prefs.containsKey(_logKey)) return;

    final samples = [
      FlightLog(
        id: 'flight_1',
        title: 'Wachusett Reservoir Sunset Shoot',
        latitude: 42.3820,
        longitude: -71.7210,
        date: DateTime.now().subtract(const Duration(days: 2)),
        droneModel: 'DJI Mini 4 Pro',
        durationMinutes: 24,
        maxAltitudeFt: 380,
        notes: 'Class G airspace. Calm 4mph winds. Captured panoramic autumn foliage.',
      ),
      FlightLog(
        id: 'flight_2',
        title: 'Lake Quinsigamond Practice Grid',
        latitude: 42.2780,
        longitude: -71.7480,
        date: DateTime.now().subtract(const Duration(days: 6)),
        droneModel: 'DJI Air 3',
        durationMinutes: 18,
        maxAltitudeFt: 250,
        notes: 'Advisory zone: LifeFlight corridor caution maintained below 300ft.',
      ),
    ];

    _save(samples);
  }
}
