import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true; // Dark mode by default for professional techy aesthetic
  String _accentName = 'Cyber Sky';

  bool get isDarkMode => _isDarkMode;
  String get accentName => _accentName;

  // Map of techy accent presets
  static const Map<String, Color> accentColors = {
    'Cyber Sky': Color(0xFF38BDF8),
    'Neon Cyan': Color(0xFF00E5FF),
    'Electric Indigo': Color(0xFF6366F1),
    'Matrix Emerald': Color(0xFF10B981),
    'Solar Amber': Color(0xFFF59E0B),
  };

  Color get accentColor => accentColors[_accentName] ?? accentColors['Cyber Sky']!;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setDarkMode(bool value) {
    if (_isDarkMode != value) {
      _isDarkMode = value;
      notifyListeners();
    }
  }

  void setAccent(String name) {
    if (accentColors.containsKey(name) && _accentName != name) {
      _accentName = name;
      notifyListeners();
    }
  }
}
