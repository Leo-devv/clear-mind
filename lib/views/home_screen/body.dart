import 'dart:ui';
import 'dart:math' as math;

import 'package:clear_mind/styles/colors.dart';
import 'package:clear_mind/widgets/tiles/mood_check_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:clear_mind/widgets/decorators/container.dart';

class HomeTheme {
  static const Color background = Color(0xFFF5F7FA);
  static const Color primary = Color(0xFF3498DB);
  static const Color secondary = Color(0xFF2ECC71);
  static const Color accent = Color(0xFFE74C3C);
  static const Color text = Color(0xFF2C3E50);
  static const Color textLight = Color(0xFF7F8C8D);
  static const Color cardBackground = Colors.white;
}

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom + 20.0;

    return Container(
      color: HomeTheme.background,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, bottomPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildHeader(),
                const SizedBox(height: 20),
                MoodCheckWidget(),
                const SizedBox(height: 24),
                _buildQuickActions(context),
                const SizedBox(height: 24),
                _buildFeaturedContent(context),
                const SizedBox(height: 24),
                _buildMeditationSection(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final now = DateTime.now();
    final hour = now.hour;
    final greeting = hour < 12
        ? 'Good Morning'
        : (hour < 17 ? 'Good Afternoon' : 'Good Evening');
    final iconData =
        hour < 17 ? Icons.light_mode_rounded : Icons.dark_mode_rounded;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: HomeTheme.textLight,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Sarah',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: HomeTheme.text,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  DateFormat('MMM d').format(now),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: HomeTheme.textLight,
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: HomeTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    iconData,
                    color: HomeTheme.primary,
                    size: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    // Define a new color palette
    final tileColors = [
      Color(0xFF64B5F6), // Light Blue
      Color(0xFF81C784), // Light Green
      Color(0xFFFFB74D), // Light Orange
      Color(0xFFBA68C8), // Light Purple
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Explore',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: HomeTheme.text,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final baseHeight = maxWidth * 0.3;
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildQuickActionItem(
                        context,
                        Icons.spa,
                        'Meditate',
                        '/meditation',
                        tileColors[0],
                        height: baseHeight * 1.2,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: _buildQuickActionItem(
                        context,
                        Icons.edit,
                        'Journal',
                        '/journal',
                        tileColors[1],
                        height: baseHeight * 1.2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildQuickActionItem(
                        context,
                        Icons.air,
                        'Breathe',
                        '/breathe',
                        tileColors[2],
                        height: baseHeight,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: _buildQuickActionItem(
                        context,
                        Icons.psychology,
                        'Therapy',
                        '/therapy',
                        tileColors[3],
                        height: baseHeight,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickActionItem(
    BuildContext context,
    IconData icon,
    String label,
    String route,
    Color color, {
    required double height,
  }) {
    return GestureDetector(
      onTap: () => context.go(route),
      child: Container(
        height: height,
        child: CustomPaint(
          painter: QuickActionPainter(color),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Featured for You',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: HomeTheme.text,
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFeaturedItem(
                context,
                'Mindful Breathing',
                'Learn a simple technique to reduce stress',
                Icons.air,
                [Color(0xFF6448FE), Color(0xFF5FC6FF)],
              ),
              SizedBox(width: 16),
              _buildFeaturedItem(
                context,
                'Gratitude Journal',
                'Boost your mood with daily gratitude',
                Icons.favorite,
                [Color(0xFFFE6197), Color(0xFFFFB463)],
              ),
              SizedBox(width: 16),
              _buildFeaturedItem(
                context,
                'Sleep Stories',
                'Relax and fall asleep with calming stories',
                Icons.nightlight_round,
                [Color(0xFF61A3FE), Color(0xFF63FFD5)],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedItem(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    List<Color> gradientColors,
  ) {
    return GestureDetector(
      onTap: () {
        // TODO: Implement navigation to featured content
      },
      child: Container(
        width: 200,
        height: 250,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: FeatureCardPainter(gradientColors),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, color: Colors.white, size: 32),
                  ),
                  Spacer(),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeditationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Meditation'),
        const SizedBox(height: 16),
        GlassContainer(
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: HomeTheme.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.spa, color: HomeTheme.primary, size: 50),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calm Mind',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: HomeTheme.text,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '10 minutes • Beginner',
                      style: TextStyle(
                        fontSize: 14,
                        color: HomeTheme.textLight,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildMeditationTag('Stress Relief'),
                        const SizedBox(width: 8),
                        _buildMeditationTag('Focus'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMeditationTag(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: HomeTheme.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        tag,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: HomeTheme.primary,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: HomeTheme.text,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class GlassyCircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  GlassyCircularProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 6.0;

    // Draw background circle
    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = color.withOpacity(0.2);

    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    // Draw progress arc
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = color;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -1.5708, // Start from the top (90 degrees)
      progress * 2 * 3.14159, // Full circle is 2*pi radians
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class FeatureCardPainter extends CustomPainter {
  final List<Color> gradientColors;

  FeatureCardPainter(this.gradientColors);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(20));

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradientColors,
      ).createShader(rect);

    canvas.drawRRect(rRect, paint);

    final wavePaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    for (var i = 0; i < 3; i++) {
      path.reset();
      path.moveTo(0, size.height * (0.5 + i * 0.2));
      for (var x = 0; x <= size.width; x++) {
        final y = math.sin((x / size.width) * 4 * math.pi) * 10 +
            size.height * (0.5 + i * 0.2);
        path.lineTo(x.toDouble(), y);
      }
      canvas.drawPath(path, wavePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class QuickActionPainter extends CustomPainter {
  final Color color;

  QuickActionPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(20));

    // Create a base gradient
    final baseGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        color.withOpacity(0.8),
        color,
      ],
    );

    final basePaint = Paint()
      ..shader = baseGradient.createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(rRect, basePaint);

    // Add a subtle glow effect
    final glowPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment(-0.5, -0.6),
        radius: 1.0,
        colors: [
          color.withOpacity(0.3),
          color.withOpacity(0.0),
        ],
      ).createShader(rect)
      ..blendMode = BlendMode.screen;

    canvas.drawRRect(rRect, glowPaint);

    // Add improved subtle curved lines
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.2,
      size.width,
      size.height * 0.5,
    );

    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.8,
      size.width,
      size.height * 0.3,
    );

    canvas.drawPath(path, linePaint);

    // Add a subtle overlay for depth
    final overlayPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, size.height * 0.6, size.width, size.height * 0.4),
        Radius.circular(20),
      ),
      overlayPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
