import '../models/portfolio_data.dart';

final Person portfolioData = Person(
  name: 'Govind Tank',
  role: 'Senior Lead Architect & Android Expert',
  location: 'Gandhinagar, Gujarat, India',
  summary:
      'High-performance Senior Lead Mobile Architect & Android Expert with 9+ years of experience engineering mission-critical Android (Kotlin/Jetpack Compose), Cross-Platform (Flutter), and Kotlin Multiplatform systems. Proven track record of scaling enterprise applications serving 100,000+ active users with 99.95% crash-free stability. Pioneer in AI-augmented engineering workflows, Model Context Protocol (MCP), and on-device machine learning.',
  skills: [
    Skill(
      category: 'Core Languages',
      items: [
        'Kotlin',
        'Dart (Flutter)',
        'Java',
        'TypeScript',
        'JavaScript (Node.js)',
        'Python',
        'SQL / SQLite',
        'C / C++ (NDK)',
      ],
    ),
    Skill(
      category: 'Android & KMP',
      items: [
        'Jetpack Compose',
        'Kotlin Multiplatform (KMP)',
        'Coroutines & Flow',
        'WorkManager',
        'OpenGL ES / Shaders',
        'Android Auto',
        'Material You 3',
        'Dagger Hilt / Koin',
      ],
    ),
    Skill(
      category: 'Flutter Ecosystem',
      items: [
        'Flutter Bloc / Cubit',
        'Impeller GPU Engine',
        'Provider',
        'Method Channels',
        'audio_service',
        'AutoRoute',
        'Freezed & Equatable',
        'CanvasKit & WASM',
      ],
    ),
    Skill(
      category: 'Architecture & System Design',
      items: [
        'Clean Architecture',
        'MVI / MVVM',
        'Repository Pattern',
        'Offline-First Sync',
        'Event-Driven Systems',
        'Micro-Frontends',
        'Security & DRM',
      ],
    ),
    Skill(
      category: 'AI & Next-Gen Engineering',
      items: [
        'Model Context Protocol (MCP)',
        'Agentic Tool Loops',
        'On-Device SLM / GGUF',
        'Cursor & Windsurf',
        'OpenRouter API',
        'Claude Code CLI',
        'AntiGravity AI',
      ],
    ),
    Skill(
      category: 'Cloud, IoT & DevOps',
      items: [
        'AWS CloudFront (Signed Cookies)',
        'Firebase (FCM, Firestore, Auth)',
        'MQTT & BLE Protocols',
        'Docker & CI/CD (GitHub Actions)',
        'FastAPI & Node.js',
        'Play Console Publishing',
      ],
    ),
  ],
  projects: [
    Project(
      name: 'BAPS Prakash',
      description:
          'Directed complete architectural overhaul of "BAPS Prakash" (50k+ active users). Engineered secure audio streaming engine utilizing AWS CloudFront Signed Cookies with token rotation, completely preventing unauthorized access to copyrighted audio content.\n\n• AWS CloudFront Signed Cookies DRM protection\n• Integrated audio_service for lock-screen controls and Android Auto\n• Achieved 99.95% crash-free session stability',
      technologies: ['Flutter', 'AWS CloudFront', 'audio_service', 'Android Auto', 'Clean Architecture'],
      link: 'https://play.google.com/store/apps/details?id=org.baps.swaminarayanprakash',
    ),
    Project(
      name: 'Akshar Amrutam',
      description:
          'Spearheaded the technical development of "Akshar Amrutam," scaling it to over 100,000+ downloads with a 99.95% crash-free rate across diverse hardware profiles. Implemented strict UI/Domain/Data layer separation with Flutter Bloc.\n\n• Scaled to 100,000+ downloads worldwide\n• Engineered offline-first caching for instant multi-media playback\n• Strict Clean Architecture with automated testing',
      technologies: ['Flutter', 'Clean Architecture', 'Flutter Bloc', 'Offline Sync', 'MVVM'],
      link: 'https://play.google.com/store/apps/details?id=org.baps.akshar_amrutam',
    ),
    Project(
      name: 'Smartindia / Autozon IoT',
      description:
          'Built the Smartindia IoT mobile companion application, implementing low-latency bi-directional MQTT communication between mobile devices and hardware sensors with zero battery drain.\n\n• Real-time MQTT telemetry streaming for smart devices\n• Optimized persistent background services\n• Seamless voice assistant triggers (Google Assistant & Alexa)',
      technologies: ['Android Native', 'MQTT', 'IoT', 'BLE', 'Kotlin Coroutines'],
      link: 'https://play.google.com/store/apps/details?id=com.voiceofthings.smartindia',
    ),
    Project(
      name: 'La Crosse View',
      description:
          'Engineered resilient background sync services for "La Crosse View" connected weather station ecosystem, slashing app startup time by 30% and eliminating memory leaks.\n\n• 30% faster cold startup performance\n• Robust Bluetooth LE and cloud synchronization engine\n• 95% reduction in runtime exceptions via Kotlin migration',
      technologies: ['Android Native', 'Kotlin', 'Background Services', 'BLE', 'RxJava/Coroutines'],
      link: 'https://play.google.com/store/apps/details?id=com.lacrosseview.app',
    ),
    Project(
      name: "Max's Fun Club",
      description:
          "Managed end-to-end delivery of international consumer applications across USA and South Africa with strict performance, security, and child safety compliance.\n\n• Coordinated global multi-region deployments\n• High-performance interactive UI animations\n• COPPA & GDPR compliant data architecture",
      technologies: ['Flutter', 'Localization', 'Security Compliance', 'Animated UX'],
      link: 'https://play.google.com/store/apps/details?id=com.maxfunclub',
    ),
    Project(
      name: 'High-Concurrency ERP Backend',
      description:
          'Architected high-throughput RESTful & GraphQL microservices using Node.js, TypeScript, and Python FastAPI, handling complex multi-tenant resource scheduling with sub-50ms latency.\n\n• High-concurrency transaction pipeline\n• Role-based security & JWT auth\n• Automated Docker CI/CD deployment',
      technologies: ['Node.js', 'TypeScript', 'FastAPI', 'PostgreSQL', 'Docker'],
      link: null,
    ),
  ],
  experiences: [
    Experience(
      role: 'Senior Lead Software Developer L2',
      company: 'Rysun Labs Pvt. Ltd.',
      duration: 'Nov 2025 -- Present',
      location: 'Ahmedabad, India',
      description:
          '• Directed complete overhaul of "BAPS Prakash" app (50k+ users) with secure AWS CloudFront audio streaming\n• Integrated audio_service for background tasks, lock-screen controls, and Android Auto compatibility\n• Architected high-concurrency backend services using TypeScript and Node.js\n• Mentored mobile engineering squads on Clean Architecture, Impeller optimizations, and AI toolchains',
    ),
    Experience(
      role: 'Senior Mobile Application Developer',
      company: 'Rysun Labs Pvt. Ltd.',
      duration: 'Apr 2022 -- Oct 2024',
      location: 'Ahmedabad, India',
      description:
          '• Spearheaded "Akshar Amrutam" development, scaling to 100,000+ downloads with 99.95% crash-free rate\n• Utilized Flutter Bloc for complex state management ensuring 60fps performance\n• Built "Smartindia/Autozon" IoT app with real-time MQTT communication\n• Managed end-to-end delivery of international mobile projects',
    ),
    Experience(
      role: 'Software Engineer - Android Native',
      company: 'Phycom Corporations',
      duration: 'Apr 2021 -- Mar 2022',
      location: 'Ahmedabad, India',
      description:
          '• Engineered robust background services for "La Crosse View" weather hardware app\n• Reduced application startup time by 30% and memory footprint by 20%\n• Refactored legacy Java codebases to Kotlin, reducing NullPointerExceptions by 95%',
    ),
    Experience(
      role: 'Remote Android Developer',
      company: 'Micro App Solutions',
      duration: 'Aug 2017 -- Dec 2019',
      location: 'Surat, India',
      description:
          '• Developed "Fastrrr-Floating Apps" and "Water Reminder" with complex overlay window permissions\n• Built "OfferzZone" hyper-local marketplace utilizing Geofencing APIs\n• Maintained strict battery efficiency protocols',
    ),
    Experience(
      role: 'Android Developer',
      company: 'Stimulus Consultancy',
      duration: 'Apr 2016 -- Aug 2017',
      location: 'Ahmedabad, India',
      description:
          '• Established initial CI/CD pipelines and repository structures for client applications\n• Implemented complex calculation logic for GST tax application with 100% accuracy\n• Reduced deployment friction in early-stage development',
    ),
  ],
  education: [
    Education(
      institution: 'AES College of Computer Applications',
      degree: 'Master of Computer Applications (M.C.A.)',
      duration: '2013 -- 2015',
      description: 'Advanced software systems, distributed computing, database architecture, and algorithms',
    ),
    Education(
      institution: 'Navgujarat College of Computer Applications',
      degree: 'Bachelor of Computer Applications (B.C.A.)',
      duration: '2010 -- 2013',
      description: 'Computer science fundamentals, Object-Oriented Programming (Java/C++), and data structures',
    ),
  ],
  contact: Contact(
    email: 'govindtank600@gmail.com',
    phone: '+91 84604848061',
    linkedin: 'https://linkedin.com/in/govindtank',
    github: 'https://github.com/govindtank',
    website: 'https://govindtank.github.io',
  ),
);
