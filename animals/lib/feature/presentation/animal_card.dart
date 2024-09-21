import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class AnimalCard extends StatefulWidget {
  final String animalName;
  final String imageAsset;
  final String soundAsset;
  final String animalNameSoundAsset;

  const AnimalCard({
    super.key,
    required this.animalName,
    required this.imageAsset,
    required this.soundAsset,
    required this.animalNameSoundAsset,
  });

  @override
  _AnimalCardState createState() => _AnimalCardState();
}

class _AnimalCardState extends State<AnimalCard> {
  late AudioPlayer player;
  late stt.SpeechToText speechToText;
  Color backgroundColor = Colors.white;
  bool isListening = false;
  bool isInitializing = false;
  bool isSpeechAvailable = false;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    speechToText = stt.SpeechToText();
    initSpeechToText();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> initSpeechToText() async {
    if (isInitializing) return;
    isInitializing = true;

    // Request microphone permission
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      print('Microphone permission not granted');
      isSpeechAvailable = false;
      isInitializing = false;
      setState(() {});
      return;
    }

    try {
      bool available = await speechToText.initialize(
          onError: (error) => print('Speech recognition error: $error'),
          debugLogging: true);
      print('Speech recognition available: $available');
      isSpeechAvailable = available;
    } catch (e) {
      print("Error initializing speech recognition: $e");
      isSpeechAvailable = false;
    } finally {
      isInitializing = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();
    final speechToText = stt.SpeechToText();

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 0, left: 16, right: 16),
      child: GestureDetector(
        onTap: () {
          player.play(AssetSource(widget.soundAsset));
        },
        child: Card(
          color:
              backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                  ),
                  child: Image.asset(
                    widget.imageAsset,
                    fit: BoxFit.fitHeight,
                    height: 150,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton(
                      onPressed: () async {
                        if (isInitializing) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Speech recognition is initializing')),
                          );
                          return;
                        }

                        if (!isSpeechAvailable) {
                          await initSpeechToText(); // Try to initialize again if it failed before
                        }

                        if (isSpeechAvailable) {
                          if (isListening) {
                            await speechToText.stop();
                            setState(() {
                              isListening = false;
                            });
                          } else {
                            setState(() {
                              isListening = true;
                              backgroundColor = Colors
                                  .white; // Reset color when starting to listen
                            });
                            await speechToText.listen(
                              onResult: (result) {
                                final recognizedText = result.recognizedWords;
                                setState(() {
                                  print(
                                      '______________>>>>>>>>>>>>: $recognizedText');
                                  if (recognizedText
                                      .toLowerCase()
                                      .contains(widget.animalName)) {
                                    backgroundColor = Colors.lightGreenAccent;
                                  } else {
                                    backgroundColor = const Color(0xffff7f7f);
                                  }
                                });
                              },
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Speech recognition is not available')),
                          );
                        }
                      },
                      mini: true,
                      backgroundColor: Colors.lightBlueAccent,
                      shape: const CircleBorder(),
                      child: const Icon(Icons.mic, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    FloatingActionButton(
                      onPressed: () {
                        player.play(AssetSource(widget.animalNameSoundAsset));
                      },
                      mini: true,
                      backgroundColor: Colors.lightGreenAccent,
                      shape: const CircleBorder(),
                      child: const Icon(Icons.play_arrow),
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
}
