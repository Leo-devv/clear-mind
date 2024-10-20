import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class MentalWellnessScoreWidget extends StatelessWidget {
  final double score; // Score from 0 to 100
  final String status; // e.g., "Good", "Excellent", "Needs Attention"

  const MentalWellnessScoreWidget({
    Key? key,
    required this.score,
    required this.status,
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
          painter: WellnessScorePainter(score: score),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Expanded(
                  child: Center(
                    child: _buildScoreAndStatus(),
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
            Icons.psychology,
            color: Colors.white,
            size: 24,
          ),
        ),
        SizedBox(width: 12),
        Text(
          'Wellness',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildScoreAndStatus() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${score.toStringAsFixed(0)}',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 64,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          status,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class WellnessScorePainter extends CustomPainter {
  final double score;

  WellnessScorePainter({required this.score});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(20));

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF00C9FF), Color(0xFF92FE9D)],
    );

    final paint = Paint()..shader = gradient.createShader(rect);

    canvas.drawRRect(rRect, paint);

    _drawWavyLines(canvas, size);
    _drawScoreIndicator(canvas, size);
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

  void _drawScoreIndicator(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.85, size.height * 0.5);
    final radius = size.width * 0.12;
    final arcPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(
        center, radius, Paint()..color = Colors.white.withOpacity(0.1));

    final startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * (score / 100);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
