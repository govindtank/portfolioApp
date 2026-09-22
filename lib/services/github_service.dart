import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/github_project.dart';

class GithubService {
  static const String _baseUrl = 'https://api.github.com/users/govindtank/repos';

  Future<List<GithubProject>> fetchRecentRepos() async {
    return fetchTopProjects();
  }

  Future<List<GithubProject>> fetchTopProjects() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?sort=updated&per_page=8'),
        headers: {'Accept': 'application/vnd.github.v3+json'},
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body);
        final List<GithubProject> projects = body
            .map((dynamic item) => GithubProject.fromJson(item))
            .toList();
        return projects;
      }
    } catch (e) {
      debugPrint('Error fetching Github projects: $e');
    }
    return _fallbackProjects;
  }

  static final List<GithubProject> _fallbackProjects = [
    GithubProject(
      name: 'cmp-keyboard',
      description: 'Compose Multiplatform reactive keyboard-aware layout for Android & iOS.',
      htmlUrl: 'https://github.com/govindtank/cmp-keyboard',
      language: 'Kotlin',
      stargazersCount: 12,
    ),
    GithubProject(
      name: 'waveform_pro',
      description: 'GPU-accelerated Flutter audio waveform renderer with cue markers and zoom.',
      htmlUrl: 'https://github.com/govindtank/waveform_pro',
      language: 'Dart',
      stargazersCount: 18,
    ),
    GithubProject(
      name: 'country_mobile_validator',
      description: 'Pure Dart high-performance phone number validation with libphonenumber metadata.',
      htmlUrl: 'https://github.com/govindtank/country_mobile_validator',
      language: 'Dart',
      stargazersCount: 9,
    ),
    GithubProject(
      name: 'flutter_whisper',
      description: 'On-device local speech-to-text inference with whisper.cpp on Android.',
      htmlUrl: 'https://github.com/govindtank/flutter_whisper',
      language: 'C++ / Dart',
      stargazersCount: 15,
    ),
  ];
}
