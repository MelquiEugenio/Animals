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

class _AnimalCardState extends State<AnimalCard> {
  late final AudioPlayer _player;
  late final stt.SpeechToText _speechToText;
  Color _backgroundColor = Colors.white;
  bool _isSpeechAvailable = false;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _speechToText = stt.SpeechToText();
    _initSpeechToText();
  }

  @override
  void dispose() {
    _player.dispose();
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
        _backgroundColor = recognizedText.contains(widget.animalName.toLowerCase())
            ? Colors.lightGreenAccent
            : const Color(0xffff7f7f);
        _isRecording = false;  // Reset recording state
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: GestureDetector(
        onTap: () => _player.play(AssetSource(widget.soundAsset)),
        child: Card(
          color: _backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
                  child: Image.asset(
                    widget.imageAsset,
                    fit: BoxFit.fitHeight,
                    height: 150,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      onPressed: _handleMicPress,
                      color: _isRecording ? Colors.red : Colors.lightBlueAccent,
                      icon: _isRecording ? Icons.fiber_manual_record : Icons.mic,
                    ),
                    const SizedBox(height: 16),
                    _buildActionButton(
                      onPressed: () => _player.play(AssetSource(widget.animalNameSoundAsset)),
                      color: Colors.lightGreenAccent,
                      icon: Icons.play_arrow,
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
