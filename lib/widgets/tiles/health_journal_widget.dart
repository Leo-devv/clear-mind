import 'package:flutter/material.dart';
import 'package:clear_mind/styles/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class HealthJournalWidget extends StatelessWidget {
  final int daysLogged;
  final int totalDays;

  const HealthJournalWidget({
    Key? key,
    required this.daysLogged,
    required this.totalDays,
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
          painter: HealthJournalPainter(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 16),
                _buildStats(),
                SizedBox(height: 16),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return _buildCircleGrid(constraints);
                    },
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
            Icons.favorite,
            color: Colors.white,
            size: 24,
          ),
        ),
        SizedBox(width: 12),
        Text(
          'Activity',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              daysLogged.toString(),
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '/$totalDays days',
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Text(
          '${(daysLogged / totalDays * 100).toStringAsFixed(0)}%',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCircleGrid(BoxConstraints constraints) {
    final availableWidth = constraints.maxWidth;
    final availableHeight = constraints.maxHeight;

    int crossAxisCount = _calculateCrossAxisCount(daysLogged);
    double itemSize =
        (availableWidth - (crossAxisCount - 1) * 2) / crossAxisCount;

    int rowCount = (daysLogged / crossAxisCount).ceil();
    double totalHeight = rowCount * itemSize + (rowCount - 1) * 2;

    while (totalHeight > availableHeight && crossAxisCount < 20) {
      crossAxisCount++;
      itemSize = (availableWidth - (crossAxisCount - 1) * 2) / crossAxisCount;
      rowCount = (daysLogged / crossAxisCount).ceil();
      totalHeight = rowCount * itemSize + (rowCount - 1) * 2;
    }

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 1,
      ),
      itemCount: daysLogged,
      itemBuilder: (context, index) {
        return Container(
          width: itemSize,
          height: itemSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.3),
          ),
        );
      },
    );
  }

  int _calculateCrossAxisCount(int daysLogged) {
    if (daysLogged <= 30) return 6;
    if (daysLogged <= 100) return 10;
    if (daysLogged <= 225) return 15;
    return 20;
  }
}

class HealthJournalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(20));

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
    );

    final paint = Paint()..shader = gradient.createShader(rect);

    canvas.drawRRect(rRect, paint);

    final wavePaint = Paint()
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

    canvas.drawPath(path, wavePaint);

    final glowPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment(-0.5, -0.6),
        radius: 1.0,
        colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.0)],
      ).createShader(rect)
      ..blendMode = BlendMode.screen;

    canvas.drawRRect(rRect, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
