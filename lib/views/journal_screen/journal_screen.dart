import 'package:flutter/material.dart';
import 'package:clear_mind/styles/colors.dart';
import 'package:intl/intl.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({Key? key}) : super(key: key);

  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _journalEntryController = TextEditingController();
  final List<JournalEntry> _journalEntries = [];
  final List<String> _prompts = [
    "What are you grateful for today?",
    "Describe a challenge you overcame recently.",
    "What's one thing you'd like to improve about yourself?",
    "Write about a person who inspires you and why.",
    "What are your goals for the next month?",
  ];
  String _currentPrompt = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _currentPrompt = _getRandomPrompt();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _journalEntryController.dispose();
    super.dispose();
  }

  String _getRandomPrompt() {
    _prompts.shuffle();
    return _prompts.first;
  }

  void _saveJournalEntry() {
    if (_journalEntryController.text.isNotEmpty) {
      setState(() {
        _journalEntries.add(JournalEntry(
          date: DateTime.now(),
          content: _journalEntryController.text,
          mood: _selectedMood,
        ));
        _journalEntryController.clear();
        _selectedMood = Mood.neutral;
        _currentPrompt = _getRandomPrompt();
      });
      _showSnackBar('Journal entry saved successfully!');
    } else {
      _showSnackBar('Please write something before saving.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Mood _selectedMood = Mood.neutral;

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
                  _buildNewEntryTab(),
                  _buildJournalEntriesTab(),
                  _buildInsightsTab(),
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
            onPressed: () => Navigator.of(context).pop(),
          ),
          Text(
            'Journal',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.text100,
            ),
          ),
          IconButton(
            icon: Icon(Icons.settings, color: AppColors.text100),
            onPressed: () {
              // TODO: Implement settings
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
          Tab(text: 'New Entry'),
          Tab(text: 'Entries'),
          Tab(text: 'Insights'),
        ],
      ),
    );
  }

  Widget _buildNewEntryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMoodSelector(),
          const SizedBox(height: 20),
          _buildPromptCard(),
          const SizedBox(height: 20),
          _buildJournalEntryField(),
          const SizedBox(height: 20),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildMoodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How are you feeling?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.text100,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: Mood.values.map((mood) {
            return GestureDetector(
              onTap: () => setState(() => _selectedMood = mood),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _selectedMood == mood
                          ? AppColors.accent200
                          : AppColors.bg300,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      mood.emoji,
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    mood.name,
                    style: TextStyle(
                      color: _selectedMood == mood
                          ? AppColors.accent200
                          : AppColors.text200,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPromptCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bg100,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary300.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Writing Prompt',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.text100,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _currentPrompt,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.text200,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _currentPrompt = _getRandomPrompt();
              });
            },
            child: Text('Get New Prompt'),
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColors.bg100,
              backgroundColor: AppColors.accent200,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalEntryField() {
    return TextField(
      controller: _journalEntryController,
      maxLines: 10,
      decoration: InputDecoration(
        hintText: 'Start writing your thoughts...',
        fillColor: AppColors.bg100,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveJournalEntry,
        child: Text('Save Entry'),
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColors.bg100,
          backgroundColor: AppColors.accent200,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildJournalEntriesTab() {
    return _journalEntries.isEmpty
        ? Center(
            child: Text(
              'No journal entries yet.\nStart writing to see them here!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.text200,
              ),
            ),
          )
        : ListView.builder(
            itemCount: _journalEntries.length,
            itemBuilder: (context, index) {
              final entry = _journalEntries[_journalEntries.length - 1 - index];
              return _buildJournalEntryCard(entry);
            },
          );
  }

  Widget _buildJournalEntryCard(JournalEntry entry) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMM d, y').format(entry.date),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text100,
                  ),
                ),
                Text(
                  entry.mood.emoji,
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              entry.content,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.text200,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMoodDistributionChart(),
          const SizedBox(height: 20),
          _buildJournalingSummary(),
          const SizedBox(height: 20),
          _buildWordCloudCard(),
        ],
      ),
    );
  }

  Widget _buildMoodDistributionChart() {
    // TODO: Implement mood distribution chart
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bg100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          'Mood Distribution Chart\n(To be implemented)',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.text200,
          ),
        ),
      ),
    );
  }

  Widget _buildJournalingSummary() {
    int totalEntries = _journalEntries.length;
    int streakDays = _calculateStreakDays();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bg100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Journaling Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.text100,
            ),
          ),
          const SizedBox(height: 10),
          Text('Total Entries: $totalEntries'),
          Text('Current Streak: $streakDays days'),
          // Add more statistics here
        ],
      ),
    );
  }

  int _calculateStreakDays() {
    // TODO: Implement streak calculation logic
    return 0;
  }

  Widget _buildWordCloudCard() {
    // TODO: Implement word cloud visualization
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bg100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          'Word Cloud\n(To be implemented)',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.text200,
          ),
        ),
      ),
    );
  }
}

class JournalEntry {
  final DateTime date;
  final String content;
  final Mood mood;

  JournalEntry({required this.date, required this.content, required this.mood});
}

enum Mood {
  happy('😊'),
  sad('😢'),
  angry('😠'),
  excited('😃'),
  neutral('😐');

  final String emoji;
  const Mood(this.emoji);
}
