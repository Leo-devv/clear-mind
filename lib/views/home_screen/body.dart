import 'package:flutter/material.dart';
import 'package:clear_mind/styles/colors.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg200,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildWeeklyMoodTracker(),
                    const SizedBox(height: 24),
                    _buildQuickActions(),
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
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 64, // Reduced height
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.bg100,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary300.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(Icons.home_rounded, 'Home', true),
          _buildNavItem(Icons.insights_rounded, 'Insights', false),
          _buildNavItem(Icons.add_circle_outline_rounded, 'Add', false),
          _buildNavItem(Icons.calendar_today_rounded, 'Plan', false),
          _buildNavItem(Icons.person_rounded, 'Profile', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return InkWell(
      onTap: () {
        // TODO: Implement navigation
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.accent200 : AppColors.text200,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.accent200 : AppColors.text200,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good morning,',
              style: TextStyle(fontSize: 16, color: AppColors.text200),
            ),
            Text(
              'Sarah',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text100),
            ),
          ],
        ),
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.accent100,
          child: Icon(Icons.person, color: AppColors.bg100),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildQuickActionItem(
            Icons.self_improvement, 'Meditate', AppColors.primary100),
        _buildQuickActionItem(Icons.edit_note, 'Journal', AppColors.accent100),
        _buildQuickActionItem(Icons.favorite, 'Breathe', AppColors.primary200),
        _buildQuickActionItem(Icons.psychology, 'Therapy', AppColors.accent200),
      ],
    );
  }

  Widget _buildQuickActionItem(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: AppColors.text200, fontSize: 12)),
      ],
    );
  }

  Widget _buildWeeklyMoodTracker() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.bg200,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary300.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
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
            'Daily Goals',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.text100),
          ),
          const SizedBox(height: 16),
          _buildGoalItem('Meditate for 10 minutes', 0.6),
          const SizedBox(height: 12),
          _buildGoalItem('Write in journal', 1.0),
          const SizedBox(height: 12),
          _buildGoalItem('30 minutes of exercise', 0.3),
        ],
      ),
    );
  }

  Widget _buildGoalItem(String title, double progress) {
    return Row(
      children: [
        CircularPercentIndicator(
          radius: 20.0,
          lineWidth: 4.0,
          percent: progress,
          center: Text('${(progress * 100).toInt()}%',
              style: TextStyle(fontSize: 10)),
          progressColor: AppColors.accent200,
          backgroundColor: AppColors.bg300,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(title,
              style: TextStyle(color: AppColors.text200, fontSize: 14)),
        ),
      ],
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
                  color: AppColors.primary200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.spa, color: AppColors.bg100, size: 40),
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
                      style: TextStyle(fontSize: 14, color: AppColors.text200),
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
}
