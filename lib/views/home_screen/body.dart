import 'package:flutter/material.dart';
import 'package:clear_mind/styles/colors.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA), // Very light gray, almost white
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildWeeklyMoodTracker(),
                    const SizedBox(height: 24),
                    _buildQuickActions(context),
                    const SizedBox(height: 24),
                    _buildDailyGoals(),
                    const SizedBox(height: 24),
                    _buildMeditationSection(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      child: _buildGlassContainer(
        borderRadius: 24,
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white
                .withOpacity(0.9), // Increased opacity for bottom nav
            borderRadius: BorderRadius.circular(24),
            border:
                Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(context, Icons.home_rounded, '/', true),
              _buildNavItem(
                  context, Icons.insights_rounded, '/insights', false),
              _buildNavItem(context, Icons.person_rounded, '/profile', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, IconData icon, String route, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          context.go(route);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent100.withOpacity(0.5)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          color: isSelected ? AppColors.accent300 : AppColors.text200,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final now = DateTime.now();
    final dateFormat = DateFormat('EEEE, MMMM d');
    final formattedDate = dateFormat.format(now);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, Sarah',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.text100,
              ),
            ),
            Text(
              formattedDate,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.text200,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.accent100,
            border: Border.all(color: AppColors.accent300, width: 2),
          ),
          child: Icon(
            Icons.person,
            color: AppColors.accent300,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.text100,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildQuickActionItem(context, Icons.self_improvement, 'Meditate',
                AppColors.primary200),
            _buildQuickActionItem(context, Icons.edit_note_rounded, 'Journal',
                AppColors.accent200),
            _buildQuickActionItem(
                context, Icons.air_rounded, 'Breathe', AppColors.primary200),
            _buildQuickActionItem(context, Icons.psychology_alt_rounded,
                'Therapy', AppColors.accent200),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionItem(
      BuildContext context, IconData icon, String label, Color color) {
    return Column(
      children: [
        _buildGlassContainer(
          borderRadius: 20,
          child: Container(
            width: 70,
            height: 70,
            child: Icon(icon, color: AppColors.accent300, size: 32),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: AppColors.text200,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
          width: 24,
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
        color: AppColors.bg100,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary300.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
        Text(
          'Daily Goals',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.text100,
          ),
        ),
        const SizedBox(height: 16),
        _buildGoalItem('Meditate', '10 min', 0.6, Icons.self_improvement),
        const SizedBox(height: 12),
        _buildGoalItem('Journal', '1 entry', 1.0, Icons.edit_note_rounded),
        const SizedBox(height: 12),
        _buildGoalItem('Exercise', '30 min', 0.3, Icons.fitness_center),
      ],
    );
  }

  Widget _buildGoalItem(
      String title, String subtitle, double progress, IconData icon) {
    final color = AppColors.accent300;

    return _buildGlassContainer(
      borderRadius: 16,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text100,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.text200,
                    ),
                  ),
                ],
              ),
            ),
            CircularProgressIndicator(
              value: progress,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              strokeWidth: 5,
            ),
          ],
        ),
      ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Daily Tip',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.text100,
                      fontSize: 18)),
              Icon(Icons.lightbulb, color: AppColors.accent200),
            ],
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
    return _buildGlassContainer(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recommended Meditation',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text100),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.accent100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.spa, color: AppColors.accent300, size: 40),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Calm Mind',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text100),
                      ),
                      Text(
                        '10 minutes • Beginner',
                        style:
                            TextStyle(fontSize: 14, color: AppColors.text200),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Start'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: AppColors.bg100,
                          backgroundColor: AppColors.accent200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJournalPrompt() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bg100,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary300.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8), // Increased opacity
              borderRadius: BorderRadius.circular(borderRadius),
              border:
                  Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
