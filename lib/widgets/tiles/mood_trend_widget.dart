import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:clear_mind/styles/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class MoodTrendWidget extends StatelessWidget {
  final String currentMood;
  final List<double> moodData;

  const MoodTrendWidget({
    Key? key,
    required this.currentMood,
    required this.moodData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: CustomPaint(
          painter: MoodTrendPainter(moodData),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Spacer(),
                _buildCurrentMood(),
                SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.timeline,
            color: Colors.white,
            size: 24,
          ),
        ),
        SizedBox(width: 12),
        Text(
          'Mood Trend',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentMood() {
    return Row(
      children: [
        Icon(
          _getMoodIcon(currentMood),
          color: Colors.white,
          size: 48,
        ),
        SizedBox(width: 16),
        Text(
          currentMood,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  IconData _getMoodIcon(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return Icons.sentiment_very_satisfied;
      case 'good':
        return Icons.sentiment_satisfied;
      case 'okay':
        return Icons.sentiment_neutral;
      case 'sad':
        return Icons.sentiment_dissatisfied;
      case 'awful':
        return Icons.sentiment_very_dissatisfied;
      default:
        return Icons.mood;
    }
  }
}

class MoodTrendPainter extends CustomPainter {
  final List<double> moodData;

  MoodTrendPainter(this.moodData);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(20));

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF6448FE), Color(0xFF5FC6FF)],
    );

    final paint = Paint()..shader = gradient.createShader(rect);

    canvas.drawRRect(rRect, paint);

    _drawWavyLines(canvas, size);
    _drawMoodGraph(canvas, size);
  }

  void _drawWavyLines(Canvas canvas, Size size) {
    final wavePaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int i = 0; i < 3; i++) {
      final path = Path();
      path.moveTo(0, size.height * (0.2 + i * 0.2));
      for (double x = 0; x <= size.width; x++) {
        final y = math.sin(x / 50 + i) * 10 + size.height * (0.2 + i * 0.2);
        path.lineTo(x, y);
      }
      canvas.drawPath(path, wavePaint);
    }
  }

  void _drawMoodGraph(Canvas canvas, Size size) {
    final graphPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final stepX = size.width / (moodData.length - 1);
    final stepY = size.height * 0.4;

    for (int i = 0; i < moodData.length; i++) {
      final x = i * stepX;
      final y = size.height - moodData[i] * stepY - size.height * 0.1;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      canvas.drawCircle(Offset(x, y), 4, graphPaint);
    }

    canvas.drawPath(path, graphPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
