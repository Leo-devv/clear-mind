import 'package:flutter/material.dart';

class MoodTracker extends StatelessWidget {
  const MoodTracker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How are you feeling?',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMoodButton(context, '😊', 'Great'),
              _buildMoodButton(context, '😌', 'Good'),
              _buildMoodButton(context, '😐', 'Okay'),
              _buildMoodButton(context, '😔', 'Low'),
              _buildMoodButton(context, '😢', 'Bad'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodButton(BuildContext context, String emoji, String label) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            // TODO: Implement mood selection
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.background,
            foregroundColor: Theme.of(context).colorScheme.primary,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(12),
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 24)),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
