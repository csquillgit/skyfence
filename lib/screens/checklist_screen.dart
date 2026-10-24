import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/flight_log.dart';
import '../services/flight_log_service.dart';

class ChecklistScreen extends StatefulWidget {
  final FlightLogService logService;

  const ChecklistScreen({
    super.key,
    required this.logService,
  });

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  int _tabIndex = 0; // 0 = Checklist, 1 = Flight Log

  // Checklist state
  final Map<int, bool> _checked = {
    0: false,
    1: false,
    2: false,
    3: false,
    4: false,
    5: false,
    6: false,
  };

  static const List<Map<String, String>> _checklistItems = [
    {
      'title': 'Propellers & Motor Arms',
      'desc': 'Props undamaged, free of micro-cracks, securely locked.',
    },
    {
      'title': 'Flight Battery & Cell Voltage',
      'desc': 'Battery charged above 90%, cell delta under 0.03V.',
    },
    {
      'title': 'Return-to-Home (RTH) Altitude',
      'desc': 'RTH altitude configured higher than surrounding obstacles/trees.',
    },
    {
      'title': 'Compass & GPS Satellites',
      'desc': 'Strong 3D GPS lock (10+ satellites), compass calibrated.',
    },
    {
      'title': 'MicroSD Storage & Camera',
      'desc': 'Card inserted, space available, gimbal cover removed.',
    },
    {
      'title': 'Airspace & Ceiling Verification',
      'desc': 'Confirm active ceiling limit in SkyFence (Max 400ft AGL).',
    },
    {
      'title': 'Visual Line-of-Sight & Weather',
      'desc': 'Clear flight path, wind under limits, no manned aircraft nearby.',
    },
  ];

  @override
  void initState() {
    super.initState();
    widget.logService.addListener(_onLogsChanged);
  }

  @override
  void dispose() {
    widget.logService.removeListener(_onLogsChanged);
    super.dispose();
  }

  void _onLogsChanged() {
    if (mounted) setState(() {});
  }

  void _showAddLogDialog() {
    final titleCtrl = TextEditingController();
    final droneCtrl = TextEditingController(text: 'DJI Mini 4 Pro');
    final durationCtrl = TextEditingController(text: '20');
    final altCtrl = TextEditingController(text: '350');
    final notesCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Log Drone Flight',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogField(titleCtrl, 'Flight Title / Spot', 'e.g. Quinsigamond Sunset'),
              const SizedBox(height: 12),
              _buildDialogField(droneCtrl, 'Drone Model', 'e.g. DJI Mini 4 Pro, Air 3'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildDialogField(durationCtrl, 'Duration (Min)', '20', isNum: true),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDialogField(altCtrl, 'Max Alt (FT)', '350', isNum: true),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildDialogField(notesCtrl, 'Notes (Optional)', 'Wind, airspace conditions, etc.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF94A3B8))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.black,
            ),
            onPressed: () async {
              if (titleCtrl.text.trim().isEmpty) return;
              final log = FlightLog(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: titleCtrl.text.trim(),
                latitude: 42.26,
                longitude: -71.80,
                date: DateTime.now(),
                droneModel: droneCtrl.text.trim(),
                durationMinutes: int.tryParse(durationCtrl.text) ?? 15,
                maxAltitudeFt: int.tryParse(altCtrl.text) ?? 300,
                notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
              );
              await widget.logService.addLog(log);
              if (mounted) Navigator.of(ctx).pop();
            },
            child: const Text('Save Log', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogField(TextEditingController ctrl, String label, String hint,
      {bool isNum = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: ctrl,
          keyboardType: isNum ? TextInputType.number : TextInputType.text,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF0F172A),
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF475569), fontSize: 13),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF334155)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF334155)),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _checked.values.where((v) => v).length;
    final totalCount = _checklistItems.length;
    final allComplete = completedCount == totalCount;
    final logs = widget.logService.getLogs();

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'FLIGHT OPERATIONS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            fontSize: 16,
          ),
        ),
      ),
      body: Column(
        children: [
          // Segmented Tab Switcher (Checklist | Logbook)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSegmentButton(
                      'Pre-Flight Checklist',
                      _tabIndex == 0,
                      () => setState(() => _tabIndex = 0),
                    ),
                  ),
                  Expanded(
                    child: _buildSegmentButton(
                      'Flight Logbook',
                      _tabIndex == 1,
                      () => setState(() => _tabIndex = 1),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          Expanded(
            child: _tabIndex == 0
                ? _buildChecklistView(completedCount, totalCount, allComplete)
                : _buildLogbookView(logs),
          ),
        ],
      ),
      floatingActionButton: _tabIndex == 1
          ? FloatingActionButton.extended(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.black,
              onPressed: _showAddLogDialog,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Log Flight', style: TextStyle(fontWeight: FontWeight.bold)),
            )
          : null,
    );
  }

  Widget _buildChecklistView(int completed, int total, bool allDone) {
    return ListView(
      padding: const EdgeInsets.only(top: 4, bottom: 84),
      children: [
        // Status Card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: allDone
                ? const Color(0xFF10B981).withOpacity(0.15)
                : const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: allDone ? const Color(0xFF10B981) : const Color(0xFF334155),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Icon(
                allDone ? Icons.flight_takeoff_rounded : Icons.checklist_rounded,
                color: allDone ? const Color(0xFF10B981) : const Color(0xFF38BDF8),
                size: 28,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      allDone ? 'READY FOR SAFE TAKEOFF' : '$completed of $total Verified',
                      style: TextStyle(
                        color: allDone ? const Color(0xFF10B981) : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      allDone
                          ? 'All pre-flight systems and airspace verifications complete.'
                          : 'Complete all checks before arming drone motors.',
                      style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (completed > 0)
                TextButton(
                  onPressed: () => setState(() => _checked.updateAll((key, val) => false)),
                  child: const Text('Reset', style: TextStyle(color: Color(0xFF94A3B8))),
                ),
            ],
          ),
        ),

        // Checklist Items
        ...List.generate(_checklistItems.length, (i) {
          final item = _checklistItems[i];
          final isChecked = _checked[i] ?? false;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isChecked
                    ? const Color(0xFF10B981).withOpacity(0.4)
                    : const Color(0xFF334155),
              ),
            ),
            child: CheckboxListTile(
              value: isChecked,
              activeColor: const Color(0xFF10B981),
              checkColor: Colors.black,
              onChanged: (val) => setState(() => _checked[i] = val ?? false),
              title: Text(
                item['title']!,
                style: TextStyle(
                  color: isChecked ? const Color(0xFF10B981) : Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              subtitle: Text(
                item['desc']!,
                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildLogbookView(List<FlightLog> logs) {
    if (logs.isEmpty) {
      return const Center(
        child: Text(
          'No flights logged yet.\nTap below to record your first flight.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF64748B)),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 4, bottom: 84),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        final dateStr = DateFormat('MMM d, yyyy • h:mm a').format(log.date);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      log.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF94A3B8), size: 18),
                    color: const Color(0xFF1E293B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFF334155)),
                    ),
                    onSelected: (val) {
                      if (val == 'delete') widget.logService.deleteLog(log.id);
                    },
                    itemBuilder: (ctx) => const [
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444), size: 18),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Color(0xFFEF4444))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${log.droneModel} • $dateStr',
                style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 12),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildLogMetric('Duration', '${log.durationMinutes} min', const Color(0xFF10B981)),
                  const SizedBox(width: 14),
                  _buildLogMetric('Max Altitude', '${log.maxAltitudeFt} FT', const Color(0xFFF59E0B)),
                ],
              ),
              if (log.notes != null) ...[
                const SizedBox(height: 8),
                Text(
                  log.notes!,
                  style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12, height: 1.3),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildLogMetric(String label, String value, Color color) {
    return Row(
      children: [
        Text('$label: ', style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
        Text(value, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSegmentButton(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF38BDF8) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : const Color(0xFF94A3B8),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
