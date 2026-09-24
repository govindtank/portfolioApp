import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/github_snake_matrix.dart';
import '../core/widgets/system_architecture_diagram.dart';
import '../data/portfolio_data.dart';
import '../models/portfolio_data.dart';
import '../services/blog_service.dart';
import '../services/visitor_counter_service.dart';
import 'blog_detail_screen.dart';

class HomeTab extends StatefulWidget {
  final VoidCallback onNavigateToBlogs;
  final VoidCallback onNavigateToProjects;
  final VoidCallback onNavigateToResume;

  const HomeTab({
    super.key,
    required this.onNavigateToBlogs,
    required this.onNavigateToProjects,
    required this.onNavigateToResume,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final VisitorCounterService _visitorService = VisitorCounterService();
  int _liveVisitorCount = 0;
  bool _isLoadingCount = true;

  @override
  void initState() {
    super.initState();
    _fetchTelemetry();
  }

  Future<void> _fetchTelemetry() async {
    final count = await _visitorService.getVisitorCount();
    if (mounted) {
      setState(() {
        _liveVisitorCount = count;
        _isLoadingCount = false;
      });
    }
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Error launching $url: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 700;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 28,
          vertical: 20,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1040),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. COMMAND CENTER STATUS HUD
                _buildStatusHUD(context, isMobile, isDark, primary),

                const SizedBox(height: 24),

                // 2. INTERACTIVE ARCHITECTURE BLUEPRINT (CUSTOM CANVAS NODE DIAGRAM)
                const SystemArchitectureDiagram(),

                const SizedBox(height: 24),

                // 3. GITHUB ACTIVITY & INTERACTIVE SNAKE MATRIX
                const GithubSnakeMatrix().animate().fadeIn(delay: 200.ms, duration: 400.ms),

                const SizedBox(height: 24),

                // 4. CORE ARCHITECTURAL COMPETENCIES & TOOLCHAINS
                _buildSkillsMatrix(context, isMobile, isDark, primary),

                const SizedBox(height: 24),

                // 5. LATEST ARCHITECTURAL DEEP DIVES
                _buildBlogTeaser(context, isMobile, isDark, primary),

                const SizedBox(height: 24),

                // 6. QUICK CONNECT BANNER
                _buildConnectBanner(context, isMobile, isDark, primary),

                const SizedBox(height: 120), // Extra space for floating dock
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusHUD(BuildContext context, bool isMobile, bool isDark, Color primary) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A).withOpacity(0.85) : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.06),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 18 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Status & Live Visitor Telemetry Row
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              runSpacing: 8,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.success.withOpacity(0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'OPEN FOR ARCHITECTURE ROLES',
                        style: TextStyle(
                          color: AppColors.success,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),

                // Live Telemetry Visitor Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: primary.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.remove_red_eye_outlined, size: 13, color: primary),
                      const SizedBox(width: 6),
                      _isLoadingCount
                          ? SizedBox(
                              width: 10,
                              height: 10,
                              child: CircularProgressIndicator(strokeWidth: 1.5, color: primary),
                            )
                          : TweenAnimationBuilder<int>(
                              tween: IntTween(begin: 0, end: _liveVisitorCount),
                              duration: const Duration(milliseconds: 1200),
                              curve: Curves.easeOutExpo,
                              builder: (context, val, _) {
                                return Text(
                                  '$val live visits',
                                  style: GoogleFonts.firaCode(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: primary,
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Animated Dual-Tagline Headline
            DefaultTextStyle(
              style: GoogleFonts.spaceGrotesk(
                fontSize: isMobile ? 18 : 22,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                letterSpacing: -0.3,
                height: 1.3,
              ),
              child: AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Architecting High-Performance Mobile Ecosystems & AI Systems.',
                    speed: const Duration(milliseconds: 40),
                  ),
                  TypewriterAnimatedText(
                    'Kotlin Multiplatform • Flutter Impeller • On-Device VLMs & MCP.',
                    speed: const Duration(milliseconds: 40),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // High-Impact Proof Matrix
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildHUDMetricChip('9+ Yrs', 'Experience', Icons.timeline_rounded, primary, isDark),
                _buildHUDMetricChip('100k+', 'Active Users', Icons.group_outlined, primary, isDark),
                _buildHUDMetricChip('99.95%', 'Crash-Free SLA', Icons.shield_outlined, primary, isDark),
                _buildHUDMetricChip('110+', 'Tech Articles', Icons.menu_book_rounded, primary, isDark),
              ],
            ),
            const SizedBox(height: 18),

            // Direct Exploration Actions
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: widget.onNavigateToProjects,
                  icon: const Icon(Icons.rocket_launch_rounded, size: 14),
                  label: const Text('Projects Vault'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: widget.onNavigateToBlogs,
                  icon: const Icon(Icons.auto_stories_rounded, size: 14),
                  label: const Text('Read Deep Dives'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark ? Colors.white : AppColors.lightTextPrimary,
                    side: BorderSide(color: isDark ? AppColors.darkBorderLight : AppColors.lightBorder),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                IconButton(
                  tooltip: 'GitHub',
                  icon: const Icon(Icons.code_rounded, size: 18),
                  color: primary,
                  onPressed: () => _launchUrl('https://github.com/govindtank'),
                ),
                IconButton(
                  tooltip: 'LinkedIn',
                  icon: const Icon(Icons.business_center_rounded, size: 18),
                  color: primary,
                  onPressed: () => _launchUrl('https://linkedin.com/in/govindtank'),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05);
  }

  Widget _buildHUDMetricChip(String val, String label, IconData icon, Color primary, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B).withOpacity(0.7) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: primary),
          const SizedBox(width: 6),
          Text(
            val,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsMatrix(BuildContext context, bool isMobile, bool isDark, Color primary) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      padding: EdgeInsets.all(isMobile ? 16 : 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.terminal_rounded, color: primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Technical Architecture & Toolchains',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...portfolioData.skills.map((skillGroup) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    skillGroup.category,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: skillGroup.items.map((item) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorderLight : AppColors.lightBorder,
                          ),
                        ),
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    ).animate().fadeIn(delay: 250.ms, duration: 400.ms);
  }

  Widget _buildBlogTeaser(BuildContext context, bool isMobile, bool isDark, Color primary) {
    final blogService = BlogService();
    final featured = blogService.cachedPosts.take(2).toList();

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 22),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_stories_rounded, color: primary, size: 20),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Latest Articles',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: isMobile ? 16 : 18,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: widget.onNavigateToBlogs,
                icon: const Icon(Icons.arrow_forward_rounded, size: 13),
                label: const Text('View All'),
                style: TextButton.styleFrom(
                  foregroundColor: primary,
                  padding: EdgeInsets.zero,
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...featured.map((post) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: ListTile(
                dense: isMobile,
                contentPadding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16, vertical: 4),
                title: Text(
                  post.title,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: isMobile ? 13 : 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${post.category} • ${post.readTime} min read',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
                trailing: Icon(Icons.chevron_right, color: primary, size: 18),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BlogDetailScreen(post: post),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    ).animate().fadeIn(delay: 350.ms, duration: 400.ms);
  }

  Widget _buildConnectBanner(BuildContext context, bool isMobile, bool isDark, Color primary) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 18 : 26),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primary.withOpacity(0.15),
            AppColors.secondary.withOpacity(0.12),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: primary.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            'Ready to Build High-Performance Mobile Systems?',
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceGrotesk(
              fontSize: isMobile ? 17 : 20,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Consulting, architectural audits, and full-lifecycle development.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _launchUrl('mailto:govindtank600@gmail.com'),
            icon: const Icon(Icons.email_outlined, size: 15),
            label: Text(isMobile ? 'Email Govind (govindtank600@gmail.com)' : 'Get in Touch (govindtank600@gmail.com)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
              textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 450.ms, duration: 400.ms);
  }
}
