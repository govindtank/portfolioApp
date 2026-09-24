import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class SystemArchitectureDiagram extends StatefulWidget {
  const SystemArchitectureDiagram({super.key});

  @override
  State<SystemArchitectureDiagram> createState() => _SystemArchitectureDiagramState();
}

class _SystemArchitectureDiagramState extends State<SystemArchitectureDiagram> {
  int _selectedNodeIndex = 0;

  final List<Map<String, dynamic>> _nodes = [
    {
      'title': 'UI & GPU Layer',
      'tag': 'IMPELLER / VULKAN',
      'icon': Icons.layers_rounded,
      'color': Color(0xFF0EA5E9),
      'headline': 'High-Performance 60/120 FPS Rendering',
      'details': 'Jetpack Compose & Flutter Impeller engine with Vulkan/Metal backend. Zero jank, sub-16ms frame times, and native Material You dynamic fidelity.',
      'techs': ['Flutter Impeller', 'Jetpack Compose', 'Vulkan/Metal', '60 FPS SLA'],
    },
    {
      'title': 'Domain & Reactive Core',
      'tag': 'MVI / CLEAN ARCH',
      'icon': Icons.hub_rounded,
      'color': Color(0xFF6366F1),
      'headline': 'Deterministic State & Business Logic',
      'details': 'Unidirectional data flow (MVI/BLoC) with Kotlin Coroutines and StateFlow. 100% pure shared logic ready for Kotlin Multiplatform (KMP).',
      'techs': ['Clean Architecture', 'MVI / BLoC', 'Kotlin StateFlow', 'KMP Shared'],
    },
    {
      'title': 'Data & NDK Engine',
      'tag': 'ROOM / C++ JNI',
      'icon': Icons.memory_rounded,
      'color': Color(0xFF10B981),
      'headline': 'Local-First Resiliency & 16KB Page Safe',
      'details': 'Room DB with SQLite WAL, encrypted SQLCipher, C++ NDK signal processing bridges, and 16KB page-size alignment for Android 15/16.',
      'techs': ['Room DB SQLite', 'C++ JNI NDK', '16KB Page Safe', 'Offline First'],
    },
    {
      'title': 'On-Device AI / ML',
      'tag': 'EDGE TFLITE / MCP',
      'icon': Icons.psychology_rounded,
      'color': Color(0xFFF59E0B),
      'headline': 'Sub-100ms On-Device Intelligence',
      'details': 'Quantized TFLite vision models (v9 opcodes), ML Kit EMA bounding box smoothing, and Agentic MCP tool-calling servers.',
      'techs': ['TFLite NPU', 'ML Kit Vision', 'Gemini Nano', 'MCP Agents'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 700;
    final selectedNode = _nodes[_selectedNodeIndex];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A).withOpacity(0.85) : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.06),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.all(isMobile ? 16 : 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.architecture_rounded, color: primary, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Interactive Architecture Blueprint',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: isMobile ? 15 : 18,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primary.withOpacity(0.3)),
                ),
                child: Text(
                  'TAP TO INSPECT',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: primary,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Interactive Node Pipeline (Step Selector)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _nodes.asMap().entries.map((entry) {
                final idx = entry.key;
                final node = entry.value;
                final isSelected = _selectedNodeIndex == idx;
                final nodeColor = node['color'] as Color;

                return GestureDetector(
                  onTap: () => setState(() => _selectedNodeIndex = idx),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? nodeColor.withOpacity(0.18)
                          : (isDark ? const Color(0xFF1E293B).withOpacity(0.6) : const Color(0xFFF1F5F9)),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? nodeColor : (isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05)),
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: nodeColor.withOpacity(0.25),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              )
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          node['icon'] as IconData,
                          size: 16,
                          color: isSelected ? nodeColor : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              node['title'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                color: isSelected
                                    ? (isDark ? Colors.white : Colors.black)
                                    : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                              ),
                            ),
                            Text(
                              node['tag'] as String,
                              style: GoogleFonts.firaCode(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? nodeColor : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Selected Node Detail Card
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Container(
              key: ValueKey<int>(_selectedNodeIndex),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B).withOpacity(0.8) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: (selectedNode['color'] as Color).withOpacity(0.35),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selectedNode['color'] as Color,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          selectedNode['headline'] as String,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    selectedNode['details'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: (selectedNode['techs'] as List<String>).map((t) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: (selectedNode['color'] as Color).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: (selectedNode['color'] as Color).withOpacity(0.25)),
                        ),
                        child: Text(
                          t,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: selectedNode['color'] as Color,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 150.ms, duration: 400.ms);
  }
}
