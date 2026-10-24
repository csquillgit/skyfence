import 'package:flutter/material.dart';
import '../models/airspace_zone.dart';
import '../services/airspace_engine.dart';
import '../widgets/airspace_card.dart';

class AirspacesScreen extends StatefulWidget {
  const AirspacesScreen({super.key});

  @override
  State<AirspacesScreen> createState() => _AirspacesScreenState();
}

class _AirspacesScreenState extends State<AirspacesScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All'; // 'All', 'Class B', 'Class C/D', 'Parks', 'Heliports'

  List<AirspaceZone> _getFiltered() {
    final all = AirspaceEngine.getAllAirspaces();
    return all.where((z) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchName = z.name.toLowerCase().contains(q);
        final matchCode = z.code.toLowerCase().contains(q);
        if (!matchName && !matchCode) return false;
      }

      if (_selectedFilter == 'Class B') {
        return z.type == AirspaceType.classB;
      } else if (_selectedFilter == 'Class C/D') {
        return z.type == AirspaceType.classC || z.type == AirspaceType.classD;
      } else if (_selectedFilter == 'Parks') {
        return z.type == AirspaceType.nationalPark;
      } else if (_selectedFilter == 'Heliports') {
        return z.type == AirspaceType.heliport;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _getFiltered();

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'AIRSPACE DIRECTORY',
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
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              style: const TextStyle(color: Colors.white, fontSize: 14),
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1E293B),
                hintText: 'Search by airport code (BOS, ORH) or name...',
                hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 20),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFF334155)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFF334155)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFF38BDF8), width: 1.5),
                ),
              ),
            ),
          ),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                _buildFilterChip('All'),
                _buildFilterChip('Class B'),
                _buildFilterChip('Class C/D'),
                _buildFilterChip('Parks'),
                _buildFilterChip('Heliports'),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // List
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      'No matching airspaces found',
                      style: TextStyle(color: Color(0xFF64748B)),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 84),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return AirspaceCard(zone: filtered[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => setState(() => _selectedFilter = label),
        selectedColor: const Color(0xFF38BDF8),
        backgroundColor: const Color(0xFF1E293B),
        labelStyle: TextStyle(
          color: isSelected ? Colors.black : const Color(0xFF94A3B8),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        side: BorderSide(
          color: isSelected ? const Color(0xFF38BDF8) : const Color(0xFF334155),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
