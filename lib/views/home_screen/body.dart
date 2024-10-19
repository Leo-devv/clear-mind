import 'package:flutter/material.dart';
import 'package:clear_mind/styles/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the height of the bottom navigation bar plus some extra padding
    final bottomPadding = MediaQuery.of(context).padding.bottom + 20.0;

    return Stack(
      children: [
        CustomPaint(
          painter: MorningSkyPainter(),
          size: Size.infinite,
        ),
        CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, bottomPadding),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildWeeklyMoodTracker(),
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
      ],
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
                    color: Color(0xFF2D3142),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Sarah',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
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
                    color: Color(0xFF2D3142).withOpacity(0.7),
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF4F5D75).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    iconData,
                    color: Color(0xFF4F5D75),
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
            color: AppColors.text100,
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
                  Color(0xFF6A11CB),
                  [Icons.spa, Icons.air, Icons.waves],
                  width: itemWidth,
                  height: itemHeight,
                ),
                _buildQuickActionItem(
                  context,
                  Icons.edit_note_rounded,
                  'Journal',
                  '/journal',
                  Color(0xFF5643CC),
                  [Icons.book, Icons.create, Icons.mood],
                  width: itemWidth,
                  height: itemHeight,
                ),
                _buildQuickActionItem(
                  context,
                  Icons.air_rounded,
                  'Breathe',
                  '/breathe',
                  Color(0xFF4B3CCC),
                  [Icons.favorite, Icons.cloud, Icons.nature],
                  width: itemWidth,
                  height: itemHeight,
                ),
                _buildQuickActionItem(
                  context,
                  Icons.psychology_alt_rounded,
                  'Therapy',
                  '/therapy',
                  Color(0xFF7E57C2),
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
      child: SizedBox(
        width: width,
        height: height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity(0.7),
                    color.withOpacity(0.4),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
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
                        color: Colors.white,
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
                                      color: Colors.white.withOpacity(0.6),
                                      size: 12,
                                    ),
                                  ))
                              .toList(),
                        ),
                        Icon(
                          icon,
                          color: Colors.white.withOpacity(0.8),
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
      ),
    );
  }

  Widget _buildWeeklyMoodTracker() {
    return _buildGlassContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDayMood('Su', 0.8, AppColors.primary100),
            _buildDayMood('Mo', 0.6, AppColors.accent100),
            _buildDayMood('Tu', 0.4, AppColors.primary200),
            _buildDayMood('We', 0.7, AppColors.accent200),
            _buildDayMood('Th', 0.9, AppColors.primary300),
            _buildDayMood('Fr', 0.5, Colors.orange),
            _buildDayMood('Sa', 0.3, AppColors.primary100),
          ],
        ),
      ),
    );
  }

  Widget _buildDayMood(String day, double moodLevel, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          day,
          style: TextStyle(
            color: AppColors.text200,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 20,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.bg300.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 24,
                height: 120 * moodLevel,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.topCenter,
                    colors: [
                      color.withOpacity(0.7),
                      color.withOpacity(0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Container(
                width: 16,
                height: 2,
                decoration: BoxDecoration(
                  color: AppColors.bg100,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMoodTracker() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How are you feeling today?',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.text100),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMoodItem('😊', 'Happy'),
              _buildMoodItem('😐', 'Neutral'),
              _buildMoodItem('😔', 'Sad'),
              _buildMoodItem('😠', 'Angry'),
              _buildMoodItem('😰', 'Anxious'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodItem(String emoji, String label) {
    return Column(
      children: [
        Text(emoji, style: TextStyle(fontSize: 32)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: AppColors.text200, fontSize: 12)),
      ],
    );
  }

  Widget _buildDailyGoals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Daily Goals'),
        const SizedBox(height: 16),
        _buildGlassContainer(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildGoalItem('Meditate', '10 min', 0.6,
                    Icons.self_improvement, Color(0xFF6A11CB)),
                _buildGoalItem('Journal', '1 entry', 1.0,
                    Icons.edit_note_rounded, Color(0xFF5643CC)),
                _buildGoalItem('Gratitude', '3 things', 0.3,
                    Icons.favorite_outline, Color(0xFF4B3CCC)),
              ],
            ),
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
                      color: Colors.white.withOpacity(0.3),
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
            color: AppColors.text100,
          ),
        ),
        Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColors.text200,
          ),
        ),
      ],
    );
  }

  Widget _buildDailyTip() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Tip',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.text100),
          ),
          const SizedBox(height: 12),
          Text(
            'Practice gratitude by writing down three things youre thankful for each day.',
            style: TextStyle(color: AppColors.text200, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildMeditationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Meditation'),
        const SizedBox(height: 16),
        _buildGlassContainer(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color(0xFF6A11CB).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(Icons.spa, color: Color(0xFF6A11CB), size: 50),
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
                          color: AppColors.text100,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '10 minutes • Beginner',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.text200,
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
        ),
      ],
    );
  }

  Widget _buildMeditationTag(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Color(0xFF6A11CB).withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        tag,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF6A11CB),
        ),
      ),
    );
  }

  Widget _buildJournalPrompt() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Journal Prompt',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.text100),
          ),
          const SizedBox(height: 12),
          Text(
            'Whats one small thing you can do today to improve your mood?',
            style: TextStyle(fontSize: 14, color: AppColors.text200),
          ),
          const SizedBox(height: 16),
          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Start writing...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.bg300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.accent200),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassContainer(
      {required Widget child, double borderRadius = 20}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white
                .withOpacity(0.8), // Increased opacity for better contrast
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
                color: Colors.white.withOpacity(0.6),
                width: 1.5), // Increased opacity
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.accent200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.text100,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class MorningSkyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final LinearGradient gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFD8E1EB), // Darker blue-gray
        Color(0xFFEAEEF3), // Darker off-white
      ],
      stops: [0.0, 1.0],
    );

    final Paint paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);

    // Draw subtle accent
    final accentPaint = Paint()
      ..color =
          Color(0xFFC5D1E0).withOpacity(0.3) // Even darker and more transparent
      ..style = PaintingStyle.fill;

    Path accentPath = Path()
      ..moveTo(0, size.height * 0.35)
      ..quadraticBezierTo(
          size.width * 0.5, size.height * 0.2, size.width, size.height * 0.3)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(accentPath, accentPaint);

    // Draw abstract sun
    final sunPaint = Paint()
      ..color = Color(0xFFFFF0B3)
          .withOpacity(0.1) // Darker yellow, even more transparent
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.1),
        size.width * 0.15, sunPaint);

    // Draw abstract clouds
    final cloudPaint = Paint()
      ..color = Colors.white.withOpacity(0.2) // Even more transparent
      ..style = PaintingStyle.fill;

    Path cloudPath1 = Path()
      ..moveTo(size.width * 0.1, size.height * 0.15)
      ..quadraticBezierTo(size.width * 0.2, size.height * 0.1, size.width * 0.3,
          size.height * 0.15)
      ..quadraticBezierTo(size.width * 0.4, size.height * 0.2, size.width * 0.5,
          size.height * 0.15);

    Path cloudPath2 = Path()
      ..moveTo(size.width * 0.4, size.height * 0.25)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.2, size.width * 0.6,
          size.height * 0.25)
      ..quadraticBezierTo(size.width * 0.7, size.height * 0.3, size.width * 0.8,
          size.height * 0.25);

    canvas.drawPath(cloudPath1, cloudPaint);
    canvas.drawPath(cloudPath2, cloudPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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

    // Draw subtle background circle
    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = color.withOpacity(0.1);

    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    // Draw progress arc
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
        colors: [
          color.withOpacity(0.8),
          color.withOpacity(0.6),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -1.5708, // Start from the top (90 degrees)
      progress * 2 * 3.14159, // Full circle is 2*pi radians
      false,
      paint,
    );

    // Draw glassy highlight
    final highlightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth / 2
      ..color = Colors.white.withOpacity(0.4);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -1.5708,
      0.7853981633974483, // 45 degrees
      false,
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
