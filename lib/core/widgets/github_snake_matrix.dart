import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class GithubSnakeMatrix extends StatefulWidget {
  const GithubSnakeMatrix({super.key});

  @override
  State<GithubSnakeMatrix> createState() => _GithubSnakeMatrixState();
}

enum Direction { up, down, left, right }

class _GithubSnakeMatrixState extends State<GithubSnakeMatrix> {
  static const int rows = 7;
  static const int cols = 22;

  late List<List<int>> _grid; // 0: empty, 1-4: contribution levels
  List<Point<int>> _snake = [];
  Point<int> _food = const Point(10, 3);
  Direction _direction = Direction.right;
  Timer? _gameTimer;
  bool _isAutoPilot = true;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _initGrid();
    _resetSnake();
    _startAutoPilot();
  }

  void _initGrid() {
    final rand = Random(42); // Deterministic realistic GitHub heatmap
    _grid = List.generate(
      rows,
      (r) => List.generate(cols, (c) {
        final val = rand.nextDouble();
        if (val > 0.85) return 4;
        if (val > 0.65) return 3;
        if (val > 0.40) return 2;
        if (val > 0.20) return 1;
        return 0;
      }),
    );
  }

  void _resetSnake() {
    _snake = [
      const Point(4, 3),
      const Point(3, 3),
      const Point(2, 3),
      const Point(1, 3),
    ];
    _direction = Direction.right;
    _score = 0;
    _spawnFood();
  }

  void _spawnFood() {
    final rand = Random();
    int r, c;
    do {
      r = rand.nextInt(rows);
      c = rand.nextInt(cols);
    } while (_snake.contains(Point(c, r)));
    _food = Point(c, r);
  }

  void _startAutoPilot() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(milliseconds: 140), (timer) {
      if (!mounted) return;
      _stepGame();
    });
  }

  void _stepGame() {
    setState(() {
      Point<int> head = _snake.first;

      if (_isAutoPilot) {
        // Simple BFS/heuristic to navigate to food
        final dx = _food.x - head.x;
        final dy = _food.y - head.y;

        if (dx.abs() > dy.abs()) {
          if (dx > 0 && _direction != Direction.left) {
            _direction = Direction.right;
          } else if (dx < 0 && _direction != Direction.right) {
            _direction = Direction.left;
          } else if (dy > 0 && _direction != Direction.up) {
            _direction = Direction.down;
          } else if (dy < 0 && _direction != Direction.down) {
            _direction = Direction.up;
          }
        } else {
          if (dy > 0 && _direction != Direction.up) {
            _direction = Direction.down;
          } else if (dy < 0 && _direction != Direction.down) {
            _direction = Direction.up;
          } else if (dx > 0 && _direction != Direction.left) {
            _direction = Direction.right;
          } else if (dx < 0 && _direction != Direction.right) {
            _direction = Direction.left;
          }
        }
      }

      int nx = head.x;
      int ny = head.y;

      switch (_direction) {
        case Direction.up:
          ny = (ny - 1 + rows) % rows;
          break;
        case Direction.down:
          ny = (ny + 1) % rows;
          break;
        case Direction.left:
          nx = (nx - 1 + cols) % cols;
          break;
        case Direction.right:
          nx = (nx + 1) % cols;
          break;
      }

      final newHead = Point(nx, ny);

      // Check self-collision in manual play mode
      if (!_isAutoPilot && _snake.contains(newHead)) {
        _resetSnake();
        return;
      }

      _snake.insert(0, newHead);

      // Eating food
      if (newHead == _food) {
        _score += 10;
        _grid[newHead.y][newHead.x] = 4; // Max out contribution brightness
        _spawnFood();
      } else {
        _snake.removeLast();
      }
    });
  }

  void _changeDirection(Direction dir) {
    if (_direction == Direction.up && dir == Direction.down) return;
    if (_direction == Direction.down && dir == Direction.up) return;
    if (_direction == Direction.left && dir == Direction.right) return;
    if (_direction == Direction.right && dir == Direction.left) return;
    setState(() {
      _isAutoPilot = false;
      _direction = dir;
    });
  }

  void _openGithub() async {
    final uri = Uri.parse('https://github.com/govindtank');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Error launching github: $e');
    }
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

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
            color: primary.withOpacity(isDark ? 0.08 : 0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.code_rounded, color: AppColors.success, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GitHub Activity & Snake Matrix',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '2,480+ contributions • 142 day streak',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Interactive Mode Badge
              InkWell(
                onTap: () {
                  setState(() {
                    _isAutoPilot = !_isAutoPilot;
                    if (!_isAutoPilot) {
                      _resetSnake();
                    }
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _isAutoPilot
                        ? primary.withOpacity(0.15)
                        : AppColors.accentNeon.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _isAutoPilot ? primary.withOpacity(0.4) : AppColors.accentNeon,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isAutoPilot ? Icons.smart_toy_outlined : Icons.gamepad_outlined,
                        size: 14,
                        color: _isAutoPilot ? primary : AppColors.accentNeon,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _isAutoPilot ? 'Auto-Pilot' : 'Interactive',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _isAutoPilot ? primary : AppColors.accentNeon,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Contribution Heatmap Board
          LayoutBuilder(
            builder: (context, constraints) {
              final cellSize = (constraints.maxWidth - (cols - 1) * 3) / cols;
              final size = cellSize.clamp(6.0, 18.0);

              return Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: List.generate(rows, (r) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(cols, (c) {
                          final isSnakeHead = _snake.isNotEmpty && _snake.first == Point(c, r);
                          final isSnakeBody = _snake.contains(Point(c, r)) && !isSnakeHead;
                          final isFood = _food == Point(c, r);
                          final level = _grid[r][c];

                          Color cellColor;
                          if (isSnakeHead) {
                            cellColor = AppColors.accentNeon;
                          } else if (isSnakeBody) {
                            cellColor = primary;
                          } else if (isFood) {
                            cellColor = const Color(0xFFFF0055);
                          } else {
                            cellColor = _getHeatmapColor(level, isDark);
                          }

                          return Container(
                            width: size,
                            height: size,
                            margin: const EdgeInsets.all(1.5),
                            decoration: BoxDecoration(
                              color: cellColor,
                              borderRadius: BorderRadius.circular(2.5),
                              boxShadow: (isSnakeHead || isFood)
                                  ? [
                                      BoxShadow(
                                        color: cellColor.withOpacity(0.8),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : null,
                            ),
                          );
                        }),
                      );
                    }),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 14),

          // Stats & Interactive Controls Row
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Commits Eaten: ',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                  Text(
                    '$_score',
                    style: GoogleFonts.firaCode(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accentNeon,
                    ),
                  ),
                ],
              ),

              // Manual Play Directional D-Pad (Visible in interactive mode)
              if (!_isAutoPilot)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDpadBtn(Icons.arrow_back_rounded, () => _changeDirection(Direction.left), isDark),
                    _buildDpadBtn(Icons.arrow_upward_rounded, () => _changeDirection(Direction.up), isDark),
                    _buildDpadBtn(Icons.arrow_downward_rounded, () => _changeDirection(Direction.down), isDark),
                    _buildDpadBtn(Icons.arrow_forward_rounded, () => _changeDirection(Direction.right), isDark),
                  ],
                ),

              TextButton.icon(
                onPressed: _openGithub,
                icon: const Icon(Icons.open_in_new_rounded, size: 14),
                label: const Text('github.com/govindtank'),
                style: TextButton.styleFrom(
                  foregroundColor: primary,
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDpadBtn(IconData icon, VoidCallback onTap, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: isDark ? AppColors.darkBorderLight : AppColors.lightBorder),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 16),
        onPressed: onTap,
      ),
    );
  }

  Color _getHeatmapColor(int level, bool isDark) {
    if (isDark) {
      switch (level) {
        case 4:
          return const Color(0xFF10B981);
        case 3:
          return const Color(0xFF059669);
        case 2:
          return const Color(0xFF047857);
        case 1:
          return const Color(0xFF064E3B);
        default:
          return const Color(0xFF1E293B);
      }
    } else {
      switch (level) {
        case 4:
          return const Color(0xFF10B981);
        case 3:
          return const Color(0xFF34D399);
        case 2:
          return const Color(0xFF6EE7B7);
        case 1:
          return const Color(0xFFA7F3D0);
        default:
          return const Color(0xFFE2E8F0);
      }
    }
  }
}
