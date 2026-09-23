import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/theme/app_theme.dart';
import '../models/blog_post.dart';
import '../services/blog_service.dart';
import '../services/visitor_counter_service.dart';

class BlogDetailScreen extends StatefulWidget {
  final BlogPost post;

  const BlogDetailScreen({super.key, required this.post});

  @override
  State<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  final BlogService _blogService = BlogService();
  String? _markdownContent;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    VisitorCounterService.trackPageView(
      '/blog/${widget.post.slug}',
      title: widget.post.title,
    );
    _loadContent();
  }

  Future<void> _loadContent() async {
    if (widget.post.content != null && widget.post.content!.isNotEmpty) {
      setState(() {
        _markdownContent = widget.post.content;
        _isLoading = false;
      });
      return;
    }

    final content = await _blogService.fetchPostMarkdown(widget.post.slug);
    if (mounted) {
      setState(() {
        _markdownContent = content;
        _isLoading = false;
      });
    }
  }

  void _openInBrowser() async {
    final uri = Uri.parse(widget.post.webUrl);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch ${widget.post.webUrl}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 700;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: (isDark ? AppColors.darkSurface : AppColors.lightSurface).withOpacity(0.95),
        elevation: 0,
        title: Text(
          widget.post.category,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: primary,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Read on Website (govindtank.github.io)',
            icon: const Icon(Icons.open_in_browser_rounded),
            onPressed: _openInBrowser,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: primary),
                  const SizedBox(height: 16),
                  Text(
                    'Loading article from govindtank.github.io...',
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 24,
                vertical: 20,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 820),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Metadata
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: primary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: primary.withOpacity(0.3)),
                            ),
                            child: Text(
                              widget.post.category,
                              style: TextStyle(
                                color: primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                size: 13,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.post.readTime} min read',
                                style: TextStyle(
                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.post.date,
                                style: TextStyle(
                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Title
                      Text(
                        widget.post.title,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: isMobile ? 22 : 26,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Author Row
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage('assets/images/profile.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Govind Tank',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                ),
                              ),
                              Text(
                                'Senior Lead Architect',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Divider(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      const SizedBox(height: 16),

                      // Markdown Content
                      MarkdownBody(
                        data: _markdownContent ?? '',
                        selectable: true,
                        styleSheet: MarkdownStyleSheet(
                          p: GoogleFonts.inter(
                            fontSize: 14,
                            height: 1.7,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                          h1: GoogleFonts.spaceGrotesk(
                            fontSize: isMobile ? 20 : 22,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            height: 1.4,
                          ),
                          h2: GoogleFonts.spaceGrotesk(
                            fontSize: isMobile ? 17 : 18,
                            fontWeight: FontWeight.w600,
                            color: primary,
                            height: 1.4,
                          ),
                          h3: GoogleFonts.spaceGrotesk(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                          code: GoogleFonts.firaCode(
                            fontSize: 12,
                            color: isDark ? AppColors.accentNeon : AppColors.primaryDark,
                            backgroundColor: isDark ? AppColors.darkSurfaceElevated : const Color(0xFFE2E8F0),
                          ),
                          codeblockPadding: const EdgeInsets.all(14),
                          codeblockDecoration: BoxDecoration(
                            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1),
                            ),
                          ),
                          blockquote: GoogleFonts.inter(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                          blockquoteDecoration: BoxDecoration(
                            color: primary.withOpacity(0.08),
                            border: Border(
                              left: BorderSide(color: primary, width: 3),
                            ),
                          ),
                          listBullet: TextStyle(color: primary),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Footer Card
                      Container(
                        padding: const EdgeInsets.all(18),
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
                            Text(
                              'Enjoyed this deep dive?',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Explore all 110+ technical publications on system architecture, KMP, and on-device AI.',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: _openInBrowser,
                                  icon: const Icon(Icons.open_in_browser_rounded, size: 14),
                                  label: const Text('Read on Web (govindtank.github.io)'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primary,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                    textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                                OutlinedButton.icon(
                                  onPressed: () => _openInBrowser(),
                                  icon: const Icon(Icons.forum_outlined, size: 14),
                                  label: const Text('Join Discussion & Comments'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: isDark ? Colors.white : AppColors.lightTextPrimary,
                                    side: BorderSide(color: isDark ? AppColors.darkBorderLight : AppColors.lightBorder),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                    textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
