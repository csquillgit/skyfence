import 'package:flutter/material.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'FAA AIRSPACE GUIDE',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 84),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Intro Hero
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.4)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.shield_rounded, color: Color(0xFF38BDF8), size: 22),
                      SizedBox(width: 8),
                      Text(
                        'FAA Drone Operations Guide',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Both recreational flyers (TRUST) and commercial pilots (Part 107) must obey FAA airspace boundaries. SkyFence tracks controlled airspace layers so you never inadvertently violate federal airspace.',
                    style: TextStyle(
                      color: Color(0xFFCBD5E1),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildSectionHeader('AIRSPACE CLASSIFICATIONS'),
            const SizedBox(height: 10),
            _buildAirspaceExplainer(
              type: 'CLASS B',
              title: 'Major International Hubs (e.g. BOS)',
              color: const Color(0xFFEF4444),
              desc: 'Shaped like an inverted wedding cake. From surface to 7,000–10,000ft MSL. Strict 0ft drone limit on surface without automated LAANC authorization.',
            ),
            const SizedBox(height: 8),
            _buildAirspaceExplainer(
              type: 'CLASS C',
              title: 'Regional Jet Ports (e.g. MHT, PVD, BDL)',
              color: const Color(0xFFF97316),
              desc: 'Typically consists of a 5-nautical-mile surface ring up to 4,000ft AGL, and a 10nm outer shelf from 1,200ft to 4,000ft.',
            ),
            const SizedBox(height: 8),
            _buildAirspaceExplainer(
              type: 'CLASS D',
              title: 'Tower-Controlled Local Fields (e.g. ORH, BED, OWD)',
              color: const Color(0xFFF59E0B),
              desc: 'A 4-to-5 nautical-mile cylinder from the surface up to ~2,500ft AGL surrounding airports with an active control tower.',
            ),
            const SizedBox(height: 8),
            _buildAirspaceExplainer(
              type: 'CLASS G',
              title: 'Uncontrolled Airspace',
              color: const Color(0xFF10B981),
              desc: 'Free to fly drones up to 400 ft AGL without air traffic control clearance. Always yield right of way to any manned aircraft.',
            ),
            const SizedBox(height: 24),

            _buildSectionHeader('CRITICAL RULES OF THE SKY'),
            const SizedBox(height: 10),
            _buildRuleCard(
              icon: Icons.height_rounded,
              color: const Color(0xFF38BDF8),
              title: '400 Feet AGL Ceiling',
              desc: 'You can never fly higher than 400 ft above ground level in Class G airspace. If inspecting a structure, Part 107 permits flying 400ft above the top of the structure within a 400ft radius.',
            ),
            const SizedBox(height: 10),
            _buildRuleCard(
              icon: Icons.remove_red_eye_rounded,
              color: const Color(0xFF10B981),
              title: 'Visual Line-of-Sight (VLOS)',
              desc: 'You or a visual observer must be able to see the aircraft with unaided eyesight (goggles or binoculars do not count as VLOS).',
            ),
            const SizedBox(height: 10),
            _buildRuleCard(
              icon: Icons.wb_twilight_rounded,
              color: const Color(0xFFF59E0B),
              title: 'Civil Twilight & Night Flight',
              desc: 'Drones can fly 30 minutes before sunrise and 30 minutes after sunset (civil twilight) and at night ONLY if equipped with anti-collision strobe lighting visible for at least 3 statute miles.',
            ),
            const SizedBox(height: 10),
            _buildRuleCard(
              icon: Icons.park_rounded,
              color: const Color(0xFFEF4444),
              title: 'National Parks & Wildlife Refuges',
              desc: 'Launching, landing, or operating unmanned aircraft on lands administered by the National Park Service (36 CFR 1.5) is strictly prohibited nationwide.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF94A3B8),
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildAirspaceExplainer({
    required String type,
    required String title,
    required Color color,
    required String desc,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  type,
                  style: TextStyle(color: color, fontSize: 10.5, fontWeight: FontWeight.w900),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12, height: 1.35)),
        ],
      ),
    );
  }

  Widget _buildRuleCard({
    required IconData icon,
    required Color color,
    required String title,
    required String desc,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12, height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
