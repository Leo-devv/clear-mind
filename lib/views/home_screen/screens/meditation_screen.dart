import 'package:flutter/material.dart';
import 'package:clear_mind/styles/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:just_audio/just_audio.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({Key? key}) : super(key: key);

  @override
  _MeditationScreenState createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen>
    with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  int selectedDuration = 5; // Default 5 minutes
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _timer;
  int _secondsRemaining = 0;

  late AudioPlayer _audioPlayer;
  String _selectedSound = 'none';
  bool _isLoading = false;

  final Map<String, String> _soundUrls = {
    'rainforest':
        'https://soundbible.com/mp3/rainforest_ambience-GlorySunz-1938133500.mp3',
    'ocean': 'https://soundbible.com/mp3/Ocean_Waves-Mike_Koenig-980635527.mp3',
    'white_noise':
        'https://soundbible.com/mp3/White_Noise_TV_Static-SoundBible.com-897772304.mp3',
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _audioPlayer = AudioPlayer();
    _audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        if (state.processingState == ProcessingState.completed) {
          _stopMeditation();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    _audioPlayer.stop().then((_) => _audioPlayer.dispose());
    super.dispose();
  }

  void _selectSound(String sound) {
    if (mounted) {
      setState(() {
        _selectedSound = sound;
      });
    }
  }

  Future<void> _togglePlay() async {
    if (_isLoading || !mounted) return;

    if (!isPlaying) {
      await _startMeditation();
    } else {
      await _pauseMeditation();
    }
  }

  Future<void> _startMeditation() async {
    if (_selectedSound == 'none' || !mounted) return;

    setState(() => _isLoading = true);

    try {
      final url = _soundUrls[_selectedSound];
      if (url != null) {
        await _audioPlayer.setUrl(url);
        await _audioPlayer.setLoopMode(LoopMode.one);
        await _audioPlayer.play();
        _startTimer();
        if (mounted) {
          setState(() {
            isPlaying = true;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error starting meditation: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        // Show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to start meditation. Please try again.')),
        );
      }
    }
  }

  Future<void> _pauseMeditation() async {
    await _audioPlayer.pause();
    _timer?.cancel();
    if (mounted) {
      setState(() {
        isPlaying = false;
      });
    }
  }

  Future<void> _stopMeditation() async {
    if (!mounted) return;

    setState(() {
      isPlaying = false;
      _secondsRemaining = 0;
    });

    _timer?.cancel();
    await _audioPlayer.stop();
  }

  void _startTimer() {
    _secondsRemaining = selectedDuration * 60;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
          } else {
            _stopMeditation();
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  String get timerString {
    final minutes = (_secondsRemaining / 60).floor().toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isPlaying) {
          await _stopMeditation();
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.bg100,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        _buildMeditationCard(),
                        const SizedBox(height: 30),
                        _buildDurationSelector(),
                        const SizedBox(height: 30),
                        _buildAmbientSoundSelector(),
                        const SizedBox(height: 30),
                        _buildBenefits(),
                        const SizedBox(height: 30),
                        _buildTips(),
                      ],
                    ),
                  ),
                ),
              ),
              _buildControlButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon:
                Icon(Icons.arrow_back_ios, color: AppColors.text100, size: 20),
            onPressed: () => context.go('/'),
          ),
          Text(
            'Meditation',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.text100,
            ),
          ),
          IconButton(
            icon: Icon(Icons.settings_outlined,
                color: AppColors.text100, size: 20),
            onPressed: () {}, // Add functionality for settings
          ),
        ],
      ),
    );
  }

  Widget _buildMeditationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              color: AppColors.accent100.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.self_improvement,
                color: AppColors.accent300, size: 40),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mindful Breathing',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text100,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Focus on your breath and find inner peace',
                  style: TextStyle(fontSize: 14, color: AppColors.text200),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildMeditationTag('Beginner'),
                    const SizedBox(width: 8),
                    _buildMeditationTag('Relaxation'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeditationTag(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accent100.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        tag,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.accent300,
        ),
      ),
    );
  }

  Widget _buildDurationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Duration',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.text100,
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final buttonWidth = (constraints.maxWidth - 3 * 8) /
                4; // 8 is the gap between buttons
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [5, 10, 15, 20].map((duration) {
                return _buildDurationButton(duration, buttonWidth);
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDurationButton(int duration, double width) {
    final isSelected = duration == selectedDuration;
    return GestureDetector(
      onTap: () => setState(() => selectedDuration = duration),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent200 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.accent200 : AppColors.bg300,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: AppColors.accent200.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4))
                ]
              : null,
        ),
        child: Text(
          '$duration min',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.text200,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildAmbientSoundSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ambient Sound',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.text100,
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final buttonWidth = (constraints.maxWidth - 3 * 8) / 2;
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildAmbientSoundButton(
                    'Rainforest', Icons.forest, buttonWidth),
                _buildAmbientSoundButton('Ocean', Icons.waves, buttonWidth),
                _buildAmbientSoundButton(
                    'White Noise', Icons.noise_control_off, buttonWidth),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildAmbientSoundButton(String label, IconData icon, double width) {
    final isSelected = _selectedSound == label.toLowerCase();
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: () => _selectSound(label.toLowerCase()),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.accent200 : Colors.white,
          foregroundColor: isSelected ? Colors.white : AppColors.text200,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
                color: isSelected ? AppColors.accent200 : AppColors.bg300),
          ),
          elevation: isSelected ? 4 : 2,
          shadowColor: Colors.black.withOpacity(0.1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: isSelected ? Colors.white : AppColors.accent300,
                size: 24),
            SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefits() {
    return _buildCard(
      title: 'Benefits',
      content: Column(
        children: [
          _buildBenefitItem(Icons.spa, 'Reduces stress and anxiety'),
          _buildBenefitItem(Icons.favorite, 'Improves emotional well-being'),
          _buildBenefitItem(Icons.psychology, 'Enhances self-awareness'),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent200, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: AppColors.text200),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTips() {
    return _buildCard(
      title: 'Tips for Better Meditation',
      content: Column(
        children: [
          _buildTipItem('Find a quiet and comfortable place'),
          _buildTipItem('Sit in a relaxed position'),
          _buildTipItem('Focus on your breath'),
          _buildTipItem('Be patient and kind to yourself'),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: AppColors.accent200, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: AppColors.text200),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required Widget content}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.text100,
            ),
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  Widget _buildControlButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: GestureDetector(
        onTap: _isLoading ? null : _togglePlay,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: _isLoading
                ? AppColors.accent100
                : (isPlaying ? AppColors.accent100 : AppColors.accent200),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent200.withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                )
              else
                Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              SizedBox(width: 8),
              Text(
                _isLoading
                    ? 'Loading...'
                    : (isPlaying ? timerString : 'Start Meditation'),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
