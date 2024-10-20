import 'package:flutter/material.dart';
import 'package:clear_mind/styles/colors.dart';
import 'package:clear_mind/widgets/decorators/container.dart';

class WeekTrackerWidget extends StatelessWidget {
  final int daysInARow;
  final int longestChain;
  final DateTime date;

  const WeekTrackerWidget({
    Key? key,
    required this.daysInARow,
    required this.longestChain,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Days in a row: $daysInARow',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _buildWeekDays(),
          ),
          SizedBox(height: 8),
          Divider(color: Colors.grey[300], thickness: 1),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Longest chain: $longestChain day${longestChain != 1 ? 's' : ''}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '${_getMonthName(date.month)} ${date.day}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildWeekDays() {
    final weekDays = ['Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Today'];
    return List.generate(6, (index) {
      final isToday = index == 5;
      final isCompleted = isToday && daysInARow > 0;

      return Row(
        children: [
          if (index > 0) _buildDivider(),
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isCompleted
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFAA77FF), Color(0xFF66347F)],
                        )
                      : null,
                  border: Border.all(
                    color: isCompleted ? Colors.transparent : Colors.grey[300]!,
                    width: 2,
                  ),
                ),
                child: isCompleted
                    ? Icon(Icons.check, color: Colors.white, size: 24)
                    : null,
              ),
              SizedBox(height: 8),
              Text(
                weekDays[index],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  color: isToday ? Colors.black : Colors.grey[400],
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildDivider() {
    return Container(
      width: 10,
      height: 1,
      color: Colors.grey[300],
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return monthNames[month - 1];
  }
}
