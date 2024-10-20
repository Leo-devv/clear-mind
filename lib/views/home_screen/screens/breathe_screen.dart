import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:clear_mind/styles/colors.dart';
import 'package:clear_mind/widgets/decorators/container.dart';

class BreatheScreen extends StatefulWidget {
  const BreatheScreen({Key? key}) : super(key: key);

  @override
  _BreatheScreenState createState() => _BreatheScreenState();
}

class _BreatheScreenState extends State<BreatheScreen>
    with TickerProviderStateMixin {
  late AnimationController _breatheController;
  late Animation<double> _breatheAnimation;

  bool _isBreathing = false;
  String _currentPhase = 'Tap to begin';
  int _breathCount = 0;
  String _selectedPattern = 'Calm';

  final Map<String, Map<String, dynamic>> _breathingPatterns = {
    'Calm': {'icon': Icons.spa, 'inhale': 4, 'hold': 7, 'exhale': 8},
    'Energize': {'icon': Icons.bolt, 'inhale': 6, 'hold': 0, 'exhale': 2},
    'Focus': {
      'icon': Icons.center_focus_strong,
      'inhale': 4,
      'hold': 4,
      'exhale': 4
    },
    'Relax': {'icon': Icons.beach_access, 'inhale': 4, 'hold': 4, 'exhale': 6},
  };

  @override
  void initState() {
    super.initState();
    _breatheController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _breatheAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breatheController.dispose();
    super.dispose();
  }

  void _toggleBreathing() {
    setState(() {
      _isBreathing = !_isBreathing;
      if (_isBreathing) {
        _breathCount = 0;
        _breathe();
      } else {
        _breatheController.stop();
        _currentPhase = 'Tap to begin';
      }
    });
  }

  void _breathe() {
    if (!_isBreathing) return;

    final pattern = _breathingPatterns[_selectedPattern]!;

    setState(() => _currentPhase = 'Inhale');
    HapticFeedback.lightImpact();
    _breatheController.duration = Duration(seconds: pattern['inhale']!);
    _breatheController.forward().then((_) {
      if (!_isBreathing) return;
      if (pattern['hold']! > 0) {
        setState(() => _currentPhase = 'Hold');
        Future.delayed(Duration(seconds: pattern['hold']!), () {
          if (!_isBreathing) return;
          setState(() => _currentPhase = 'Exhale');
          HapticFeedback.lightImpact();
          _breatheController.duration = Duration(seconds: pattern['exhale']!);
          _breatheController.reverse().then((_) {
            if (!_isBreathing) return;
            setState(() {
              _breathCount++;
              _currentPhase = 'Hold';
            });
            Future.delayed(Duration(seconds: 1), () {
              _breathe();
            });
          });
        });
      } else {
        setState(() => _currentPhase = 'Exhale');
        HapticFeedback.lightImpact();
        _breatheController.duration = Duration(seconds: pattern['exhale']!);
        _breatheController.reverse().then((_) {
          if (!_isBreathing) return;
          setState(() {
            _breathCount++;
          });
          Future.delayed(Duration(seconds: 1), () {
            _breathe();
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg100,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: _buildBreathingContent(),
            ),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.text100, size: 24),
            onPressed: () => context.pop(),
          ),
          Text(
            'Breathe',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.text100,
            ),
          ),
          IconButton(
            icon: Icon(Icons.info_outline, color: AppColors.text100, size: 24),
            onPressed: () {
              // TODO: Show info modal
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBreathingContent() {
    return GestureDetector(
      onTap: _toggleBreathing,
      child: Center(
        child: _buildBreathingAnimation(),
      ),
    );
  }

  Widget _buildBreathingAnimation() {
    return AnimatedBuilder(
      animation: _breatheAnimation,
      builder: (context, child) {
        return Container(
          width: 250 * _breatheAnimation.value,
          height: 250 * _breatheAnimation.value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.accent200.withOpacity(0.1),
            border: Border.all(
              color: AppColors.accent200.withOpacity(0.5),
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              _currentPhase,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: AppColors.accent200,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.bg200,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align children to start
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBreathCount(),
          SizedBox(height: 20),
          _buildPatternSelector(),
          SizedBox(height: 20),
          _buildStartStopButton(),
        ],
      ),
    );
  }

  Widget _buildBreathCount() {
    return GlassContainer(
      borderRadius: 16,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.air, color: AppColors.accent200),
          SizedBox(width: 8),
          Text(
            'Breath Count: $_breathCount',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.text100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatternSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How do you want to feel?',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.text200,
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _breathingPatterns.entries.map((entry) {
            final pattern = entry.key;
            final icon = entry.value['icon'] as IconData;
            return Tooltip(
              message: pattern,
              child: ChoiceChip(
                label: Icon(
                  icon,
                  color: _selectedPattern == pattern
                      ? AppColors.bg100
                      : AppColors.accent200,
                  size: 24,
                ),
                selected: _selectedPattern == pattern,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedPattern = pattern;
                    });
                  }
                },
                selectedColor: AppColors.accent200,
                backgroundColor: Colors.white,
                padding: EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStartStopButton() {
    return GlassContainer(
      borderRadius: 16,
      child: GestureDetector(
        onTap: _toggleBreathing,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4), // Further reduced height
          width: double.infinity,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isBreathing ? Icons.stop : Icons.play_arrow,
                  color: AppColors.accent200,
                  size: 22, // Slightly reduced icon size
                ),
                SizedBox(width: 8),
                Text(
                  _isBreathing ? 'Stop' : 'Start Breathing',
                  style: GoogleFonts.poppins(
                    fontSize: 15, // Further reduced font size
                    fontWeight: FontWeight.w600,
                    color: AppColors.accent200,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
