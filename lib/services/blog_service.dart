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
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> files = json.decode(response.body);
        final List<BlogPost> dynamicPosts = [];

        final mdFiles = files
            .where((f) => f['name'] != null && f['name'].toString().endsWith('.md'))
            .toList();

        for (final file in mdFiles) {
          final fileName = file['name'] as String;
          final slug = fileName.replaceAll('.md', '');
          
          final featuredMatch = _featuredArticles.where((p) => p.slug == slug).firstOrNull;
          if (featuredMatch != null) {
            dynamicPosts.add(featuredMatch);
          } else {
            // Intelligent Category Discovery from Slug
            String category = 'Architecture';
            if (slug.contains('flutter') || slug.contains('impeller') || slug.contains('dart') || slug.contains('webgpu')) {
              category = 'Flutter & Impeller';
            } else if (slug.contains('ai') || slug.contains('agent') || slug.contains('mcp') || slug.contains('llm') || slug.contains('slm') || slug.contains('rag') || slug.contains('claude')) {
              category = 'Agentic AI & MCP';
            } else if (slug.contains('android') || slug.contains('compose') || slug.contains('kotlin') || slug.contains('kmp') || slug.contains('npu') || slug.contains('opengl')) {
              category = 'Android & KMP';
            } else if (slug.contains('tool') || slug.contains('rust') || slug.contains('docker') || slug.contains('wasm') || slug.contains('typescript') || slug.contains('idea')) {
              category = 'Dev Tools';
            } else {
              category = 'System Design';
            }

            final title = _formatTitleFromSlug(slug);

            dynamicPosts.add(
              BlogPost(
                title: title,
                slug: slug,
                date: '2026',
                excerpt: 'Architectural analysis and implementation guide on $title by Senior Lead Mobile Architect Govind Tank.',
                coverImage: _getCoverImageForCategory(category),
                category: category,
                readTime: 6,
                tags: [category, 'Architecture', 'Enterprise'],
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

  static String _formatTitleFromSlug(String slug) {
    return slug
        .split('-')
        .map((w) {
          if (w.isEmpty) return '';
          if (w.toLowerCase() == 'ai') return 'AI';
          if (w.toLowerCase() == 'mcp') return 'MCP';
          if (w.toLowerCase() == 'kmp') return 'KMP';
          if (w.toLowerCase() == 'npu') return 'NPU';
          if (w.toLowerCase() == 'llm') return 'LLM';
          if (w.toLowerCase() == 'slm') return 'SLM';
          if (w.toLowerCase() == 'ui') return 'UI';
          if (w.toLowerCase() == 'crdt') return 'CRDT';
          if (w.toLowerCase() == 'cqrs') return 'CQRS';
          return '${w[0].toUpperCase()}${w.substring(1)}';
        })
        .join(' ');
  }

  Future<String> fetchPostMarkdown(String slug) async {
    final match = _featuredArticles.where((p) => p.slug == slug && p.content != null).firstOrNull;
    if (match != null && match.content != null && match.content!.isNotEmpty) {
      return match.content!;
    }

    try {
      final url = Uri.parse(
        'https://raw.githubusercontent.com/govindtank/govindtank.github.io/main/src/content/blog/$slug.md',
      );
      final response = await http.get(url).timeout(const Duration(seconds: 10));
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
      debugPrint('Error fetching post markdown: $e');
    }

    return '# $slug\n\nArticle preview loaded directly from [govindtank.github.io](https://govindtank.github.io/blog/$slug). Read the full article on the web.';
  }

  static String _getCoverImageForCategory(String category) {
    switch (category) {
      case 'Flutter & Impeller':
        return 'https://images.unsplash.com/photo-1551650975-87deedd944c3?auto=format&fit=crop&q=80&w=1200';
      case 'Agentic AI & MCP':
        return 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?auto=format&fit=crop&q=80&w=1200';
      case 'Android & KMP':
        return 'https://images.unsplash.com/photo-1607252650355-f7fd0460ccdb?auto=format&fit=crop&q=80&w=1200';
      case 'Dev Tools':
        return 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?auto=format&fit=crop&q=80&w=1200';
      default:
        return 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&q=80&w=1200';
    }
  }

  static final List<BlogPost> _featuredArticles = [
    BlogPost(
      title: 'Flutter 4 and Impeller: The Next Generation of UI Performance',
      slug: 'flutter-4-and-impeller-the-next-generation-of-cross-platform-ui-performance',
      date: 'Aug 03, 2026',
      excerpt: 'In Flutter 4, the Skia path is deprecated. Every frame renders through Impeller with zero runtime shader compilation jank.',
      coverImage: 'https://images.unsplash.com/photo-1551650975-87deedd944c3?auto=format&fit=crop&q=80&w=1200',
      category: 'Flutter & Impeller',
      readTime: 6,
      tags: ['Flutter', 'Impeller', 'Graphics', 'Performance'],
      content: '''# Flutter 4 and Impeller: The Next Generation of UI Performance

I've shipped Flutter apps since the 1.0 days. For most of that time I kept a rehearsed answer for the same complaint: *"the app stutters on the first scroll."* 

Flutter 4 completely transforms cross-platform rendering. On iOS and Android, every frame renders through **Impeller**, Flutter's purpose-built GPU renderer. Nothing gets compiled at runtime.

### Key Architectural Shifts:
1. **Ahead-of-Time Shader Compilation:** Shaders are pre-compiled into target GPU formats (MSL for iOS, SPIR-V/Vulkan for Android).
2. **Explicit Concurrency Model:** Multi-threaded command submission decouples UI layout from GPU buffer submission.
3. **Hardware Tessellation:** Geometry curves and shadows are rasterized with hardware-level acceleration.
''',
    ),
    BlogPost(
      title: 'Building Production-Grade Model Context Protocol (MCP) Clients in KMP',
      slug: 'building-production-grade-model-context-protocol-mcp-clients-in-kotlin-multiplatform',
      date: 'Aug 01, 2026',
      excerpt: 'Architecting cross-platform autonomous agents connecting LLMs to native mobile sensors and file systems with Model Context Protocol.',
      coverImage: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?auto=format&fit=crop&q=80&w=1200',
      category: 'Agentic AI & MCP',
      readTime: 8,
      tags: ['MCP', 'AI Agents', 'Kotlin Multiplatform', 'Architecture'],
      content: '''# Building Production-Grade MCP Clients in Kotlin Multiplatform

Model Context Protocol (MCP) has emerged as the universal standard for AI tool execution. By building MCP clients in Kotlin Multiplatform (KMP), we bridge LLMs directly to Android and iOS platform capabilities.

```kotlin
class MobileMcpClient(private val transport: McpTransport) {
    suspend fun executeTool(name: String, params: JsonObject): ToolResult {
        return transport.sendRequest("tools/call", json {
            "name" to name
            "arguments" to params
        })
    }
}
```
''',
    ),
    BlogPost(
      title: 'Android NPU Acceleration: Implementing ONNX Runtime for Edge AI',
      slug: 'android-npu-acceleration-implementing-onnx-runtime-for-ml-inference',
      date: 'Jul 28, 2026',
      excerpt: 'Achieving sub-50ms on-device machine learning inference on Qualcomm and MediaTek NPUs using NNAPI and ONNX Runtime.',
      coverImage: 'https://images.unsplash.com/photo-1607252650355-f7fd0460ccdb?auto=format&fit=crop&q=80&w=1200',
      category: 'Android & KMP',
      readTime: 7,
      tags: ['Android', 'NPU', 'ONNX', 'Machine Learning', 'Edge AI'],
      content: '''# Android NPU Acceleration: ONNX Runtime for Edge AI

Running neural networks on mobile CPUs quickly leads to battery drain and thermal throttling. Leveraging dedicated Neural Processing Units (NPUs) unlocks constant 60fps vision and NLP pipelines.
''',
    ),
    BlogPost(
      title: 'Offline-First State Synchronization with CRDTs in Flutter',
      slug: 'offline-first-mobile-apps-crdts-for-conflict-free-replication-in-flutter',
      date: 'Jul 20, 2026',
      excerpt: 'Building bulletproof offline-first replication engines using Conflict-free Replicated Data Types (CRDTs) and SQLite.',
      coverImage: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&q=80&w=1200',
      category: 'System Design',
      readTime: 9,
      tags: ['Offline-First', 'CRDT', 'SQLite', 'Distributed Systems'],
      content: '''# Offline-First State Synchronization with CRDTs

Mobile devices are inherently distributed nodes with intermittent connectivity. CRDTs enable deterministic, conflict-free state merging across devices without central locks.
''',
    ),
    BlogPost(
      title: 'Building Developer Tools in 2026: From CLI Design to AI Extensions',
      slug: 'building-developer-tools-in-2026-from-cli-design-to-ai-assisted-extensions',
      date: 'Jul 15, 2026',
      excerpt: 'Creating developer tools that combine high-performance terminal UX, Model Context Protocol servers, and automated pipelines.',
      coverImage: 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?auto=format&fit=crop&q=80&w=1200',
      category: 'Dev Tools',
      readTime: 5,
      tags: ['DevTools', 'CLI', 'Automation', 'Productivity'],
      content: '''# Building Developer Tools in 2026

Modern developer tooling demands instantaneous CLI execution, intelligent error diagnosis, and seamless IDE integration.
''',
    ),
  ];
}
