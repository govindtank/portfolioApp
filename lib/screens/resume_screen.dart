import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/visitor_counter_service.dart';

class ResumeScreen extends StatefulWidget {
  final bool? isDarkMode;
  final VoidCallback? onThemeChanged;

  const ResumeScreen({
    super.key,
    this.isDarkMode,
    this.onThemeChanged,
  });

  @override
  State<ResumeScreen> createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen> {
  final ScrollController _scrollController = ScrollController();
  int _visitorCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVisitorCount();
  }

  Future<void> _loadVisitorCount() async {
    final service = VisitorCounterService();
    final count = await service.getVisitorCount();
    if (mounted) {
      setState(() {
        _visitorCount = count;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode ?? (Theme.of(context).brightness == Brightness.dark);
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1200;

    double bodyPadding, sectionSpacing, headingFontSize, textFontSize;
    if (isMobile) {
      bodyPadding = 16.0;
      sectionSpacing = 20.0;
      headingFontSize = 20.0;
      textFontSize = 14.0;
    } else if (isTablet) {
      bodyPadding = 24.0;
      sectionSpacing = 28.0;
      headingFontSize = 22.0;
      textFontSize = 15.0;
    } else {
      bodyPadding = 40.0;
      sectionSpacing = 30.0;
      headingFontSize = 24.0;
      textFontSize = 16.0;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Resume'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Visitor Counter Badge
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.withOpacity(0.8),
                  Colors.pink.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.visibility, size: 16, color: Colors.white),
                const SizedBox(width: 6),
                _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        '$_visitorCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onThemeChanged,
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: bodyPadding),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, isMobile),
                  SizedBox(height: sectionSpacing),
                  _buildDownloadButton(context),
                  SizedBox(height: sectionSpacing),
                  _buildSummary(context, headingFontSize, textFontSize),
                  SizedBox(height: sectionSpacing),
                  _buildSkills(context, headingFontSize, textFontSize),
                  SizedBox(height: sectionSpacing),
                  _buildExperience(context, headingFontSize, textFontSize),
                  SizedBox(height: sectionSpacing),
                  _buildEducation(context, headingFontSize, textFontSize),
                  SizedBox(height: sectionSpacing),
                  _buildContact(context, headingFontSize, textFontSize),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return GlassCard(
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C63FF).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'GT',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
            ),
          ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.8, 0.8)),
          const SizedBox(height: 20),
          const Text(
            'Govind Tank',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 8),
          const Text(
            'Senior Lead Architect & Android Expert',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 8),
          const Text(
            'Kotlin • Flutter Impeller • KMP • AI Systems',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF38BDF8),
              fontWeight: FontWeight.w500,
            ),
          ).animate().fadeIn(delay: 500.ms),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildContactChip(Icons.location_on, 'Gandhinagar, Gujarat, India'),
              const SizedBox(width: 8),
              _buildContactChip(Icons.phone, '+91 8460 48 4061'),
            ],
          ).animate().fadeIn(delay: 600.ms),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildContactChip(Icons.email, 'govindtank600@gmail.com'),
            ],
          ).animate().fadeIn(delay: 700.ms),
        ],
      ),
    );
  }

  Widget _buildContactChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white70),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => _launchUrl('https://govindtank.github.io/portfolio/assets/resume/Govind_Tank_Resume.html'),
        icon: const Icon(Icons.download),
        label: const Text('Download Resume as PDF'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6C63FF),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
      ),
    ).animate().fadeIn(delay: 300.ms).scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildSummary(BuildContext context, double headingFontSize, double textFontSize) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.person, color: Color(0xFF6C63FF)),
              ),
              const SizedBox(width: 12),
              Text(
                'Professional Summary',
                style: TextStyle(
                  fontSize: headingFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'High-performance Senior Mobile Application Developer with 9+ years of experience architecting scalable Android (Kotlin/Java) and Cross-Platform (Flutter) solutions. Proven track record of delivering applications serving 100,000+ active users with 99.9% crash-free stability. Specialized in Clean Architecture, MVVM/Bloc patterns, and modern UI toolkits like Jetpack Compose. Forward-thinking advocate for AI-augmented development, leveraging coding agents like Cursor and Windsurf to accelerate delivery cycles and enhance code quality.',
            style: TextStyle(
              fontSize: textFontSize,
              color: Colors.white70,
              height: 1.6,
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: -0.1);
  }

  Widget _buildSkills(BuildContext context, double headingFontSize, double textFontSize) {
    final skills = [
      {
        'category': 'Languages',
        'items': ['Kotlin', 'Java', 'Dart (Flutter)', 'TypeScript', 'JavaScript (Node.js)', 'SQL'],
      },
      {
        'category': 'Android Native',
        'items': ['SDK', 'Jetpack Compose', 'Coroutines', 'State Flow', 'LiveData', 'WorkManager', 'Android Auto', 'Material 3'],
      },
      {
        'category': 'Flutter Ecosystem',
        'items': ['Flutter Bloc', 'Provider', 'AutoRoute', 'Freezed', 'Method Channels', 'audio_service', 'Equatable'],
      },
      {
        'category': 'Architecture',
        'items': ['Clean Architecture', 'MVVM', 'MVI', 'Repository Pattern', 'Dependency Injection (Dagger Hilt, Koin)'],
      },
      {
        'category': 'Backend & Cloud',
        'items': ['Node.js', 'Express.js', 'Firebase (Auth, Firestore, FCM)', 'AWS CloudFront', 'RESTful APIs', 'GraphQL'],
      },
      {
        'category': 'AI & Next-Gen Dev',
        'items': ['Cursor', 'Windsurf', 'Claude Code', 'OpenRouter API', 'Anti Gravity', 'Kilo Code', 'Open Claw'],
      },
      {
        'category': 'DevOps & Tools',
        'items': ['CI/CD (GitHub Actions)', 'Docker', 'Git', 'Gradle', 'Android Studio', 'Postman', 'Play Store Console'],
      },
    ];

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.code, color: Color(0xFF6C63FF)),
              ),
              const SizedBox(width: 12),
              Text(
                'Technical Skills',
                style: TextStyle(
                  fontSize: headingFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...skills.asMap().entries.map((entry) {
            final index = entry.key;
            final skill = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    skill['category'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6C63FF),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (skill['items'] as List<String>).map((item) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Text(
                          item,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: (index * 100).ms);
          }),
        ],
      ),
    );
  }

  Widget _buildExperience(BuildContext context, double headingFontSize, double textFontSize) {
    final experiences = [
      {
        'role': 'Senior Software Developer L2',
        'company': 'Rysun Labs Pvt. Ltd.',
        'location': 'Ahmedabad, India',
        'duration': 'Nov 2025 -- Present',
        'achievements': [
          'Secure Media Engineering: Directed the complete overhaul of the "BAPS Prakash" application (50k+ users). Engineered a secure audio streaming engine using AWS CloudFront Signed Cookies, successfully preventing unauthorized access to copyright-protected content.',
          'Advanced Background Audio: Integrated audio_service to manage complex background tasks, lock-screen controls, and Android Auto compatibility, significantly enhancing user accessibility.',
          'Scalable Backend Design: Architected high-concurrency RESTful APIs using Node.js and TypeScript for an internal HCP ERP system, optimizing complex resource allocation logic for enterprise use.',
        ],
      },
      {
        'role': 'Senior Software Developer / Project Owner',
        'company': 'Rysun Labs Pvt. Ltd.',
        'location': 'Ahmedabad, India',
        'duration': 'Apr 2022 -- Oct 2025',
        'achievements': [
          'Clean Architecture Implementation: Spearheaded the development of "Akshar Amrutam," scaling it to 100,000+ downloads. Enforced strict separation of UI, Domain, and Data layers, resulting in a 99.95% crash-free session rate.',
          'State Management Optimization: Utilized Flutter Bloc to manage complex application states, ensuring 60fps performance across a fragmented device market (low-end to high-end).',
          'IoT & Hardware Integration: Built the "Smartindia/Autozon" application, implementing real-time MQTT communication between mobile devices and IoT hardware. Optimized battery usage for companion apps by refactoring background services.',
          'Global Delivery: Managed end-to-end delivery of international projects (DRC USA, Max\'s Fun Club South Africa), ensuring strict adherence to timelines and quality standards.',
        ],
      },
      {
        'role': 'Software Engineer - Android',
        'company': 'Phycom Corporations',
        'location': 'Ahmedabad, India',
        'duration': 'Apr 2021 -- Mar 2022',
        'achievements': [
          'Hardware Synchronization: Engineered robust background services for "La Crosse View," ensuring reliable data synchronization with weather station hardware.',
          'Performance Tuning: Reduced application startup time by 30% and memory footprint by 20% through aggressive code profiling and optimization.',
          'Legacy Migration: Refactored legacy Java codebases to Kotlin, improving code safety and reducing NullPointerExceptions by 95%.',
        ],
      },
      {
        'role': 'Remote Android Developer',
        'company': 'Micro App Solutions',
        'location': 'Surat, India',
        'duration': 'Aug 2017 -- Dec 2019',
        'achievements': [
          'Utility App Development: Developed "Fastrrr-Floating Apps" and "Water Reminder," implementing complex overlay window permissions while maintaining strict battery efficiency protocols.',
          'Geospatial Tech: Built "OfferzZone," a hyper-local marketplace utilizing Geofencing APIs to trigger precise location-based notifications.',
        ],
      },
      {
        'role': 'Android Developer',
        'company': 'Stimulus Consultancy',
        'location': 'Ahmedabad, India',
        'duration': 'Apr 2016 -- Aug 2017',
        'achievements': [
          'Startup Engineering: Established initial CI/CD pipelines and repository structures for "City Tadka" and "Oowomaniya," reducing deployment friction in early-stage development.',
          'FinTech Logic: Implemented complex tax calculation logic for a GST application, ensuring 100% accuracy during critical national policy rollouts.',
        ],
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.work, color: Color(0xFF6C63FF)),
            ),
            const SizedBox(width: 12),
            Text(
              'Professional Experience',
              style: TextStyle(
                fontSize: headingFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ...experiences.asMap().entries.map((entry) {
          final index = entry.key;
          final exp = entry.value;
          return GlassCard(
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        exp['role'] as String,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        exp['duration'] as String,
                        style: const TextStyle(
                          color: Color(0xFF6C63FF),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.business, size: 16, color: Color(0xFFFF6584)),
                    const SizedBox(width: 6),
                    Text(
                      '${exp['company']} | ${exp['location']}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...(exp['achievements'] as List<String>).map((achievement) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF6C63FF),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            achievement,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.1);
        }),
      ],
    );
  }

  Widget _buildEducation(BuildContext context, double headingFontSize, double textFontSize) {
    final education = [
      {
        'degree': 'Master of Computer Applications (M.C.A.)',
        'institution': 'AES College of Computer Science, Ahmedabad University',
        'location': 'Ahmedabad, India',
        'duration': '2013 -- 2015',
      },
      {
        'degree': 'Bachelor of Computer Applications (B.C.A.)',
        'institution': 'Navgujarat College of Computer Applications, Gujarat University',
        'location': 'Ahmedabad, India',
        'duration': '2010 -- 2013',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.school, color: Color(0xFF6C63FF)),
            ),
            const SizedBox(width: 12),
            Text(
              'Education',
              style: TextStyle(
                fontSize: headingFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ...education.asMap().entries.map((entry) {
          final index = entry.key;
          final edu = entry.value;
          return GlassCard(
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        edu['degree'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        edu['duration'] as String,
                        style: const TextStyle(
                          color: Color(0xFF6C63FF),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  edu['institution'] as String,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  edu['location'] as String,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: (index * 100).ms);
        }),
      ],
    );
  }

  Widget _buildContact(BuildContext context, double headingFontSize, double textFontSize) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.contact_mail, color: Color(0xFF6C63FF)),
              ),
              const SizedBox(width: 12),
              Text(
                'Connect',
                style: TextStyle(
                  fontSize: headingFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildContactLink(
            Icons.link,
            'LinkedIn',
            'linkedin.com/in/govindtank',
            'https://linkedin.com/in/govindtank',
          ),
          const SizedBox(height: 12),
          _buildContactLink(
            Icons.code,
            'GitHub',
            'github.com/govindtank',
            'https://github.com/govindtank',
          ),
          const SizedBox(height: 12),
          _buildContactLink(
            Icons.language,
            'Portfolio',
            'govindtank.github.io',
            'https://govindtank.github.io',
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: -0.1);
  }

  Widget _buildContactLink(IconData icon, String label, String url, String fullUrl) {
    return InkWell(
      onTap: () => _launchUrl(fullUrl),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF6C63FF)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    url,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.open_in_new, color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(0),
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}