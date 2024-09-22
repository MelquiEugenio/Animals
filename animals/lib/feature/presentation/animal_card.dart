import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AnimalCard extends StatefulWidget {
  final String animalName;
  final String imageAsset;
  final String soundAsset;
  final String animalNameSoundAsset;
  final bool microphonePermission;

  const AnimalCard({
    super.key,
    required this.animalName,
    required this.imageAsset,
    required this.soundAsset,
    required this.animalNameSoundAsset,
    required this.microphonePermission,
  });

  @override
  State<AnimalCard> createState() => _AnimalCardState();
}

class _AnimalCardState extends State<AnimalCard>
    with SingleTickerProviderStateMixin {
  late final AudioPlayer _player;
  late final AudioPlayer
      _recordingFinishPlayer; // New AudioPlayer for finish sound
  late final stt.SpeechToText _speechToText;
  Color _backgroundColor = Colors.white;
  bool _isSpeechAvailable = false;
  bool _isRecording = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _recordingFinishPlayer = AudioPlayer(); // Initialize the new AudioPlayer
    _speechToText = stt.SpeechToText();
    _initSpeechToText();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -0.2), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -0.2, end: 0.2), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.2, end: 0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _player.dispose();
    _recordingFinishPlayer.dispose(); // Dispose the new AudioPlayer
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initSpeechToText() async {
    try {
      _isSpeechAvailable = await _speechToText.initialize(
        onError: (error) => print('Speech recognition error: $error'),
        debugLogging: true,
      );
    } catch (e) {
      print("Error initializing speech recognition: $e");
      _isSpeechAvailable = false;
    }
    if (mounted) setState(() {});
  }

  void _handleMicPress() async {
    if (!widget.microphonePermission) {
      _showSnackBar('Microphone permission is not granted');
      return;
    }

    if (!_isSpeechAvailable) {
      await _initSpeechToText();
      if (!_isSpeechAvailable) {
        _showSnackBar('Speech recognition is not available');
        return;
      }
    }

    if (!_isRecording) {
      setState(() {
        _isRecording = true;
      });

      await _speechToText.listen(
        onResult: _handleSpeechResult,
        listenFor: const Duration(seconds: 5),
        cancelOnError: true,
        partialResults: false,
      );

      // Add a timeout to reset the state if no result is received
      Future.delayed(const Duration(seconds: 5), () {
        if (_isRecording) {
          setState(() {
            _isRecording = false;
          });
        }
      });
    } else {
      setState(() {
        _isRecording = false;
      });
      await _speechToText.stop();
    }
  }

  void _handleSpeechResult(SpeechRecognitionResult result) {
    if (result.finalResult) {
      final recognizedText = result.recognizedWords.toLowerCase();
      setState(() {
        recognizedText.contains(widget.animalName.toLowerCase())
            ? {
                _backgroundColor = Colors.lightGreenAccent,
                _playRecordingFinishSound(true)
              }
            : {
                _backgroundColor = const Color(0xffff7f7f),
                _playRecordingFinishSound(false)
              };
        _isRecording = false; // Reset recording state
      });
    }
  }

  void _playRecordingFinishSound(bool isCorrect) {
    _recordingFinishPlayer.play(AssetSource(isCorrect
        ? 'sounds/positive-answer.wav'
        : 'sounds/negative-answer.wav')); // Replace with your sound file
  }

  void _handleTap() {
    _player.play(AssetSource(widget.soundAsset));
    _controller.forward(from: 0);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: GestureDetector(
        onTap: _handleTap,
        child: Card(
          color: _backgroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _animation.value,
                      child: child,
                    );
                  },
                  child: ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(20)),
                    child: Image.asset(
                      widget.imageAsset,
                      fit: BoxFit.fitHeight,
                      height: 150,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      onPressed: () => _player
                          .play(AssetSource(widget.animalNameSoundAsset)),
                      color: Colors.lightGreenAccent,
                      icon: Icons.volume_up,
                    ),
                    const SizedBox(height: 16),
                    _buildActionButton(
                      onPressed: _handleMicPress,
                      color: _isRecording ? Colors.red : Colors.lightBlueAccent,
                      icon:
                          _isRecording ? Icons.fiber_manual_record : Icons.mic,
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

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required Color color,
    required IconData icon,
  }) {
    return FloatingActionButton(
      onPressed: onPressed,
      mini: true,
      backgroundColor: color,
      shape: const CircleBorder(),
      child: Icon(icon, color: Colors.white),
    );
  }
}
