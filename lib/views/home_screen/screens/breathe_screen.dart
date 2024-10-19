import 'package:flutter/material.dart';
import 'package:clear_mind/styles/colors.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';

class BreatheScreen extends StatefulWidget {
  const BreatheScreen({Key? key}) : super(key: key);

  @override
  _BreatheScreenState createState() => _BreatheScreenState();
}

class _BreatheScreenState extends State<BreatheScreen>
    with TickerProviderStateMixin {
  late AnimationController _breatheController;
  late Animation<double> _breatheAnimation;
  late TabController _tabController;

  int _selectedExerciseIndex = 0;
  int _duration = 60; // Default duration in seconds
  bool _isBreathing = false;
  int _breathCount = 0;
  List<BreathingSession> _sessions = [];

  final List<BreathingExercise> _exercises = [
    BreathingExercise(
      name: 'Box Breathing',
      inhale: 4,
      hold1: 4,
      exhale: 4,
      hold2: 4,
    ),
    BreathingExercise(
      name: '4-7-8 Technique',
      inhale: 4,
      hold1: 7,
      exhale: 8,
      hold2: 0,
    ),
    BreathingExercise(
      name: 'Deep Breathing',
      inhale: 5,
      hold1: 2,
      exhale: 5,
      hold2: 0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _breatheController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _breatheAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOut),
    );
    _tabController = TabController(length: 3, vsync: this);
    _loadSessions();
  }

  @override
  void dispose() {
    _breatheController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _loadSessions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _sessions = (prefs.getStringList('breathing_sessions') ?? [])
          .map((e) => BreathingSession.fromJson(e))
          .toList();
    });
  }

  void _saveSessions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'breathing_sessions',
      _sessions.map((e) => e.toJson()).toList(),
    );
  }

  void _startBreathing() {
    setState(() {
      _isBreathing = true;
      _breathCount = 0;
    });
    _breathe();
  }

  void _stopBreathing() {
    setState(() {
      _isBreathing = false;
    });
    _breatheController.stop();
    _sessions.add(BreathingSession(
      date: DateTime.now(),
      duration: _duration,
      breathCount: _breathCount,
      exerciseName: _exercises[_selectedExerciseIndex].name,
    ));
    _saveSessions();
  }

  void _breathe() {
    if (!_isBreathing) return;

    final exercise = _exercises[_selectedExerciseIndex];
    _breatheController.duration = Duration(seconds: exercise.inhale);
    _breatheController.forward().then((_) {
      if (!_isBreathing) return;
      Future.delayed(Duration(seconds: exercise.hold1), () {
        if (!_isBreathing) return;
        _breatheController.reverse().then((_) {
          if (!_isBreathing) return;
          Future.delayed(Duration(seconds: exercise.hold2), () {
            if (!_isBreathing) return;
            setState(() {
              _breathCount++;
            });
            _breathe();
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg200,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBreathingExercise(),
                  _buildCustomization(),
                  _buildStats(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bg100,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary300.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.text100),
            onPressed: () => context.go('/'),
          ),
          Text(
            'Breathe',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.text100,
            ),
          ),
          IconButton(
            icon: Icon(Icons.info_outline, color: AppColors.text100),
            onPressed: () {
              // TODO: Show info dialog
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppColors.bg100,
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.accent200,
        labelColor: AppColors.accent200,
        unselectedLabelColor: AppColors.text200,
        tabs: const [
          Tab(text: 'Exercise'),
          Tab(text: 'Customize'),
          Tab(text: 'Stats'),
        ],
      ),
    );
  }

  Widget _buildBreathingExercise() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildExerciseSelector(),
          const SizedBox(height: 40),
          _buildBreathingAnimation(),
          const SizedBox(height: 40),
          _buildBreathingControls(),
        ],
      ),
    );
  }

  Widget _buildExerciseSelector() {
    return DropdownButton<int>(
      value: _selectedExerciseIndex,
      items: _exercises.asMap().entries.map((entry) {
        return DropdownMenuItem<int>(
          value: entry.key,
          child: Text(entry.value.name),
        );
      }).toList(),
      onChanged: (int? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedExerciseIndex = newValue;
          });
        }
      },
    );
  }

  Widget _buildBreathingAnimation() {
    return AnimatedBuilder(
      animation: _breatheAnimation,
      builder: (context, child) {
        return Container(
          width: 200 * _breatheAnimation.value,
          height: 200 * _breatheAnimation.value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary200.withOpacity(0.3),
          ),
          child: Center(
            child: Text(
              _isBreathing ? 'Breathe' : 'Ready',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.text100,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBreathingControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _isBreathing ? _stopBreathing : _startBreathing,
          child: Text(_isBreathing ? 'Stop' : 'Start'),
          style: ElevatedButton.styleFrom(
            foregroundColor: AppColors.bg100,
            backgroundColor: _isBreathing ? Colors.red : AppColors.accent200,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Text(
          'Breaths: $_breathCount',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.text100,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomization() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customize Exercise',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.text100,
            ),
          ),
          const SizedBox(height: 20),
          _buildCustomizationSlider('Duration', _duration.toDouble(), 30, 300,
              (value) {
            setState(() {
              _duration = value.round();
            });
          }),
          const SizedBox(height: 20),
          _buildCustomizationSlider(
              'Inhale',
              _exercises[_selectedExerciseIndex].inhale.toDouble(),
              2,
              10, (value) {
            setState(() {
              _exercises[_selectedExerciseIndex].inhale = value.round();
            });
          }),
          const SizedBox(height: 20),
          _buildCustomizationSlider(
              'Hold',
              _exercises[_selectedExerciseIndex].hold1.toDouble(),
              0,
              10, (value) {
            setState(() {
              _exercises[_selectedExerciseIndex].hold1 = value.round();
            });
          }),
          const SizedBox(height: 20),
          _buildCustomizationSlider(
              'Exhale',
              _exercises[_selectedExerciseIndex].exhale.toDouble(),
              2,
              10, (value) {
            setState(() {
              _exercises[_selectedExerciseIndex].exhale = value.round();
            });
          }),
        ],
      ),
    );
  }

  Widget _buildCustomizationSlider(String label, double value, double min,
      double max, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ${value.round()} seconds',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.text100,
          ),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).round(),
          onChanged: onChanged,
          activeColor: AppColors.accent200,
          inactiveColor: AppColors.bg300,
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Breathing Stats',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.text100,
            ),
          ),
          const SizedBox(height: 20),
          _buildBreathingChart(),
          const SizedBox(height: 20),
          _buildBreathingHistory(),
        ],
      ),
    );
  }

  Widget _buildBreathingChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bg100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: _sessions.asMap().entries.map((entry) {
                return FlSpot(
                    entry.key.toDouble(), entry.value.breathCount.toDouble());
              }).toList(),
              isCurved: true,
              color: AppColors.accent200,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreathingHistory() {
    return Expanded(
      child: ListView.builder(
        itemCount: _sessions.length,
        itemBuilder: (context, index) {
          final session = _sessions[_sessions.length - 1 - index];
          return ListTile(
            title: Text(session.exerciseName),
            subtitle: Text(
                '${session.duration} seconds, ${session.breathCount} breaths'),
            trailing: Text(
              '${session.date.day}/${session.date.month}/${session.date.year}',
              style: TextStyle(color: AppColors.text200),
            ),
          );
        },
      ),
    );
  }
}

class BreathingExercise {
  String name;
  int inhale;
  int hold1;
  int exhale;
  int hold2;

  BreathingExercise({
    required this.name,
    required this.inhale,
    required this.hold1,
    required this.exhale,
    required this.hold2,
  });
}

class BreathingSession {
  final DateTime date;
  final int duration;
  final int breathCount;
  final String exerciseName;

  BreathingSession({
    required this.date,
    required this.duration,
    required this.breathCount,
    required this.exerciseName,
  });

  factory BreathingSession.fromJson(String json) {
    final parts = json.split('|');
    return BreathingSession(
      date: DateTime.parse(parts[0]),
      duration: int.parse(parts[1]),
      breathCount: int.parse(parts[2]),
      exerciseName: parts[3],
    );
  }

  String toJson() {
    return '$date|$duration|$breathCount|$exerciseName';
  }
}
