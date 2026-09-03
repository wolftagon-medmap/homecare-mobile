import 'package:flutter/material.dart';

/// Palette and icon vocabulary for the assistant surface.
///
/// Kept local to the feature: `lib/const.dart` carries a local `BASE_URL`
/// override and is owned elsewhere, so these values cannot land there yet.
class AssistantPalette {
  const AssistantPalette._();

  static const Color primary = Color(0xFF038E9F);
  static const Color navy = Color(0xFF0F3D6E);
  static const Color body = Color(0xFF3C4A63);
  static const Color muted = Color(0xFF7C8AA5);
  static const Color surface = Colors.white;
  static const Color canvas = Color(0xFFFAFCFD);
  static const Color bubble = Color(0xFFF1F3F8);
  static const Color border = Color(0xFFE6ECF2);
  static const Color heroTop = Color(0xFFE4F3F6);
  static const Color heroBottom = Color(0xFFF6FBFC);
  static const Color cardTint = Color(0xFFF2FAFB);

  static const Map<String, Color> _toneForeground = {
    'teal': Color(0xFF0FA3A3),
    'red': Color(0xFFE2574C),
    'purple': Color(0xFF8B5CF6),
    'green': Color(0xFF3FA34D),
    'pink': Color(0xFFE879A6),
    'blue': Color(0xFF4894FE),
    'amber': Color(0xFFF4A62A),
    'grey': Color(0xFF8696BB),
  };

  static const Map<String, Color> _toneBackground = {
    'teal': Color(0xFFE4F5F5),
    'red': Color(0xFFFDEBE9),
    'purple': Color(0xFFF1EBFE),
    'green': Color(0xFFE9F6EA),
    'pink': Color(0xFFFCEBF2),
    'blue': Color(0xFFE9F1FE),
    'amber': Color(0xFFFEF3E2),
    'grey': Color(0xFFEEF1F6),
  };

  static Color foregroundOf(String tone) =>
      _toneForeground[tone] ?? _toneForeground['grey']!;

  static Color backgroundOf(String tone) =>
      _toneBackground[tone] ?? _toneBackground['grey']!;
}

class AssistantIcons {
  const AssistantIcons._();

  static const Map<String, IconData> _icons = {
    'symptom': Icons.thermostat,
    'medication': Icons.medication_outlined,
    'concern': Icons.monitor_heart_outlined,
    'lifestyle': Icons.eco_outlined,
    'stress': Icons.psychology_outlined,
    'results': Icons.description_outlined,
    'someone': Icons.people_outline,
    'other': Icons.more_horiz,
    'issue': Icons.push_pin_outlined,
    'when': Icons.schedule,
    'symptoms': Icons.healing_outlined,
    'history': Icons.medical_information_outlined,
    'for': Icons.person_search_outlined,
    'pharmacy': Icons.medication_liquid_outlined,
    'screening': Icons.assignment_turned_in_outlined,
    'doctor': Icons.medical_services_outlined,
    'services': Icons.grid_view_rounded,
    'save': Icons.bookmark_border,
    'ask': Icons.chat_bubble_outline,
  };

  static IconData of(String key) => _icons[key] ?? Icons.help_outline;
}

class ToneIcon extends StatelessWidget {
  final String icon;
  final String tone;
  final double size;
  final bool rounded;

  const ToneIcon({
    super.key,
    required this.icon,
    required this.tone,
    this.size = 36,
    this.rounded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AssistantPalette.backgroundOf(tone),
        borderRadius: BorderRadius.circular(rounded ? size / 4 : size / 2),
      ),
      child: Icon(
        AssistantIcons.of(icon),
        size: size * 0.52,
        color: AssistantPalette.foregroundOf(tone),
      ),
    );
  }
}
