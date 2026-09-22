import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';
import '../models/blog_post.dart';
import '../services/blog_service.dart';
import 'blog_detail_screen.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  final BlogService _blogService = BlogService();
  final TextEditingController _searchController = TextEditingController();
  
  List<BlogPost> _allPosts = [];
  List<BlogPost> _filteredPosts = [];
  String _selectedCategory = 'All';
  bool _isLoading = true;

  final List<String> _categories = [
    'All',
    'Flutter & Impeller',
    'Agentic AI & MCP',
    'Android & KMP',
    'System Design',
    'Dev Tools',
  ];

  @override
  void initState() {
    super.initState();
    _loadPosts();
    _searchController.addListener(_filterPosts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPosts({bool forceRefresh = false}) async {
    setState(() => _isLoading = true);
    final posts = await _blogService.fetchBlogPosts(forceRefresh: forceRefresh);
    if (mounted) {
      setState(() {
        _allPosts = posts;
        _isLoading = false;
        _filterPosts();
      });
    }
  }

  void _filterPosts() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      _filteredPosts = _allPosts.where((post) {
        bool matchesCategory = false;
        if (_selectedCategory == 'All') {
          matchesCategory = true;
        } else if (_selectedCategory == 'Flutter & Impeller') {
          matchesCategory = post.category.toLowerCase().contains('flutter') ||
              post.category.toLowerCase().contains('impeller') ||
              post.tags.any((t) => t.toLowerCase().contains('flutter'));
        } else if (_selectedCategory == 'Agentic AI & MCP') {
          matchesCategory = post.category.toLowerCase().contains('ai') ||
              post.category.toLowerCase().contains('mcp') ||
              post.category.toLowerCase().contains('agent') ||
              post.tags.any((t) => t.toLowerCase().contains('ai') || t.toLowerCase().contains('mcp'));
        } else if (_selectedCategory == 'Android & KMP') {
          matchesCategory = post.category.toLowerCase().contains('android') ||
              post.category.toLowerCase().contains('kotlin') ||
              post.category.toLowerCase().contains('kmp') ||
              post.tags.any((t) => t.toLowerCase().contains('android') || t.toLowerCase().contains('kotlin'));
        } else if (_selectedCategory == 'Dev Tools') {
          matchesCategory = post.category.toLowerCase().contains('tool') ||
              post.tags.any((t) => t.toLowerCase().contains('tool') || t.toLowerCase().contains('cli'));
        } else {
          matchesCategory = post.category.toLowerCase().contains('design') ||
              post.category.toLowerCase().contains('architecture') ||
              post.tags.any((t) => t.toLowerCase().contains('architecture') || t.toLowerCase().contains('crdt'));
        }

        final matchesQuery = query.isEmpty ||
            post.title.toLowerCase().contains(query) ||
            post.excerpt.toLowerCase().contains(query) ||
            post.tags.any((t) => t.toLowerCase().contains(query));

        return matchesCategory && matchesQuery;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 700;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: () => _loadPosts(forceRefresh: true),
        color: primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 28,
            vertical: 20,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.auto_stories_rounded, color: primary, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Architectural Logs & Blog',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: isMobile ? 20 : 24,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            Text(
                              '110+ technical deep dives from govindtank.github.io',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.05),

                  const SizedBox(height: 20),

                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search articles, tags, or topics (e.g. Impeller, MCP, CRDT)...',
                        hintStyle: TextStyle(
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          fontSize: 13,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          size: 20,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  _filterPosts();
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

                  const SizedBox(height: 16),

                  // Category Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((cat) {
                        final isSelected = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedCategory = cat;
                                  _filterPosts();
                                });
                              }
                            },
                            selectedColor: primary.withOpacity(0.18),
                            backgroundColor: isDark
                                ? AppColors.darkSurfaceElevated
                                : AppColors.lightSurfaceElevated,
                            side: BorderSide(
                              color: isSelected
                                  ? primary
                                  : (isDark ? AppColors.darkBorderLight : AppColors.lightBorder),
                              width: isSelected ? 1.5 : 1,
                            ),
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? primary
                                  : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              fontSize: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

                  const SizedBox(height: 20),

                  // Blog List / Loading / Empty State
                  if (_isLoading)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: CircularProgressIndicator(color: primary),
                      ),
                    )
                  else if (_filteredPosts.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Icon(
                              Icons.article_outlined,
                              size: 48,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No articles found for "$_selectedCategory"',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Try picking "All" to browse all 110+ technical articles.',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filteredPosts.length,
                      itemBuilder: (context, index) {
                        final post = _filteredPosts[index];
                        return _buildBlogCard(context, post, index, isMobile);
                      },
                    ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBlogCard(BuildContext context, BlogPost post, int index, bool isMobile) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlogDetailScreen(post: post),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 14 : 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Category badge & Read time
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: primary.withOpacity(0.3)),
                      ),
                      child: Text(
                        post.category,
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
                          Icons.access_time_rounded,
                          size: 12,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${post.readTime} min read',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          post.date,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Title
                Text(
                  post.title,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: isMobile ? 15 : 17,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),

                // Excerpt
                Text(
                  post.excerpt,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 12),

                // Read Article Action
                Row(
                  children: [
                    Text(
                      'Read Breakdown',
                      style: TextStyle(
                        color: primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded, size: 14, color: primary),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 40 * (index % 10)), duration: 300.ms);
  }
}
