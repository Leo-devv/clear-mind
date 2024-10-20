import 'dart:ui';

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
                MoodCheckWidget(), // Use the new widget here
                const SizedBox(height: 24),
                _buildQuickActions(context),
                const SizedBox(height: 24),
                _buildDailyGoals(),
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
            final itemWidth = (constraints.maxWidth - 12) / 2;
            final itemHeight = itemWidth * 0.6;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildQuickActionItem(
                  context,
                  Icons.self_improvement,
                  'Meditate',
                  '/meditation',
                  HomeTheme.primary,
                  [Icons.spa, Icons.air, Icons.waves],
                  width: itemWidth,
                  height: itemHeight,
                ),
                _buildQuickActionItem(
                  context,
                  Icons.edit_note_rounded,
                  'Journal',
                  '/journal',
                  HomeTheme.secondary,
                  [Icons.book, Icons.create, Icons.mood],
                  width: itemWidth,
                  height: itemHeight,
                ),
                _buildQuickActionItem(
                  context,
                  Icons.air_rounded,
                  'Breathe',
                  '/breathe',
                  HomeTheme.accent,
                  [Icons.favorite, Icons.cloud, Icons.nature],
                  width: itemWidth,
                  height: itemHeight,
                ),
                _buildQuickActionItem(
                  context,
                  Icons.psychology_alt_rounded,
                  'Therapy',
                  '/therapy',
                  HomeTheme.accent,
                  [Icons.chat_bubble, Icons.people, Icons.healing],
                  width: itemWidth,
                  height: itemHeight,
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
    Color color,
    List<IconData> smallIcons, {
    required double width,
    required double height,
  }) {
    return GestureDetector(
      onTap: () => context.go(route),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: HomeTheme.cardBackground.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      color: HomeTheme.text,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: smallIcons
                            .map((smallIcon) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Icon(
                                    smallIcon,
                                    color: HomeTheme.textLight,
                                    size: 12,
                                  ),
                                ))
                            .toList(),
                      ),
                      Icon(
                        icon,
                        color: color,
                        size: 28,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDailyGoals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Daily Goals'),
        const SizedBox(height: 16),
        GlassContainer(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildGoalItem('Meditate', '10 min', 0.6, Icons.self_improvement,
                  HomeTheme.primary),
              _buildGoalItem('Journal', '1 entry', 1.0, Icons.edit_note_rounded,
                  HomeTheme.secondary),
              _buildGoalItem('Gratitude', '3 things', 0.3,
                  Icons.favorite_outline, HomeTheme.accent),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGoalItem(String title, String subtitle, double progress,
      IconData icon, Color color) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.15),
                  ),
                  child: CustomPaint(
                    painter: GlassyCircularProgressPainter(
                      progress: progress,
                      color: color,
                    ),
                  ),
                ),
              ),
            ),
            ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.2),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(icon, color: color.withOpacity(0.8), size: 28),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: HomeTheme.text,
          ),
        ),
        Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: HomeTheme.textLight,
          ),
        ),
      ],
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
