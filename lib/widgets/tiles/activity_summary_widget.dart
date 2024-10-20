import 'package:flutter/material.dart';
import 'package:clear_mind/styles/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class ActivitySummaryWidget extends StatelessWidget {
  final int exerciseMinutes;
  final int meditationMinutes;

  const ActivitySummaryWidget({
    Key? key,
    required this.exerciseMinutes,
    required this.meditationMinutes,
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
          painter: ActivitySummaryPainter(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildActivitySummary(
                          Icons.directions_run, 'Exercise', exerciseMinutes),
                      _buildActivitySummary(Icons.self_improvement,
                          'Meditation', meditationMinutes),
                    ],
                  ),
                ),
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
            Icons.bar_chart,
            color: Colors.white,
            size: 24,
          ),
        ),
        SizedBox(width: 12),
        Text(
          'Active',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildActivitySummary(IconData icon, String label, int minutes) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.0),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        SizedBox(height: 12),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Text(
          '$minutes min',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class ActivitySummaryPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(20));

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.accent100, AppColors.accent200],
    );

    final paint = Paint()..shader = gradient.createShader(rect);

    canvas.drawRRect(rRect, paint);

    _drawWavyLines(canvas, size);
  }

  void _drawWavyLines(Canvas canvas, Size size) {
    final wavePaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int i = 0; i < 3; i++) {
      final path = Path();
      path.moveTo(0, size.height * (0.2 + i * 0.3));
      for (double x = 0; x <= size.width; x++) {
        final y = math.sin(x / 50 + i) * 10 + size.height * (0.2 + i * 0.3);
        path.lineTo(x, y);
      }
      canvas.drawPath(path, wavePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
