import 'package:flutter/material.dart';
import 'package:clear_mind/styles/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'dart:ui';

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

  // Add these new state variables
  bool _isBinaural = false;
  double _binauralFrequency = 7.83; // Default to Schumann resonance
  bool _isNatureSoundsEnabled = false;
  String _selectedNatureSound = 'rain';

  final Map<String, String> _soundUrls = {
    'rainforest':
        'https://soundbible.com/mp3/rainforest_ambience-GlorySunz-1938133500.mp3',
    'ocean': 'https://soundbible.com/mp3/Ocean_Waves-Mike_Koenig-980635527.mp3',
    'white_noise':
        'https://soundbible.com/mp3/White_Noise_TV_Static-SoundBible.com-897772304.mp3',
    'fireplace': 'https://soundbible.com/mp3/Fire_Burning-JaBa-810606813.mp3',
    'thunder':
        'https://soundbible.com/mp3/Thunder_Crack-Mike_Koenig-1661117150.mp3',
    'birds':
        'https://soundbible.com/mp3/Morning_Birds_2-Tomasz_Budzynski-1690704083.mp3',
    'wind': 'https://soundbible.com/mp3/wind-howling-daniel_simon.mp3',
    'stream': 'https://soundbible.com/mp3/Creek-SoundBible.com-2007778707.mp3',
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

    // Implement binaural beats generation if enabled
    if (_isBinaural) {
      // Add logic to generate and play binaural beats
    }

    // Implement nature sounds playback if enabled
    if (_isNatureSoundsEnabled) {
      // Add logic to play selected nature sound
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
    return Scaffold(
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
                      const SizedBox(height: 16),
                      _buildMeditationCard(),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Duration'),
                      const SizedBox(height: 8),
                      _buildDurationSelector(),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Ambient Sound'),
                      const SizedBox(height: 8),
                      _buildAmbientSoundSelector(),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Sound Enhancements'),
                      const SizedBox(height: 8),
                      _buildBinauralBeatsControl(),
                      const SizedBox(height: 16),
                      _buildNatureSoundsControl(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            _buildControlButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 16, bottom: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.text100, size: 24),
            onPressed: () => context.pop(), // Use context.pop() here
          ),
          const SizedBox(width: 8),
          Text(
            'Meditation',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.text100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeditationCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.accent200.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    Icon(Icons.self_improvement, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 16),
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
                      'Focus on your breath',
                      style: TextStyle(fontSize: 14, color: AppColors.text200),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildMeditationTag('Beginner'),
                        const SizedBox(width: 8),
                        _buildMeditationTag('5-30 min'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMeditationTag(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      child: Text(
        tag,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.accent200,
        ),
      ),
    );
  }

  Widget _buildDurationSelector() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Row(
                children: [5, 10, 15, 20, 25, 30].map((duration) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _buildDurationCard(duration),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDurationCard(int duration) {
    final isSelected = duration == selectedDuration;
    return GestureDetector(
      onTap: () => setState(() => selectedDuration = duration),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.accent200 : Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected ? AppColors.accent200 : Colors.grey.withOpacity(0.2),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$duration',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : AppColors.accent200,
              ),
            ),
            Text(
              'min',
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Colors.white : AppColors.text100,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmbientSoundSelector() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Row(
                children: [
                  _buildAmbientSoundCard('Rainforest', Icons.forest),
                  _buildAmbientSoundCard('Ocean', Icons.waves),
                  _buildAmbientSoundCard(
                      'White Noise', Icons.noise_control_off),
                  _buildAmbientSoundCard('Fireplace', Icons.fireplace),
                  _buildAmbientSoundCard('Thunder', Icons.thunderstorm),
                  _buildAmbientSoundCard('Birds', Icons.flutter_dash),
                  _buildAmbientSoundCard('Wind', Icons.air),
                  _buildAmbientSoundCard('Stream', Icons.water),
                ]
                    .map((widget) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: widget,
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmbientSoundCard(String label, IconData icon) {
    final isSelected = _selectedSound == label.toLowerCase();
    return GestureDetector(
      onTap: () => _selectSound(label.toLowerCase()),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.accent200 : Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected ? AppColors.accent200 : Colors.grey.withOpacity(0.2),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isSelected ? Colors.white : AppColors.accent200,
                size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : AppColors.text100,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.text100,
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: Colors.white.withOpacity(0.2), width: 1),
            ),
            child: GestureDetector(
              onTap: _isLoading ? null : _togglePlay,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: _isLoading
                      ? AppColors.bg100.withOpacity(0.8)
                      : (isPlaying
                          ? AppColors.bg100.withOpacity(0.8)
                          : Colors.white),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isLoading)
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.accent200),
                          strokeWidth: 2,
                        ),
                      )
                    else
                      AnimatedIcon(
                        icon: AnimatedIcons.play_pause,
                        progress: isPlaying
                            ? AlwaysStoppedAnimation(1.0)
                            : AlwaysStoppedAnimation(0.0),
                        color: AppColors.accent200,
                        size: 24,
                      ),
                    SizedBox(width: 12),
                    Text(
                      _isLoading
                          ? 'Loading...'
                          : (isPlaying ? timerString : 'Start Meditation'),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.text100,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBinauralBeatsControl() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Binaural Beats',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.text100,
                      ),
                    ),
                    _buildCustomSwitch(_isBinaural, (value) {
                      setState(() {
                        _isBinaural = value;
                      });
                      // Implement binaural beats generation
                    }),
                  ],
                ),
                if (_isBinaural) ...[
                  SizedBox(height: 8),
                  Text(
                    'Frequency: ${_binauralFrequency.toStringAsFixed(2)} Hz',
                    style: TextStyle(fontSize: 12, color: AppColors.text200),
                  ),
                  Slider(
                    value: _binauralFrequency,
                    min: 0.5,
                    max: 40,
                    divisions: 79,
                    onChanged: (value) {
                      setState(() {
                        _binauralFrequency = value;
                      });
                      // Update binaural beats frequency
                    },
                    activeColor: AppColors.accent200,
                    inactiveColor: AppColors.accent200.withOpacity(0.3),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNatureSoundsControl() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nature Sounds',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.text100,
                      ),
                    ),
                    _buildCustomSwitch(_isNatureSoundsEnabled, (value) {
                      setState(() {
                        _isNatureSoundsEnabled = value;
                      });
                      // Implement nature sounds playback
                    }),
                  ],
                ),
                if (_isNatureSoundsEnabled) ...[
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children:
                        ['rain', 'ocean', 'forest', 'stream'].map((sound) {
                      return ChoiceChip(
                        label: Text(sound),
                        selected: _selectedNatureSound == sound,
                        onSelected: (selected) {
                          setState(() {
                            _selectedNatureSound = sound;
                          });
                          // Update nature sound selection
                        },
                        backgroundColor: Colors.white.withOpacity(0.2),
                        selectedColor: AppColors.accent200,
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomSwitch(bool value, Function(bool) onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 50,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: value ? AppColors.accent200 : Colors.grey.withOpacity(0.3),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: value ? 22 : 2,
              top: 2,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
