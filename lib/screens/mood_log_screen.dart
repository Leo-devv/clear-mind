import 'dart:math';
import 'dart:ui';
import 'package:clear_mind/widgets/decorators/container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clear_mind/styles/colors.dart';

class MoodLogScreen extends StatefulWidget {
  @override
  _MoodLogScreenState createState() => _MoodLogScreenState();
}

class _MoodLogScreenState extends State<MoodLogScreen> {
  double _moodValue = 2;
  final List<MoodIcon> _moodIcons = [
    MoodIcon('😢', "Very\nUnhappy", Color(0xFFFF6B6B)),
    MoodIcon('🙁', "Unhappy", Color(0xFFFF9F45)),
    MoodIcon('😐', "Neutral", Color(0xFFFFD93D)),
    MoodIcon('🙂', "Happy", Color(0xFF6BCB77)),
    MoodIcon('😄', "Very\nHappy", Color(0xFF4D96FF)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'How are you feeling?',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _buildMoodDisplay()),
              SizedBox(height: 40),
              _buildMoodSlider(),
              SizedBox(height: 40),
              _buildLogMoodButton(),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodDisplay() {
    int index = _moodValue.round();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _moodIcons[index].emoji,
          style: TextStyle(fontSize: 120),
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildMoodSlider() {
    return GlassContainer(
      borderRadius: 20,
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.transparent,
                inactiveTrackColor: Colors.transparent,
                thumbColor: Colors.white,
                overlayColor: AppColors.accent200.withOpacity(0.1),
                thumbShape: _CustomSliderThumbShape(),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 24),
                trackHeight: 60,
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.accent200.withOpacity(0.2),
                          AppColors.accent200,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                  Slider(
                    value: _moodValue,
                    onChanged: (newValue) {
                      setState(() {
                        _moodValue = newValue;
                      });
                    },
                    min: 0,
                    max: 4,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              return Column(
                children: [
                  Text(
                    _moodIcons[index].emoji,
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _moodIcons[index].label,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text200,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLogMoodButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: Colors.white.withOpacity(0.2), width: 1),
            ),
            child: GestureDetector(
              onTap: () {
                // TODO: Implement mood logging logic
                Navigator.pop(context);
              },
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: AppColors.accent200,
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Log Mood',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.text100,
                      ),
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
}

class MoodIcon {
  final String emoji;
  final String label;
  final Color color;

  MoodIcon(this.emoji, this.label, this.color);
}

class _CustomSliderThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(20, 60);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: 8, height: 50),
        Radius.circular(4),
      ),
      paint,
    );
  }
}
