import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/github_snake_matrix.dart';
import '../data/portfolio_data.dart';
import '../models/portfolio_data.dart';
import '../services/blog_service.dart';
import 'blog_detail_screen.dart';

class HomeTab extends StatelessWidget {
  final VoidCallback onNavigateToBlogs;
  final VoidCallback onNavigateToProjects;
  final VoidCallback onNavigateToResume;

  const HomeTab({
    super.key,
    required this.onNavigateToBlogs,
    required this.onNavigateToProjects,
    required this.onNavigateToResume,
  });

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
                // 1. HERO ARCHITECT CARD
                _buildHeroCard(context, isMobile, isDark, primary),

                const SizedBox(height: 20),

                // 2. KEY METRICS MATRIX
                _buildMetricsRow(context, isMobile, isDark, primary),

                const SizedBox(height: 24),

                // 3. GITHUB ACTIVITY & INTERACTIVE SNAKE MATRIX (MOTION FUN TWIST)
                const GithubSnakeMatrix().animate().fadeIn(delay: 200.ms, duration: 400.ms),

                const SizedBox(height: 24),

                // 4. SKILLS & ARCHITECTURE TOOLCHAIN
                _buildSkillsMatrix(context, isMobile, isDark, primary),

                const SizedBox(height: 24),

                // 5. LATEST ARCHITECTURAL LOGS / BLOG TEASER
                _buildBlogTeaser(context, isMobile, isDark, primary),

                const SizedBox(height: 24),

                // 6. QUICK CONNECT BANNER
                _buildConnectBanner(context, isMobile, isDark, primary),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context, bool isMobile, bool isDark, Color primary) {
    final data = portfolioData;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 18 : 28),
        child: Column(
          children: [
            if (!isMobile)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar with Cyber Glow Ring
                  _buildProfileAvatar(150, isDark, primary),
                  const SizedBox(width: 28),
                  // Bio Details
                  Expanded(
                    child: _buildHeroBioContent(context, data, isDark, primary),
                  ),
                ],
              )
            else
              Column(
                children: [
                  _buildProfileAvatar(125, isDark, primary),
                  const SizedBox(height: 18),
                  _buildHeroBioContent(context, data, isDark, primary, isCentered: true),
                ],
              ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.05);
  }

  Widget _buildProfileAvatar(double size, bool isDark, Color primary) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer pulsing ring
        Container(
          width: size + 16,
          height: size + 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(
              colors: [
                primary,
                AppColors.secondary,
                AppColors.accentNeon,
                primary,
              ],
            ),
          ),
        ),
        // Inner gap
        Container(
          width: size + 8,
          height: size + 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
          ),
        ),
        // Photo
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: const DecorationImage(
              image: AssetImage('assets/images/profile.png'),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(0.35),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeroBioContent(
    BuildContext context,
    Person data,
    bool isDark,
    Color primary, {
    bool isCentered = false,
  }) {
    return Column(
      crossAxisAlignment: isCentered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // Availability Status Pill
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
              Flexible(
                child: Text(
                  'Open to System Architecture & Mobile Roles',
                  style: const TextStyle(
                    color: AppColors.success,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Name
        Text(
          data.name,
          textAlign: isCentered ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.spaceGrotesk(
            fontSize: isCentered ? 26 : 32,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),

        // Animated Typewriter Role
        SizedBox(
          height: 24,
          child: DefaultTextStyle(
            style: GoogleFonts.spaceGrotesk(
              fontSize: isCentered ? 15 : 17,
              fontWeight: FontWeight.w600,
              color: primary,
            ),
            textAlign: isCentered ? TextAlign.center : TextAlign.start,
            child: AnimatedTextKit(
              repeatForever: true,
              animatedTexts: [
                TypewriterAnimatedText(
                  'Senior Lead Architect',
                  speed: const Duration(milliseconds: 70),
                ),
                TypewriterAnimatedText(
                  'Android Native & KMP Expert',
                  speed: const Duration(milliseconds: 70),
                ),
                TypewriterAnimatedText(
                  'Flutter & Impeller Specialist',
                  speed: const Duration(milliseconds: 70),
                ),
                TypewriterAnimatedText(
                  'Agentic AI & MCP Engineer',
                  speed: const Duration(milliseconds: 70),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Summary
        Text(
          data.summary,
          textAlign: isCentered ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            fontSize: 13,
            height: 1.55,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 16),

        // Action Buttons
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: isCentered ? WrapAlignment.center : WrapAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: onNavigateToProjects,
              icon: const Icon(Icons.layers_rounded, size: 15),
              label: const Text('Explore Projects'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.black,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            OutlinedButton.icon(
              onPressed: onNavigateToBlogs,
              icon: const Icon(Icons.article_outlined, size: 15),
              label: const Text('Read Tech Logs'),
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? Colors.white : AppColors.lightTextPrimary,
                side: BorderSide(color: isDark ? AppColors.darkBorderLight : AppColors.lightBorder),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            IconButton(
              tooltip: 'LinkedIn',
              icon: const Icon(Icons.business_center_rounded, size: 20),
              color: primary,
              onPressed: () => _launchUrl('https://linkedin.com/in/govindtank'),
            ),
            IconButton(
              tooltip: 'GitHub',
              icon: const Icon(Icons.code_rounded, size: 20),
              color: primary,
              onPressed: () => _launchUrl('https://github.com/govindtank'),
            ),
            IconButton(
              tooltip: 'Resume',
              icon: const Icon(Icons.description_outlined, size: 20),
              color: primary,
              onPressed: onNavigateToResume,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricsRow(BuildContext context, bool isMobile, bool isDark, Color primary) {
    final metrics = [
      {'val': '9+ Yrs', 'label': 'Experience', 'icon': Icons.trending_up_rounded},
      {'val': '100k+', 'label': 'Active Users', 'icon': Icons.people_alt_rounded},
      {'val': '99.95%', 'label': 'Crash-Free', 'icon': Icons.security_rounded},
      {'val': '110+', 'label': 'Tech Blogs', 'icon': Icons.menu_book_rounded},
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: metrics.map((m) {
            final cardWidth = constraints.maxWidth > 700
                ? (constraints.maxWidth - 30) / 4
                : (constraints.maxWidth > 320 ? (constraints.maxWidth - 10) / 2 : constraints.maxWidth);

            return Container(
              width: cardWidth,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(m['icon'] as IconData, color: primary, size: 20),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      m['val'] as String,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    m['label'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    ).animate().fadeIn(delay: 150.ms, duration: 400.ms);
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
                onPressed: onNavigateToBlogs,
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
