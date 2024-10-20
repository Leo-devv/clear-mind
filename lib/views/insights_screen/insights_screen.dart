import 'package:clear_mind/widgets/tiles/activity_summary_widget.dart';
import 'package:clear_mind/widgets/tiles/health_journal_widget.dart';
import 'package:clear_mind/widgets/tiles/mood_trend_widget.dart';
import 'package:clear_mind/widgets/tiles/wellness_score_widget.dart';
import 'package:flutter/material.dart';
import 'package:clear_mind/styles/colors.dart';
import 'package:clear_mind/widgets/tiles/week_tracker_widget.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              snap: false,
              centerTitle: false,
              title: Text(
                'Insights',
                style: TextStyle(
                  color: AppColors.text100,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: WeekTrackerWidget(
                  daysInARow: 1,
                  longestChain: 1,
                  date: DateTime.now(),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildListDelegate([
                  HealthJournalWidget(daysLogged: 60, totalDays: 365),
                  MoodTrendWidget(
                    currentMood: 'Sad',
                    moodData: [0.2, 0.5, 0.8, 0.3, 0.6, 0.4, 0.7],
                  ),
                  ActivitySummaryWidget(),
                  MentalWellnessScoreWidget(
                    score: 75,
                    status: 'Good',
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
