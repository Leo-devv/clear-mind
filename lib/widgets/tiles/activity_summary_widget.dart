import 'package:flutter/material.dart';
import 'package:clear_mind/styles/colors.dart';

class ActivitySummaryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.accent300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activity Summary',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildActivityIcon(Icons.directions_run, '30 min'),
                    _buildActivityIcon(Icons.self_improvement, '15 min'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityIcon(IconData icon, String duration) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 40),
        SizedBox(height: 8),
        Text(
          duration,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
