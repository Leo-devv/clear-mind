import 'package:flutter/material.dart';
import 'package:clear_mind/styles/colors.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Insights',
          style: TextStyle(color: AppColors.text100),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.insights,
              size: 100,
              color: AppColors.accent200,
            ),
            SizedBox(height: 20),
            Text(
              'Insights Coming Soon',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.text100,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'We\'re working on bringing you valuable insights about your mental health journey.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.text200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
