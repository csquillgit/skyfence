import 'package:flutter/material.dart';
import '../services/flight_log_service.dart';
import '../widgets/tactical_legal_sheet.dart';
import 'airspaces_screen.dart';
import 'checklist_screen.dart';
import 'guide_screen.dart';
import 'radar_screen.dart';

class HomeScreen extends StatefulWidget {
  final FlightLogService logService;

  const HomeScreen({
    super.key,
    required this.logService,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TacticalLegalSheet.checkFirstRun(context, skyFenceLegal);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const RadarScreen(),
          const AirspacesScreen(),
          ChecklistScreen(logService: widget.logService),
          const GuideScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0F172A),
          border: Border(
            top: BorderSide(color: Color(0xFF1E293B), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFF38BDF8), // Electric Cyan
          unselectedItemColor: const Color(0xFF64748B),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.radar_rounded),
              activeIcon: Icon(Icons.radar_rounded, size: 26),
              label: 'Advisor',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.flight_takeoff_rounded),
              activeIcon: Icon(Icons.flight_takeoff_rounded, size: 26),
              label: 'Airspaces',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.checklist_rounded),
              activeIcon: Icon(Icons.checklist_rounded, size: 26),
              label: 'Checklist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              activeIcon: Icon(Icons.menu_book_rounded, size: 26),
              label: 'Guide',
            ),
          ],
        ),
      ),
    );
  }
}
