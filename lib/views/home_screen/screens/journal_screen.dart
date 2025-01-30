import 'package:flutter/material.dart';
import 'package:clear_mind/styles/colors.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:clear_mind/services/journal_service.dart';
import 'package:uuid/uuid.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({Key? key}) : super(key: key);

  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _journalEntryController = TextEditingController();
  List<JournalEntry> _journalEntries = [];
  final List<String> _prompts = [
    "What are you grateful for today?",
    "Describe a challenge you overcame recently.",
    "What's one thing you'd like to improve about yourself?",
    "Write about a person who inspires you and why.",
    "What are your goals for the next month?",
  ];
  String _currentPrompt = "";
  String _selectedMood = "Fine";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _currentPrompt = _getRandomPrompt();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final entries = await JournalService.getEntries();
    setState(() {
      _journalEntries = entries;
    });
  }

  String _getRandomPrompt() {
    _prompts.shuffle();
    return _prompts.first;
  }

  Future<void> _saveEntry() async {
    if (_journalEntryController.text.isEmpty) return;

    final entry = JournalEntry(
      id: const Uuid().v4(),
      content: _journalEntryController.text,
      date: DateTime.now(),
      mood: _selectedMood,
      tags: [],
    );

    await JournalService.addEntry(entry);
    _journalEntryController.clear();
    await _loadEntries();
    setState(() {
      _currentPrompt = _getRandomPrompt();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _journalEntryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg200,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.text100),
          onPressed: () => context.go('/'),
        ),
        title: Text(
          'Journal',
          style: TextStyle(color: AppColors.text100),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.accent200,
          labelColor: AppColors.text100,
          unselectedLabelColor: AppColors.text200,
          tabs: const [
            Tab(text: 'New Entry'),
            Tab(text: 'Past Entries'),
            Tab(text: 'Insights'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNewEntryTab(),
          _buildJournalEntriesTab(),
          _buildInsightsTab(),
        ],
      ),
    );
  }

  Widget _buildNewEntryTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _currentPrompt,
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.text100,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildMoodSelector(),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _journalEntryController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Write your thoughts here...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _saveEntry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent200,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Save Entry'),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How are you feeling?',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.text100,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMoodOption('Unhappy', Icons.sentiment_very_dissatisfied),
                _buildMoodOption('Stressed', Icons.sentiment_dissatisfied),
                _buildMoodOption('Fine', Icons.sentiment_neutral),
                _buildMoodOption('Relaxed', Icons.sentiment_satisfied),
                _buildMoodOption('Excited', Icons.sentiment_very_satisfied),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodOption(String mood, IconData icon) {
    final isSelected = _selectedMood == mood;
    return GestureDetector(
      onTap: () => setState(() => _selectedMood = mood),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.accent200 : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.text200,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            mood,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? AppColors.accent200 : AppColors.text200,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalEntriesTab() {
    if (_journalEntries.isEmpty) {
      return Center(
        child: Text(
          'No entries yet',
          style: TextStyle(color: AppColors.text200),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _journalEntries.length,
      itemBuilder: (context, index) {
        final entry = _journalEntries[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('MMM d, y').format(entry.date),
                      style: TextStyle(
                        color: AppColors.text200,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      entry.mood,
                      style: TextStyle(
                        color: AppColors.accent200,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  entry.content,
                  style: TextStyle(
                    color: AppColors.text100,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInsightsTab() {
    if (_journalEntries.isEmpty) {
      return Center(
        child: Text(
          'No journal entries yet.\nStart writing to see your insights!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.text200,
            fontSize: 16,
          ),
        ),
      );
    }

    // Calculate mood counts
    final moodCounts = <String, int>{};
    for (final entry in _journalEntries) {
      moodCounts[entry.mood] = (moodCounts[entry.mood] ?? 0) + 1;
    }

    // Calculate most common mood safely
    String? mostCommonMood;
    int maxCount = 0;
    moodCounts.forEach((mood, count) {
      if (count > maxCount) {
        maxCount = count;
        mostCommonMood = mood;
      }
    });

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (moodCounts.isNotEmpty) Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mood Distribution',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.text100,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...moodCounts.entries.map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Text(
                                e.key,
                                style: TextStyle(color: AppColors.text200),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: e.value / _journalEntries.length,
                                  backgroundColor: AppColors.bg100,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.accent200),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${e.value}',
                                style: TextStyle(color: AppColors.text200),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statistics',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.text100,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStatItem('Total Entries', '${_journalEntries.length}'),
                    if (mostCommonMood != null)
                      _buildStatItem('Most Common Mood', mostCommonMood!),
                    _buildStatItem(
                      'Journaling Streak',
                      '${_calculateStreak()} days',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: AppColors.text200),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppColors.text100,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  int _calculateStreak() {
    if (_journalEntries.isEmpty) return 0;

    final sortedEntries = List<JournalEntry>.from(_journalEntries)
      ..sort((a, b) => b.date.compareTo(a.date));

    var streak = 1;
    var currentDate = DateTime.now();
    var lastEntryDate = sortedEntries.first.date;

    // If the last entry is not from today, break the streak
    if (!_isSameDay(currentDate, lastEntryDate)) {
      return 0;
    }

    for (var i = 1; i < sortedEntries.length; i++) {
      final previousDate = sortedEntries[i].date;
      if (_isSameDay(
          lastEntryDate.subtract(const Duration(days: 1)), previousDate)) {
        streak++;
        lastEntryDate = previousDate;
      } else {
        break;
      }
    }

    return streak;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
