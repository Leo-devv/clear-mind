import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:clear_mind/styles/colors.dart';

class BreatheScreen extends StatefulWidget {
  const BreatheScreen({Key? key}) : super(key: key);

  @override
  _BreatheScreenState createState() => _BreatheScreenState();
}

class _BreatheScreenState extends State<BreatheScreen>
    with TickerProviderStateMixin {
  late AnimationController _breatheController;
  late Animation<double> _breatheAnimation;
  late AnimationController _backgroundController;
  late Animation<Color?> _backgroundAnimation;

  bool _isBreathing = false;
  String _currentPhase = 'Tap to begin';
  int _breathCount = 0;
  int _selectedDuration = 5;

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
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 60),
      vsync: this,
    )..repeat(reverse: true);
    _backgroundAnimation = ColorTween(
      begin: AppColors.bg100,
      end: AppColors.bg200,
    ).animate(_backgroundController);
  }

  @override
  void dispose() {
    _breatheController.dispose();
    _backgroundController.dispose();
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

    setState(() => _currentPhase = 'Inhale');
    HapticFeedback.lightImpact();
    _breatheController.forward().then((_) {
      if (!_isBreathing) return;
      setState(() => _currentPhase = 'Hold');
      Future.delayed(Duration(seconds: 4), () {
        if (!_isBreathing) return;
        setState(() => _currentPhase = 'Exhale');
        HapticFeedback.lightImpact();
        _breatheController.reverse().then((_) {
          if (!_isBreathing) return;
          setState(() {
            _breathCount++;
            _currentPhase = 'Hold';
          });
          Future.delayed(Duration(seconds: 4), () {
            _breathe();
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _backgroundAnimation.value!,
                  AppColors.bg100,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildTopBar(context),
                  Expanded(
                    child: _buildBreathingContent(),
                  ),
                  _buildBottomBar(),
                ],
              ),
            ),
          );
        },
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
            icon:
                Icon(Icons.arrow_back_ios, color: AppColors.text100, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Text(
            'Breathe',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.text100,
            ),
          ),
          IconButton(
            icon: Icon(Icons.info_outline, color: AppColors.text100, size: 20),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBreathingAnimation(),
            SizedBox(height: 40),
            _buildPhaseText(),
            SizedBox(height: 20),
            _buildDurationSelector(),
          ],
        ),
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
            gradient: RadialGradient(
              colors: [
                AppColors.primary100.withOpacity(0.7),
                AppColors.primary200.withOpacity(0.3),
              ],
              stops: [0.5, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary100.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: Text(
              _currentPhase,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w300,
                color: AppColors.text100,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhaseText() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: Text(
        'Breath count: $_breathCount',
        key: ValueKey(_breathCount),
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w300,
          color: AppColors.text200,
        ),
      ),
    );
  }

  Widget _buildDurationSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bg300.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButton<int>(
        value: _selectedDuration,
        items: [5, 10, 15, 20].map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(
              '$value min',
              style: GoogleFonts.poppins(color: AppColors.text100),
            ),
          );
        }).toList(),
        onChanged: (int? newValue) {
          if (newValue != null) {
            setState(() {
              _selectedDuration = newValue;
            });
          }
        },
        dropdownColor: AppColors.bg300,
        style: GoogleFonts.poppins(color: AppColors.text100),
        underline: SizedBox(),
        icon: Icon(Icons.arrow_drop_down, color: AppColors.text100),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: _buildBreathingButton(),
    );
  }

  Widget _buildBreathingButton() {
    return GestureDetector(
      onTap: _toggleBreathing,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isBreathing
                ? [AppColors.accent200, AppColors.accent100]
                : [AppColors.primary200, AppColors.primary100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: _isBreathing
                  ? AppColors.accent200.withOpacity(0.3)
                  : AppColors.primary200.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          _isBreathing ? 'Stop' : 'Start',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.bg100,
          ),
        ),
      ),
    );
  }
}
