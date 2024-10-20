import 'package:clear_mind/views/home_screen/body.dart';
import 'package:clear_mind/widgets/decorators/container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'dart:math' as math;
import 'package:clear_mind/screens/mood_log_screen.dart';

class MoodCheckWidget extends StatelessWidget {
  const MoodCheckWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MoodLogScreen()),
        ),
        child: CustomPaint(
          painter: MoodCheckPainter(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'How are you feeling today?',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMoodIcon(
                        'Unhappy', Icons.sentiment_very_dissatisfied),
                    _buildMoodIcon('Stressed', Icons.sentiment_dissatisfied),
                    _buildMoodIcon('Fine', Icons.sentiment_neutral),
                    _buildMoodIcon('Relaxed', Icons.sentiment_satisfied),
                    _buildMoodIcon('Excited', Icons.sentiment_very_satisfied),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => _showMoodLogModal(context),
                  child: Text(
                    'View Mood Journal',
                    style: TextStyle(color: Color(0xFF1E3A8A)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF1E3A8A),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoodIcon(String label, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.2),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 40,
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  void _showMoodLogModal(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => MoodLogModal(),
    );
  }
}

class MoodCheckPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(20));

    // Use the bluish gradient from the third featured tile
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF61A3FE), Color(0xFF63FFD5)],
    );

    final paint = Paint()..shader = gradient.createShader(rect);

    canvas.drawRRect(rRect, paint);

    // Draw multiple wavy lines with varying opacity
    for (var i = 0; i < 4; i++) {
      _drawWavyLine(canvas, size, i * 0.2, (i + 1) * 0.05);
    }

    // Add a subtle glow effect
    final glowPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      size.width * 0.3,
      glowPaint,
    );

    // Draw decorative shapes
    _drawDecorativeShapes(canvas, size);
  }

  void _drawWavyLine(Canvas canvas, Size size, double yOffset, double opacity) {
    final wavePaint = Paint()
      ..color = Colors.white.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    path.moveTo(0, size.height * (0.2 + yOffset));
    for (var x = 0; x <= size.width; x++) {
      final y = math.sin((x / size.width) * 4 * math.pi) * 8 +
          size.height * (0.2 + yOffset);
      path.lineTo(x.toDouble(), y);
    }
    canvas.drawPath(path, wavePaint);
  }

  void _drawDecorativeShapes(Canvas canvas, Size size) {
    final shapePaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Draw a larger circle
    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.2),
      size.width * 0.2,
      shapePaint,
    );

    // Draw a smaller circle
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.8),
      size.width * 0.1,
      shapePaint,
    );

    // Draw a rounded rectangle
    final rrectPath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.6, size.height * 0.6, size.width * 0.3,
            size.height * 0.3),
        Radius.circular(15),
      ));
    canvas.drawPath(rrectPath, shapePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ... (keep the existing MoodLogModal class)

class MoodLogModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            _buildCalendar(),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: HomeTheme.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildDailyMoodLog(),
                      _buildWeeklyMoodLog(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Mood Log',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.black54),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return GlassContainer(
      borderRadius: 20,
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'October 2024',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                .map((day) => Text(day,
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w500)))
                .toList(),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [14, 15, 16, 17, 18, 19, 20]
                .map((date) => Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: date == 20 ? Colors.purple[100] : null,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        '$date',
                        style: TextStyle(
                          color: date == 20 ? Colors.purple : Colors.black87,
                          fontWeight:
                              date == 20 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyMoodLog() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sunday, 20 October',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          GlassContainer(
            borderRadius: 20,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.purple[50],
                      ),
                      child: Icon(Icons.sentiment_satisfied,
                          color: Colors.purple, size: 36),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fine',
                            style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87),
                          ),
                          Text(
                            '12:18 am',
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.black54),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              _buildModernChip('Work'),
                              SizedBox(width: 8),
                              _buildModernChip('Exercise'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.purple.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.purple,
        ),
      ),
    );
  }

  Widget _buildWeeklyMoodLog() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '14-19 October',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          GlassContainer(
            borderRadius: 12,
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.grey[600]),
                SizedBox(width: 12),
                Text(
                  '6 days missing',
                  style: GoogleFonts.poppins(
                      color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
