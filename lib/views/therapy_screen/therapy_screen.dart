import 'package:flutter/material.dart';
import 'package:clear_mind/styles/colors.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

class TherapyScreen extends StatefulWidget {
  const TherapyScreen({Key? key}) : super(key: key);

  @override
  _TherapyScreenState createState() => _TherapyScreenState();
}

class _TherapyScreenState extends State<TherapyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  List<Therapist> _therapists = [];
  List<Appointment> _appointments = [];
  int _selectedMoodIndex = -1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadTherapists();
    _loadAppointments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadTherapists() {
    // TODO: Load therapists from API or local storage
    _therapists = [
      Therapist(
          name: "Dr. Emily Johnson",
          specialization: "Cognitive Behavioral Therapy",
          rating: 4.8),
      Therapist(
          name: "Dr. Michael Chen",
          specialization: "Family Therapy",
          rating: 4.6),
      Therapist(
          name: "Dr. Sarah Williams",
          specialization: "Anxiety and Depression",
          rating: 4.9),
    ];
  }

  void _loadAppointments() {
    // TODO: Load appointments from API or local storage
    _appointments = [
      Appointment(
          therapist: _therapists[0],
          dateTime: DateTime.now().add(Duration(days: 2))),
      Appointment(
          therapist: _therapists[1],
          dateTime: DateTime.now().add(Duration(days: 5))),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg200,
      appBar: AppBar(
        title: Text('Therapy', style: TextStyle(color: AppColors.text100)),
        backgroundColor: AppColors.bg100,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.accent200,
          labelColor: AppColors.accent200,
          unselectedLabelColor: AppColors.text200,
          tabs: [
            Tab(text: 'Find'),
            Tab(text: 'Appointments'),
            Tab(text: 'Mood'),
            Tab(text: 'Resources'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFindTherapistsTab(),
          _buildAppointmentsTab(),
          _buildMoodTrackingTab(),
          _buildResourcesTab(),
        ],
      ),
    );
  }

  Widget _buildFindTherapistsTab() {
    return ListView.builder(
      itemCount: _therapists.length,
      itemBuilder: (context, index) {
        final therapist = _therapists[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(therapist.name[0]),
              backgroundColor: AppColors.primary200,
            ),
            title: Text(therapist.name),
            subtitle: Text(therapist.specialization),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, color: Colors.amber),
                SizedBox(width: 4),
                Text(therapist.rating.toString()),
              ],
            ),
            onTap: () => _showTherapistDetails(therapist),
          ),
        );
      },
    );
  }

  void _showTherapistDetails(Therapist therapist) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(therapist.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(therapist.specialization),
              SizedBox(height: 16),
              Text('About:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _bookAppointment(therapist),
                child: Text('Book Appointment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent200,
                  foregroundColor: AppColors.bg100,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _bookAppointment(Therapist therapist) {
    // TODO: Implement appointment booking logic
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Appointment booked with ${therapist.name}')),
    );
  }

  Widget _buildAppointmentsTab() {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2021, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarFormat: _calendarFormat,
          onDaySelected: _onDaySelected,
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _appointments.length,
            itemBuilder: (context, index) {
              final appointment = _appointments[index];
              return ListTile(
                title: Text(appointment.therapist.name),
                subtitle: Text(appointment.dateTime.toString()),
                trailing: IconButton(
                  icon: Icon(Icons.video_call),
                  onPressed: () => _startVideoCall(appointment),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _startVideoCall(Appointment appointment) async {
    // TODO: Implement actual video call integration
    const url = 'https://meet.google.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch video call')),
      );
    }
  }

  Widget _buildMoodTrackingTab() {
    final moods = ['😊', '😐', '😔', '😠', '😰'];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'How are you feeling today?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Wrap(
          spacing: 16,
          children: List.generate(moods.length, (index) {
            return GestureDetector(
              onTap: () => setState(() => _selectedMoodIndex = index),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _selectedMoodIndex == index
                      ? AppColors.accent100
                      : AppColors.bg100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(moods[index], style: TextStyle(fontSize: 32)),
              ),
            );
          }),
        ),
        SizedBox(height: 32),
        ElevatedButton(
          onPressed: _saveMood,
          child: Text('Save Mood'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent200,
            foregroundColor: AppColors.bg100,
          ),
        ),
        Expanded(
          child: _buildMoodChart(),
        ),
      ],
    );
  }

  void _saveMood() {
    if (_selectedMoodIndex != -1) {
      // TODO: Save mood to database or API
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mood saved successfully')),
      );
    }
  }

  Widget _buildMoodChart() {
    // TODO: Implement mood chart using a charting library
    return Center(
      child: Text('Mood chart will be displayed here'),
    );
  }

  Widget _buildResourcesTab() {
    final resources = [
      Resource(
          title: 'Understanding Anxiety',
          url: 'https://www.example.com/anxiety'),
      Resource(
          title: 'Coping with Depression',
          url: 'https://www.example.com/depression'),
      Resource(
          title: 'Stress Management Techniques',
          url: 'https://www.example.com/stress'),
      Resource(
          title: 'Building Healthy Relationships',
          url: 'https://www.example.com/relationships'),
    ];

    return ListView.builder(
      itemCount: resources.length,
      itemBuilder: (context, index) {
        final resource = resources[index];
        return ListTile(
          title: Text(resource.title),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () => _openResourceUrl(resource.url),
        );
      },
    );
  }

  void _openResourceUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open the resource')),
      );
    }
  }
}

class Therapist {
  final String name;
  final String specialization;
  final double rating;

  Therapist(
      {required this.name, required this.specialization, required this.rating});
}

class Appointment {
  final Therapist therapist;
  final DateTime dateTime;

  Appointment({required this.therapist, required this.dateTime});
}

class Resource {
  final String title;
  final String url;

  Resource({required this.title, required this.url});
}
