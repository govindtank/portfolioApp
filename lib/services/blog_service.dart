import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/blog_post.dart';

class BlogService {
  static final BlogService _instance = BlogService._internal();
  factory BlogService() => _instance;
  BlogService._internal();

  List<BlogPost> _cachedPosts = [];
  bool _isLoading = false;

  List<BlogPost> get cachedPosts => _cachedPosts.isNotEmpty ? _cachedPosts : _featuredArticles;

  Future<List<BlogPost>> fetchBlogPosts({bool forceRefresh = false}) async {
    if (_cachedPosts.isNotEmpty && !forceRefresh) {
      return _cachedPosts;
    }

    if (_isLoading) {
      return _cachedPosts.isNotEmpty ? _cachedPosts : _featuredArticles;
    }

    _isLoading = true;

    try {
      final url = Uri.parse(
        'https://api.github.com/repos/govindtank/govindtank.github.io/contents/src/content/blog',
      );
      final response = await http.get(
        url,
        headers: {'Accept': 'application/vnd.github.v3+json'},
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final List<dynamic> files = json.decode(response.body);
        final List<BlogPost> dynamicPosts = [];

        // Take the top 15 most relevant articles
        final mdFiles = files
            .where((f) => f['name'] != null && f['name'].toString().endsWith('.md'))
            .take(15)
            .toList();

        for (final file in mdFiles) {
          final fileName = file['name'] as String;
          final slug = fileName.replaceAll('.md', '');
          
          // Match with featured first or construct item
          final featuredMatch = _featuredArticles.where((p) => p.slug == slug).firstOrNull;
          if (featuredMatch != null) {
            dynamicPosts.add(featuredMatch);
          } else {
            // Generate clean human title from slug
            final title = slug
                .split('-')
                .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
                .join(' ');

            String category = 'Architecture';
            if (slug.contains('flutter')) {
              category = 'Flutter';
            } else if (slug.contains('android') || slug.contains('compose')) {
              category = 'Android';
            } else if (slug.contains('ai') || slug.contains('agent') || slug.contains('llm')) {
              category = 'AI Systems';
            } else if (slug.contains('kotlin') || slug.contains('kmp')) {
              category = 'Kotlin';
            }

            dynamicPosts.add(
              BlogPost(
                title: title,
                slug: slug,
                date: '2026',
                excerpt: 'In-depth engineering breakdown of $title by Govind Tank.',
                coverImage: _getCoverImageForCategory(category),
                category: category,
                readTime: 6,
                tags: [category, 'Mobile', 'Architecture'],
              ),
            );
          }
        }

        if (dynamicPosts.isNotEmpty) {
          _cachedPosts = dynamicPosts;
          _isLoading = false;
          return _cachedPosts;
        }
      }
    } catch (e) {
      debugPrint('Error fetching dynamic blog list: $e');
    }

    _isLoading = false;
    _cachedPosts = _featuredArticles;
    return _featuredArticles;
  }

  Future<String> fetchPostMarkdown(String slug) async {
    // Check if we have pre-cached full content
    final match = _featuredArticles.where((p) => p.slug == slug && p.content != null).firstOrNull;
    if (match != null && match.content != null && match.content!.isNotEmpty) {
      return match.content!;
    }

    try {
      final url = Uri.parse(
        'https://raw.githubusercontent.com/govindtank/govindtank.github.io/main/src/content/blog/$slug.md',
      );
      final response = await http.get(url).timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        final raw = response.body;
        if (raw.startsWith('---')) {
          final parts = raw.split('---');
          if (parts.length >= 3) {
            return parts.sublist(2).join('---').trim();
          }
        }
        return raw;
      }
    } catch (e) {
      debugPrint('Error fetching raw post markdown: $e');
    }

    return '# Article Overview\n\nThis article is available online at [https://govindtank.github.io/blog/$slug](https://govindtank.github.io/blog/$slug).\n\n### Highlights\n- In-depth architectural patterns\n- Production benchmarks and case studies\n- Mobile engineering insights by Govind Tank';
  }

  String _getCoverImageForCategory(String category) {
    switch (category) {
      case 'Flutter':
        return 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&q=80&w=1200';
      case 'Android':
        return 'https://images.unsplash.com/photo-1607252650355-f7fd0460ccdb?auto=format&fit=crop&q=80&w=1200';
      case 'AI Systems':
        return 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?auto=format&fit=crop&q=80&w=1200';
      case 'Kotlin':
        return 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?auto=format&fit=crop&q=80&w=1200';
      default:
        return 'https://images.unsplash.com/photo-1522252234503-e356532cafd5?auto=format&fit=crop&q=80&w=1200';
    }
  }

  static final List<BlogPost> _featuredArticles = [
    BlogPost(
      title: 'Flutter 4 and Impeller: The Next Generation of Cross-Platform UI Performance',
      slug: 'flutter-4-and-impeller-the-next-generation-of-cross-platform-ui-performance',
      date: 'August 03, 2026',
      excerpt:
          'Deep dive into Flutter 4 with Impeller GPU renderer, custom fragment shaders, and eliminating runtime shader compilation jank forever.',
      coverImage: 'https://images.unsplash.com/photo-1522252234503-e356532cafd5?auto=format&fit=crop&q=80&w=1200',
      category: 'Flutter',
      readTime: 6,
      tags: ['Flutter', 'Impeller', 'Performance', 'GPU'],
      content: '''
# Flutter 4 and Impeller: Next-Gen Cross-Platform UI Performance

I've shipped Flutter apps since the 1.0 days. For most of that time I kept a rehearsed answer for the same complaint: "the app stutters on the first scroll." Launch, swipe, and the raster thread froze for a beat while the engine compiled shaders on the fly. A few hundred milliseconds later everything ran smooth, but the first impression was already ruined.

Flutter 4 removes that excuse. On iOS and Android, the Skia path is gone. Every frame renders through Impeller, Flutter's own GPU renderer, and nothing gets compiled at runtime. No warm-up pass. No hitch.

## The Jank Problem Impeller Solves

The old renderer received draw commands, turned them into GPU work, and hit a wall the moment it met an unfamiliar effect. Shadows, rounded corners, gradients — each one needed a shader, and Skia compiled shaders lazily on the raster thread.

Impeller compiles all shaders ahead of time during the engine build phase. It embraces modern graphic backends:
- **Metal** on iOS and macOS
- **Vulkan** on Android (with robust OpenGLES fallbacks)
- Pre-compiled SPIR-V pipeline state objects

## Real Architectural Benefits

1. **Deterministic 120 FPS**: Zero runtime shader compilation pauses.
2. **First-Class Fragment Shaders**: Custom GLSL shaders run at raw hardware speeds.
3. **Optimized Memory Footprint**: Textures and surfaces recycled with zero memory churn.

```dart
// Custom Impeller-ready shader snippet
final program = await FragmentProgram.fromAsset('shaders/cyber_glow.frag');
final shader = program.fragmentShader();
shader.setFloat(0, size.width);
shader.setFloat(1, size.height);
canvas.drawRect(rect, Paint()..shader = shader);
```

By transitioning enterprise apps like *BAPS Prakash* and *Akshar Amrutam* to modern architectures, we achieve consistent 99.95% crash-free stability across millions of user sessions.
''',
    ),
    BlogPost(
      title: 'Agentic AI Workflows: Architecting Multi-Agent Systems with MCP in 2026',
      slug: 'agentic-ai-building-autonomous-workflows-with-langgraph-and-mcp-protocol',
      date: 'August 12, 2026',
      excerpt:
          'How Model Context Protocol (MCP) and agentic tool loops are reshaping mobile and backend software engineering workflows.',
      coverImage: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?auto=format&fit=crop&q=80&w=1200',
      category: 'AI Systems',
      readTime: 8,
      tags: ['AI Agents', 'MCP', 'Architecture', 'Tool Loops'],
      content: '''
# Agentic AI Workflows: Architecting Multi-Agent Systems in 2026

The shift from simple conversational chatbots to autonomous coding and diagnostic agents is the most significant leap in software engineering this decade.

## The Core Foundations of Agentic Loops

An autonomous agent differs fundamentally from a single-prompt LLM:
1. **Perception**: Reading workspace context, inspecting file trees, and gathering live metrics.
2. **Action Plan**: Formulating verified hypothesis steps with fail-safes.
3. **Execution**: Running targeted tools (terminal, file patchers, AST analyzers).
4. **Verification**: Validating test outputs and real world artifacts before declaring completion.

## The Role of Model Context Protocol (MCP)

Model Context Protocol standardizes how LLMs interface with databases, codebases, and physical OS tools without bespoke APIs:
- Isolated security contexts
- Bi-directional telemetry
- Zero-drift schema enforcement

By integrating agentic automation into CI/CD pipelines, we reduce release cycle overhead by over 70% while improving test coverage.
''',
    ),
    BlogPost(
      title: 'Kotlin Multiplatform at Scale: Production Architecture for Shared Logic',
      slug: 'kotlin-multiplatform-in-production-sharing-business-logic-across-android-ios-and-web-in-2026',
      date: 'July 28, 2026',
      excerpt:
          'Lessons from sharing Clean Architecture domain and data layers across Android, iOS, and Web with Kotlin Multiplatform and Compose.',
      coverImage: 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?auto=format&fit=crop&q=80&w=1200',
      category: 'Kotlin',
      readTime: 7,
      tags: ['KMP', 'Kotlin', 'Clean Architecture', 'Compose'],
      content: '''
# Kotlin Multiplatform at Scale: Production Architecture

Kotlin Multiplatform (KMP) has matured into the premier solution for teams wanting shared native performance without the compromises of monolithic web wrappers.

## Layer Separation Strategy

```
┌─────────────────────────────────────────┐
│        UI Layer (Jetpack Compose / SwiftUI) │
├─────────────────────────────────────────┤
│        Shared Domain (UseCases, Entities)│
├─────────────────────────────────────────┤
│        Shared Data (Ktor, SQLDelight, KV)│
└─────────────────────────────────────────┘
```

- **Zero UI Lock-in**: Share 80% of business logic while maintaining pixel-perfect native platform aesthetics.
- **Strict Memory Safety**: Native binary compilation via Kotlin/Native for iOS and standard JVM bytecode on Android.
- **Coroutines & Flow**: Reactive state synchronization across Swift and Kotlin boundaries.
''',
    ),
    BlogPost(
      title: 'Modern Android Live Wallpapers: OpenGL ES & Jetpack Compose Performance',
      slug: 'android-live-wallpapers-with-opengl-es-performance-optimization-guide',
      date: 'July 15, 2026',
      excerpt:
          'Architecting 60fps battery-efficient Android live wallpapers using OpenGL ES shaders, SurfaceHolders, and Material You theming.',
      coverImage: 'https://images.unsplash.com/photo-1607252650355-f7fd0460ccdb?auto=format&fit=crop&q=80&w=1200',
      category: 'Android',
      readTime: 5,
      tags: ['Android', 'OpenGL ES', 'Live Wallpaper', 'Graphics'],
      content: '''
# Modern Android Live Wallpapers: OpenGL ES Optimization

Building live wallpapers demands rigorous performance discipline. Unlike standard applications, a wallpaper shares GPU cycles directly with the home launcher and background services.

## Key Performance Pillars

1. **SurfaceHolder Lifecycle**: Never render when the screen is locked or hidden. Use visibility callbacks to halt GL threads immediately.
2. **Vsync Clamping**: Throttle rendering to match display refresh rates (60Hz / 120Hz) rather than free-wheeling.
3. **Day/Night & Material You Sync**: Listen for dynamic system color palette shifts using Android 12+ WallpaperColors APIs.

These optimizations guarantee zero background battery drain while delivering smooth dynamic visual effects.
''',
    ),
  ];
}
