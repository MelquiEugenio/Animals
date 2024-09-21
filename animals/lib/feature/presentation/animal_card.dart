import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AnimalCard extends StatelessWidget {
  final String imageAsset;
  final String soundAsset;
  final String animalNameSoundAsset;

  const AnimalCard({
    super.key,
    required this.imageAsset,
    required this.soundAsset,
    required this.animalNameSoundAsset,
  });

  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 0, left: 16, right: 16),
      child: GestureDetector(
        onTap: () {
          player.play(AssetSource(soundAsset));
        },
        child: Card(
          color: Colors.white,
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
                    imageAsset,
                    fit: BoxFit.fitHeight,
                    height: 180,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        player.play(AssetSource(animalNameSoundAsset));
                      },
                      mini: true,
                      backgroundColor: Colors.lightGreenAccent,
                      child: const Icon(Icons.play_arrow, ),
                    ),
                    const SizedBox(height: 16),
                    FloatingActionButton(
                      onPressed: () {
                        // Add functionality for the microphone button
                      },
                      mini: true,
                      backgroundColor: Colors.lightBlueAccent,
                      child: const Icon(Icons.mic, color: Colors.white,),
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
