import 'package:flutter/material.dart';
import 'package:clear_mind/styles/colors.dart';
import 'package:go_router/go_router.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({Key? key}) : super(key: key);

  @override
  _MeditationScreenState createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  bool isPlaying = false;
  int selectedDuration = 5; // Default 5 minutes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg200,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 40),
              _buildMeditationCard(),
              const SizedBox(height: 40),
              _buildDurationSelector(),
              const Spacer(),
              _buildControlButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.text100),
          onPressed: () {
            // Use context.go('/') instead of Navigator.pop(context)
            context.go('/home');
          },
        ),
        Text(
          'Meditation',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.text100,
          ),
        ),
        const SizedBox(width: 40), // For balance
      ],
    );
  }

  Widget _buildMeditationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bg100,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary300.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary200,
              borderRadius: BorderRadius.circular(15),
            ),
            child:
                Icon(Icons.self_improvement, color: AppColors.bg100, size: 40),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Calm Mind',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text100,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Guided meditation for relaxation',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.text200,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Duration',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.text100,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [5, 10, 15, 20].map((duration) {
            return _buildDurationButton(duration);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDurationButton(int duration) {
    final isSelected = duration == selectedDuration;
    return GestureDetector(
      onTap: () => setState(() => selectedDuration = duration),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent200 : AppColors.bg100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '$duration min',
          style: TextStyle(
            color: isSelected ? AppColors.bg100 : AppColors.text200,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton() {
    return GestureDetector(
      onTap: () => setState(() => isPlaying = !isPlaying),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.accent200,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            isPlaying ? 'Pause' : 'Start Meditation',
            style: TextStyle(
              color: AppColors.bg100,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
