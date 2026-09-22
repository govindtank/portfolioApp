class BlogPost {
  final String title;
  final String slug;
  final String date;
  final String excerpt;
  final String coverImage;
  final String category;
  final int readTime;
  final List<String> tags;
  final String? content;

  BlogPost({
    required this.title,
    required this.slug,
    required this.date,
    required this.excerpt,
    required this.coverImage,
    required this.category,
    required this.readTime,
    required this.tags,
    this.content,
  });

  String get webUrl => 'https://govindtank.github.io/blog/$slug';

  factory BlogPost.fromFrontmatter({
    required String rawMarkdown,
    required String fallbackSlug,
  }) {
    String title = 'Architectural Log';
    String slug = fallbackSlug;
    String date = '2026';
    String excerpt = '';
    String coverImage =
        'https://images.unsplash.com/photo-1522252234503-e356532cafd5?auto=format&fit=crop&q=80&w=1200';
    String category = 'Mobile Architecture';
    int readTime = 5;
    List<String> tags = ['Architecture'];
    String bodyContent = rawMarkdown;

    if (rawMarkdown.startsWith('---')) {
      final parts = rawMarkdown.split('---');
      if (parts.length >= 3) {
        final frontmatter = parts[1];
        bodyContent = parts.sublist(2).join('---').trim();

        for (final line in frontmatter.split('\n')) {
          final trimmed = line.trim();
          if (trimmed.startsWith('title:')) {
            title = trimmed.replaceFirst('title:', '').trim().replaceAll('"', '');
          } else if (trimmed.startsWith('slug:')) {
            slug = trimmed.replaceFirst('slug:', '').trim().replaceAll('"', '');
          } else if (trimmed.startsWith('date:')) {
            date = trimmed.replaceFirst('date:', '').trim().replaceAll('"', '');
          } else if (trimmed.startsWith('category:')) {
            category = trimmed.replaceFirst('category:', '').trim().replaceAll('"', '');
          } else if (trimmed.startsWith('coverImage:')) {
            coverImage = trimmed.replaceFirst('coverImage:', '').trim().replaceAll('"', '');
          } else if (trimmed.startsWith('readTime:')) {
            final parsed = int.tryParse(trimmed.replaceFirst('readTime:', '').trim());
            if (parsed != null) readTime = parsed;
          }
        }
      }
    }

    if (excerpt.isEmpty && bodyContent.isNotEmpty) {
      final clean = bodyContent
          .replaceAll(RegExp(r'#+ '), '')
          .replaceAll(RegExp(r'\*+'), '')
          .trim();
      final lines = clean.split('\n').where((l) => l.trim().isNotEmpty).toList();
      excerpt = lines.isNotEmpty ? lines.first : 'Technical article on system architecture and mobile development.';
      if (excerpt.length > 160) {
        excerpt = '${excerpt.substring(0, 157)}...';
      }
    }

    return BlogPost(
      title: title,
      slug: slug,
      date: date,
      excerpt: excerpt,
      coverImage: coverImage,
      category: category,
      readTime: readTime,
      tags: tags,
      content: bodyContent,
    );
  }
}
